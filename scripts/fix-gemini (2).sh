#!/bin/bash
# Fix Gemini CLI - use newer model

# Update config with correct model
mkdir -p ~/.config

cat > ~/.config/gemini-cli.toml << 'EOF'
token = "AIzaSyAqKF5BU4VQZSDLBnMLPHiLQbhcDO9nvSU"
model = "gemini-2.0-flash-exp"
EOF

echo "✅ Config fixed!"
echo ""
echo "Test:"
echo "  gemini-cli 'hello'"
