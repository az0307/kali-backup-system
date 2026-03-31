#!/bin/bash
# SUPER QUICK INSTALL - One command, works, no questions
# Run: sudo bash super-install.sh

set -e

export DEBIAN_FRONTEND=noninteractive

echo "Installing everything..."

# Update
apt update -y 2>/dev/null || true

# Core tools
apt install -y aircrack-ng reaver bully wifite wifiphisher nmap masscan net-tools rustscan hashcat john crunch hydra nikto sqlmap gobuster dirb metasploit-framework searchsploit python3 python3-pip git curl wget vim tmux build-essential 2>/dev/null || true

# Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 2>/dev/null || true
apt install -y nodejs npm 2>/dev/null || true

# AI Tools
npm install -g opencode-ai 2>/dev/null || true
npm install -g @anthropic-ai/claude-code 2>/dev/null || true

# Gemini CLI
pip3 install --break-system-packages gemini-cli 2>/dev/null || pip3 install gemini-cli 2>/dev/null || true

# Configure Gemini CLI with API key
mkdir -p ~/.config
cat > ~/.config/gemini-cli.toml << 'EOF'
token = "AIzaSyAqKF5BU4VQZSDLBnMLPHiLQbhcDO9nvSU"
EOF

# Wordlists
apt install -y wordlists seclists 2>/dev/null || true

# Copy skills
mkdir -p ~/.config/opencode/skills
cp -r /media/sf_KaliShare/skills/* ~/.config/opencode/skills/ 2>/dev/null || true
cp -r /mnt/sf_KaliShare/skills/* ~/.config/opencode/skills/ 2>/dev/null || true
cp -r /mnt/sf_KaliShare/gems/* ~/.config/opencode/skills/ 2>/dev/null || true

echo ""
echo "=========================================="
echo "DONE! Use these commands:"
echo "=========================================="
echo ""
echo "gemini --prompt 'hello'"
echo "gemini --prompt 'help me hack wifi'"
echo ""
echo "opencode"
echo "claude"
echo ""
