#!/bin/bash
# ====================================================================
# KALISHARE COMPREHENSIVE SETUP
# Sets up everything: SSH, RDP, MCP, AI tools, Desktop Connector
# ====================================================================

set -euo pipefail

KALI_SHARE="/root/KaliShare"
LOG_FILE="${KALI_SHARE}/logs/setup.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; exit 1; }

mkdir -p "$(dirname "$LOG_FILE")"

install_ssh() {
    log "Installing and configuring SSH..."
    
    apt-get update
    apt-get install -y openssh-server
    
    # Configure SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    
    # Allow port 22
    ufw allow 22/tcp 2>/dev/null || true
    
    # Start SSH
    systemctl enable ssh
    systemctl start ssh
    
    log "SSH installed and running on port 22"
    echo "SSH=$(date)" >> "$LOG_FILE"
}

install_rdp() {
    log "Installing XRDP for Remote Desktop..."
    
    apt-get install -y xrdp xfce4 kali-desktop-xfce
    
    # Configure XRDP
    echo "startxfce4" > ~/.xsession
    
    # Allow RDP port
    ufw allow 3389/tcp 2>/dev/null || true
    
    # Start XRDP
    systemctl enable xrdp
    systemctl start xrdp
    
    log "XRDP installed and running on port 3389"
    echo "RDP=$(date)" >> "$LOG_FILE"
}

install_mcp() {
    log "Installing MCP (Model Context Protocol) servers..."
    
    # Install Node.js if needed
    if ! command -v node &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
        apt-get install -y nodejs
    fi
    
    # Install Python MCP
    pip3 install mcp serverforge 2>/dev/null || true
    
    # Install essential MCP servers
    npm install -g @modelcontextprotocol/server-filesystem 2>/dev/null || true
    npm install -g @modelcontextprotocol/server-github 2>/dev/null || true
    npm install -g @anthropic-ai/mcp-server 2>/dev/null || true
    
    log "MCP servers installed"
    echo "MCP=$(date)" >> "$LOG_FILE"
}

install_ai_tools() {
    log "Installing AI tools..."
    
    # Ollama
    if ! command -v ollama &> /dev/null; then
        curl -fsSL https://ollama.com/install.sh | sh
    fi
    
    # OpenCode (if available)
    if [[ ! -f "/usr/local/bin/opencode" ]]; then
        # Try to install from source or binary
        echo "OpenCode setup skipped - use standalone"
    fi
    
    # Python AI libraries
    pip3 install openai anthropic google-generativeai 2>/dev/null || true
    
    log "AI tools installed"
    echo "AI=$(date)" >> "$LOG_FILE"
}

configure_firewall() {
    log "Configuring firewall rules..."
    
    # Allow common pentest ports
    ufw allow 22/tcp    # SSH
    ufw allow 3389/tcp  # RDP
    ufw allow 4444/tcp  # Metasploit
    ufw allow 5555/tcp  # Metasploit
    ufw allow 8080/tcp  # HTTP proxy
    ufw allow 443/tcp   # HTTPS
    
    # Enable UFW if not already
    echo "y" | ufw enable 2>/dev/null || true
    
    log "Firewall configured"
}

setup_network() {
    log "Setting up network services..."
    
    # Get IP
    local ip=$(ip addr | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d'/' -f1)
    
    echo "======================================"
    echo "  KALI SHARE NETWORK CONFIG"
    echo "======================================"
    echo ""
    echo "  IP Address: $ip"
    echo "  SSH Port: 22"
    echo "  RDP Port: 3389"
    echo ""
    echo "  Connect from Windows:"
    echo "    SSH: ssh root@$ip"
    echo "    RDP: $ip:3389"
    echo ""
    echo "  Use KaliShare Connector app on Windows"
    echo "======================================"
    
    echo "IP=$ip" >> "$LOG_FILE"
}

install_desktop_tools() {
    log "Installing desktop organization tools..."
    
    # Create launchers
    mkdir -p /root/Desktop/KaliShare
    
    # Copy desktop app configs
    if [[ -d "${KALI_SHARE}/desktop" ]]; then
        cp -r "${KALI_SHARE}/desktop" /root/
    fi
    
    # Setup bashrc enhancements
    if [[ -f "${KALI_SHARE}/aliases.sh" ]]; then
        echo "" >> /root/.bashrc
        echo "# KaliShare aliases" >> /root/.bashrc
        echo "source ${KALI_SHARE}/aliases.sh" >> /root/.bashrc
    fi
    
    # Setup desktop organization
    if [[ -f "${KALI_SHARE}/scripts/setup-desktop-org.sh" ]]; then
        bash "${KALI_SHARE}/scripts/setup-desktop-org.sh"
    fi
    
    log "Desktop tools configured"
}

show_summary() {
    local ip=$(ip addr | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d'/' -f1)
    
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          KALI SHARE SETUP COMPLETE                   ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}Network:${NC} $ip"
    echo -e "  ${GREEN}SSH:${NC} Enabled (port 22)"
    echo -e "  ${GREEN}RDP:${NC} Enabled (port 3389)"
    echo -e "  ${GREEN}MCP:${NC} Installed"
    echo -e "  ${GREEN}AI:${NC} Installed"
    echo ""
    echo -e "  ${YELLOW}Windows Connection:${NC}"
    echo -e "    SSH:  ssh root@$ip"
    echo -e "    RDP:  $ip:3389"
    echo ""
    echo -e "  ${YELLOW}KaliShare Commands:${NC}"
    echo -e "    go help              - Show all commands"
    echo -e "    go status            - System status"
    echo -e "    go widget            - Tool launcher"
    echo ""
    echo -e "  ${YELLOW}Desktop App:${NC}"
    echo -e "    Run on Windows: python KaliShare-Connector.py"
    echo ""
}

main() {
    echo -e "${CYAN}Starting KaliShare Comprehensive Setup...${NC}"
    
    install_ssh
    install_rdp
    install_mcp
    install_ai_tools
    configure_firewall
    install_desktop_tools
    setup_network
    show_summary
    
    log "Setup complete!"
}

main "$@"