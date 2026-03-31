#!/bin/bash
# ====================================================================
# Kali Live USB - Essential Tools Installer
# Run this after booting Kali Live
# ====================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      KALI LIVE USB - ESSENTIAL TOOLS INSTALLER        ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Run with sudo!${NC}"
   exit 1
fi

echo -e "${YELLOW}[1] Updating package lists...${NC}"
apt update -qq

echo -e "${YELLOW}[2] Installing pentest tools...${NC}"
apt install -y \
    nmap \
    masscan \
    aircrack-ng \
    reaver \
    wash \
    mdk4 \
    hostapd-tools \
    wireshark-commons \
    tcpdump \
    nikto \
    dirb \
    gobuster \
    sqlmap \
    john \
    hashcat \
    hydra \
    responder \
    impacket-scripts \
    crackmapexec \
    empire-community \
    koadic \
   veil \
    > /dev/null 2>&1

echo -e "${YELLOW}[3] Installing privilege escalation tools...${NC}"
apt install -y \
    linux-exploit-suggester \
    linux-enum-users \
    ps-py \
    > /dev/null 2>&1

echo -e "${YELLOW}[4] Installing WiFi tools...${NC}"
apt install -y \
    wifite \
    fluxion \
    > /dev/null 2>&1

echo -e "${YELLOW}[5] Installing web tools...${NC}"
apt install -y \
    zaproxy \
    burpsuite \
    > /dev/null 2>&1

echo -e "${YELLOW}[6] Installing password tools...${NC}"
apt install -y \
    chntpw \
    ntfs-3g \
    > /dev/null 2>&1

echo -e "${YELLOW}[7] Installing network tools...${NC}"
apt install -y \
    net-tools \
    iputils-ping \
    traceroute \
    nfs-common \
    smbclient \
    enum4linux \
    > /dev/null 2>&1

echo -e "${YELLOW}[8] Installing wordlists...${NC}"
apt install -y \
    wordlists \
    seclists \
    > /dev/null 2>&1

echo -e "${YELLOW}[9] Installing development tools...${NC}"
apt install -y \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    > /dev/null 2>&1

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ALL TOOLS INSTALLED!                        ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Quick commands:"
echo "  nmap -sn 192.168.1.0/24    - Network scan"
echo "  airmon-ng                  - WiFi monitor mode"
echo "  hydra                      - Password attacks"
echo "  sqlmap                     - SQL injection"
echo "  msfconsole                 - Metasploit"
echo ""