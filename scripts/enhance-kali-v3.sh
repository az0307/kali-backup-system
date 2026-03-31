#!/bin/bash

################################################################################
#                                                                              #
#    ██████╗ ███████╗ ██████╗ ██╗   ██╗██╗  ██╗ ██████╗                    #
#    ██╔══██╗██╔════╝██╔════╝ ██║   ██║██║  ██║██╔═══██╗                   #
#    ██████╔╝█████╗  ██║  ███╗██║   ██║███████║██║   ██║                   #
#    ██╔══██╗██╔══╝  ██║   ██║██║   ██║██╔══██║██║   ██║                   #
#    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║╚██████╔╝                   #
#    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝                    #
#                                                                              #
#           █████╗ ██╗      ██████╗  ██████╗ ██████╗ ███████╗██████╗         #
#          ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██╔════╝██╔══██╗        #
#          ███████║██║     ██║  ███╗██║   ██║██████╔╝█████╗  ██║  ██║        #
#          ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██╔══╝  ██║  ██║        #
#          ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║███████╗██████╔╝        #
#          ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝         #
#                                                                              #
#              🐉 KALI LINUX ENHANCEMENT SCRIPT v3.0                          #
#              AI Tools + Wireless Pentest + Ultimate UI/UX                   #
#                                                                              #
################################################################################

# ==============================================================================
# CONFIGURATION
# ==============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Script configuration
SCRIPT_VERSION="3.0"
SCRIPT_DATE="2026-03-16"
LOG_FILE="/var/log/kali-enhance.log"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "$message" | tee -a "$LOG_FILE"
}

log_header() {
    echo ""
    log "INFO" "${CYAN}════════════════════════════════════════════════════════════${NC}"
    log "INFO" "${CYAN}  $*${NC}"
    log "INFO" "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

log_success() {
    log "INFO" "${GREEN}  ✓ $*${NC}"
}

log_error() {
    log "ERROR" "${RED}  ✗ $*${NC}" >&2
}

log_warn() {
    log "WARN" "${YELLOW}  ⚠ $*${NC}"
}

log_info() {
    log "INFO" "${BLUE}  ◆ $*${NC}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: Please run as root${NC}"
        echo -e "${YELLOW}Usage: sudo $0${NC}"
        exit 1
    fi
}

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
    else
        OS="unknown"
        VER="unknown"
    fi
}

# Check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ==============================================================================
# MAIN MENU
# ==============================================================================

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
    ██████╗ ███████╗ ██████╗ ██╗   ██╗██╗  ██╗ ██████╗                    
    ██╔══██╗██╔════╝██╔════╝ ██║   ██║██║  ██║██╔═══██╗                   
    ██████╔╝█████╗  ██║  ███╗██║   ██║███████║██║   ██║                   
    ██╔══██╗██╔══╝  ██║   ██║██║   ██║██╔══██║██║   ██║                   
    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║╚██████╔╝                   
    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝                    
                                                                     
         █████╗ ██╗      ██████╗  ██████╗ ██████╗ ███████╗██████╗            
        ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██╔════╝██╔══██╗           
        ███████║██║     ██║  ███╗██║   ██║██████╔╝█████╗  ██║  ██║           
        ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██╔══╝  ██║  ██║           
        ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║███████╗██████╔╝           
        ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝            
                                                                     
                         ╔═══════════════════════════════╗
                         ║   KALI ENHANCEMENT SUITE    ║
                         ║        v3.0 - 2026          ║
                         ╚═══════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}  Version: ${SCRIPT_VERSION}  |  Date: ${SCRIPT_DATE}  |  User: $(whoami)${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

show_menu() {
    show_banner
    
    echo -e "${CYAN}  ┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}  │                    MAIN MENU                             │${NC}"
    echo -e "${CYAN}  ├─────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}  │                                                         │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[1]${NC}  🔧  Full System Install (AI + UI + Tools)     │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[2]${NC}  🤖  AI Tools Only                              │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[3]${NC}  🎨  UI/UX Enhancement Only                     │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[4]${NC}  📡  Wireless/Pentest Tools Only                │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[5]${NC}  ⚡  Quick Install (Minimal)                   │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[6]${NC}  🔐  SSH & Remote Access Setup                  │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[7]${NC}  📊  System Info & Diagnostics                  │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[8]${NC}  🧹  Cleanup & Optimization                     │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[9]${NC}  💾  Backup Current Setup                        │${NC}"
    echo -e "${CYAN}  │  ${GREEN}[0]${NC}  ❌  Exit                                        │${NC}"
    echo -e "${CYAN}  │                                                         │${NC}"
    echo -e "${CYAN}  └─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Select option: " choice
    echo ""
}

# ==============================================================================
# INSTALLATION FUNCTIONS
# ==============================================================================

install_base() {
    log_header "BASE SYSTEM UPDATE"
    
    log_info "Updating package lists..."
    apt update -qq
    
    log_info "Upgrading system..."
    apt upgrade -y -qq
    
    log_info "Installing essential packages..."
    apt install -y -qq \
        curl \
        wget \
        git \
        vim \
        htop \
        tmux \
        tree \
        net-tools \
        dnsutils \
        iputils-ping \
        sudo \
        gnupg \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        lsb-release \
        figlet \
        boxes \
        lolcat
    
    log_success "Base packages installed"
}

install_python() {
    log_header "PYTHON ENVIRONMENT"
    
    if ! command_exists python3; then
        log_info "Installing Python 3..."
        apt install -y -qq python3 python3-pip python3-venv python3-dev
    fi
    
    log_info "Installing Python packages..."
    pip3 install --break-system-packages \
        requests \
        beautifulsoup4 \
        scapy \
        paramiko \
        pwntools \
        colorama \
        termcolor \
        pyyaml \
        jsonschema \
        yapf \
        black \
        flake8 \
        mypy \
        pytest
    
    log_success "Python environment configured"
}

install_nodejs() {
    log_header "NODE.JS ENVIRONMENT"
    
    if ! command_exists node; then
        log_info "Installing Node.js 20..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
        apt install -y -qq nodejs
    fi
    
    log_info "Installing global npm packages..."
    npm install -g npm@latest
    
    log_success "Node.js environment configured"
}

install_ai_tools() {
    log_header "🤖 AI TOOLS INSTALLATION"
    
    local tools=(
        "opencode-ai:OpenCode"
        "@google/gemini-cli:Gemini CLI"
        "@agent-tars/cli:TARS Agent"
        "@anthropic-ai/claude-code:Claude Code"
    )
    
    for item in "${tools[@]}"; do
        IFS=':' read -r package name <<< "$item"
        
        if command_exists "${name,,}" 2>/dev/null || command_exists "${package}" 2>/dev/null; then
            log_info "$name already installed, skipping..."
        else
            log_info "Installing $name..."
            if npm install -g "$package" 2>/dev/null; then
                log_success "$name installed"
            else
                log_warn "$name installation failed, will retry..."
            fi
        fi
    done
    
    # Install additional AI-related npm packages
    npm install -g \
        @modelcontextprotocol/server-filesystem \
        @modelcontextprotocol/server-github \
        @modelcontextprotocol/server-brave-search \
        @modelcontextprotocol/server-memory \
        @upstash/context7-mcp \
        @notionhq/notion-mcp-server
    
    log_success "AI tools installation complete"
}

install_ui_enhancements() {
    log_header "🎨 UI/UX ENHANCEMENTS"
    
    # Zsh
    if ! command_exists zsh; then
        log_info "Installing Zsh..."
        apt install -y -qq zsh fonts-powerline
    fi
    
    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Powerlevel10k
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        log_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    fi
    
    # Zsh plugins
    local plugins=(
        "zsh-users/zsh-autosuggestions:zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting:zsh-syntax-highlighting"
        "MichaelAquilina/zsh-you-should-use:you-should-use"
        "zap-zsh/zap:zap"
    )
    
    for item in "${plugins[@]}"; do
        IFS=':' read -r repo plugin <<< "$item"
        if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$plugin" ]; then
            git clone https://github.com/$repo $HOME/.oh-my-zsh/custom/plugins/$plugin
        fi
    done
    
    # FZF
    if ! command_exists fzf; then
        apt install -y -qq fzf
    fi
    
    # Modern CLI tools
    log_info "Installing modern CLI tools..."
    
    # Bat (cat alternative)
    if ! command_exists bat; then
        local bat_version="0.24.0"
        wget -q https://github.com/sharkdp/bat/releases/download/v${bat_version}/bat-v${bat_version}-x86_64-unknown-linux-gnu.tar.gz -O /tmp/bat.tar.gz
        tar -xzf /tmp/bat.tar.gz -C /tmp
        cp /tmp/bat-v${bat_version}-x86_64-unknown-linux-gnu/bat /usr/local/bin/
        rm -rf /tmp/bat*
    fi
    
    # Eza (ls alternative)
    if ! command_exists eza; then
        local eza_version="0.20.0"
        wget -q https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_x86_64-unknown-linux-gnu.tar.gz -O /tmp/eza.tar.gz
        tar -xzf /tmp/eza.tar.gz -C /tmp
        cp /tmp/eza_x86_64-unknown-linux-gnu/eza /usr/local/bin/
        rm -rf /tmp/eza*
    fi
    
    # Btop (htop alternative)
    if ! command_exists btop; then
        local btop_version="1.4.0"
        wget -q https://github.com/aristocratos/btop/releases/download/v${btop_version}/btop-x86_64-linux-musl.tbz -O /tmp/btop.tbz
        tar -xjf /tmp/btop.tbz -C /tmp
        cp /tmp/btop-x86_64-linux-musl/btop /usr/local/bin/
        rm -rf /tmp/btop*
    fi
    
    # Neofetch/Fastfetch
    if ! command_exists neofetch; then
        apt install -y -qq neofetch
    fi
    
    # Coreutils alternatives
    apt install -y -qq \
        bat \
        eza \
        fzf \
        btop \
        tldr \
        httpie \
        jq \
        yq \
        ncdu \
        bandwhich \
        bottom
    
    log_success "UI/UX enhancements installed"
}

install_pentest_tools() {
    log_header "📡 WIRELESS & PENTEST TOOLS"
    
    # Update Kali tools
    log_info "Installing Kali metapackages..."
    apt install -y -qq \
        kali-tools-wireless \
        kali-tools-passwords \
        kali-tools-web \
        kali-tools-exploitation \
        kali-tools-post-exploitation \
        kali-tools-social-engineering \
        kali-tools-fuzzing \
        kali-tools-voip \
        kali-tools-reverse-engineering \
        kali-tools-hardware
    
    # Individual tools
    log_info "Installing additional security tools..."
    apt install -y -qq \
        aircrack-ng \
        reaver \
        bully \
        mdk4 \
        hostapd \
        wireshark \
        nikto \
        dirb \
        gobuster \
        sqlmap \
        hydra \
        john \
        hashcat \
        hashid \
        netcat \
        socat \
        psmisc \
        tcpdump \
        tshark \
        ettercap-graphical \
        bettercap \
        responder \
        impacket-scripts \
        crackmapexec \
        enum4linux \
        smbclient \
        ldapsearch \
        kerberoast \
        bloodhound \
        neo4j \
        certipy \
        ldapdomaindump \
        mingw-w64 \
        nasm \
        radare2 \
        ghidra \
        binwalk \
        forensics-extra \
        sleuthkit \
        autopsy \
        volatility3
    
    # Wireless specific
    log_info "Configuring wireless tools..."
    
    # Ensure airmon-ng is available
    if ! command_exists airmon-ng; then
        apt install -y -qq aircrack-ng
    fi
    
    # Install rfkill if not present
    if ! command_exists rfkill; then
        apt install -y -qq rfkill
    fi
    
    log_success "Pentest tools installed"
}

install_programming() {
    log_header "💻 PROGRAMMING LANGUAGES"
    
    # Go
    if ! command_exists go; then
        log_info "Installing Go..."
        wget -q https://go.dev/dl/go1.22.0-linux-amd64.tar.gz -O /tmp/go.tar.gz
        tar -C /usr/local -xzf /tmp/go.tar.gz
        rm /tmp/go.tar.gz
        export PATH=$PATH:/usr/local/go/bin
    fi
    
    # Rust
    if ! command_exists rustc; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
    
    # Additional tools
    apt install -y -qq \
        ruby \
        ruby-dev \
        perl \
        libffi-dev \
        libssl-dev
    
    log_success "Programming languages installed"
}

install_docker() {
    log_header "🐳 DOCKER & CONTAINERS"
    
    if ! command_exists docker; then
        log_info "Installing Docker..."
        
        # Install dependencies
        apt install -y -qq \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
        
        # Add Docker GPG key
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        
        # Add Docker repo
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Install Docker
        apt update -qq
        apt install -y -qq \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin
        
        # Add user to docker group
        usermod -aG docker $SUDO_USER
        
        # Enable Docker
        systemctl enable docker
        systemctl start docker
    fi
    
    # Docker Compose
    if ! command_exists docker-compose; then
        apt install -y -qq docker-compose
    fi
    
    log_success "Docker installed"
}

configure_shell() {
    log_header "🐚 SHELL CONFIGURATION"
    
    # Create .zshrc
    cat > $HOME/.zshrc << 'EOF'
# =============================================================================
# KALI LINUX ENHANCED ZSHRC
# Generated by Kali Enhancement Script v3.0
# =============================================================================

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugins
plugins=(
    git
    docker
    kubectl
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    you-should-use
    zap
)

# Aliases
alias ll='eza -la --icons --group'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --style=auto'
alias find='fd'
alias grep='rg'
alias top='btop'
alias update='sudo apt update && sudo apt upgrade -y'

# AI Tool aliases
alias o='opencode'
alias g='gemini'
alias t='agent-tars'
alias claude='claude'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'

# System aliases
alias ports='netstat -tulanp'
alias meminfo='free -h'
alias cpuinfo='lscpu'
alias df='eza -h'
alias du='eza -h --du'
alias ps='eza --icons'

# Pentest aliases
alias monitor='sudo airmon-ng start wlan0'
alias monstop='sudo airmon-ng stop wlan0mon'
alias scan='sudo airodump-ng wlan0mon'
alias handshake='sudo airodump-ng --channel $1 --bssid $2 -w capture wlan0mon'
alias deauth='sudo aireplay-ng --deauth 10 -a $1 wlan0mon'

# Quick functions
mkcd() { mkdir -p "$1" && cd "$1" }
extract() { for file in "$@"; do unzip -q "$file" || tar -xf "$file"; done }
h() { history | grep "$1"; }

# Development
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$HOME/.local/bin

# Editor
export EDITOR=vim
export VISUAL=vim

# Starship (optional)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Load completion
autoload -Uz compinit
compinit

# Key bindings
bindkey -e

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Enable color support
autoload -U colors && colors

# Prompt
PS1="%F{green}%n@%m%f:%F{blue}%~%f\$ "
RPS1="%(?..%F{red}%?%f)"

# Alias expansion
set -k

# Correction
setopt CORRECT
setopt CORRECT_ALL

# Completion
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

# History
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Misc
setopt NO_BEEP
setopt NUMERIC_GLOB_SORT
EOF

    log_success "Zsh configuration created"
    
    # Create .bashrc enhancements
    if [ -f $HOME/.bashrc ]; then
        cat >> $HOME/.bashrc << 'EOF'

# =============================================================================
# KALI ENHANCEMENTS (loaded after default .bashrc)
# =============================================================================

# AI Tools
alias o='opencode'
alias g='gemini'
alias t='agent-tars'

# Modern CLI
alias ll='eza -la --icons --group'
alias la='eza -a --icons'
alias cat='bat --style=auto'
alias top='btop'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# Pentest
alias scan='sudo airodump-ng wlan0mon'
alias monitor='sudo airmon-ng start wlan0'

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() { for file in "$@"; do unzip -q "$file" || tar -xf "$file"; done; }

# Path
export PATH=$PATH:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin

# Editor
export EDITOR=vim

# Starship
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi
EOF
    fi
    
    log_success "Shell configurations updated"
}

create_menu_scripts() {
    log_header "📜 CREATING MENU SCRIPTS"
    
    # Main dashboard
    cat > $HOME/ai-menu.sh << 'EOF'
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

while true; do
    clear
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}       🔐 Kali Linux AI & Pentesting Dashboard${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}1.${NC}) AI Tools                     ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}2.${NC}) Wireless/Pentest              ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}3.${NC}) System Info                   ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}4.${NC}) Network Tools                 ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}5.${NC}) Update System                ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}6.${NC}) Custom Scripts               ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}7.${NC}) NeoFetch                     ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}8.${NC}) Docker                        ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}0.${NC}) Exit                         ${YELLOW}│${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -n "Select option: "
    read choice
    
    case $choice in
        1)
            echo "AI Tools:"
            echo "  1) OpenCode"
            echo "  2) Gemini CLI"
            echo "  3) TARS"
            read -p "Select: " ai
            case $ai in
                1) opencode ;;
                2) gemini ;;
                3) agent-tars ;;
            esac
            ;;
        2)
            echo "Wireless Tools:"
            echo "  1) Check interfaces"
            echo "  2) Start monitor mode"
            echo "  3) Scan networks"
            echo "  4) Stop monitor mode"
            read -p "Select: " w
            case $w in
                1) sudo airmon-ng ;;
                2) sudo airmon-ng start wlan0 ;;
                3) sudo airodump-ng wlan0mon ;;
                4) sudo airmon-ng stop wlan0mon ;;
            esac
            ;;
        3) neofetch ;;
        4) sudo btop ;;
        5) sudo apt update && sudo apt upgrade -y ;;
        6) ls -la $HOME/scripts/ ;;
        7) neofetch ;;
        8) docker ps ;;
        0) exit 0 ;;
        *) echo "Invalid" ;;
    esac
    echo "Press Enter to continue..."
    read
done
EOF
    chmod +x $HOME/ai-menu.sh
    
    # Wireless quick scripts
    mkdir -p $HOME/scripts/wireless
    
    cat > $HOME/scripts/wireless/quick-scan.sh << 'EOF'
#!/bin/bash
echo "Starting wireless scan..."
sudo airmon-ng start wlan0
sudo airodump-ng wlan0mon
EOF
    chmod +x $HOME/scripts/wireless/quick-scan.sh
    
    cat > $HOME/scripts/wireless/stop-monitor.sh << 'EOF'
#!/bin/bash
echo "Stopping monitor mode..."
sudo airmon-ng stop wlan0mon
sudo ip link set wlan0 up
EOF
    chmod +x $HOME/scripts/wireless/stop-monitor.sh
    
    log_success "Menu scripts created"
}

configure_ssh() {
    log_header "🔐 SSH CONFIGURATION"
    
    # Install OpenSSH
    apt install -y -qq openssh-server
    
    # Configure SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    
    # Generate SSH keys if not exist
    if [ ! -f $HOME/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -N "" -f $HOME/.ssh/id_rsa
    fi
    
    # Enable and start SSH
    systemctl enable ssh
    systemctl start ssh
    
    log_success "SSH configured"
    log_info "You can now SSH into this machine"
    log_info "Default user: root"
    log_info "Run 'sudo systemctl start ssh' if not already running"
}

system_cleanup() {
    log_header "🧹 SYSTEM CLEANUP"
    
    apt autoremove -y -qq
    apt autoclean -y -qq
    apt clean -y -qq
    
    # Clean log files
    journalctl --vacuum-time=7d
    
    # Clean cache
    rm -rf /tmp/*
    rm -rf /var/cache/apt/archives/*
    
    log_success "System cleaned"
}

show_system_info() {
    log_header "📊 SYSTEM INFO"
    
    echo -e "${GREEN}Kernel:${NC} $(uname -r)"
    echo -e "${GREEN}OS:${NC} $(lsb_release -ds)"
    echo -e "${GREEN}Architecture:${NC} $(uname -m)"
    echo -e "${GREEN}Uptime:${NC} $(uptime -p)"
    echo -e "${GREEN}Disk:${NC} $(df -h / | tail -1 | awk '{print $3 " / " $2 " (" $5 ")"}')"
    echo -e "${GREEN}RAM:${NC} $(free -h | grep Mem | awk '{print $3 " / " $2}')"
    echo ""
    
    echo -e "${YELLOW}Installed Tools:${NC}"
    echo -e "  OpenCode:    $(command -v opencode &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Gemini CLI:  $(command -v gemini &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  TARS:       $(command -v agent-tars &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Claude:      $(command -v claude &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Docker:     $(command -v docker &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Zsh:        $(command -v zsh &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Bat:        $(command -v bat &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Eza:        $(command -v eza &>/dev/null && echo '✓' || echo '✗')"
    echo -e "  Btop:       $(command -v btop &>/dev/null && echo '✓' || echo '✗')"
    echo ""
    
    echo -e "${YELLOW}Network Interfaces:${NC}"
    ip -br addr show | grep -v lo
    echo ""
    
    echo -e "${YELLOW}Wireless Interfaces:${NC}"
    iw dev 2>/dev/null || echo "  No wireless interfaces found"
    echo ""
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

main() {
    check_root
    detect_os
    
    while true; do
        show_menu
        
        case $choice in
            1)
                install_base
                install_python
                install_nodejs
                install_ai_tools
                install_ui_enhancements
                install_pentest_tools
                install_programming
                install_docker
                configure_shell
                create_menu_scripts
                configure_ssh
                show_system_info
                echo -e "${GREEN}Full installation complete!${NC}"
                ;;
            2)
                install_nodejs
                install_ai_tools
                show_system_info
                ;;
            3)
                install_ui_enhancements
                configure_shell
                create_menu_scripts
                ;;
            4)
                install_pentest_tools
                configure_ssh
                ;;
            5)
                install_base
                install_nodejs
                install_ai_tools
                apt install -y -qq python3-pip git curl
                ;;
            6)
                configure_ssh
                ;;
            7)
                show_system_info
                ;;
            8)
                system_cleanup
                ;;
            9)
                echo "Backup functionality - Coming soon!"
                ;;
            0)
                echo -e "${CYAN}Goodbye! 🐉${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
    done
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
