#!/bin/bash
# ====================================================================
# DESKTOP KALI NETWORK SETUP
# Run after Kali installation on desktop
# ====================================================================

echo "=========================================="
echo "  Desktop Kali Network Setup"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Run as: sudo $0"
    exit 1
fi

echo "[1/3] Detecting network interface..."
ETH=$(ip -o link show | grep -i ethernet | head -1 | awk -F': ' '{print $2}')
echo "  Found: $ETH"

echo "[2/3] Configuring IP..."
ip addr add 192.168.1.200/24 dev $ETH 2>/dev/null || true
ip link set $ETH up
ip route add default via 192.168.1.100

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

echo "[3/3] Testing connection..."
ping -c 2 192.168.1.100 && echo "  Gateway OK" || echo "  Gateway unreachable"
ping -c 2 8.8.8.8 && echo "  Internet OK" || echo "  No internet"

echo ""
echo "=========================================="
echo "  Network Config:"
echo "    IP: 192.168.1.200"
echo "    Gateway: 192.168.1.100"
echo "    DNS: 8.8.8.8"
echo "=========================================="
