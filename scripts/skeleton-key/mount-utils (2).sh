#!/bin/bash
# ====================================================================
# mount-utils.sh - Safe mount/umount utilities for Skeleton Key USB
# ====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error-handler.sh"

# Mount Windows partition safely with retries
mount_windows_partition() {
    local partition="$1"
    local mount_point="${2:-/mnt/windows}"
    
    [ -z "$partition" ] && error_exit "No partition specified"
    [ ! -b "$partition" ] && error_exit "Partition does not exist: $partition"
    
    mkdir -p "$mount_point"
    
    log "Attempting to mount $partition..."
    
    local attempts=0
    local max_attempts=3
    
    while [ $attempts -lt $max_attempts ]; do
        ((attempts++))
        
        # Try normal mount first
        if mount -t ntfs-3g -o rw,remove_hiberfile "$partition" "$mount_point" 2>/dev/null; then
            log "Mounted successfully (attempt $attempts)"
            if mountpoint -q "$mount_point"; then
                echo "$mount_point"
                return 0
            fi
        fi
        
        # Try with force
        if mount -t ntfs-3g -o rw,force,remove_hiberfile "$partition" "$mount_point" 2>/dev/null; then
            log "Mounted with force (attempt $attempts)"
            if mountpoint -q "$mount_point"; then
                echo "$mount_point"
                return 0
            fi
        fi
        
        log "Attempt $attempts failed, retrying..."
        sleep 1
    done
    
    error_exit "Failed to mount $partition after $max_attempts attempts"
}

# Unmount safely with force if needed
unmount_windows_partition() {
    local mount_point="$1"
    
    [ -z "$mount_point" ] && return 0
    
    if mountpoint -q "$mount_point"; then
        log "Unmounting $mount_point..."
        sync
        
        if umount "$mount_point" 2>/dev/null; then
            log "Unmounted cleanly"
        elif umount -l "$mount_point" 2>/dev/null; then
            log "Unmounted lazily (busy)"
        elif umount -f "$mount_point" 2>/dev/null; then
            log "Force unmounted"
        else
            warn "Could not unmount, continuing..."
        fi
    fi
    
    rmdir "$mount_point" 2>/dev/null || true
}

# Safe mount with automatic cleanup
safe_mount() {
    local partition="$1"
    local mount_point="${2:-/mnt/windows}"
    
    # Cleanup any existing mount at this point
    unmount_windows_partition "$mount_point"
    
    # Mount
    local result
    result=$(mount_windows_partition "$partition" "$mount_point")
    [ $? -ne 0 ] && return 1
    
    # Verify Windows directory exists
    if [ ! -d "$mount_point/Windows" ]; then
        unmount_windows_partition "$mount_point"
        error_exit "Not a valid Windows partition (no Windows folder found)"
    fi
    
    log "Verified Windows installation at $mount_point"
    echo "$mount_point"
    return 0
}

# Check if partition is Windows
is_windows_partition() {
    local partition="$1"
    local test_mount="/mnt/test_win_$$"
    
    mkdir -p "$test_mount"
    
    if mount -t ntfs-3g -o ro "$partition" "$test_mount" 2>/dev/null; then
        if [ -d "$test_mount/Windows" ]; then
            umount "$test_mount" 2>/dev/null
            rmdir "$test_mount" 2>/dev/null
            return 0
        fi
        umount "$test_mount" 2>/dev/null
    fi
    
    rmdir "$test_mount" 2>/dev/null
    return 1
}

# Get partition info
get_partition_info() {
    local partition="$1"
    
    echo "=== Partition Info ==="
    echo "Device: $partition"
    blkid "$partition" 2>/dev/null || echo "blkid failed"
    echo "Size: $(blockdev --getsize64 "$partition" 2>/dev/null | numfmt --to=iec 2>/dev/null || echo 'unknown')"
}
