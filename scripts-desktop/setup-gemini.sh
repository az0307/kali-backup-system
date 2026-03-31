#!/bin/bash
# Setup Gemini CLI with API key

echo "Setting up Gemini CLI..."

# Get API key from config or prompt
echo "Enter your Gemini API key (or press Enter to use default):"
read -s API_KEY

if [ -z "$API_KEY" ]; then
    # Use the key from our config
    API_KEY="AIzaSyAqKF5BU4VQZSDLBnMLPHiLQbhcDO9nvSU"
fi

# Create config directory
mkdir -p ~/.config

# Create config file
cat > ~/.config/gemini-cli.toml << EOF
token = "$API_KEY"
EOF

echo ""
echo "✅ Gemini CLI configured!"
echo ""
echo "Test it:"
echo "  gemini-cli 'hello'"
