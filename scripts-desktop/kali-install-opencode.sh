#!/bin/bash
# Kali VM - Install OpenCode + Update Script
# Run this in your Kali VM terminal

set -e

echo "=========================================="
echo "  KALI VM - INSTALL OPENCODE + UPDATE"
echo "=========================================="

# Update system
echo "[1/5] Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "[2/5] Installing required packages..."
sudo apt install -y curl wget git python3 python3-pip unzip

# Install Bun (required for OpenCode)
echo "[3/5] Installing Bun..."
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Install OpenCode
echo "[4/5] Installing OpenCode..."
npm install -g opencode-ai

# Configure OpenCode
echo "[5/5] Configuring OpenCode..."
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/config.json << 'EOF'
{
  "model": "google/gemini-2.0-flash-exp",
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/root"]
    },
    "memory": {
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
EOF

echo ""
echo "=========================================="
echo "  INSTALLATION COMPLETE!"
echo "=========================================="
echo ""
echo "To run OpenCode:"
echo "  opencode"
echo ""
echo "To update later:"
echo "  ./kali-install-opencode.sh"
echo ""
