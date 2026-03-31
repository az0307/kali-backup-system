#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-metasploit.log"

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

check_already_installed() {
    if [ -d "/opt/MetasploitMCP" ] || command -v msfrpc &> /dev/null; then
        warn "MetasploitMCP appears to be installed"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            success "Skipping installation"
            exit 0
        fi
    fi
}

install_metasploit() {
    log "Installing Metasploit Framework..."
    
    export DEBIAN_FRONTEND=noninteractive
    
    if command -v msfconsole &> /dev/null; then
        success "Metasploit already installed"
        return
    fi
    
    apt-get update -qq
    
    curl -fsSL https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
    chmod 755 /tmp/msfinstall
    /tmp/msfinstall
    
    rm -f /tmp/msfinstall
    
    success "Metasploit installed"
}

install_dependencies() {
    log "Installing dependencies..."
    
    local deps=(
        "python3"
        "python3-pip"
        "python3-venv"
        "git"
        "curl"
        "wget"
        "ruby"
        "rubygems"
        "build-essential"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "^ii  $dep"; then
            apt-get install -y -qq "$dep" 2>/dev/null || warn "$dep not available"
        fi
    done
    
    success "Dependencies installed"
}

install_metasploit_mcp() {
    log "Installing MetasploitMCP from GitHub..."
    
    local install_dir="/opt/MetasploitMCP"
    local repo_url="https://github.com/GH05TCREW/MetasploitMCP.git"
    
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
    
    if [ -f "setup.sh" ]; then
        log "Running setup script..."
        chmod +x setup.sh
        ./setup.sh 2>/dev/null || warn "Setup script had issues"
    fi
    
    success "MetasploitMCP installed to $install_dir"
}

configure_msfrpc() {
    log "Configuring msfrpc..."
    
    mkdir -p /etc/metasploit
    cat > /etc/metasploit/msf_config.yml << 'EOF'
# Metasploit RPC Configuration
rpc:
  host: 127.0.0.1
  port: 55553
  user: msf
  password: password
  ssl: false

# Auto-start configuration
auto_start: true

# Database configuration
database:
  host: localhost
  port: 5432
  name: msf
  username: msf
  password: ""
EOF

    cat > /etc/systemd/system/msfrpc.service << 'EOF'
[Unit]
Description=Metasploit RPC Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/MetasploitMCP
ExecStart=/usr/bin/msfrpc -P password -U msf -a 127.0.0.1
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload 2>/dev/null || true
    
    success "msfrpc configured"
}

create_start_script() {
    log "Creating start scripts..."
    
    cat > /usr/local/bin/msf-start << 'EOF'
#!/bin/bash

# Start PostgreSQL if not running
systemctl start postgresql 2>/dev/null || true

# Initialize database if needed
msfdb init 2>/dev/null || true

# Start msfrpc
msfrpc -P password -U msf -a 127.0.0.1 &
MSFRPC_PID=$!

echo "msfrpc started with PID: $MSFRPC_PID"
echo "RPC API available at: http://127.0.0.1:55553"
EOF

    chmod +x /usr/local/bin/msf-start
    
    cat > /usr/local/bin/msf-stop << 'EOF'
#!/bin/bash

pkill -f msfrpc || true
echo "msfrpc stopped"
EOF

    chmod +x /usr/local/bin/msf-stop
    
    success "Start/stop scripts created"
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
    
    if ! grep -q "metasploit" "$config_file" 2>/dev/null; then
        local temp_file=$(mktemp)
        jq '. + {
          "mcp-servers": (.["mcp-servers"] // {}) + {
            "metasploit": {
              "command": "python3",
              "args": ["/opt/MetasploitMCP/mcp_server.py"],
              "env": {
                "MSFRPC_HOST": "127.0.0.1",
                "MSFRPC_PORT": "55553",
                "MSFRPC_USER": "msf",
                "MSFRPC_PASS": "password"
              }
            }
          }
        }' "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
        success "Added to OpenCode config"
    else
        warn "metasploit already in config"
    fi
}

show_summary() {
    echo
    echo "=============================================="
    echo "  MetasploitMCP Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to: /opt/MetasploitMCP"
    echo "Log file: $LOG_FILE"
    echo
    echo "To start Metasploit RPC:"
    echo "  msf-start"
    echo "  or"
    echo "  systemctl start msfrpc"
    echo "  or"
    echo "  msfrpc -P password -U msf -a 127.0.0.1"
    echo
    echo "To stop:"
    echo "  msf-stop"
    echo
    echo "Access via:"
    echo "  Host: 127.0.0.1"
    echo "  Port: 55553"
    echo "  User: msf"
    echo "  Password: password"
    echo
}

main() {
    log "Starting MetasploitMCP installation..."
    
    check_root
    check_already_installed
    install_dependencies
    install_metasploit
    install_metasploit_mcp
    configure_msfrpc
    create_start_script
    add_to_opencode_config
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
