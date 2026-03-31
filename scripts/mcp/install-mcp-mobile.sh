#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install-mcp-mobile.log"

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
        "android-sdk"
        "build-essential"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "^ii  $dep"; then
            apt-get install -y -qq "$dep" 2>/dev/null || warn "$dep not available"
        fi
    done
    
    pip3 install --break-system-packages pydantic httpx 2>/dev/null || pip3 install pydantic httpx
    
    success "Dependencies installed"
}

install_apktool() {
    log "Installing apktool..."
    
    if command -v apktool &> /dev/null; then
        success "apktool already installed"
        return
    fi
    
    local apktool_version="2.9.3"
    local apktool_dir="/opt/apktool"
    
    mkdir -p "$apktool_dir"
    cd "$apktool_dir"
    
    wget -q https://github.com/iBotPeaches/Apktool/releases/download/v${apktool_version}/apktool_${apktool_version}.jar -O apktool.jar
    
    cat > apktool << 'EOF'
#!/bin/bash
java -jar "$(dirname "$0")/apktool.jar" "$@"
EOF
    chmod +x apktool
    ln -sf "$apktool_dir/apktool" /usr/local/bin/apktool
    
    success "apktool installed to $apktool_dir"
}

install_android_sdk() {
    log "Installing Android SDK..."
    
    if [ -n "$ANDROID_HOME" ] || [ -n "$ANDROID_SDK_ROOT" ]; then
        success "Android SDK already configured"
        return
    fi
    
    local sdk_dir="/opt/android-sdk"
    mkdir -p "$sdk_dir"
    cd "$sdk_dir"
    
    if [ ! -f "cmdline-tools/latest/bin/sdkmanager" ]; then
        log "Downloading Android command-line tools..."
        wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
        unzip -qo cmdline-tools.zip
        mkdir -p cmdline-tools/latest
        mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
        rm -f cmdline-tools.zip
    fi
    
    export ANDROID_HOME="$sdk_dir"
    export ANDROID_SDK_ROOT="$sdk_dir"
    export PATH="$PATH:$sdk_dir/cmdline-tools/latest/bin:$sdk_dir/platform-tools"
    
    yes | sdkmanager --licenses 2>/dev/null || true
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" 2>/dev/null || true
    
    cat >> /etc/profile.d/android-sdk.sh << EOF
export ANDROID_HOME=$sdk_dir
export ANDROID_SDK_ROOT=$sdk_dir
export PATH=\$PATH:$sdk_dir/cmdline-tools/latest/bin:$sdk_dir/platform-tools
EOF
    
    success "Android SDK installed to $sdk_dir"
}

install_android_mcp() {
    log "Installing android-mcp-server..."
    
    local install_dir="/opt/android-mcp-server"
    local repo_url="https://github.com/sec-escapes/android-mcp-server.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating android-mcp-server..."
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
    
    cat > "$install_dir/run.sh" << 'EOF'
#!/bin/bash
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
cd /opt/android-mcp-server
python3 server.py "$@"
EOF
    chmod +x "$install_dir/run.sh"
    
    success "android-mcp-server installed"
}

install_apktool_mcp() {
    log "Installing apktool-mcp-server..."
    
    local install_dir="/opt/apktool-mcp-server"
    local repo_url="https://github.com/sec-escapes/apktool-mcp-server.git"
    
    if [ -d "$install_dir" ]; then
        log "Updating apktool-mcp-server..."
        cd "$install_dir"
        git pull
    else
        git clone "$repo_url" "$install_dir"
        cd "$install_dir"
    fi
    
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
    fi
    
    cat > "$install_dir/run.sh" << 'EOF'
#!/bin/bash
cd /opt/apktool-mcp-server
python3 server.py "$@"
EOF
    chmod +x "$install_dir/run.sh"
    
    success "apktool-mcp-server installed"
}

install_mobile_tools() {
    log "Installing additional mobile security tools..."
    
    local tools=(
        "jadx"
        "dex2jar"
        "jad"
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null && ! dpkg -l | grep -q "^ii  $tool"; then
            apt-get install -y -qq "$tool" 2>/dev/null || warn "$tool not available"
        fi
    done
    
    if ! command -v jadx &> /dev/null; then
        log "Installing jadx..."
        cd /tmp
        wget -q https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip -O jadx.zip
        unzip -qo jadx.zip
        mv jadx-1.4.7 /opt/jadx
        ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
        rm -f jadx.zip
    fi
    
    if ! command -v d2j-dex2jar &> /dev/null; then
        log "Installing dex2jar..."
        cd /tmp
        wget -q https://github.com/pxb1988/dex2jar/releases/download/v2.0/dex2jar-2.0.zip -O dex2jar.zip
        unzip -qo dex2jar.zip
        mv dex2jar-2.0 /opt/dex2jar
        ln -sf /opt/dex2jar/d2j-dex2jar.sh /usr/local/bin/d2j-dex2jar
        rm -f dex2jar.zip
    fi
    
    success "Additional mobile tools installed"
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
    
    if ! grep -q "android-mcp" "$config_file" 2>/dev/null; then
        cat > "$config_file" << 'EOFCONFIG'
{
  "mcp-servers": {
    "android": {
      "command": "/opt/android-mcp-server/run.sh",
      "env": {
        "ANDROID_HOME": "/opt/android-sdk",
        "ANDROID_SDK_ROOT": "/opt/android-sdk"
      }
    },
    "apktool": {
      "command": "/opt/apktool-mcp-server/run.sh",
      "env": {
        "APKTOOL_PATH": "/opt/apktool/apktool.jar"
      }
    }
  }
}
EOFCONFIG
        success "Added to OpenCode config"
    else
        warn "Mobile MCPs already in config"
    fi
}

show_summary() {
    echo
    echo "=============================================="
    echo "  Mobile Security MCPs Installation Complete!"
    echo "=============================================="
    echo
    echo "Installed to:"
    echo "  • /opt/android-sdk - Android SDK"
    echo "  • /opt/android-mcp-server - Android MCP server"
    echo "  • /opt/apktool - apktool"
    echo "  • /opt/apktool-mcp-server - apktool MCP server"
    echo "  • /opt/jadx - Java decompiler"
    echo "  • /opt/dex2jar - DEX tools"
    echo
    echo "Log file: $LOG_FILE"
    echo
    echo "Tools available:"
    echo "  • apktool - APK decompilation/rebuilding"
    echo "  • jadx - DEX to Java decompiler"
    echo "  • d2j-dex2jar - DEX to JAR converter"
    echo "  • adb - Android Debug Bridge"
    echo
    echo "Environment setup:"
    echo "  source /etc/profile.d/android-sdk.sh"
    echo
}

main() {
    log "Starting Mobile Security MCPs installation..."
    
    check_root
    install_dependencies
    install_apktool
    install_android_sdk
    install_android_mcp
    install_apktool_mcp
    install_mobile_tools
    add_to_opencode_config
    show_summary
    
    success "Installation completed successfully!"
}

main "$@"
