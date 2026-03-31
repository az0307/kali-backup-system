#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-redteam.log"

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

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

install_dependencies() {
    log "Installing dependencies..."
    
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    
    local deps=(
        "python3"
        "python3-pip"
        "git"
        "curl"
        "wget"
        "build-essential"
        "cargo"
        "go"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            apt-get install -y -qq "$dep" 2>/dev/null || warn "$dep not available"
        fi
    done
    
    success "Dependencies installed"
}

install_sliver_mcp() {
    log "Installing sec-sliver-c2-mcp..."
    
    local install_dir="/opt/sec-sliver-c2-mcp"
    local repo_url="https://github.com/sec-escapes/sec-sliver-c2-mcp.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating sec-sliver-c2-mcp..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    if [ -f "Cargo.toml" ]; then
        cargo build --release 2>/dev/null || true
    fi
    
    success "sec-sliver-c2-mcp installed"
}

install_havoc_mcp() {
    log "Installing sec-havoc-c2-mcp..."
    
    local install_dir="/opt/sec-havoc-c2-mcp"
    local repo_url="https://github.com/sec-escapes/sec-havoc-c2-mcp.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating sec-havoc-c2-mcp..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "sec-havoc-c2-mcp installed"
}

install_shodan_mcp() {
    log "Installing shodan-mcp..."
    
    local install_dir="/opt/shodan-mcp"
    local repo_url="https://github.com/sec-escapes/shodan-mcp.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating shodan-mcp..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    if ! command -v shodan &> /dev/null; then
        pip3 install shodan --break-system-packages 2>/dev/null || pip3 install shodan
    fi
    
    success "shodan-mcp installed"
}

install_masscan_mcp() {
    log "Installing masscan-mcp..."
    
    if ! command -v masscan &> /dev/null; then
        log "Installing masscan..."
        apt-get install -y -qq masscan 2>/dev/null || {
            cd /tmp
            git clone https://github.com/robertdavidgraham/masscan.git
            cd masscan
            make -j$(nproc)
            cp bin/masscan /usr/local/bin/
            cd /tmp
            rm -rf masscan
        }
    fi
    
    local install_dir="/opt/masscan-mcp"
    local repo_url="https://github.com/sec-escapes/masscan-mcp.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating masscan-mcp..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "masscan-mcp installed"
}

install_additional_redteam_tools() {
    log "Installing additional red team tools..."
    
    if ! command -v naabu &> /dev/null; then
        log "Installing naabu..."
        go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>/dev/null || true
    fi
    
    if ! command -v httpx &> /dev/null; then
        log "Installing httpx..."
        go install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null || true
    fi
    
    if ! command -v subdomainizer &> /dev/null; then
        log "Installing SubDomainizer..."
        pip3 install SubDomainizer --break-system-packages 2>/dev/null || true
    fi
    
    success "Additional tools installed"
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
    
    if ! grep -q "sliver" "$config_file" 2>/dev/null; then
        local temp_file=$(mktemp)
        jq '. + {
          "mcp-servers": (.["mcp-servers"] // {}) + {
            "sliver-c2": {
              "command": "python3",
              "args": ["/opt/sec-sliver-c2-mcp/server.py"]
            },
            "havoc-c2": {
              "command": "python3",
              "args": ["/opt/sec-havoc-c2-mcp/server.py"]
            },
            "shodan": {
              "command": "python3",
              "args": ["/opt/shodan-mcp/server.py"],
              "env": {
                "SHODAN_API_KEY": "${SHODAN_API_KEY}"
              }
            },
            "masscan": {
              "command": "python3",
              "args": ["/opt/masscan-mcp/server.py"]
            }
          }
        }' "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
        success "Added to OpenCode config"
    else
        warn "Red team MCPs already in config"
    fi
}

show_summary() {
    echo
    echo "=============================================="
    echo "  Red Team MCPs Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to: /opt/"
    echo "  • sec-sliver-c2-mcp"
    echo "  • sec-havoc-c2-mcp"
    echo "  • shodan-mcp"
    echo "  • masscan-mcp"
    echo
    echo "Log file: $LOG_FILE"
    echo
    echo "Required environment variables:"
    echo "  export SHODAN_API_KEY=your_api_key"
    echo
    echo "Sliver C2 requires:"
    echo "  • Generate implant: ./sliver client"
    echo "  • Start server: ./sliver server"
    echo
    echo "Havoc C2 requires:"
    echo "  • Team server: ./havocd teamserver"
    echo
}

main() {
    log "Starting Red Team MCPs installation..."
    
    check_root
    install_dependencies
    install_sliver_mcp
    install_havoc_mcp
    install_shodan_mcp
    install_masscan_mcp
    install_additional_redteam_tools
    add_to_opencode_config
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
