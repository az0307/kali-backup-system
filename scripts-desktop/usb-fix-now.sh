#!/bin/bash
# USB DETECT FIX - Run this NOW in Kali

echo "=== USB FIX ==="

# 1. Check USB devices
echo "[1] USB Devices:"
lsusb

# 2. Check wireless
echo "[2] Wireless interfaces:"
ip link show

# 3. Install firmware
echo "[3] Installing firmware..."
apt install firmware-atheros -y 2>/dev/null

# 4. Load driver
echo "[4] Loading driver..."
modprobe ath9k_htc 2>/dev/null

# 5. Check again
echo "[5] After fix:"
ip link show | grep -A1 wlan

# 6. Start monitor mode if found
echo "[6] Starting monitor mode..."
airmon-ng start wlan0 2>/dev/null

echo "=== DONE ==="
echo "If wlan0 still not showing, check VirtualBox USB settings"
