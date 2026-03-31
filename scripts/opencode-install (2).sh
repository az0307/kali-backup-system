#!/bin/bash
# Install OpenCode + Oh-My-OpenCode + Skills on Kali Linux
# Run as root in Kali terminal

set -e

echo "=========================================="
echo "Installing OpenCode + Oh-My-OpenCode + Skills"
echo "=========================================="

# Install Node.js if not present
echo "[1/6] Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install bun (for Oh-My-OpenCode)
echo "[2/6] Installing Bun..."
curl -fsSL https://bun.sh/install | bash

# Install OpenCode
echo "[3/6] Installing OpenCode..."
sudo npm install -g opencode-ai

# Install Oh-My-OpenCode
echo "[4/6] Installing Oh-My-OpenCode..."
bunx oh-my-opencode install

# Create skills directory
echo "[5/6] Setting up skills..."
mkdir -p ~/.config/opencode/skills

# Copy skills from shared folder (if available)
if [ -d "/mnt/share" ]; then
    echo "Copying skills from shared folder..."
    cp -r /mnt/share/../07_Inbox_Temp/*.md ~/.config/opencode/skills/ 2>/dev/null || true
    cp -r /mnt/share/../07_Inbox_Temp/references ~/.config/opencode/skills/ 2>/dev/null || true
fi

# Also copy from host filesystem if mounted
if [ -d "/mnt/sf_Users_User" ]; then
    echo "Copying from VirtualBox shared folder..."
    cp -r /mnt/sf_Users_User/07_Inbox_Temp/*.md ~/.config/opencode/skills/ 2>/dev/null || true
    cp -r /mnt/sf_Users_User/07_Inbox_Temp/references ~/.config/opencode/skills/ 2>/dev/null || true
fi

# Install MCP servers (optional)
echo "[6/6] Setting up MCP servers..."
# Note: API keys should be set in ~/.opencode.json
npm install -g @modelcontextprotocol/server-filesystem @modelcontextprotocol/server-github @modelcontextprotocol/server-brave-search @modelcontextprotocol/server-memory 2>/dev/null || true

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "To start OpenCode:"
echo "  opencode"
echo ""
echo "Skills are in:"
echo "  ~/.config/opencode/skills/"
echo ""
echo "Configure MCP in:"
echo "  ~/.opencode.json"
echo ""
