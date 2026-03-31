#!/bin/bash

################################################################################
#  📡 DESKTOP KALI AUTO-CONNECT SCRIPT
#  Runs on new Kali Desktop to auto-connect via Ethernet to this laptop
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  🖥️  KALI DESKTOP AUTO-CONNECT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

# ============================================================================
# CONFIGURATION
# ============================================================================

# This laptop's IP (will be gateway)
HOST_IP="192.168.1.100"

# This desktop's IP
DESKTOP_IP="192.168.1.75"

# DNS
DNS1="8.8.8.8"
DNS2="8.8.4.4"

echo -e "${YELLOW}[1] Detecting network...${NC}"

# ============================================================================
# DETECT ETHERNET INTERFACE
# ============================================================================

# Find ethernet interface (usually eth0, enp0sX, ensX)
if ip link show eth0 >/dev/null 2>&1; then
    ETH="eth0"
elif ip link show enp0s3 >/dev/null 2>&1; then
    ETH="enp0s3"
elif ip link show ens33 >/dev/null 2>&1; then
    ETH="ens33"
else
    # List all interfaces
    echo -e "${YELLOW}Available interfaces:${NC}"
    ip -br addr show | grep -v lo
    echo -e "${RED}No ethernet found!${NC}"
    read -p "Enter interface name: " ETH
fi

echo -e "${GREEN}  Using interface: $ETH${NC}"

# ============================================================================
# CONFIGURE STATIC IP
# ============================================================================

echo -e "${YELLOW}[2] Configuring static IP: $DESKTOP_IP${NC}"

# Backup current config
cp /etc/network/interfaces /etc/network/interfaces.bak 2>/dev/null || true

# Write new config
cat > /etc/network/interfaces << EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# Loopback
auto lo
iface lo inet loopback

# Ethernet - Static IP
auto $ETH
iface $ETH inet static
    address $DESKTOP_IP
    netmask 255.255.255.0
    gateway $HOST_IP
    dns-nameservers $DNS1 $DNS2
EOF

echo -e "${GREEN}  Static IP configured${NC}"

# ============================================================================
# RESTART NETWORK
# ============================================================================

echo -e "${YELLOW}[3] Restarting network...${NC}"
systemctl restart networking

sleep 3

# Check if we got IP
if ip addr show $ETH | grep -q "$DESKTOP_IP"; then
    echo -e "${GREEN}  ✓ IP configured: $DESKTOP_IP${NC}"
else
    echo -e "${RED}  ✗ IP not configured!${NC}"
    ip addr show $ETH
fi

# ============================================================================
# TEST CONNECTION
# ============================================================================

echo -e "${YELLOW}[4] Testing connections...${NC}"

# Test gateway
if ping -c 1 -W 2 $HOST_IP >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Can reach host laptop ($HOST_IP)${NC}"
else
    echo -e "${RED}  ✗ Cannot reach host laptop!${NC}"
    echo -e "${YELLOW}  Check ethernet cable!${NC}"
fi

# Test internet
if ping -c 1 -W 4 8.8.8.8 >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Internet connected!${NC}"
else
    echo -e "${RED}  ✗ No internet!${NC}"
fi

# ============================================================================
# ENABLE SSH
# ============================================================================

echo -e "${YELLOW}[5] Enabling SSH...${NC}"

# Install openssh if not present
if ! command -v sshd &> /dev/null; then
    apt update && apt install -y openssh-server
fi

# Configure SSH
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Enable and start
systemctl enable ssh
systemctl start ssh

echo -e "${GREEN}  ✓ SSH enabled${NC}"

# ============================================================================
# SET ROOT PASSWORD
# ============================================================================

echo -e "${YELLOW}[6] Root password${NC}"
echo -e "${YELLOW}  Please set root password when prompted${NC}"
passwd root

# ============================================================================
# FINAL INFO
# ============================================================================

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ CONFIGURATION COMPLETE!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Desktop IP:     ${GREEN}$DESKTOP_IP${NC}"
echo -e "  Host IP:       ${GREEN}$HOST_IP${NC}"
echo -e "  SSH Port:      ${GREEN}22${NC}"
echo -e "  SSH User:      ${GREEN}root${NC}"
echo ""
echo -e "${YELLOW}  From host laptop, connect with:${NC}"
echo -e "    ${GREEN}ssh root@$DESKTOP_IP${NC}"
echo ""
echo -e "${YELLOW}  Copy scripts with:${NC}"
echo -e "    ${GREEN}scp -r scripts/* root@$DESKTOP_IP:/root/${NC}"
echo ""
