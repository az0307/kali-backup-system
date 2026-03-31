#!/bin/bash
# ====================================================================
# auto-reset.sh - Level 1: Auto password reset (zero interaction)
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all modules
source "$SCRIPT_DIR/error-handler.sh"      || { echo "Failed to load error-handler.sh"; exit 1; }
source "$SCRIPT_DIR/mount-utils.sh"        || { echo "Failed to load mount-utils.sh"; exit 1; }
source "$SCRIPT_DIR/detect-windows.sh"      || { echo "Failed to load detect-windows.sh"; exit 1; }
source "$SCRIPT_DIR/reset-password.sh"      || { echo "Failed to load reset-password.sh"; exit 1; }
source "$SCRIPT_DIR/verify-reset.sh"        || { echo "Failed to load verify-reset.sh"; exit 1; }
source "$SCRIPT_DIR/banner.sh"               || { echo "Failed to load banner.sh"; exit 1; }

main() {
    # Pre-flight checks
    require_root
    require_chntpw
    require_ntfs3g
    
    # Display banner
    banner_skeleton_key
    banner_auto_mode
    
    echo "Starting automatic Windows password reset..."
    echo ""
    log "Auto-detecting Windows installation..."
    
    # Auto-detect everything
    local detection_result
    detection_result=$(auto_detect_all)
    local detect_status=$?
    
    if [ $detect_status -ne 0 ] || [ -z "$detection_result" ]; then
        banner_error "Could not auto-detect Windows installation"
        echo "Please use start.sh for manual mode"
        exit 1
    fi
    
    # Parse detection result
    local partition
    local mount_point
    local username
    
    partition=$(echo "$detection_result" | cut -d'|' -f1)
    mount_point=$(echo "$detection_result" | cut -d'|' -f2)
    username=$(echo "$detection_result" | cut -d'|' -f3)
    
    echo ""
    echo "Auto-detected:"
    echo "  Windows: $partition"
    echo "  User: $username"
    echo ""
    
    # Warning banner
    banner_warning "$partition" "$username"
    
    # Read confirmation
    read CONFIRM
    
    if [ "$CONFIRM" != "YES" ]; then
        echo ""
        echo "Operation cancelled."
        echo "Type YES to confirm."
        exit 0
    fi
    
    echo ""
    echo "Proceeding with password reset..."
    echo ""
    
    # Unmount from auto_detect (we'll re-mount in do_password_reset)
    unmount_windows_partition "$mount_point"
    
    # Perform the reset (blank password)
    do_password_reset "$partition" "$username" "blank"
    
    if [ $? -ne 0 ]; then
        banner_error "Password reset failed"
        exit 1
    fi
    
    # Verify
    verify_password_reset "$partition" "$username"
    
    # Success
    banner_success "Password has been reset to BLANK"
    echo "You can now reboot to Windows and login with no password!"
    echo ""
    echo "Press Enter to reboot..."
    read
    
    log "Rebooting..."
    reboot
}

# Run
main "$@"
