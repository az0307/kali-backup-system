#!/bin/bash
# android-transfer.sh - Android file transfer via ADB/MTP
# Usage: ./android-transfer.sh [pull|push|backup|install]

MODE=${1:-menu}

ANDROID_DIR="/sdcard"
LOCAL_DIR="$HOME/android-transfer"

mkdir -p "$LOCAL_DIR"

case $MODE in
    pull)
        echo "=== Pull files from Android ==="
        echo "Source path on device: "
        read SRC
        adb pull "$SRC" "$LOCAL_DIR/" 2>/dev/null || echo "ADB not connected or permission denied"
        ;;
    push)
        echo "=== Push files to Android ==="
        echo "Local file path: "
        read SRC
        echo "Destination path: "
        read DST
        adb push "$SRC" "$DST" 2>/dev/null || echo "ADB not connected"
        ;;
    backup)
        echo "=== Backup Android data ==="
        adb backup -f "$LOCAL_DIR/backup-$(date +%Y%m%d).ab" -all 2>/dev/null || echo "Backup failed"
        echo "Backup saved to $LOCAL_DIR"
        ;;
    install)
        echo "=== Install APK ==="
        echo "APK file path: "
        read APK
        adb install "$APK" 2>/dev/null || echo "Install failed"
        ;;
    screenshot)
        adb shell screencap -p /sdcard/screen.png
        adb pull /sdcard/screen.png "$LOCAL_DIR/"
        echo "Screenshot saved"
        ;;
    shell)
        adb shell
        ;;
    devices)
        adb devices
        ;;
    menu|*)
        echo "=== Android Transfer Menu ==="
        echo "1) Pull files from device"
        echo "2) Push files to device"
        echo "3) Backup all data"
        echo "4) Install APK"
        echo "5) Take screenshot"
        echo "6) Shell access"
        echo "7) List devices"
        read -p "Choice: " choice
        case $choice in
            1) $0 pull ;;
            2) $0 push ;;
            3) $0 backup ;;
            4) $0 install ;;
            5) $0 screenshot ;;
            6) $0 shell ;;
            7) $0 devices ;;
        esac
        ;;
esac