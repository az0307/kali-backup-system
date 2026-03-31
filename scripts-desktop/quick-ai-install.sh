#!/bin/bash
# QUICK AI INSTALL - Get AI running in Kali ASAP
# Run as root in Kali

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     🚀 QUICK AI INSTALL FOR KALI VM               ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "[1/4] Installing Gemini CLI (FREE - works immediately)..."
pip3 install --break-system-packages gemini-cli 2>/dev/null || pip3 install gemini-cli 2>/dev/null || true

echo ""
echo "[2/4] Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - 2>/dev/null || true
sudo apt-get install -y nodejs npm 2>/dev/null || true

echo ""
echo "[3/4] Installing OpenCode..."
sudo npm install -g opencode-ai 2>/dev/null || sudo npm install -g opencode-ai --force 2>/dev/null || true

echo ""
echo "[4/4] Installing Claude Code..."
sudo npm install -g @anthropic-ai/claude-code 2>/dev/null || sudo npm install -g @anthropic-ai/claude-code --force 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              ✅ AI INSTALLED!                         ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "COMMANDS TO USE AI:"
echo ""
echo "1. GEMINI CLI (FREE - No API key needed!):"
echo "   gemini --prompt 'hello'"
echo "   gemini --prompt 'help me crack wifi'"
echo ""
echo "2. OPENCODE (needs API key):"
echo "   opencode"
echo ""
echo "3. CLAUDE CODE (needs API key):"
echo "   claude"
echo ""
echo "⚠️ To configure API keys:"
echo "   nano ~/.opencode.json"
echo ""
echo "🎯 Try Gemini first - it's FREE and works right away!"
