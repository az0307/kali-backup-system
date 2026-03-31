#!/bin/bash
# ====================================================================
# Install All Security Tools - Kali Live USB
# Run: sudo ./install-all-tools.sh
# ====================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; exit 1; }

# Check root
[[ $EUID -ne 0 ]] && error "Run with sudo"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  KALI SECURITY TOOLS INSTALLER"
echo "════════════════════════════════════════════════════════════"
echo ""

log "Updating package lists..."
apt update -qq

# Core Pentest Tools
log "Installing core penetration testing tools..."
apt install -y \
    nmap \
    masscan \
    net-tools \
    tcpdump \
    wireshark \
    nikto \
    dirb \
    gobuster \
    sqlmap \
    sslyze \
    zaproxy \
    2>/dev/null

# Password Tools
log "Installing password cracking tools..."
apt install -y \
    john \
    hashcat \
    hydra \
    medusa \
    crowbar \
    2>/dev/null

# Wireless Tools
log "Installing wireless tools..."
apt install -y \
    aircrack-ng \
    reaver \
    wifite \
    mdk4 \
    hostapd \
    wpa-supplicant \
    2>/dev/null

# Exploitation
log "Installing exploitation frameworks..."
apt install -y \
    metasploit-framework \
    searchsploit \
    msfpc \
    2>/dev/null

# Windows Tools
log "Installing Windows assessment tools..."
apt install -y \
    impacket-scripts \
    responder \
    crackmapexec \
    ldapdomaindump \
    enum4linux \
    2>/dev/null

# Enumeration
log "Installing enumeration tools..."
apt install -y \
    nbtscan \
    enum4linux \
    smbclient \
    smbmap \
    2>/dev/null

# Web Shells
log "Installing web shells..."
apt install -y \
    weevely \
    findomain \
    2>/dev/null

# OSINT
log "Installing OSINT tools..."
apt install -y \
    theharvester \
    recon-ng \
    spiderfoot \
    2>/dev/null

# Forensics
log "Installing forensics tools..."
apt install -y \
    binwalk \
    foremost \
    strings \
    volatility \
    2>/dev/null

# Wordlists
log "Installing wordlists..."
apt install -y \
    seclists \
    wordlists \
    2>/dev/null

# Development
log "Installing development tools..."
apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    2>/dev/null

# Python tools
log "Installing Python security tools..."
pip3 install -q \
    payloads \
    evil-winrm \
    pwntools \
    2>/dev/null

echo ""
echo "════════════════════════════════════════════════════════════"
log "All tools installed successfully!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Quick commands:"
echo "  nmap -sn 192.168.1.0/24    # Network scan"
echo "  airmon-ng                  # WiFi monitor"
echo "  msfconsole                 # Metasploit"
echo "  hydra                      # Password attacks"
echo "  sqlmap                     # SQL injection"
echo ""