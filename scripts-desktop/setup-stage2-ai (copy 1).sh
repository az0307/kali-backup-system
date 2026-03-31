#!/bin/bash
# STAGE 2: AI Tools

export DEBIAN_FRONTEND=noninteractive

echo "Installing AI Tools..."

# Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 2>/dev/null || true
apt install -y nodejs npm 2>/dev/null || true

# AI CLIs
npm install -g opencode-ai 2>/dev/null || true
npm install -g @anthropic-ai/claude-code 2>/dev/null || true

# Gemini CLI
pip3 install --break-system-packages gemini-cli 2>/dev/null || pip3 install gemini-cli 2>/dev/null || true

echo "✅ Stage 2 Complete"
echo "Use: gemini --prompt 'hello'"
