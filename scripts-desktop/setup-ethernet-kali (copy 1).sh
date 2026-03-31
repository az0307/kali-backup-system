#!/bin/bash
#############################################################################
#  🐉 ETHERNET NETWORK SETUP - Kali Linux Client
#  Configures network to connect to Windows laptop via Ethernet
#############################################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║           🐉 ETHERNET NETWORK SETUP - Kali Linux                    ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "⚠️  Please run as root: sudo $0"
    exit 1
fi

echo "[1/4] Detecting network adapters..."
echo ""

ETH_ADAPTER=$(ip -o link show | grep -i ethernet | head -1 | awk -F': ' '{print $2}')
echo "  Found Ethernet adapter: $ETH_ADAPTER"
echo ""

if [ -z "$ETH_ADAPTER" ]; then
    echo "  ⚠️  No Ethernet adapter found!"
    echo "  Please connect Ethernet cable and try again"
    exit 1
fi

echo "[2/4] Configuring IP address..."
echo ""

CURRENT_IP=$(ip addr show $ETH_ADAPTER 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1)

if [ -n "$CURRENT_IP" ]; then
    echo "  Current IP: $CURRENT_IP"
    if [ "$CURRENT_IP" = "192.168.1.200" ]; then
        echo "  ✓ Already configured correctly"
    else
        echo "  Setting new IP: 192.168.1.200"
        ip addr add 192.168.1.200/24 dev $ETH_ADAPTER 2>/dev/null
    fi
else
    echo "  Setting IP: 192.168.1.200"
    ip addr add 192.168.1.200/24 dev $ETH_ADAPTER
fi

ip link set $ETH_ADAPTER up
echo "  ✓ Interface up"
echo ""

echo "[3/4] Configuring gateway and DNS..."
echo ""

ip route del default 2>/dev/null
ip route add default via 192.168.1.100
echo "  ✓ Gateway: 192.168.1.100"

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "  ✓ DNS: 8.8.8.8, 8.8.4.4"
echo ""

echo "[4/4] Testing connectivity..."
echo ""

ping -c 2 -W 2 192.168.1.100 >/dev/null 2>&1
[ $? -eq 0 ] && echo "  ✓ Gateway reachable" || echo "  ⚠️  Cannot reach gateway"

ping -c 2 -W 2 8.8.8.8 >/dev/null 2>&1
[ $? -eq 0 ] && echo "  ✓ Internet accessible" || echo "  ⚠️  Cannot reach internet"

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ NETWORK SETUP COMPLETE                          ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "  IP Address:    192.168.1.200"
echo "  Gateway:       192.168.1.100"
echo "  DNS:           8.8.8.8, 8.8.4.4"
echo ""
