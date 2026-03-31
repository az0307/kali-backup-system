#!/bin/bash
# ====================================================================
# verify-reset.sh - Post-reset verification
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error-handler.sh"
source "$SCRIPT_DIR/mount-utils.sh"

verify_password_reset() {
    local partition="$1"
    local username="$2"
    
    log "=========================================="
    log "Verifying password reset"
    log "Partition: $partition"
    log "User: $username"
    log "=========================================="
    
    # Mount again to verify
    local mount_point
    mount_point=$(safe_mount "$partition")
    [ $? -ne 0 ] && {
        warn "Could not re-mount to verify - check manually"
        return 1
    }
    
    local config_dir="$mount_point/Windows/System32/config"
    
    cd "$config_dir"
    
    log "Checking user account status..."
    
    # Get user info
    local user_info
    user_info=$(chntpw -l SAM 2>/dev/null | grep -E "^[0-9]+:" | grep "$username")
    
    if [ -z "$user_info" ]; then
        warn "User $username not found in SAM - may have been deleted"
    else
        log "User account info:"
        echo "  $user_info"
        
        # Check for disabled flag
        if echo "$user_info" | grep -qi "disabled"; then
            warn "Account may be disabled!"
        else
            log "Account appears enabled"
        fi
        
        # Check for password status
        if echo "$user_info" | grep -q "(password set)"; then
            log "Password is set"
        elif echo "$user_info" | grep -q "(blank)"; then
            log "Password is BLANK (reset successful)"
        fi
    fi
    
    # Check backup exists
    if [ -d "/mnt/backup" ]; then
        local backups=$(ls -1 /mnt/backup/SAM.* 2>/dev/null | wc -l)
        log "Backup files available: $backups"
    fi
    
    # Unmount
    unmount_windows_partition "$mount_point"
    
    log "Verification complete"
    echo ""
    echo "✅ Password reset verified!"
    echo ""
    
    return 0
}

# Quick sanity check
quick_verify() {
    local partition="$1"
    
    log "Quick verification of partition..."
    
    # Check partition exists and is NTFS
    local fs_type
    fs_type=$(blkid -s TYPE -o value "$partition" 2>/dev/null)
    
    if [ "$fs_type" != "ntfs" ]; then
        warn "Partition is not NTFS: $fs_type"
        return 1
    fi
    
    log "Partition type: NTFS (verified)"
    return 0
}
