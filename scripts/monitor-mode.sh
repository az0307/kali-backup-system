#!/bin/bash
# TP-Link TL-WN721N (AR9271) Monitor Mode Activator
# Run as root in Kali terminal

echo "=========================================="
echo "TP-Link TL-WN721N Monitor Mode Setup"
echo "=========================================="

# Check if adapter is connected
echo "[1/5] Checking USB devices..."
lsusb | grep -i "tp-link" || lsusb | grep -i "9271" || echo "Warning: TP-Link not found in lsusb"

# Check wireless interfaces
echo "[2/5] Available wireless interfaces..."
ip link show | grep -E "^[0-9]+: wl"

# Kill processes that interfere
echo "[3/5] Killing interfering processes..."
airmon-ng check kill

# Start monitor mode
echo "[4/5] Starting monitor mode on wlan0..."
airmon-ng start wlan0

# Verify
echo "[5/5] Verifying monitor mode..."
echo ""
echo "=== INTERFACES ==="
iw dev
echo ""
echo "=== MONITOR MODE STATUS ==="
iwconfig 2>/dev/null | grep -A5 "wlan0" || airmon-ng | grep -E "wlan0|mon0"

echo ""
echo "=========================================="
echo "Monitor mode should be active!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Scan networks: sudo airodump-ng wlan0mon"
echo "2. Capture handshake: sudo airodump-ng -c CHANNEL --bssid MAC -w capture wlan0mon"
echo "3. Deauth: sudo aireplay-ng --deauth 10 -a MAC wlan0mon"
echo "4. Crack: sudo aircrack-ng -w wordlist.txt capture-01.cap"
echo ""
