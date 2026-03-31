#!/bin/bash
# Complete Kali Linux Pentest Setup + Gemini AI
# Run as root in Kali terminal
# Source: https://github.com/yourusername/kali-setup

set -e

echo "=========================================="
echo "Complete Kali Pentest Setup + Gemini AI"
echo "=========================================="

# Update
echo "[1/7] Updating system..."
sudo apt update && sudo apt upgrade -y

# Gemini CLI (AI Assistant - FREE!)
echo "[2/7] Installing Gemini AI..."
sudo apt install -y gemini-cli

# Wireless Tools
echo "[3/7] Installing wireless tools..."
sudo apt install -y aircrack-ng reaver wash bully wifite wifiphisher fern-wifi-cracker wpasupplicant

# Network Tools
echo "[4/7] Installing network tools..."
sudo apt install -y nmap masscan net-tools iproute2

# Password Tools
echo "[5/7] Installing password tools..."
sudo apt install -y hashcat john crunch

# Web & Exploitation
echo "[6/7] Installing web & exploitation tools..."
sudo apt install -y nikto sqlmap gobuster dirb metasploit-framework searchsploit

# Python & Basics
echo "[7/7] Installing Python & basics..."
sudo apt install -y python3 python3-pip git curl wget vim build-essential

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="

# Test wireless adapter
echo ""
echo "Testing TP-Link TL-WN721N..."
sleep 2

echo ""
echo "=== MONITOR MODE ==="
echo "Running: sudo airmon-ng start wlan0"
sudo airmon-ng start wlan0

echo ""
echo "=== VERIFY ==="
echo "Check interface:"
iw dev

echo ""
echo "=== TEST INJECTION ==="
echo "Running: sudo aireplay-ng -9 wlan0mon"
sudo aireplay-ng -9 wlan0mon 2>/dev/null || echo "Injection test done"

echo ""
echo "=========================================="
echo "All done!"
echo "=========================================="
echo ""
echo "To use Gemini AI:"
echo "  gemini --prompt 'your question'"
echo ""
echo "To scan networks:"
echo "  sudo airodump-ng wlan0mon"
echo ""
echo "Quick Commands:"
echo "  airmon-ng start wlan0     # Monitor mode"
echo "  airodump-ng wlan0mon      # Scan networks"
echo "  aireplay-ng --deauth 10 -a MAC wlan0mon  # Deauth"
echo "  aircrack-ng -w wordlist.cap  # Crack"
