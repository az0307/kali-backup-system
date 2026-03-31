#!/bin/bash
# STAGE 4: Remote Access & Networking
# Run as root: sudo ./scripts/setup-stage4-network.sh

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     STAGE 4: Remote Access & Networking          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "[1/4] Installing SSH server..."
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

echo "[2/4] Installing VPN tools..."
sudo apt install -y openvpn wireguard

echo "[3/4] Installing networking tools..."
sudo apt install -y netcat-openbsd socat proxychains

echo "[4/4] Installing cloud tunnel tools..."
# Ngrok alternative - Cloudflare Tunnel
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

echo ""
echo "✅ Stage 4 Complete!"
echo ""
echo "Commands:"
echo "  ssh root@<ip>           # SSH into Kali"
echo "  service ssh start      # Start SSH"
echo "  cloudflared tunnel     # Create tunnel"
