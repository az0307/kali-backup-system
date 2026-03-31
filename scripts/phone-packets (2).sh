#!/bin/bash
# phone-packets.sh - Unified phone packet capture & transfer
# Usage: ./phone-packets.sh [capture|transfer|mirror|monitor]

MODE=${1:-menu}

ANDROID_DIR="/sdcard"
IOS_DIR="$HOME/ios-mount"
PKT_DIR="$HOME/phone-packets"

mkdir -p "$PKT_DIR"

case $MODE in
    capture)
        echo "=== Phone Packet Capture ==="
        echo "1) Android (via ADB)"
        echo "2) iOS (via usbmuxd)"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Starting tcpdump on Android..."
                adb shell "which tcpdump" || adb shell "apt install tcpdump" 2>/dev/null
                adb shell "tcpdump -i any -w /sdcard/capture.pcap" &
                echo "Capturing... Press Enter to stop"
                read
                adb shell "pkill tcpdump"
                adb pull /sdcard/capture.pcap "$PKT_DIR/"
                echo "Saved to $PKT_DIR"
                ;;
            2)
                echo "Use iOS Packet Logger or enable mirroring via macOS"
                ;;
        esac
        ;;
    transfer)
        echo "=== Phone File Transfer ==="
        echo "1) Android -> PC"
        echo "2) PC -> Android"
        echo "3) iOS -> PC"
        echo "4) PC -> iOS"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Source path on Android: "
                read SRC
                adb pull "$SRC" "$PKT_DIR/"
                ;;
            2)
                echo "Local file: "
                read SRC
                echo "Android destination: "
                read DST
                adb push "$SRC" "$DST"
                ;;
            3)
                ifuse "$IOS_DIR" 2>/dev/null
                echo "iOS path: "
                read SRC
                cp "$IOS_DIR/$SRC" "$PKT_DIR/"
                fusermount -u "$IOS_DIR"
                ;;
            4)
                ifuse "$IOS_DIR" 2>/dev/null
                echo "Local file: "
                read SRC
                echo "iOS destination: "
                read DST
                cp "$SRC" "$IOS_DIR/$DST"
                fusermount -u "$IOS_DIR"
                ;;
        esac
        ;;
    mirror)
        echo "=== Real-time Phone Screen Mirror ==="
        echo "1) Android (scrcpy)"
        echo "2) iOS (via usbmuxd)"
        read -p "Choice: " choice
        
        case $choice in
            1)
                which scrcpy || echo "Install scrcpy first"
                adb connect 127.0.0.1:5555 2>/dev/null
                scrcpy
                ;;
            2)
                echo "iOS mirroring requires macOS + QuickTime or ventrix"
                ;;
        esac
        ;;
    monitor)
        echo "=== Network Monitor (Phone Traffic) ==="
        echo "1) Android traffic"
        echo "2) Network scan from phone"
        read -p "Choice: " choice
        
        case $choice in
            1)
                adb shell "dumpsys netstats > /sdcard/netstats.txt"
                adb pull /sdcard/netstats.txt "$PKT_DIR/"
                cat "$PKT_DIR/netstats.txt"
                ;;
            2)
                echo "Run nmap from phone via Termux:"
                echo "pkg install nmap && nmap -sV 192.168.1.0/24"
                ;;
        esac
        ;;
    backup)
        echo "=== Full Phone Backup ==="
        echo "1) Android (ADB backup)"
        echo "2) iOS (idevicebackup)"
        read -p "Choice: " choice
        
        case $choice in
            1)
                adb backup -f "$PKT_DIR/android-backup-$(date +%Y%m%d).ab" -all
                ;;
            2)
                mkdir -p "$PKT_DIR/ios-backup-$(date +%Y%m%d)"
                idevicebackup2 backup "$PKT_DIR/ios-backup-$(date +%Y%m%d)"
                ;;
        esac
        ;;
    menu|*)
        echo "=== Phone Packets & Transfer ==="
        echo "1) Packet Capture"
        echo "2) File Transfer"
        echo "3) Screen Mirror"
        echo "4) Network Monitor"
        echo "5) Full Backup"
        echo "6) Exit"
        read -p "Choice: " choice
        case $choice in
            1) $0 capture ;;
            2) $0 transfer ;;
            3) $0 mirror ;;
            4) $0 monitor ;;
            5) $0 backup ;;
            6) exit ;;
        esac
        ;;
esac