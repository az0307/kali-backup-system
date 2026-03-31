#!/bin/bash
# ====================================================================
# DESKTOP KALI FULL SETUP
# Complete setup script for Kali desktop
# ====================================================================

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           DESKTOP KALI FULL SETUP v1.0                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# Check root
if [ "$EUID" -ne 0 ]; then
    echo "Run as: sudo $0"
    exit 1
fi

USB_MOUNT=""
for mount in /media/usb /mnt/usb /mnt/sdb1 /mnt/sdc1; do
    if [ -d "$mount" ]; then
        USB_MOUNT=$mount
        break
    fi
done

echo ""
echo "[1/8] Network Setup..."
echo "=========================================="

ETH=$(ip -o link show | grep -i ethernet | head -1 | awk -F': ' '{print $2}')
echo "  Interface: $ETH"

ip addr add 192.168.1.200/24 dev $ETH 2>/dev/null || true
ip link set $ETH up
ip route add default via 192.168.1.100 2>/dev/null || true

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

echo "  IP: 192.168.1.200"
echo "  Gateway: 192.168.1.100"

echo ""
echo "[2/8] Updating system..."
echo "=========================================="
apt update && apt upgrade -y

echo ""
echo "[3/8] Installing essential tools..."
echo "=========================================="
apt install -y \
    git curl wget vim nano \
    network-manager \
    nmap net-tools \
    openssh-client \
    python3 python3-pip

echo ""
echo "[4/8] Installing pentesting tools..."
echo "=========================================="
apt install -y \
    nmap sqlmap nikto gobuster \
    john hashcat hydra \
    aircrack-ng reaver wifite

echo ""
echo "[5/8] Installing AI agents..."
echo "=========================================="
apt install -y nodejs npm

npm install -g opencode-ai 2>/dev/null || true
npm install -g @agent-tars/cli 2>/dev/null || true

echo "alias o='opencode'" >> ~/.bashrc
echo "alias t='agent-tars'" >> ~/.bashrc

echo ""
echo "[6/8] Installing QoL tools..."
echo "=========================================="
apt install -y zsh bat exa fzf ripgrep htop

echo ""
echo "[7/8] Copying tools from USB..."
echo "=========================================="
if [ -n "$USB_MOUNT" ] && [ -d "$USB_MOUNT/tools" ]; then
    cp -r $USB_MOUNT/tools/scripts/* ~/scripts/ 2>/dev/null || true
    echo "  Tools copied!"
else
    echo "  USB not found, skipping..."
fi

echo ""
echo "[8/8] Configuring SSH..."
echo "=========================================="
systemctl enable ssh
systemctl start ssh

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    SETUP COMPLETE!                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  Desktop IP:     192.168.1.200"
echo "  SSH Port:       22"
echo "  SSH User:       root"
echo ""
echo "  From laptop:    ssh root@192.168.1.200"
echo ""
