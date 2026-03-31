#!/bin/bash
# Network Scanner - Quick nmap network discovery

echo "=== NETWORK SCANNER ==="
echo ""

# Get interface
echo "Available interfaces:"
ip link show | grep -E "^[0-9]+:" | awk '{print $2}' | sed 's/:$//'
echo ""

# Quick scan
echo "Running quick network scan..."
nmap -sn 192.168.1.0/24 -oG - | grep "Up" | awk '{print $2, $3}'

echo ""
echo "=== Port Scan (top 100) ==="
read -p "Enter target IP: " target
if [ -n "$target" ]; then
    nmap -F --top-ports 100 "$target"
fi
