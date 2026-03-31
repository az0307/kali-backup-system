#!/bin/bash
# ios-transfer.sh - iOS file transfer via idevices/ifuse
# Usage: ./ios-transfer.sh [pull|push|backup|install|plist]

MODE=${1:-menu}

IOS_DIR="$HOME/ios-mount"
mkdir -p "$IOS_DIR"

case $MODE in
    mount)
        echo "=== Mount iOS device ==="
        ifuse "$IOS_DIR" 2>/dev/null && echo "Mounted at $IOS_DIR" || echo "Failed - check device connection"
        ;;
    unmount)
        echo "=== Unmount iOS ==="
        fusermount -u "$IOS_DIR" 2>/dev/null || umount "$IOS_DIR" 2>/dev/null
        echo "Unmounted"
        ;;
    pull)
        echo "=== Pull files from iOS ==="
        if [ ! -d "$IOS_DIR" ]; then
            echo "Mount device first: $0 mount"
            exit 1
        fi
        echo "Source path (relative to mount): "
        read SRC
        cp "$IOS_DIR/$SRC" "./" 2>/dev/null || echo "Copy failed"
        ;;
    push)
        echo "=== Push files to iOS ==="
        echo "Local file: "
        read SRC
        echo "Destination: "
        read DST
        cp "$SRC" "$IOS_DIR/$DST" 2>/dev/null || echo "Copy failed"
        ;;
    backup)
        echo "=== iOS Backup (idevices) ==="
        which idevicebackup2 2>/dev/null || echo "libimobiledevice not installed"
        idevicebackup2 backup "$HOME/ios-backup-$(date +%Y%m%d)" 2>/dev/null || echo "Backup failed"
        ;;
    install)
        echo "=== Install IPA ==="
        echo "IPA file: "
        read IPA
        ideviceinstaller -i "$IPA" 2>/dev/null || echo "Install failed"
        ;;
    screenshot)
        idevicescreenshot "$HOME/screenshot-$(date +%Y%m%d-%H%M%S).png" 2>/dev/null || echo "Screenshot failed"
        ;;
    info)
        ideviceinfo 2>/dev/null || echo "Device info unavailable"
        ;;
    menu|*)
        echo "=== iOS Transfer Menu ==="
        echo "1) Mount device"
        echo "2) Unmount device"
        echo "3) Pull files"
        echo "4) Push files"
        echo "5) Full backup"
        echo "6) Install IPA"
        echo "7) Screenshot"
        echo "8) Device info"
        read -p "Choice: " choice
        case $choice in
            1) $0 mount ;;
            2) $0 unmount ;;
            3) $0 pull ;;
            4) $0 push ;;
            5) $0 backup ;;
            6) $0 install ;;
            7) $0 screenshot ;;
            8) $0 info ;;
        esac
        ;;
esac