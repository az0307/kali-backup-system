#!/bin/bash
# ====================================================================
# detect-windows.sh - Windows partition and user detection
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error-handler.sh"
source "$SCRIPT_DIR/mount-utils.sh"

# Find all Windows partitions (internal drives only)
find_windows_partitions() {
    local partitions=()
    local test_mount="/mnt/tempdetect_$$"
    mkdir -p "$test_mount"
    
    log "Scanning for Windows installations..."
    
    # Scan internal drives (sda, nvme0n1, etc.)
    for dev in /dev/sd[a-z] /dev/nvme*; do
        [ -b "$dev" ] || continue
        
        # Skip removable drives (USB)
        local devname=$(basename "$dev")
        if [ -f "/sys/block/$devname/removable" ]; then
            if [ "$(cat /sys/block/$devname/removable 2>/dev/null)" = "1" ]; then
                log "Skipping removable: $dev"
                continue
            fi
        fi
        
        # Check each partition
        for part in "$dev"*; do
            [ -b "$part" ] || continue
            
            # Quick NTFS check
            local fs_type=$(blkid -s TYPE -o value "$part" 2>/dev/null)
            if [ "$fs_type" = "ntfs" ]; then
                # Test mount to check for Windows
                if mount -t ntfs-3g -o ro "$part" "$test_mount" 2>/dev/null; then
                    if [ -d "$test_mount/Windows" ]; then
                        partitions+=("$part")
                        log "Found Windows: $part"
                    fi
                    umount "$test_mount" 2>/dev/null
                fi
            fi
        done
    done
    
    rmdir "$test_mount" 2>/dev/null
    
    # Also check for boot flag NTFS
    local boot_ntfs=$(fdisk -l 2>/dev/null | grep -E "NTFS.*\*" | awk '{print $1}')
    if [ -n "$boot_ntfs" ]; then
        local found=0
        for p in "${partitions[@]}"; do
            [ "$p" = "$boot_ntfs" ] && found=1
        done
        if [ "$found" = "0" ]; then
            if is_windows_partition "$boot_ntfs"; then
                partitions+=("$boot_ntfs")
                log "Found boot NTFS: $boot_ntfs"
            fi
        fi
    fi
    
    printf '%s\n' "${partitions[@]}"
}

# Detect Windows partition (single auto mode)
detect_windows_partition() {
    local windows_parts=($(find_windows_partitions))
    
    case ${#windows_parts[@]} in
        0)
            echo ""
            return 1
            ;;
        1)
            echo "${windows_parts[0]}"
            return 0
            ;;
        *)
            # Multiple found
            printf '%s\n' "${windows_parts[@]}"
            return 2
            ;;
    esac
}

# Detect admin users from Windows SAM
detect_admin_users() {
    local sam_path="$1"
    local users=()
    
    [ ! -f "$sam_path/SAM" ] && return 1
    
    cd "$sam_path"
    
    # Parse user list from chntpw
    while IFS= read -r line; do
        # Extract username (second field after : )
        local username=$(echo "$line" | awk -F': ' '{print $2}' | cut -d':' -f1)
        [ -n "$username" ] && users+=("$username")
    done < <(chntpw -l SAM 2>/dev/null | grep -E "^[0-9]+:" | head -10)
    
    # Default fallback
    [ ${#users[@]} -eq 0 ] && users+=("Administrator")
    
    printf '%s\n' "${users[@]}"
}

# Auto-detect all (partition, user, mount_point)
auto_detect_all() {
    log "Starting auto-detection..."
    
    local partition
    partition=$(detect_windows_partition)
    
    if [ -z "$partition" ]; then
        error_exit "No Windows installation found on internal drives"
    fi
    
    log "Found Windows partition: $partition"
    
    # Mount it
    local mount_point
    mount_point=$(safe_mount "$partition")
    [ $? -ne 0 ] && error_exit "Failed to mount Windows"
    
    log "Mounted to: $mount_point"
    
    # Find users
    local users=($(detect_admin_users "$mount_point/Windows/System32/config"))
    
    if [ ${#users[@]} -eq 0 ]; then
        unmount_windows_partition "$mount_point"
        error_exit "Could not detect any users"
    fi
    
    log "Found user: ${users[0]}"
    
    # Output: partition|mount_point|user
    echo "$partition|$mount_point|${users[0]}"
    
    # Don't unmount - caller will use it
    return 0
}

# List Windows partitions for menu
list_windows_partitions() {
    local parts=($(find_windows_partitions))
    
    if [ ${#parts[@]} -eq 0 ]; then
        echo "No Windows installations found."
        return 1
    fi
    
    echo "Available Windows installations:"
    echo ""
    
    local i=1
    for p in "${parts[@]}"; do
        local size=$(blockdev --getsize64 "$p" 2>/dev/null | numfmt --to=iec 2>/dev/null || echo "unknown")
        echo "  [$i] $p ($size)"
        ((i++))
    done
    
    return 0
}
