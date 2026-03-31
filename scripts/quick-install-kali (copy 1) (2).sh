#!/bin/bash

# Quick Install Script for Kali Linux
# Run: curl -fsSL https://raw.githubusercontent.com/.../quick-install.sh | bash
# Or: wget -qO- ... | bash

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║         ⚡ Kali Linux AI Tools Quick Install             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root: sudo $0${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/6] Updating system...${NC}"
apt update && apt upgrade -y

echo -e "${YELLOW}[2/6] Installing Node.js...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
fi

echo -e "${YELLOW}[3/6] Installing AI Tools...${NC}"

# OpenCode
if ! command -v opencode &> /dev/null; then
    npm install -g opencode-ai
fi

# Gemini CLI
if ! command -v gemini &> /dev/null; then
    npm install -g @google/gemini-cli
fi

# TARS
if ! command -v agent-tars &> /dev/null; then
    npm install -g @agent-tars/cli
fi

echo -e "${YELLOW}[4/6] Installing Python tools...${NC}"
apt install -y python3-pip
pip3 install --break-system-packages requests pwntools scapy

echo -e "${YELLOW}[5/6] Installing UI enhancements...${NC}"
apt install -y zsh git curl wget htop bat exa

echo -e "${YELLOW}[6/6] Setting up aliases...${NC}"

# Add to .bashrc
cat >> ~/.bashrc << 'ALIASES'

# AI Tools Aliases
alias o='opencode'
alias g='gemini'
alias t='agent-tars'
alias claude='claude'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# System Aliases  
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='netstat -tulanp'
alias meminfo='free -h'

ALIASES

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    ✅ Installation Complete!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Commands:${NC}"
echo "  opencode     - Start OpenCode"
echo "  gemini       - Start Gemini CLI"  
echo "  agent-tars   - Start TARS"
echo ""
echo -e "${YELLOW}Aliases added to ~/.bashrc:${NC}"
echo "  o, g, t, gs, ga, gc, gp, gl, update"
echo ""
echo -e "${GREEN}Run 'source ~/.bashrc' or restart terminal${NC}"
