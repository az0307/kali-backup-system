#!/bin/bash
# Kali VM - Network + SSH Setup Script
# Run this in your Kali VM terminal

echo "=========================================="
echo "  KALI VM - NETWORK + SSH SETUP"
echo "=========================================="

# Get IP
echo "[1/4] Getting IP address..."
ip addr show

# Try DHCP if no IP
echo ""
echo "[2/4] Requesting DHCP..."
sudo dhclient -v

# Show IP again
echo ""
echo "[3/4] Your IP address:"
ip addr show | grep "inet "

# Enable SSH
echo ""
echo "[4/4] Enabling SSH..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Set root password
echo ""
echo "=========================================="
echo "  SSH is now enabled!"
echo "  Run: sudo systemctl start ssh"
echo "  Then tell me your IP address"
echo "=========================================="
