#!/bin/bash
# HexStrike AI + AI Pentesting Tools Installation
# Run as root in Kali

echo "=========================================="
echo "Installing HexStrike AI + AI Pentesting Tools"
echo "=========================================="

# Install HexStrike AI
echo "[1/5] Installing HexStrike AI..."
cd /opt
git clone --depth 1 https://github.com/0x4m4/hexstrike-ai.git
cd hexstrike-ai
pip3 install -r requirements.txt

# Create config
echo "[2/5] Creating config..."
cat > config.yaml << 'EOF'
llm:
  provider: google
  model: gemini-2.0-flash-exp
  api_key: YOUR_GEMINI_API_KEY_HERE

server:
  host: 0.0.0.0
  port: 8888

tools:
  auto_install: true
EOF

# Install additional AI pentesting tools
echo "[3/5] Installing additional AI tools..."

# AutoGPT (autonomous AI agent)
git clone --depth 1 https://github.com/Significant-Gravitas/AutoGPT.git /opt/AutoGPT 2>/dev/null || true

# PentestGPT
git clone --depth 1 https://github.com/GreyDGlitch/PentestGPT.git /opt/PentestGPT 2>/dev/null || true

# ReconGPT
git clone --depth 1 https://github.com/0xDekmi/ReconGPT.git /opt/ReconGPT 2>/dev/null || true

# Install other useful AI tools
echo "[4/5] Installing Python AI libraries..."
pip3 install openai anthropic google-generativeai

# Create startup script
echo "[5/5] Creating startup scripts..."
cat > /usr/local/bin/hexstrike << 'EOF'
#!/bin/bash
cd /opt/hexstrike-ai
python3 hexstrike.py "$@"
EOF
chmod +x /usr/local/bin/hexstrike

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "To start HexStrike AI:"
echo "  cd /opt/hexstrike-ai"
echo "  python3 hexstrike.py"
echo ""
echo "Or use the wrapper:"
echo "  hexstrike"
echo ""
echo "Configure API key in:"
echo "  /opt/hexstrike-ai/config.yaml"
echo ""
echo "Other AI tools:"
echo "  - AutoGPT: /opt/AutoGPT"
echo "  - PentestGPT: /opt/PentestGPT"
echo "  - ReconGPT: /opt/ReconGPT"
