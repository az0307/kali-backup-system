#!/bin/bash
# ====================================================================
# reset-password.sh - Core password reset logic with backup/rollback
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error-handler.sh"
source "$SCRIPT_DIR/mount-utils.sh"

BACKUP_DIR="/mnt/backup"
SAM_BACKUP=""

# Create backup before any modification
backup_sam() {
    local config_dir="$1"
    
    [ ! -d "$BACKUP_DIR" ] && mkdir -p "$BACKUP_DIR"
    
    local timestamp=$(date +%Y%m%d%H%M%S)
    SAM_BACKUP="$BACKUP_DIR/SAM.$timestamp"
    
    if [ -f "$config_dir/SAM" ]; then
        cp "$config_dir/SAM" "$SAM_BACKUP" || {
            warn "Primary backup failed, trying alternate method"
            cp "$config_dir/SAM" "/tmp/SAM.backup"
            SAM_BACKUP="/tmp/SAM.backup"
        }
        log "Backed up SAM to: $SAM_BACKUP"
        echo "$SAM_BACKUP"
        return 0
    else
        error_exit "SAM file not found at $config_dir/SAM"
    fi
}

# Rollback to previous SAM
rollback_sam() {
    local config_dir="$1"
    
    if [ -n "$SAM_BACKUP" ] && [ -f "$SAM_BACKUP" ]; then
        warn "Rolling back SAM from backup..."
        cp "$SAM_BACKUP" "$config_dir/SAM"
        log "Rolled back successfully"
        return 0
    else
        error_exit "No backup available for rollback"
    fi
}

# Verify SAM is writable
verify_sam_writable() {
    local config_dir="$1"
    
    [ ! -f "$config_dir/SAM" ] && error_exit "SAM file not found"
    
    # Check if file is writable
    if [ ! -w "$config_dir/SAM" ]; then
        error_exit "SAM file is not writable - insufficient permissions"
    fi
    
    # Try creating test file
    touch "$config_dir/.write_test" 2>/dev/null || error_exit "Cannot write to config directory"
    rm "$config_dir/.write_test" 2>/dev/null
    
    log "SAM write verification passed"
    return 0
}

# Check Windows BitLocker status
check_bitlocker() {
    local mount_point="$1"
    
    # Check for BitLocker recovery indicators
    if [ -d "$mount_point/Recovery" ]; then
        if ls "$mount_point/Recovery" 2>/dev/null | grep -qi "bitlocker"; then
            warn "BitLocker recovery folder detected"
            return 1
        fi
    fi
    
    # Check for BitLocker encrypted partitions via fstab
    if blkid "$2" 2>/dev/null | grep -q "BitLocker"; then
        warn "Partition appears to be BitLocker encrypted"
        return 1
    fi
    
    return 0
}

# Reset password to blank (most reliable)
reset_password_blank() {
    local config_dir="$1"
    local username="$2"
    
    log "Resetting password (blank) for user: $username"
    
    cd "$config_dir"
    
    # Use interactive mode with stdin
    {
        echo "1"  # Clear password
        echo "q"  # Quit
        echo "y"  # Yes, save
    } | chntpw -u "$username" SAM 2>&1
    
    local result=$?
    
    if [ $result -eq 0 ]; then
        log "Password reset (blank) completed successfully"
        return 0
    else
        log "chntpw returned code: $result"
        return 1
    fi
}

# Set new password
reset_password_set() {
    local config_dir="$1"
    local username="$2"
    local newpass="$3"
    
    log "Setting new password for user: $username"
    
    cd "$config_dir"
    chntpw -u "$username" -p "$newpass" SAM 2>&1
    
    local result=$?
    
    if [ $result -eq 0 ]; then
        log "Password set completed successfully"
        return 0
    else
        log "Password set returned code: $result"
        return 1
    fi
}

# Promote user to admin
promote_to_admin() {
    local config_dir="$1"
    local username="$2"
    
    log "Promoting user to admin: $username"
    
    cd "$config_dir"
    {
        echo "3"  # Promote to admin
        echo "q"  # Quit
        echo "y"  # Yes, save
    } | chntpw -u "$username" SAM 2>&1
    
    return $?
}

# Unlock account
unlock_account() {
    local config_dir="$1"
    local username="$2"
    
    log "Unlocking account: $username"
    
    cd "$config_dir"
    chntpw -u "$username" -E SAM 2>&1
    
    return $?
}

# Main reset function with full error handling
do_password_reset() {
    local partition="$1"
    local username="$2"
    local action="$3"  # blank, set, promote, unlock
    local newpass="${4:-}"
    
    log "=========================================="
    log "Starting password reset operation"
    log "Partition: $partition"
    log "User: $username"
    log "Action: $action"
    log "=========================================="
    
    # Step 1: Mount
    local mount_point
    mount_point=$(safe_mount "$partition")
    [ $? -ne 0 ] && error_exit "Failed to mount Windows partition"
    
    local config_dir="$mount_point/Windows/System32/config"
    
    # Step 2: Verify SAM
    verify_sam_writable "$config_dir"
    
    # Step 3: Backup
    backup_sam "$config_dir"
    
    # Step 4: Execute action
    local result=0
    case "$action" in
        blank)
            reset_password_blank "$config_dir" "$username" || result=1
            ;;
        set)
            [ -z "$newpass" ] && error_exit "New password required for 'set' action"
            reset_password_set "$config_dir" "$username" "$newpass" || result=1
            ;;
        promote)
            promote_to_admin "$config_dir" "$username" || result=1
            ;;
        unlock)
            unlock_account "$config_dir" "$username" || result=1
            ;;
        *)
            result=1
            ;;
    esac
    
    # Step 5: Handle result
    if [ $result -ne 0 ]; then
        warn "Action returned non-zero, attempting rollback..."
        rollback_sam "$config_dir"
        unmount_windows_partition "$mount_point"
        error_exit "Password reset failed, rolled back to backup"
    fi
    
    # Step 6: Unmount
    unmount_windows_partition "$mount_point"
    
    log "Password reset operation completed successfully!"
    return 0
}
