#!/bin/bash
# ====================================================================
# Complete Home Lab Setup Script
# Sets up everything: WiFi tools, AI tools, network, pentest env
# ====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         HOME LAB - COMPLETE SETUP v3.0                     ║"
echo "║         WiFi + AI + Pentest + Network                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
    warn "Running as non-root - some features may not work"
    warn "Run with: sudo $0"
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi

log "Detected OS: $OS"

# Stage 1: Core Tools
log "════════════════════════════════════════════════════"
log "Stage 1: Installing Core Tools"
log "════════════════════════════════════════════════════"

apt update
apt install -y git curl wget python3 python3-pip python3-venv \
    aircrack-ng reaver hashcat mdk4 hostapd dnsmasq wifite \
    nmap nikto gobuster sqlmap hydra john net-tools \
    tcpdump wireshark metasploit-framework \
    python3-pip ruby perl

# Stage 2: WiFi Tools
log "════════════════════════════════════════════════════"
log "Stage 2: Installing WiFi Pentesting Tools"
log "════════════════════════════════════════════════════"

mkdir -p /opt/wifi-tools
cd /opt/wifi-tools

# Install WiFiSentry
if [ ! -d "WiFiSentry" ]; then
    log "Installing WiFiSentry..."
    git clone --quiet https://github.com/Ajay-Bommidi/WiFiSentry.git
    cd WiFiSentry
    pip3 install rich scapy 2>/dev/null || true
    cd /opt/wifi-tools
fi

# Install Wifyte
if [ ! -d "wifyte" ]; then
    log "Installing Wifyte..."
    git clone --quiet https://github.com/Mysteriza/wifyte.git
    cd wifyte
    pip3 install rich mac-vendor-lookup 2>/dev/null || true
    cd /opt/wifi-tools
fi

# Install Fluxion
if [ ! -d "/opt/fluxion" ]; then
    log "Installing Fluxion..."
    git clone --quiet --recursive https://github.com/FluxionNetwork/fluxion.git /opt/fluxion
fi

# Install RX-WiFi
if [ ! -d "rx-wifi-pro" ]; then
    log "Installing RX-WiFi Pro..."
    git clone --quiet https://github.com/ctz101-tx/RX-wifi.git rx-wifi-pro
    cd rx-wifi-pro
    bash install.sh 2>/dev/null || true
    cd /opt/wifi-tools
fi

# Install Wraithnet
if [ ! -d "wraithnet" ]; then
    log "Installing Wraithnet..."
    git clone --quiet https://github.com/truemorganss/wraithnet.git
fi

# Create launcher scripts
log "Creating launcher scripts..."

cat > /usr/local/bin/wifi-tools << 'EOF'
#!/bin/bash
echo "╔═══════════════════════════════════════╗"
echo "║     WiFi Pentesting Tools Menu       ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "1. WiFiSentry   - Rogue AP detection"
echo "2. Wifyte       - Handshake capture"
echo "3. Fluxion      - WPA phishing"
echo "4. RX-WiFi Pro - AI WiFi testing"
echo "5. Wraithnet   - Multi-tool"
echo "6. Aircrack-ng - Core suite"
echo "7. Wifite      - Automated"
echo "0. Exit"
read -p "Select: " c
case $c in
    1) cd /opt/wifi-tools/WiFiSentry && sudo python3 wifisentry.py ;;
    2) cd /opt/wifi-tools/wifyte && sudo python3 main.py ;;
    3) cd /opt/fluxion && sudo ./fluxion.sh ;;
    4) cd /opt/wifi-tools/rx-wifi-pro && sudo python3 rxwifi.py ;;
    5) cd /opt/wifi-tools/wraithnet && sudo python3 wraithnet.py ;;
    6) airmon-ng ;;
    7) sudo wifite ;;
esac
EOF
chmod +x /usr/local/bin/wifi-tools

# Stage 3: AI Tools
log "════════════════════════════════════════════════════"
log "Stage 3: Installing AI Tools"
log "════════════════════════════════════════════════════"

# Install Claude Code (if not present)
if ! command -v claude &> /dev/null; then
    info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code 2>/dev/null || true
fi

# Install Gemini CLI
if ! command -v gemini &> /dev/null; then
    info "Installing Gemini CLI..."
    curl -fsSL https://google.github.io/gemini-cli/install | bash 2>/dev/null || true
fi

# Install oh-my-opencode
if [ ! -d "$HOME/oh-my-openagent" ]; then
    info "Installing oh-my-opencode..."
    git clone --quiet https://github.com/code-yeongyu/oh-my-openagent.git "$HOME/oh-my-openagent"
    cd "$HOME/oh-my-openagent"
    npm install 2>/dev/null || bun install 2>/dev/null || true
fi

# Configure OpenCode
mkdir -p "$HOME/.config/opencode"
cat > "$HOME/.config/opencode/opencode.json" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["oh-my-opencode@latest"],
  "model": {
    "provider": "opencode",
    "model": "claude-sonnet-4-20250514"
  }
}
EOF

# Stage 4: Network Setup
log "════════════════════════════════════════════════════"
log "Stage 4: Network Configuration"
log "════════════════════════════════════════════════════"

# Configure Ethernet
cat > /etc/network/interfaces.d/eth0 << 'EOF'
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
EOF

# Enable forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Setup SSH
apt install -y openssh-server
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl enable ssh

# Stage 5: Wordlists
log "Installing wordlists..."
mkdir -p /usr/share/wordlists
if [ ! -f /usr/share/wordlists/rockyou.txt ]; then
    wget -q -O /usr/share/wordlists/rockyou.txt.gz \
        https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt 2>/dev/null || true
    gunzip -f /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true
fi

# Create go command
log "Installing go command..."
GO_DIR="/root/KaliShare"
if [ -f "$GO_DIR/cli/go" ]; then
    cp "$GO_DIR/cli/go" /usr/local/bin/go
    chmod +x /usr/local/bin/go
fi

# Final Summary
echo ""
log "════════════════════════════════════════════════════"
log "HOME LAB SETUP COMPLETE!"
log "════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}Installed:${NC}"
echo "  ✓ Core pentest tools (nmap, nikto, sqlmap, metasploit)"
echo "  ✓ WiFi tools (aircrack-ng, reaver, wifite, mdk4)"
echo "  ✓ Advanced WiFi (WiFiSentry, Wifyte, Fluxion, RX-WiFi)"
echo "  ✓ AI tools (Claude Code, Gemini CLI, oh-my-opencode)"
echo "  ✓ Network: 192.168.1.100/24"
echo "  ✓ SSH enabled"
echo ""
echo -e "${CYAN}Quick Commands:${NC}"
echo "  go pentest <ip>      - Run pentest"
echo "  go wifi              - WiFi audit"
echo "  wifi-tools           - WiFi menu"
echo "  opencode             - Start AI coding"
echo "  gemini               - Start Gemini CLI"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Reboot to apply network changes"
echo "  2. Run 'go status' to verify"
echo "  3. Connect TP-Link adapter for WiFi testing"
