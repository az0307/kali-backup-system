#!/bin/bash
# ====================================================================
# start.sh - Level 2: Interactive menu mode
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all modules
source "$SCRIPT_DIR/error-handler.sh"      || { echo "Failed to load error-handler.sh"; exit 1; }
source "$SCRIPT_DIR/mount-utils.sh"        || { echo "Failed to load mount-utils.sh"; exit 1; }
source "$SCRIPT_DIR/detect-windows.sh"      || { echo "Failed to load detect-windows.sh"; exit 1; }
source "$SCRIPT_DIR/reset-password.sh"      || { echo "Failed to load reset-password.sh"; exit 1; }
source "$SCRIPT_DIR/verify-reset.sh"        || { echo "Failed to load verify-reset.sh"; exit 1; }
source "$SCRIPT_DIR/banner.sh"              || { echo "Failed to load banner.sh"; exit 1; }

show_menu() {
    banner_skeleton_key
    banner_menu
    
    echo "${GREEN}[1]${NC} Auto Reset Password (Recommended)"
    echo "${GREEN}[2]${NC} Set New Password"
    echo "${GREEN}[3]${NC} Promote to Admin"
    echo "${GREEN}[4]${NC} Unlock Account"
    echo "${GREEN}[5]${NC} Show Partitions"
    echo "${GREEN}[6]${NC} Kali Live Desktop"
    echo "${GREEN}[0]${NC} Exit"
    echo ""
    echo -n "Select: "
}

select_partition() {
    local parts=($(find_windows_partitions))
    
    if [ ${#parts[@]} -eq 0 ]; then
        echo "No Windows installations found!"
        return 1
    elif [ ${#parts[@]} -eq 1 ]; then
        echo "${parts[0]}"
        return 0
    else
        echo ""
        echo "Select Windows partition:"
        select partition in "${parts[@]}"; do
            [ -n "$partition" ] && {
                echo "$partition"
                return 0
            }
        done
    fi
}

select_user() {
    local partition="$1"
    local mount_point
    
    mount_point=$(safe_mount "$partition")
    [ $? -ne 0 ] && return 1
    
    local users=($(detect_admin_users "$mount_point/Windows/System32/config"))
    unmount_windows_partition "$mount_point"
    
    if [ ${#users[@]} -eq 0 ]; then
        echo "Administrator"
        return 0
    elif [ ${#users[@]} -eq 1 ]; then
        echo "${users[0]}"
        return 0
    else
        echo ""
        echo "Select user account:"
        select username in "${users[@]}"; do
            [ -n "$username" ] && {
                echo "$username"
                return 0
            }
        done
    fi
}

main() {
    # Pre-flight checks
    require_root
    require_chntpw
    require_ntfs3g
    
    while true; do
        show_menu
        read CHOICE
        
        case "$CHOICE" in
            1) action="blank" ;;
            2) action="set" ;;
            3) action="promote" ;;
            4) action="unlock" ;;
            5)
                echo ""
                list_windows_partitions
                echo ""
                echo "Press Enter to continue..."
                read
                continue
                ;;
            6)
                echo "Starting Kali desktop..."
                if command -v startx &> /dev/null; then
                    startx
                elif command -v systemctl &> /dev/null; then
                    systemctl start graphical 2>/dev/null || echo "Could not start desktop"
                fi
                continue
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid option"
                continue
                ;;
        esac
        
        # Get partition
        echo ""
        local partition
        partition=$(select_partition)
        [ -z "$partition" ] && {
            echo "No partition selected"
            continue
        }
        
        # Get user
        local username
        username=$(select_user "$partition")
        [ -z "$username" ] && {
            echo "No user selected"
            continue
        }
        
        echo ""
        echo "Selected:"
        echo "  Partition: $partition"
        echo "  User: $username"
        echo "  Action: $action"
        
        # Get new password if needed
        local newpass=""
        if [ "$action" = "set" ]; then
            echo ""
            echo -n "Enter new password: "
            read -s newpass
            echo ""
            [ -z "$newpass" ] && {
                echo "Password cannot be empty"
                continue
            }
        fi
        
        # Confirmation
        echo ""
        banner_warning "$partition" "$username"
        read CONFIRM
        
        if [ "$CONFIRM" != "YES" ]; then
            echo "Operation cancelled."
            continue
        fi
        
        echo ""
        echo "Executing..."
        
        # Execute
        if [ "$action" = "set" ]; then
            do_password_reset "$partition" "$username" "set" "$newpass"
        else
            do_password_reset "$partition" "$username" "$action"
        fi
        
        if [ $? -eq 0 ]; then
            echo ""
            banner_success "Operation completed!"
        else
            echo ""
            banner_error "Operation failed!"
        fi
        
        echo "Press Enter to continue..."
        read
    done
}

main "$@"
