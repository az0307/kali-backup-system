#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-kali.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

check_kali() {
    if ! command -v apt-get &> /dev/null; then
        error "This script requires Debian/Ubuntu/Kali Linux"
        exit 1
    fi
}

check_already_installed() {
    if command -v mcp-kali-server &> /dev/null || [ -d "/opt/MCP-Kali-Server" ]; then
        warn "MCP-Kali-Server is already installed"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            success "Skipping installation"
            exit 0
        fi
    fi
}

install_dependencies() {
    log "Installing dependencies..."
    
    export DEBIAN_FRONTEND=noninteractive
    
    apt-get update -qq
    
    local deps=(
        "python3"
        "python3-pip"
        "python3-venv"
        "git"
        "curl"
        "wget"
        "msfpc"
        "metasploit-framework"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "^ii  $dep"; then
            log "Installing $dep..."
            apt-get install -y -qq "$dep" 2>/dev/null || warn "$dep not available in repos"
        fi
    done
    
    success "Dependencies installed"
}

install_msfrpc() {
    log "Setting up msfrpc..."
    
    if command -v msfrpc &> /dev/null; then
        success "msfrpc already available"
        return
    fi
    
    if command -v msfconsole &> /dev/null; then
        log "Metasploit is available, msfrpc should be included"
        
        if [ ! -f "/usr/bin/msfrpc" ]; then
            ln -sf /opt/metasploit-framework/msf3/msfrpc /usr/bin/msfrpc 2>/dev/null || true
            ln -sf /opt/metasploit-framework/msf3/msfrpc /usr/local/bin/msfrpc 2>/dev/null || true
        fi
    else
        warn "Metasploit not installed - msfrpc may not be available"
    fi
}

install_mcp_kali() {
    log "Installing MCP-Kali-Server from GitHub..."
    
    local install_dir="/opt/MCP-Kali-Server"
    local repo_url="https://github.com/Wh0am123/MCP-Kali-Server.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating existing installation..."
        cd "$install_dir"
        git pull origin main 2>/dev/null || git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        log "Installing Python dependencies..."
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    if [ -f "setup.py" ]; then
        log "Running setup..."
        python3 setup.py install 2>/dev/null || true
    fi
    
    if [ -f "install.sh" ]; then
        log "Running provided install script..."
        chmod +x install.sh
        ./install.sh 2>/dev/null || true
    fi
    
    success "MCP-Kali-Server installed to $install_dir"
}

configure_msfrpc() {
    log "Configuring msfrpc..."
    
    local msf_config_dir="/etc/metasploit"
    local msf_config="$msf_config_dir/msf_config"
    
    mkdir -p "$msf_config_dir"
    
    cat > "$msf_config" << 'EOF'
# Metasploit RPC Configuration
# User configuration for msfrpc
msfrpc_user=msf
msfrpc_pass=password
msfrpc_host=127.0.0.1
msfrpc_port=55553
EOF
    
    chmod 600 "$msf_config"
    success "msfrpc configured"
}

add_to_opencode_config() {
    log "Adding to OpenCode config..."
    
    local config_file="$HOME/.config/opencode/mcp-servers.json"
    
    mkdir -p "$(dirname "$config_file")"
    
    if [ -f "$config_file" ]; then
        if grep -q "mcp-kali-server" "$config_file" 2>/dev/null; then
            warn "MCP-Kali-Server already in config"
            return
        fi
    fi
    
    local config_content=$(cat << 'EOFCONFIG'
{
  "mcp-servers": {
    "kali": {
      "command": "python3",
      "args": ["/opt/MCP-Kali-Server/mcp_kali_server.py"],
      "env": {
        "MSFRPC_HOST": "127.0.0.1",
        "MSFRPC_PORT": "55553"
      }
    }
  }
}
EOFCONFIG
)
    
    if [ -f "$config_file" ]; then
        jq -s '.[0] * .[1]' "$config_file" <(echo "$config_content") > "$config_file.tmp" 2>/dev/null && \
            mv "$config_file.tmp" "$config_file" || \
            echo "$config_content" >> "$config_file"
    else
        echo "$config_content" > "$config_file"
    fi
    
    success "Added to OpenCode config"
}

show_summary() {
    echo
    echo "=============================================="
    echo "  MCP-Kali-Server Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to: /opt/MCP-Kali-Server"
    echo "Log file: $LOG_FILE"
    echo
    echo "To start msfrpc service:"
    echo "  systemctl start metasploit"
    echo "  or"
    echo "  msfrpc -P password -U msf"
    echo
    echo "To use with OpenCode/Claude:"
    echo "  Add the config to your MCP servers config"
    echo
}

main() {
    log "Starting MCP-Kali-Server installation..."
    
    check_root
    check_kali
    check_already_installed
    install_dependencies
    install_msfrpc
    install_mcp_kali
    configure_msfrpc
    add_to_opencode_config
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
