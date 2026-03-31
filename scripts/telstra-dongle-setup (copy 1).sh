#!/bin/bash
# ====================================================================
# TELSTRA DONGLE SETUP - Desktop Kali
# For direct internet via Telstra mobile dongle
# ====================================================================

echo "=========================================="
echo "  Telstra Dongle Setup"
echo "=========================================="

# Check root
if [ "$EUID" -ne 0 ]; then
    echo "Run as: sudo $0"
    exit 1
fi

echo "[1/4] Detecting dongle..."
lsusb | grep -i "huawei\|telstra\|mobile" || echo "  No dongle detected"

echo "[2/4] Installing required packages..."
apt update
apt install -y usb-modeswitch wvdial network-manager

echo "[3/4] Configuring network..."
# If using DHCP (auto IP)
dhclient -v

echo "[4/4] Testing internet..."
ping -c 2 8.8.8.8 && echo "  Internet OK!" || echo "  Check dongle"

echo ""
echo "If dongle not detected:"
echo "  1. Check: lsusb"
echo "  2. Try: usb_modeswitch -c /etc/usb_modeswitch.conf"
echo "  3. Or use NetworkManager: nmtui"
