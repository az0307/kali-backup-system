#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-bluteam.log"

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
        "jq"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            apt-get install -y -qq "$dep" 2>/dev/null || warn "$dep not available"
        fi
    done
    
    pip3 install --break-system-packages requests pyjwt cryptography 2>/dev/null || \
        pip3 install requests pyjwt cryptography
    
    success "Dependencies installed"
}

install_sentinel_mcp() {
    log "Installing Sentinel-MCP..."
    
    local install_dir="/opt/Sentinel-MCP"
    local repo_url="https://github.com/sec-escapes/Sentinel-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "Sentinel-MCP installed"
}

install_splunk_mcp() {
    log "Installing Splunk-MCP..."
    
    local install_dir="/opt/Splunk-MCP"
    local repo_url="https://github.com/sec-escapes/Splunk-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "Splunk-MCP installed"
}

install_elastic_mcp() {
    log "Installing Elastic-MCP..."
    
    local install_dir="/opt/Elastic-MCP"
    local repo_url="https://github.com/sec-escapes/Elastic-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "Elastic-MCP installed"
}

install_virustotal_mcp() {
    log "Installing VirusTotal-MCP..."
    
    local install_dir="/opt/VirusTotal-MCP"
    local repo_url="https://github.com/sec-escapes/VirusTotal-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    if ! command -ppath-resolve virustotal &> /dev/null; then
        pip3 install virustotal-api --break-system-packages 2>/dev/null || pip3 install virustotal-api
    fi
    
    success "VirusTotal-MCP installed"
}

install_crowdstrike_mcp() {
    log "Installing CrowdStrike-Falcon-MCP..."
    
    local install_dir="/opt/CrowdStrike-Falcon-MCP"
    local repo_url="https://github.com/sec-escapes/CrowdStrike-Falcon-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "CrowdStrike-Falcon-MCP installed"
}

install_wazuh_mcp() {
    log "Installing Wazuh-MCP..."
    
    local install_dir="/opt/Wazuh-MCP"
    local repo_url="https://github.com/sec-escapes/Wazuh-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "Wazuh-MCP installed"
}

install_thehive_mcp() {
    log "Installing TheHive-MCP..."
    
    local install_dir="/opt/TheHive-MCP"
    local repo_url="https://github.com/sec-escapes/TheHive-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "TheHive-MCP installed"
}

install_misp_mcp() {
    log "Installing MISP-MCP (bonus)..."
    
    local install_dir="/opt/MISP-MCP"
    local repo_url="https://github.com/sec-escapes/MISP-MCP.git"
    
    if [ -d "$install_dir" ]; then
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "MISP-MCP installed"
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
    
    if ! grep -q "bluteam" "$config_file" 2>/dev/null; then
        cat > "$config_file" << 'EOFCONFIG'
{
  "mcp-servers": {
    "sentinel": {
      "command": "python3",
      "args": ["/opt/Sentinel-MCP/server.py"],
      "env": {
        "AZURE_SUBSCRIPTION_ID": "${AZURE_SUBSCRIPTION_ID}",
        "AZURE_TENANT_ID": "${AZURE_TENANT_ID}",
        "AZURE_CLIENT_ID": "${AZURE_CLIENT_ID}",
        "AZURE_CLIENT_SECRET": "${AZURE_CLIENT_SECRET}"
      }
    },
    "splunk": {
      "command": "python3",
      "args": ["/opt/Splunk-MCP/server.py"],
      "env": {
        "SPLUNK_HOST": "${SPLUNK_HOST}",
        "SPLUNK_PORT": "8089",
        "SPLUNK_USER": "admin",
        "SPLUNK_PASS": "${SPLUNK_PASSWORD}"
      }
    },
    "elastic": {
      "command": "python3",
      "args": ["/opt/Elastic-MCP/server.py"],
      "env": {
        "ELASTIC_HOST": "${ELASTIC_HOST}",
        "ELASTIC_USER": "elastic",
        "ELASTIC_PASS": "${ELASTIC_PASSWORD}"
      }
    },
    "virustotal": {
      "command": "python3",
      "args": ["/opt/VirusTotal-MCP/server.py"],
      "env": {
        "VT_API_KEY": "${VT_API_KEY}"
      }
    },
    "crowdstrike": {
      "command": "python3",
      "args": ["/opt/CrowdStrike-Falcon-MCP/server.py"],
      "env": {
        "FALCON_CLIENT_ID": "${FALCON_CLIENT_ID}",
        "FALCON_CLIENT_SECRET": "${FALCON_CLIENT_SECRET}"
      }
    },
    "wazuh": {
      "command": "python3",
      "args": ["/opt/Wazuh-MCP/server.py"],
      "env": {
        "WAZUH_URL": "${WAZUH_URL}",
        "WAZUH_USER": "admin",
        "WAZUH_PASSWORD": "${WAZUH_PASSWORD}"
      }
    },
    "thehive": {
      "command": "python3",
      "args": ["/opt/TheHive-MCP/server.py"],
      "env": {
        "THEHIVE_URL": "${THEHIVE_URL}",
        "THEHIVE_API_KEY": "${THEHIVE_API_KEY}"
      }
    },
    "misp": {
      "command": "python3",
      "args": ["/opt/MISP-MCP/server.py"],
      "env": {
        "MISP_URL": "${MISP_URL}",
        "MISP_API_KEY": "${MISP_API_KEY}"
      }
    }
  }
}
EOFCONFIG
        success "Added to OpenCode config"
    else
        warn "Blue team MCPs already in config"
    fi
}

create_env_example() {
    log "Creating environment example file..."
    
    cat > /opt/bluteam-mcp-env.example << 'EOF'
# Blue Team MCPs - Environment Variables

# Microsoft Sentinel
AZURE_SUBSCRIPTION_ID=your_subscription_id
AZURE_TENANT_ID=your_tenant_id
AZURE_CLIENT_ID=your_client_id
AZURE_CLIENT_SECRET=your_client_secret

# Splunk
SPLUNK_HOST=splunk.example.com
SPLUNK_PASSWORD=your_splunk_password

# Elasticsearch
ELASTIC_HOST=https://elasticsearch.example.com
ELASTIC_PASSWORD=your_elastic_password

# VirusTotal
VT_API_KEY=your_virustotal_api_key

# CrowdStrike Falcon
FALCON_CLIENT_ID=your_falcon_client_id
FALCON_CLIENT_SECRET=your_falcon_client_secret

# Wazuh
WAZUH_URL=https://wazuh.example.com
WAZUH_PASSWORD=your_wazuh_password

# TheHive
THEHIVE_URL=https://thehive.example.com
THEHIVE_API_KEY=your_thehive_api_key

# MISP
MISP_URL=https://misp.example.com
MISP_API_KEY=your_misp_api_key
EOF

    success "Environment example created at /opt/bluteam-mcp-env.example"
}

show_summary() {
    echo
    echo "=============================================="
    echo "  Blue Team MCPs Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to: /opt/"
    echo "  • Sentinel-MCP"
    echo "  • Splunk-MCP"
    echo "  • Elastic-MCP"
    echo "  • VirusTotal-MCP"
    echo "  • CrowdStrike-Falcon-MCP"
    echo "  • Wazuh-MCP"
    echo "  • TheHive-MCP"
    echo "  • MISP-MCP (bonus)"
    echo
    echo "Log file: $LOG_FILE"
    echo
    echo "Environment file: /opt/bluteam-mcp-env.example"
    echo
    echo "Required setup:"
    echo "  1. Copy env example: cp /opt/bluteam-mcp-env.example ~/.bluteam-mcp.env"
    echo "  2. Fill in your API keys"
    echo "  3. Source before use: source ~/.bluteam-mcp.env"
    echo
}

main() {
    log "Starting Blue Team MCPs installation..."
    
    check_root
    install_dependencies
    install_sentinel_mcp
    install_splunk_mcp
    install_elastic_mcp
    install_virustotal_mcp
    install_crowdstrike_mcp
    install_wazuh_mcp
    install_thehive_mcp
    install_misp_mcp
    add_to_opencode_config
    create_env_example
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
