#!/bin/bash
# ====================================================================
# Install Best WiFi Pentesting Tools
# Based on latest Kali tools and GitHub repos
# ====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; }

log "Installing Best WiFi Pentesting Tools..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    warn "This script should be run as root for full functionality"
    warn "Run with: sudo $0"
fi

# Update package lists
log "Updating package lists..."
apt update

# Install core wireless tools
log "Installing core wireless tools..."
apt install -y aircrack-ng reaver hashcat mdk4 hostapd dnsmasq \
    wifite wpa-supplicant pciutils usbutils wireless-tools \
    iw rfkill macchanger

# Install Python dependencies
log "Installing Python dependencies..."
apt install -y python3 python3-pip python3-venv

# Create tools directory
mkdir -p /opt/wifi-tools
cd /opt/wifi-tools

# Install WiFiSentry
log "Installing WiFiSentry..."
if [ -d "WiFiSentry" ]; then
    rm -rf WiFiSentry
fi
git clone https://github.com/Ajay-Bommidi/WiFiSentry.git
cd WiFiSentry
pip3 install -r requirements.txt
cd ..

# Install Wifyte
log "Installing Wifyte..."
if [ -d "wifyte" ]; then
    rm -rf wifyte
fi
git clone https://github.com/Mysteriza/wifyte.git
cd wifyte
pip3 install rich mac-vendor-lookup
cd ..

# Install WiFiStrike
log "Installing WiFiStrike..."
if [ -d "wifistrike" ]; then
    rm -rf wifistrike
fi
git clone https://github.com/arxhr007/wifistrike.git
cd wifistrike
pip3 install -r requirements.txt
cd ..

# Install Fluxion (if not already installed)
log "Installing Fluxion..."
if [ ! -d "/opt/fluxion" ]; then
    git clone --recursive https://github.com/FluxionNetwork/fluxion.git /opt/fluxion
    cd /opt/fluxion
    ./fluxion.sh --help >/dev/null 2>&1 || true
fi

# Install RX-WiFi Pro
log "Installing RX-WiFi Pro..."
if [ -d "rx-wifi-pro" ]; then
    rm -rf rx-wifi-pro
fi
git clone https://github.com/ctz101-tx/RX-wifi.git rx-wifi-pro
cd rx-wifi-pro
bash install.sh 2>/dev/null || true
cd ..

# Install Wraithnet
log "Installing Wraithnet..."
if [ -d "wraithnet" ]; then
    rm -rf wraithnet
fi
git clone https://github.com/truemorganss/wraithnet.git

# Install HackWiFi
log "Installing HackWiFi..."
if [ -d "hackwifi" ]; then
    rm -rf hackwifi
fi
git clone https://github.com/whoiscurrie/hackwifi.git

# Create launcher scripts
log "Creating launcher scripts..."

cat > /usr/local/bin/wifi-sentry << 'EOF'
#!/bin/bash
cd /opt/wifi-tools/WiFiSentry
sudo python3 wifisentry.py
EOF

cat > /usr/local/bin/wifyte << 'EOF'
#!/bin/bash
cd /opt/wifi-tools/wifyte
sudo python3 main.py
EOF

cat > /usr/local/bin/wifistrike << 'EOF'
#!/bin/bash
cd /opt/wifi-tools/wifistrike
sudo python3 wifistrike.py
EOF

cat > /usr/local/bin/fluxion << 'EOF'
#!/bin/bash
cd /opt/fluxion
sudo ./fluxion.sh
EOF

cat > /usr/local/bin/rx-wifi << 'EOF'
#!/bin/bash
cd /opt/wifi-tools/rx-wifi-pro
sudo python3 rxwifi.py
EOF

chmod +x /usr/local/bin/wifi-sentry /usr/local/bin/wifyte /usr/local/bin/wifistrike /usr/local/bin/fluxion /usr/local/bin/rx-wifi

# Create comprehensive menu
log "Creating WiFi Tools Menu..."

cat > /usr/local/bin/wifi-menu << 'EOF'
#!/bin/bash
# ====================================================================
# WiFi Pentesting Tools Menu
# ====================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  WiFi Pentesting Tools Menu${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo "1. WiFiSentry      - Rogue AP detection, handshake capture"
echo "2. Wifyte          - Modern WPA handshake capture tool"
echo "3. WiFiStrike      - Pure Python deauthentication tool"
echo "4. Fluxion         - MITM WPA phishing attacks"
echo "5. RX-WiFi Pro     - AI-powered WiFi security testing"
echo "6. Wraithnet       - Multi-tool WiFi pentesting"
echo "7. HackWiFi        - Automated WiFi toolkit"
echo "8. Wifite2         - Classic automated wireless attacks"
echo "9. Aircrack-ng     - Core WiFi cracking suite"
echo "10. Hashcat        - GPU-accelerated password cracking"
echo "0. Exit"
echo ""
read -p "Select tool [0-10]: " choice

case $choice in
    1) sudo wifi-sentry ;;
    2) sudo wifyte ;;
    3) sudo wifistrike ;;
    4) sudo fluxion ;;
    5) sudo rx-wifi ;;
    6) cd /opt/wifi-tools/wraithnet && sudo python3 wraithnet.py ;;
    7) cd /opt/wifi-tools/hackwifi && sudo python3 hackwifi.py ;;
    8) sudo wifite ;;
    9) airmon-ng ;;
    10) hashcat --help ;;
    0) exit 0 ;;
    *) echo "Invalid option" ;;
esac
EOF

chmod +x /usr/local/bin/wifi-menu

log "WiFi tools installed successfully!"
log "Run 'wifi-menu' to access all tools"

echo ""
echo "=== Installed Tools ==="
echo "✓ WiFiSentry    - /opt/wifi-tools/WiFiSentry"
echo "✓ Wifyte       - /opt/wifi-tools/wifyte"
echo "✓ WiFiStrike   - /opt/wifi-tools/wifistrike"
echo "✓ Fluxion      - /opt/fluxion"
echo "✓ RX-WiFi Pro  - /opt/wifi-tools/rx-wifi-pro"
echo "✓ Wraithnet    - /opt/wifi-tools/wraithnet"
echo "✓ HackWiFi     - /opt/wifi-tools/hackwifi"
echo ""
echo "=== Quick Commands ==="
echo "  wifi-menu    - Open menu"
echo "  wifi-sentry  - Run WiFiSentry"
echo "  wifyte       - Run Wifyte"
echo "  wifistrike  - Run WiFiStrike"
echo "  fluxion      - Run Fluxion"
echo "  rx-wifi      - Run RX-WiFi Pro"
