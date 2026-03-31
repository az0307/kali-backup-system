#!/bin/bash

# AI Tools & UI/UX Enhancement Script for Kali Linux
# Run as: sudo ./enhance-kali.sh

set -e

echo "════════════════════════════════════════════════════════════"
echo "       🔧 Kali Linux AI & UI/UX Enhancement"
echo "════════════════════════════════════════════════════════════"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_warn "Please run as root: sudo $0"
    exit 1
fi

log_info "Starting enhancement..."

# ═════════════════════════════════════════════════════════════
# 1. Update System
# ═════════════════════════════════════════════════════════════
log_info "Updating system packages..."
apt update && apt upgrade -y

# ═════════════════════════════════════════════════════════════
# 2. Install AI Tools Dependencies
# ═════════════════════════════════════════════════════════════
log_info "Installing AI tools dependencies..."

# Node.js (for Gemini CLI, OpenCode)
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
fi

# Python & pip
if ! command -v python3 &> /dev/null; then
    apt install -y python3 python3-pip python3-venv
fi

# Git
if ! command -v git &> /dev/null; then
    apt install -y git
fi

# ═════════════════════════════════════════════════════════════
# 3. Install AI Tools
# ═════════════════════════════════════════════════════════════
log_info "Installing AI tools..."

# OpenCode
if ! command -v opencode &> /dev/null; then
    npm install -g opencode-ai
    log_success "OpenCode installed"
else
    log_info "OpenCode already installed"
fi

# Gemini CLI
if ! command -v gemini &> /dev/null; then
    npm install -g @google/gemini-cli
    log_success "Gemini CLI installed"
else
    log_info "Gemini CLI already installed"
fi

# TARS
if ! command -v agent-tars &> /dev/null; then
    npm install -g @agent-tars/cli
    log_success "TARS installed"
else
    log_info "TARS already installed"
fi

# Claude Code (if available)
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
    log_success "Claude Code installed"
else
    log_info "Claude Code already installed"
fi

# ═════════════════════════════════════════════════════════════
# 4. UI/UX Enhancements
# ═════════════════════════════════════════════════════════════
log_info "Installing UI/UX enhancements..."

# Zsh + Oh My Zsh
if ! command -v zsh &> /dev/null; then
    apt install -y zsh fonts-powerline
    log_success "Zsh installed"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed"
fi

# Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    log_success "Powerlevel10k theme installed"
fi

# Zsh plugins
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# fzf (fuzzy finder)
if ! command -v fzf &> /dev/null; then
    apt install -y fzf
fi

# ═════════════════════════════════════════════════════════════
# 5. Terminal Enhancements
# ═════════════════════════════════════════════════════════════
log_info "Setting up terminal enhancements..."

# Install useful tools
apt install -y \
    curl \
    wget \
    htop \
    bat \
    exa \
    tree \
    neofetch \
    figlet \
    boxes \
    lolcat \
    tldr \
    bmon \
    nethogs \
    vnstat \
    iftop \
    iotop \
    strace \
    ltrace

# Bat (cat alternative with syntax highlighting)
if ! command -v bat &> /dev/null; then
    mkdir -p $HOME/.local/bin
    wget -q https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz -O /tmp/bat.tar.gz
    tar -xzf /tmp/bat.tar.gz -C /tmp
    cp /tmp/bat-v0.24.0-x86_64-unknown-linux-gnu/bat $HOME/.local/bin/
    rm -rf /tmp/bat*
fi

# Exa (ls alternative)
if ! command -v exa &> /dev/null; then
    mkdir -p $HOME/.local/bin
    wget -q https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -O /tmp/exa.zip
    unzip -q /tmp/exa.zip -d /tmp
    cp /tmp/exa-linux-x86_64 $HOME/.local/bin/exa
    rm -rf /tmp/exa*
fi

# ═════════════════════════════════════════════════════════════
# 6. Neovim (Modern Editor)
# ═════════════════════════════════════════════════════════════
if ! command -v nvim &> /dev/null; then
    log_info "Installing Neovim..."
    wget -q https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz
    tar -xzf /tmp/nvim.tar.gz -C /opt
    ln -sf /opt/nvim-linux64/bin/nvim $HOME/.local/bin/nvim
    rm /tmp/nvim.tar.gz
    log_success "Neovim installed"
fi

# ═════════════════════════════════════════════════════════════
# 7. Red Team Tools (Kali already has most)
# ═════════════════════════════════════════════════════════════
log_info "Installing additional red team tools..."

# Wireless tools (if not already installed)
apt install -y \
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
    metasploit-framework

# ═════════════════════════════════════════════════════════════
# 8. Python Tools
# ═════════════════════════════════════════════════════════════
log_info "Installing Python tools..."

pip3 install --break-system-packages \
    requests \
    beautifulsoup4 \
    scapy \
    paramiko \
    pwntools \
    radare2 \
    yapf \
    black \
    flake8 \
    mypy

# ═════════════════════════════════════════════════════════════
# 9. Dotfiles & Configs
# ═════════════════════════════════════════════════════════════
log_info "Setting up dotfiles..."

# Create .zshrc
cat > $HOME/.zshrc << 'EOF'
# Enable Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    docker
    kubectl
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    z
)

# Aliases
alias ll='exa -la --icons'
alias la='exa -a --icons'
alias lt='exa --tree --level=2 --icons'
alias cat='bat --style=auto'
alias find='fd'
alias grep='rg'
alias top='btop'

# AI Tool aliases
alias o='opencode'
alias g='gemini'
alias t='agent-tars'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# System aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='netstat -tulanp'
alias meminfo='free -h'
alias cpuinfo='lscpu'

# Load custom functions
if [ -f ~/.zsh_functions ]; then
    source ~/.zsh_functions
fi

# Prompt configuration
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time)

# Initialize completion
autoload -Uz compinit
compinit
EOF

log_success "Dotfiles configured"

# ═════════════════════════════════════════════════════════════
# 10. Create Dashboard Menu
# ═════════════════════════════════════════════════════════════
log_info "Creating dashboard menu..."

cat > $HOME/ai-menu.sh << 'EOF'
#!/bin/bash

# AI & Pentesting Dashboard Menu

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
    echo -e "${YELLOW}│${NC}  ${GREEN}1.${NC}) AI Tools                                   ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}2.${NC}) Wireless/Pentest                           ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}3.${NC}) System Info                                ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}4.${NC}) Network Tools                             ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}5.${NC}) Update System                             ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}6.${NC}) Custom Scripts                            ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}7.${NC}) NeoFetch                                  ${YELLOW}│${NC}"
    echo -e "${YELLOW}│${NC}  ${GREEN}0.${NC}) Exit                                      ${YELLOW}│${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -n "Select option: "
    read choice
    
    case $choice in
        1)
            echo -e "${BLUE}=== AI Tools ===${NC}"
            echo "1) OpenCode"
            echo "2) Gemini CLI"
            echo "3) TARS"
            echo "4) Claude Code"
            echo "0) Back"
            read ai_choice
            case $ai_choice in
                1) opencode ;;
                2) gemini ;;
                3) agent-tars ;;
                4) claude ;;
            esac
            ;;
        2)
            echo -e "${BLUE}=== Wireless Tools ===${NC}"
            echo "1) Airmon-ng (Monitor Mode)"
            echo "2) Wash (WPS)"
            echo "3) Reaver (WPS Crack)"
            echo "4) Hashcat"
            echo "0) Back"
            ;;
        3)
            neofetch
            echo ""
            echo "Press Enter to continue..."
            read
            ;;
        4)
            echo -e "${BLUE}=== Network Tools ===${NC}"
            iftop -i eth0
            ;;
        5)
            sudo apt update && sudo apt upgrade -y
            echo "Press Enter to continue..."
            read
            ;;
        6)
            ls -la $HOME/scripts/
            echo "Press Enter to continue..."
            read
            ;;
        7)
            neofetch
            ;;
        0)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
EOF

chmod +x $HOME/ai-menu.sh
log_success "Dashboard menu created"

# ═════════════════════════════════════════════════════════════
# 11. Quick Aliases File
# ═════════════════════════════════════════════════════════════
cat > $HOME/.zsh_functions << 'EOF'
# Quick access functions

# AI Tools
ai() {
    echo "Starting AI Tools..."
    echo "1) OpenCode"
    echo "2) Gemini CLI"
    echo "3) TARS"
    read -p "Select: " choice
    case $choice in
        1) opencode ;;
        2) gemini ;;
        3) agent-tars ;;
    esac
}

# Quick scan
scan() {
    echo "Starting network scan..."
    nmap -sV -O $1
}

# WiFi monitor
monitor() {
    echo "Starting monitor mode on $1..."
    airmon-ng start $1
    airodump-ng ${1}mon
}

# Clean up
cleanup() {
    echo "Cleaning up..."
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo apt clean -y
}

# Git quick
gcommit() {
    git add .
    git commit -m "$1"
    git push
}
EOF

log_success "Functions created"

# ═════════════════════════════════════════════════════════════
# Final Summary
# ═════════════════════════════════════════════════════════════
echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}       ✅ Enhancement Complete!${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}AI Tools:${NC}"
echo "  - OpenCode:    $(command -v opencode &> /dev/null && echo '✓ Installed' || echo '✗ Not found')"
echo "  - Gemini CLI:  $(command -v gemini &> /dev/null && echo '✓ Installed' || echo '✗ Not found')"
echo "  - TARS:        $(command -v agent-tars &> /dev/null && echo '✓ Installed' || echo '✗ Not found')"
echo "  - Claude Code: $(command -v claude &> /dev/null && echo '✓ Installed' || echo '✗ Not found')"
echo ""
echo -e "${YELLOW}UI/UX:${NC}"
echo "  - Zsh + Oh My Zsh: ✓"
echo "  - Powerlevel10k:    ✓"
echo "  - Bat + Exa:        ✓"
echo "  - Neovim:           ✓"
echo ""
echo -e "${YELLOW}Commands:${NC}"
echo "  ai-menu.sh    - Dashboard menu"
echo "  opencode     - Start OpenCode"
echo "  gemini       - Start Gemini CLI"
echo "  agent-tars   - Start TARS"
echo ""
echo -e "${GREEN}Done! Restart terminal or run 'source ~/.zshrc'${NC}"
