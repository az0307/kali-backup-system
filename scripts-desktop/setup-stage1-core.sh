#!/bin/bash
# STAGE 1: Core System & Tools

export DEBIAN_FRONTEND=noninteractive

echo "Installing Core Tools..."

apt update -y 2>/dev/null || true

# Wireless
apt install -y aircrack-ng reaver bully wifite wifiphisher 2>/dev/null || true

# Network
apt install -y nmap masscan net-tools iproute2 rustscan 2>/dev/null || true

# Password
apt install -y hashcat john crunch hydra 2>/dev/null || true

# Web & Exploit
apt install -y nikto sqlmap gobuster dirb metasploit-framework searchsploit 2>/dev/null || true

# Basics
apt install -y python3 python3-pip git curl wget vim build-essential tmux 2>/dev/null || true

echo "✅ Stage 1 Complete"
