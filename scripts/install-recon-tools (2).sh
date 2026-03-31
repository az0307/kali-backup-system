#!/bin/bash
# ====================================================================
# Install Advanced Recon & Network Scanning Tools
# Based on ProjectDiscovery and best GitHub repos
# ====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }

log "Installing Advanced Recon & Network Tools..."

# Install Go if not present
if ! command -v go &> /dev/null; then
    log "Installing Go..."
    apt update && apt install -y golang
fi

# Install ProjectDiscovery tools
log "Installing ProjectDiscovery tools..."

# naabu - fast port scanner
if ! command -v naabu &> /dev/null; then
    go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
    cp ~/go/bin/naabu /usr/local/bin/
fi

# httpx - HTTP toolkit
if ! command -v httpx &> /dev/null; then
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
    cp ~/go/bin/httpx /usr/local/bin/
fi

# nuclei - vulnerability scanner
if ! command -v nuclei &> /dev/null; then
    go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
    cp ~/go/bin/nuclei /usr/local/bin/
fi

# subfinder - subdomain enumeration
if ! command -v subfinder &> /dev/null; then
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    cp ~/go/bin/subfinder /usr/local/bin/
fi

# amass - subdomain enumeration
if ! command -v amass &> /dev/null; then
    go install -v github.com/owasp-amass/assemble/v3/cmd/amass@latest
    cp ~/go/bin/amass /usr/local/bin/
fi

# Install AutoRecon
log "Installing AutoRecon..."
if [ ! -d "/opt/AutoRecon" ]; then
    git clone --quiet https://github.com/AutoRecon/AutoRecon.git /opt/AutoRecon
    cd /opt/AutoRecon
    pip3 install -r requirements.txt 2>/dev/null || true
    chmod +x autorecon.py
fi

# Install PythMap
log "Installing PythMap..."
if [ ! -d "/opt/PythMap" ]; then
    git clone --quiet https://github.com/TheBitty/PythMap.git /opt/PythMap
    cd /opt/PythMap
    pip3 install python-nmap scapy 2>/dev/null || true
fi

# Install SpyHunt
log "Installing SpyHunt..."
if [ ! -d "/opt/SpyHunt" ]; then
    git clone --quiet https://github.com/Pymmdrza/SpyHunt.git /opt/SpyHunt
    cd /opt/SpyHunt
    pip3 install -r requirements.txt 2>/dev/null || true
fi

# Install reconftw
log "Installing reconftw..."
if ! command -v reconftw &> /dev/null; then
    if [ ! -d "/opt/reconftw" ]; then
        git clone --quiet https://github.com/sixfootdeveloper/reconftw.git /opt/reconftw
        cd /opt/reconftw
        chmod +x reconftw.sh
        ./reconftw.sh -h 2>/dev/null || true
    fi
fi

# Create recon menu
log "Creating Recon Menu..."

cat > /usr/local/bin/recon-menu << 'EOF'
#!/bin/bash
echo "╔═══════════════════════════════════════╗"
echo "║   RECON & SCANNING TOOLS MENU     ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "1. AutoRecon      - Full automated enumeration"
echo "2. Naabu          - Fast port scanner"
echo "3. Httpx          - HTTP probing"
echo "4. Nuclei         - Vulnerability scanner"
echo "5. Subfinder      - Subdomain enumeration"
echo "6. Amass          - Subdomain enum"
echo "7. PythMap        - Nmap with banner grab"
echo "8. SpyHunt        - Full recon framework"
echo "9. Quick Nmap     - Basic nmap scan"
echo "0. Exit"
read -p "Select: " c
case $c in
    1) cd /opt/AutoRecon && python3 autorecon.py ;;
    2) naabu -h ;;
    3) httpx -h ;;
    4) nuclei -h ;;
    5) subfinder -h ;;
    6) amass -h ;;
    7) cd /opt/PythMap && python3 main.py ;;
    8) cd /opt/SpyHunt && python3 spyhunt.py ;;
    9) 
        read -p "Target: " t
        nmap -sV -p- $t
        ;;
esac
EOF

chmod +x /usr/local/bin/recon-menu

log "Recon tools installed!"
echo ""
echo "=== Installed Tools ==="
echo "✓ naabu     - Fast port scanner"
echo "✓ httpx     - HTTP toolkit"
echo "✓ nuclei    - Vulnerability scanner"
echo "✓ subfinder - Subdomain enum"
echo "✓ amass     - Subdomain enum"
echo "✓ AutoRecon - Automated enumeration"
echo "✓ PythMap   - Network scanner"
echo "✓ SpyHunt   - Full recon framework"
echo ""
echo "Run: recon-menu"
