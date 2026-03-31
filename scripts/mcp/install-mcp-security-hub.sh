#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-security-hub.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${CYAN}[i]${NC} $1" | tee -a "$LOG_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        error "Docker daemon is not running. Please start Docker."
        exit 1
    fi
    
    success "Docker is available"
}

check_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        success "docker-compose is available"
    elif docker compose version &> /dev/null; then
        success "docker compose plugin is available"
    else
        error "Docker Compose is not installed"
        exit 1
    fi
}

check_already_installed() {
    if [ -d "/opt/mcp-security-hub" ] || [ -d "$HOME/mcp-security-hub" ]; then
        warn "mcp-security-hub appears to be installed"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            success "Skipping installation"
            exit 0
        fi
    fi
}

install_tools() {
    log "Installing security tools..."
    
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    
    local tools=(
        "nmap"
        "nikto"
        "sqlmap"
        "ffuf"
        "dirb"
        "wpscan"
        "dnsenum"
        "sublist3r"
        "theHarvester"
        "recon-ng"
        "binwalk"
        "foremost"
        "steghide"
        "volatility"
        "autopsy"
        "p7zip-full"
        "radare2"
        "ghidra"
        "jadx"
        "apktool"
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null && ! dpkg -l | grep -q "^ii  $tool"; then
            log "Installing $tool..."
            apt-get install -y -qq "$tool" 2>/dev/null || warn "$tool not available"
        fi
    done
    
    if ! command -v nuclei &> /dev/null; then
        log "Installing Nuclei..."
        download_nuclei
    fi
    
    if ! command -v masscan &> /dev/null; then
        log "Installing masscan..."
        apt-get install -y -qq masscan 2>/dev/null || install_masscan
    fi
    
    if ! command -v hashcat &> /dev/null; then
        log "Installing hashcat..."
        apt-get install -y -qq hashcat 2>/dev/null || install_hashcat
    fi
    
    success "Security tools installed"
}

download_nuclei() {
    local nuclei_version="v3.2.0"
    local tmp_dir="/tmp/nuclei_install"
    
    mkdir -p "$tmp_dir"
    cd "$tmp_dir"
    
    if command -v curl &> /dev/null; then
        curl -sL "https://github.com/projectdiscovery/nuclei/releases/download/${nuclei_version}/nuclei_${nuclei_version}_linux_amd64.zip" -o nuclei.zip
    else
        wget -q "https://github.com/projectdiscovery/nuclei/releases/download/${nuclei_version}/nuclei_${nuclei_version}_linux_amd64.zip" -O nuclei.zip
    fi
    
    unzip -qo nuclei.zip
    chmod +x nuclei
    mv nuclei /usr/local/bin/
    
    cd /tmp
    rm -rf "$tmp_dir"
    
    success "Nuclei installed"
}

install_masscan() {
    apt-get install -y -qq git build-essential
    cd /tmp
    git clone https://github.com/robertdavidgraham/masscan.git
    cd masscan
    make -j$(nproc)
    cp bin/masscan /usr/local/bin/
    cd /tmp
    rm -rf masscan
    success "masscan installed"
}

install_hashcat() {
    apt-get install -y -qq build-essential
    cd /tmp
    git clone https://github.com/hashcat/hashcat.git
    cd hashcat
    make -j$(nproc)
    cp hashcat /usr/local/bin/
    cd /tmp
    rm -rf hashcat
    success "hashcat installed"
}

install_security_hub() {
    log "Installing FuzzingLabs/mcp-security-hub..."
    
    local install_dir="/opt/mcp-security-hub"
    local repo_url="https://github.com/FuzzingLabs/mcp-security-hub.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating existing installation..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        log "Installing Python dependencies..."
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    if [ -f "package.json" ]; then
        log "Installing Node dependencies..."
        npm install 2>/dev/null || true
    fi
    
    success "mcp-security-hub installed to $install_dir"
}

create_docker_compose() {
    log "Creating Docker Compose configuration..."
    
    local compose_file="/opt/mcp-security-hub/docker-compose.yml"
    
    cat > "$compose_file" << 'EOF'
version: '3.8'

services:
  mcp-security-hub:
    image: fuzzinglabs/mcp-security-hub:latest
    container_name: mcp-security-hub
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
    volumes:
      - ./data:/data
      - /tmp:/tmp
      - /etc/passwd:/etc/passwd:ro
      - /etc/group:/etc/group:ro
    network_mode: host
    restart: unless-stopped

  # Security tool containers
  nmap-mcp:
    image: alpine/nmap:latest
    container_name: nmap-mcp
    volumes:
      - ./data/nmap:/output
    command: ["sleep", "infinity"]
    restart: unless-stopped

  nuclei-mcp:
    image: projectdiscovery/nuclei:latest
    container_name: nuclei-mcp
    volumes:
      - ./data/nuclei:/root/.nuclei
      - ./data/nuclei-templates:/nuclei-templates
    command: ["sleep", "infinity"]
    restart: unless-stopped

  sqlmap-mcp:
    image: paoloo/sqlmap:latest
    container_name: sqlmap-mcp
    volumes:
      - ./data/sqlmap:/root/.sqlmap
    command: ["sleep", "infinity"]
    restart: unless-stopped

  nikto-mcp:
    image: sullo/nikto:latest
    container_name: nikto-mcp
    volumes:
      - ./data/nikto:/tmp/nikto
    command: ["sleep", "infinity"]
    restart: unless-stopped

  ffuf-mcp:
    image: ffuf/ffuf:latest
    container_name: ffuf-mcp
    volumes:
      - ./data/ffuf:/tmp/ffuf
    command: ["sleep", "infinity"]
    restart: unless-stopped

  hashcat-mcp:
    image: hashcat/hashcat:latest
    container_name: hashcat-mcp
    volumes:
      - ./data/hashcat:/data
    command: ["sleep", "infinity"]
    restart: unless-stopped

  ghidra-mcp:
    image: ghcr.io/nightwatchys/ghidra:latest
    container_name: ghidra-mcp
    volumes:
      - ./data/ghidra:/project
    environment:
      - GHIDRA_VERSION=11.0
    command: ["sleep", "infinity"]
    restart: unless-stopped
EOF

    success "Docker Compose file created at $compose_file"
}

create_mcp_config() {
    log "Creating MCP configuration..."
    
    local config_dir="/opt/mcp-security-hub/config"
    mkdir -p "$config_dir"
    
    cat > "$config_dir/servers.json" << 'EOFCONFIG'
{
  "mcpServers": {
    "nmap": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "alpine/nmap", "nmap"]
    },
    "nuclei": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "projectdiscovery/nuclei", "nuclei"]
    },
    "sqlmap": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "paoloo/sqlmap", "sqlmap"]
    },
    "nikto": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "sullo/nikto", "nikto"]
    },
    "ffuf": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "ffuf/ffuf", "ffuf"]
    },
    "shodan": {
      "command": "shodan",
      "args": ["host"]
    },
    "masscan": {
      "command": "masscan"
    },
    "hashcat": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "-v", "$(pwd)/data:/data", "hashcat/hashcat", "hashcat"]
    },
    "ghidra": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "-v", "$(pwd)/data/ghidra:/project", "ghcr.io/nightwatchys/ghidra"]
    },
    "bloodhound": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "--network=host", "-p", "7474:7474", "-p", "7687:7687", "-e", "NEO4J_AUTH=none", "neo4j"]
    }
  }
}
EOFCONFIG

    success "MCP configuration created"
}

start_services() {
    log "Starting Docker services..."
    
    cd /opt/mcp-security-hub
    
    if docker compose version &> /dev/null; then
        docker compose up -d
    else
        docker-compose up -d
    fi
    
    success "Docker services started"
}

add_to_opencode_config() {
    log "Adding to OpenCode config..."
    
    local config_file="$HOME/.config/opencode/mcp-servers.json"
    mkdir -p "$(dirname "$config_file")"
    
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << 'EOF'
{
  "mcp-servers": {}
}
EOF
    fi
    
    if ! grep -q "security-hub" "$config_file" 2>/dev/null; then
        local temp_file=$(mktemp)
        jq '. + {
          "mcp-servers": (.["mcp-servers"] // {}) + {
            "security-hub": {
              "command": "docker",
              "args": ["run", "--rm", "-i", "--network=host", "fuzzinglabs/mcp-security-hub:latest"]
            }
          }
        }' "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
        success "Added to OpenCode config"
    else
        warn "security-hub already in config"
    fi
}

show_tools() {
    echo
    echo "=============================================="
    echo "  MCP Security Hub - Installed Tools"
    echo "=============================================="
    echo
    echo -e "${GREEN}Offensive Security:${NC}"
    echo "  • nmap - Network scanning"
    echo "  • nuclei - Vulnerability scanning"
    echo "  • sqlmap - SQL injection"
    echo "  • nikto - Web server scanning"
    echo "  • ffuf - Fuzzing"
    echo "  • masscan - Fast port scanner"
    echo "  • dirb - Web content scanner"
    echo "  • wpscan - WordPress scanner"
    echo
    echo -e "${GREEN}Reconnaissance:${NC}"
    echo "  • shodan - IoT search engine"
    echo "  • theHarvester - Email gathering"
    echo "  • recon-ng - Web reconnaissance"
    echo "  • sublist3r - Subdomain enumeration"
    echo "  • dnsenum - DNS enumeration"
    echo
    echo -e "${GREEN}Password Attacks:${NC}"
    echo "  • hashcat - Password cracking"
    echo "  • john - John the Ripper"
    echo
    echo -e "${GREEN}Reverse Engineering:${NC}"
    echo "  • ghidra - Disassembler"
    echo "  • radare2 - Framework for analysis"
    echo "  • jadx - DEX decompiler"
    echo "  • apktool - APK manipulation"
    echo
    echo -e "${GREEN}Forensics:${NC}"
    echo "  • volatility - Memory forensics"
    echo "  • autopsy - Digital forensics"
    echo "  • binwalk - Firmware analysis"
    echo "  • foremost - File carving"
    echo
    echo -e "${GREEN}Active Directory:${NC}"
    echo "  • bloodhound - AD enumeration"
    echo "  • crackmapexec - AD exploitation"
    echo
}

show_summary() {
    echo
    echo "=============================================="
    echo "  MCP Security Hub Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to: /opt/mcp-security-hub"
    echo "Log file: $LOG_FILE"
    echo
    echo "To start services:"
    echo "  cd /opt/mcp-security-hub"
    echo "  docker compose up -d"
    echo
    echo "To view logs:"
    echo "  docker compose logs -f"
    echo
    show_tools
}

main() {
    log "Starting MCP Security Hub installation..."
    
    check_root
    check_docker
    check_docker_compose
    check_already_installed
    install_tools
    install_security_hub
    create_docker_compose
    create_mcp_config
    start_services
    add_to_opencode_config
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
