#!/bin/bash
REM #############################################################################
REM  #  🐉 ETHERNET NETWORK SETUP - Kali Linux Client
REM  #  Configures network to connect to Windows laptop via Ethernet
REM  #############################################################################

cat > /tmp/ethernet-setup.sh << 'SCRIPT'
#!/bin/bash

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║           🐉 ETHERNET NETWORK SETUP - Kali Linux                    ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "⚠️  Please run as root: sudo $0"
    exit 1
fi

echo "[1/4] Detecting network adapters..."
echo ""

# Find Ethernet adapter
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

# Check if already configured
CURRENT_IP=$(ip addr show $ETH_ADAPTER | grep -oP 'inet \K[\d.]+' 2>/dev/null)

if [ -n "$CURRENT_IP" ]; then
    echo "  Current IP: $CURRENT_IP"
    
    if [ "$CURRENT_IP" = "192.168.1.200" ]; then
        echo "  ✓ Already configured correctly"
    else
        echo "  Updating IP to 192.168.1.200..."
        ip addr add 192.168.1.200/24 dev $ETH_ADAPTER
    fi
else
    echo "  Setting IP: 192.168.1.200"
    ip addr add 192.168.1.200/24 dev $ETH_ADAPTER
fi

# Bring up interface
ip link set $ETH_ADAPTER up
echo "  ✓ Interface up"
echo ""

echo "[3/4] Configuring gateway and DNS..."
echo ""

# Set default gateway
ip route del default 2>/dev/null
ip route add default via 192.168.1.100
echo "  ✓ Gateway: 192.168.1.100"

# Configure DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "  ✓ DNS: 8.8.8.8, 8.8.4.4"
echo ""

echo "[4/4] Testing connectivity..."
echo ""

# Test gateway
ping -c 2 -W 2 192.168.1.100 >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "  ✓ Gateway reachable (192.168.1.100)"
else
    echo "  ⚠️  Cannot reach gateway (192.168.1.100)"
    echo "  Check Ethernet cable connection"
fi

# Test internet
ping -c 2 -W 2 8.8.8.8 >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "  ✓ Internet accessible"
else
    echo "  ⚠️  Cannot reach internet"
    echo "  Check if Windows laptop has internet sharing enabled"
fi

# Test DNS
ping -c 1 -W 2 google.com >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "  ✓ DNS working"
else
    echo "  ⚠️  DNS not working"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ NETWORK SETUP COMPLETE                          ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "  ┌─────────────────────────────────────────────────────────────────────┐"
echo "  │  Network Configuration:                                            │"
echo "  │                                                                     │"
echo "  │    IP Address:    192.168.1.200                                    │"
echo "  │    Subnet:        255.255.255.0 (/24)                              │"
echo "  │    Gateway:       192.168.1.100 (Windows laptop)                  │"
echo "  │    DNS:           8.8.8.8, 8.8.4.4                                │"
echo "  └─────────────────────────────────────────────────────────────────────┘"
echo ""
echo "  Current IP: $(ip addr show $ETH_ADAPTER | grep -oP 'inet \K[\d.]+' 2>/dev/null)"
echo "  Gateway:     $(ip route | grep default | awk '{print $3}')"
echo ""

SCRIPT

chmod +x /tmp/ethernet-setup.sh

echo "Script created: /tmp/ethernet-setup.sh"
echo ""
echo "To run this script on Kali Linux:"
echo ""
echo "  sudo bash /tmp/ethernet-setup.sh"
echo ""
echo "Or copy to your Kali system and run:"
echo ""
echo "  curl -sSL https://raw.githubusercontent.com/anomalyco/opencode/main/scripts/kali-ethernet-setup.sh | sudo bash"
echo ""
