#!/bin/bash
# Complete Kali Red Team Setup - ONE SCRIPT
# Run as root: sudo ./full-setup.sh

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     COMPLETE RED TEAM SETUP - ONE CLICK               ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Update
echo "[1/8] Updating system..."
sudo apt update && sudo apt upgrade -y

# Install core tools
echo "[2/8] Installing core tools..."
sudo apt install -y \
    aircrack-ng reaver wash bully wifite wifiphisher \
    nmap masscan net-tools \
    hashcat john crunch \
    nikto sqlmap gobuster dirb metasploit-framework searchsploit \
    python3 python3-pip git curl wget vim build-essential \
    gemini-cli \
    nodejs npm

# Install wordlists
echo "[3/8] Installing wordlists..."
sudo apt install -y wordlists seclists

# Install bun
echo "[4/8] Installing Bun..."
curl -fsSL https://bun.sh/install | bash

# Install OpenCode
echo "[5/8] Installing OpenCode..."
sudo npm install -g opencode-ai

# Install Oh-My-OpenCode
echo "[6/8] Installing Oh-My-OpenCode..."
bunx oh-my-opencode install 2>/dev/null || true

# Install Claude Code
echo "[7/8] Installing Claude Code..."
sudo npm install -g @anthropic-ai/claude-code

# Copy skills
echo "[8/8] Setting up skills..."
mkdir -p ~/.config/opencode/skills
cp $SCRIPT_DIR/kali-redteam-curator.md ~/.config/opencode/skills/ 2>/dev/null || true
cp $SCRIPT_DIR/claude-redteam-agent.md ~/.config/opencode/skills/ 2>/dev/null || true
cp $SCRIPT_DIR/redteam-guide.md ~/.config/opencode/skills/ 2>/dev/null || true
cp -r $SCRIPT_DIR/references ~/.config/opencode/skills/ 2>/dev/null || true

# Download additional resources
echo ""
echo "Downloading additional resources..."
mkdir -p /opt/pentest-tools
cd /opt/pentest-tools
git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git 2>/dev/null || true
git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    SETUP COMPLETE!                        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "NEXT STEPS:"
echo "1. Run monitor-mode setup:"
echo "   sudo ./monitor-mode.sh"
echo ""
echo "2. Start OpenCode:"
echo "   opencode"
echo ""
echo "3. Start Claude Code:"
echo "   claude"
echo ""
echo "4. Use Gemini CLI:"
echo "   gemini --prompt 'help with nmap'"
echo ""
echo "5. Scan WiFi:"
echo "   sudo airodump-ng wlan0mon"
echo ""
echo "Location of tools:"
echo "  - Wordlists: /usr/share/wordlists/"
echo "  - SecLists: /usr/share/seclists/"
echo "  - Payloads: /opt/pentest-tools/PayloadsAllTheThings/"
echo ""
