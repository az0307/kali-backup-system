#!/bin/bash
# WiFi Password Recovery - Find saved WiFi passwords

echo "=== WIFI PASSWORD RECOVERY ==="
echo ""

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
   echo "Run with sudo"
   exit 1
fi

echo "[1] Checking Linux saved passwords..."
if [ -f /etc/NetworkManager/system-connections/* ]; then
    echo "Found NetworkManager configs:"
    cat /etc/NetworkManager/system-connections/* | grep -E "psk|password" | head -20
else
    echo "No NetworkManager configs found"
fi

echo ""
echo "[2] Checking Windows SAM (if mounted)..."
if [ -f /mnt/Windows/System32/config/SAM ]; then
    echo "Windows SAM found - use chntpw to view"
else
    echo "Windows partition not mounted"
fi

echo ""
echo "[3] Your saved credentials:"
cat /wifi-passwords/NETWORK-CREDENTIALS.txt 2>/dev/null || echo "No saved credentials"

echo ""
echo "=== For full recovery, mount Windows and use: ==="
echo "chntpw -i /mnt/Windows/System32/config/SAM"
