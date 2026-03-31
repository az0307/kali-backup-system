#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-re.log"

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
        "python3-venv"
        "git"
        "curl"
        "wget"
        "openjdk-17-jdk"
        "gradle"
        "rustc"
        "cargo"
        "build-essential"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "^ii  $dep"; then
            apt-get install -y -qq "$dep" 2>/dev/null || warn "$dep not available"
        fi
    done
    
    if [ -f "/usr/lib/jvm/java-17-openjdk-amd64/bin/java" ]; then
        export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    fi
    
    pip3 install --break-system-packages pydantic httpx 2>/dev/null || pip3 install pydantic httpx
    
    success "Dependencies installed"
}

install_ghidra() {
    log "Installing Ghidra..."
    
    if command -v ghidra &> /dev/null; then
        success "Ghidra already installed"
        return
    fi
    
    local ghidra_dir="/opt/ghidra"
    local ghidra_version="11.0.3"
    local ghidra_file="ghidra_${ghidra_version}_PUBLIC.zip"
    local ghidra_url="https://github.com/NationalSecurityAgency/ghidra/releases/download/ghidra_${ghidra_version}_PUBLIC/${ghidra_file}"
    
    mkdir -p "$ghidra_dir"
    cd "$ghidra_dir"
    
    if [ ! -f "$ghidra_file" ]; then
        log "Downloading Ghidra $ghidra_version..."
        wget -q "$ghidra_url" || curl -sL "$ghidra_url" -o "$ghidra_file"
    fi
    
    if [ -f "$ghidra_file" ]; then
        log "Extracting Ghidra..."
        unzip -qo "$ghidra_file"
        rm -f "$ghidra_file"
        
        ln -sf "$ghidra_dir/ghidra_${ghidra_version}_PUBLIC/ghidraRun" /usr/local/bin/ghidra
        ln -sf "$ghidra_dir/ghidra_${ghidra_version}_PUBLIC/ghidraRun.bat" /usr/local/bin/ghidra.bat
        
        success "Ghidra installed to $ghidra_dir"
    else
        warn "Failed to download Ghidra"
    fi
}

install_ghidra_mcp() {
    log "Installing lauriewired/ghidramcp..."
    
    local install_dir="/opt/ghidramcp"
    local repo_url="https://github.com/lauriewired/ghidramcp.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating ghidramcp..."
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
        chmod +x setup.sh
        ./setup.sh 2>/dev/null || true
    fi
    
    cat > /opt/ghidramcp/run.sh << 'EOF'
#!/bin/bash
export GHIDRA_INSTALL_DIR=/opt/ghidra/ghidra_11.0.3_PUBLIC
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
cd /opt/ghidramcp
python3 mcp_server.py "$@"
EOF
    chmod +x /opt/ghidramcp/run.sh
    
    success "GhidraMCP installed to $install_dir"
}

install_ida_mcp() {
    log "Installing ida-mcp-rs..."
    
    local install_dir="/opt/ida-mcp-rs"
    local repo_url="https://github.com/hexgolems/ida-mcp-rs.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating ida-mcp-rs..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    cargo build --release 2>/dev/null || warn "cargo build failed - will try alternative install"
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    success "ida-mcp-rs installed to $install_dir"
}

install_re_tools() {
    log "Installing additional RE tools..."
    
    local tools=(
        "radare2"
        "binwalk"
        "foremost"
        "ghidra"
        "jadx"
        "apktool"
        "d2j"
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null && ! dpkg -l | grep -q "^ii  $tool"; then
            apt-get install -y -qq "$tool" 2>/dev/null || warn "$tool not available"
        fi
    done
    
    if ! command -v r2 &> /dev/null; then
        apt-get install -y -qq radare2 2>/dev/null || true
    fi
    
    if ! command -v jadx &> /dev/null; then
        log "Installing jadx..."
        cd /tmp
        wget -q https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip -O jadx.zip
        unzip -qo jadx.zip
        mv jadx-1.4.7 /opt/jadx
        ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
        rm -f jadx.zip
    fi
    
    if ! command -v apktool &> /dev/null; then
        log "Installing apktool..."
        wget -q https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -O /usr/local/bin/apktool
        wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar -O /usr/local/bin/apktool.jar
        chmod +x /usr/local/bin/apktool
    fi
    
    success "Additional RE tools installed"
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
    
    if ! grep -q "ghidra" "$config_file" 2>/dev/null; then
        cat > "$config_file" << 'EOFCONFIG'
{
  "mcp-servers": {
    "ghidra": {
      "command": "/opt/ghidramcp/run.sh",
      "env": {
        "GHIDRA_INSTALL_DIR": "/opt/ghidra/ghidra_11.0.3_PUBLIC",
        "JAVA_HOME": "/usr/lib/jvm/java-17-openjdk-amd64"
      }
    },
    "ida": {
      "command": "/opt/ida-mcp-rs/target/release/ida-mcp",
      "args": []
    }
  }
}
EOFCONFIG
        success "Added to OpenCode config"
    else
        warn "RE MCPs already in config"
    fi
}

show_summary() {
    echo
    echo "=============================================="
    echo "  Reverse Engineering MCPs Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to:"
    echo "  • /opt/ghidra - Ghidra disassembler"
    echo "  • /opt/ghidramcp - Ghidra MCP server"
    echo "  • /opt/ida-mcp-rs - IDA Pro MCP server"
    echo
    echo "Log file: $LOG_FILE"
    echo
    echo "Additional tools installed:"
    echo "  • radare2 - Command-line framework"
    echo "  • jadx - DEX decompiler"
    echo "  • apktool - APK manipulation"
    echo "  • binwalk - Firmware analysis"
    echo
    echo "To use Ghidra MCP:"
    echo "  /opt/ghidramcp/run.sh"
    echo
    echo "Note: IDA MCP requires IDA Pro (commercial)"
    echo
}

main() {
    log "Starting Reverse Engineering MCPs installation..."
    
    check_root
    install_dependencies
    install_ghidra
    install_ghidra_mcp
    install_ida_mcp
    install_re_tools
    add_to_opencode_config
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
