#!/bin/bash
# wifi-audit.sh - Wireless network auditing
# Usage: ./wifi-audit.sh <interface>

IFACE=${1:-wlan0}

echo "=== WiFi Audit on $IFACE ==="
echo "[1/4] Monitor mode..."
ip link set $IFACE down && iw $IFACE set monitor control && ip link set $IFACE up

echo "[2/4] Scanning APs..."
airodump-ng $IFACE --write wifi-scan 2>/dev/null &
sleep 10 && pkill airodump-ng

echo "[3/4] Handshake capture..."
echo "Run: airodump-ng -c <channel> --bssid <mac> -w capture $IFACE"

echo "[4/4] Crack..."
echo "Run: aircrack-ng -w wordlist.txt capture-01.cap"

echo "=== WiFi tools ready ==="