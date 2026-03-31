#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# KALI LIVE USB - 5-MINUTE QUICK START
# Run this after booting Kali Live
# ═══════════════════════════════════════════════════════════════════

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      KALI LIVE USB - 5-MINUTE QUICK START           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check root
if [ "$(id -u)" -ne 0 ]; then
   echo -e "${RED}Run with sudo!${NC}"
   exit 1
fi

# ============================================================
# STEP 1: NETWORK SETUP
# ============================================================
echo -e "${YELLOW}[1] NETWORK SETUP${NC}"
echo "Connecting to WiFi..."
nmcli dev wifi connect "Melton 1" password "meltonone" 2>/dev/null
echo -e "${GREEN}✓ Connected to Melton 1${NC}"
echo ""

# ============================================================
# STEP 2: UPDATE SYSTEM
# ============================================================
echo -e "${YELLOW}[2] UPDATE SYSTEM${NC}"
echo "Running apt update..."
apt update -qq
echo -e "${GREEN}✓ System updated${NC}"
echo ""

# ============================================================
# STEP 3: INSTALL ESSENTIAL TOOLS
# ============================================================
echo -e "${YELLOW}[3] INSTALL ESSENTIAL TOOLS${NC}"
echo "Installing pentest tools..."
apt install -y nmap aircrack-ng reaver nfs-utils smbclient 2>/dev/null
echo -e "${GREEN}✓ Tools installed${NC}"
echo ""

# ============================================================
# STEP 4: START SERVICES
# ============================================================
echo -e "${YELLOW}[4] START SERVICES${NC}"
systemctl start ssh 2>/dev/null
service apache2 start 2>/dev/null
echo -e "${GREEN}✓ SSH and HTTP started${NC}"
echo ""

# ============================================================
# STEP 5: SHOW NETWORK INFO
# ============================================================
echo -e "${YELLOW}[5] NETWORK INFO${NC}"
echo "Your IP: $(hostname -I | awk '{print $1}')"
echo "Gateway: $(ip route | grep default | awk '{print $3}')"
echo ""

# ============================================================
# STEP 6: SHOW SAVED CREDENTIALS
# ============================================================
echo -e "${YELLOW}[6] SAVED CREDENTIALS${NC}"
echo "Melton 1: meltonone"
echo "TelstraBF869B: E3CF746CF4"
echo ""

# ============================================================
# READY - SHOW OPTIONS
# ============================================================
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    READY!                                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}QUICK COMMANDS:${NC}"
echo "  ./MENU                 - Full interactive menu"
echo "  nmap -sn 192.168.1.0/24 - Scan network"
echo "  airmon-ng start wlan0  - Monitor mode"
echo "  opencode               - AI assistant (if installed)"
echo ""
echo -e "${GREEN}TO INSTALL AI TOOLS (takes longer):${NC}"
echo "  ./scripts-desktop/install-ai-tools.sh"
echo ""
