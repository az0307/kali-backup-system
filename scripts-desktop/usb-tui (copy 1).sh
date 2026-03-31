#!/bin/bash
# USB FIX TUI - Simple menu

echo "╔═══════════════════════════╗"
echo "║   USB WIFI FIX TOOL     ║"
echo "╚═══════════════════════════╝"
echo ""

echo "1. Check if TP-Link detected"
echo "2. Fix USB permissions"
echo "3. Start monitor mode"
echo "4. Exit"
echo ""

read -p "Choice: " choice

case $choice in
  1)
    echo "=== USB Devices ==="
    lsusb
    echo ""
    echo "=== Wireless ==="
    ip link show
    ;;
  2)
    echo "Installing firmware..."
    apt install firmware-atheros -y
    modprobe ath9k_htc
    echo "Done! Check with option 1"
    ;;
  3)
    echo "Starting monitor mode..."
    airmon-ng start wlan0
    echo "Use: sudo airodump-ng wlan0mon"
    ;;
  *)
    exit
    ;;
esac
