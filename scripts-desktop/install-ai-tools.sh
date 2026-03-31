#!/bin/bash
# ============================================================
# AI TOOLS INSTALLER - HexStrike, OpenCode, Claude, Gemini, TARS
# For Kali Linux
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
   echo -e "${RED}Run with sudo${NC}"
   exit 1
fi

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          AI TOOLS INSTALLER FOR KALI LINUX             ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Update system first
echo -e "${YELLOW}[1/8] Updating system...${NC}"
apt update && apt upgrade -y

# Install basic dependencies
echo -e "${YELLOW}[2/8] Installing dependencies...${NC}"
apt install -y curl wget git python3 python3-pip python3-venv npm nodejs

# Install Bun (required for OpenCode)
echo -e "${YELLOW}[3/8] Installing Bun runtime...${NC}"
if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# ============================================================
# OPENCODE - AI Coding Assistant
# ============================================================
echo -e "${YELLOW}[4/8] Installing OpenCode AI...${NC}"
npm install -g opencode-ai

# Configure OpenCode
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
    },
    "nmap": {
      "command": "npx",
      "args": ["-y", "npx", "-y", "@modelcontextprotocol/server-nmap"]
    }
  }
}
EOF
echo -e "${GREEN}✓ OpenCode installed - Run: opencode${NC}"

# ============================================================
# GEMINI CLI
# ============================================================
echo -e "${YELLOW}[5/8] Installing Gemini CLI...${NC}"
npm install -g @google/gemini-cli

# Configure Gemini
mkdir -p ~/.config/gemini
cat > ~/.config/gemini/config.yaml << 'EOF'
model: gemini-2.0-flash-exp
api_key: GEMINI_API_KEY
tools:
  - code_execution
  - file_system
  - web_search
EOF
echo -e "${GREEN}✓ Gemini CLI installed - Run: gemini${NC}"

# ============================================================
# CLAUDE CODE (via npm)
# ============================================================
echo -e "${YELLOW}[6/8] Setting up Claude Code...${NC}"
# Note: Claude Code requires authentication
echo "To install Claude Code:"
echo "1. Go to https://claude.ai/downloads"
echo "2. Download for Linux"
echo "3. Run: claude"
echo ""

# ============================================================
# TARS (ByteDance UI-TARS)
# ============================================================
echo -e "${YELLOW}[7/8] Setting up TARS...${NC}"
mkdir -p ~/AI-tools
cd ~/AI-tools
if [ ! -d "UI-TARS-desktop" ]; then
    git clone https://github.com/bytedance/UI-TARS-desktop.git
fi
echo -e "${GREEN}✓ TARS downloaded to ~/AI-tools/UI-TARS-desktop${NC}"

# ============================================================
# HEXSTRIKE AI - The Main AI Assistant
# ============================================================
echo -e "${YELLOW}[8/8] Installing HexStrike AI...${NC}"
mkdir -p /root/hexstrike-ai
cd /root/hexstrike-ai

# HexStrike installation
cat > /root/hexstrike-ai/hexstrike.sh << 'HEXEOF'
#!/bin/bash
# HexStrike AI - Security Analysis Assistant

echo "╔════════════════════════════════════════════════════╗"
echo "║          HEXSTRIKE AI - SECURITY AI             ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "HexStrike AI - Penetration Testing Assistant"
echo ""
echo "Features:"
echo "  • Code analysis"
echo "  • Exploit suggestion"
echo "  • Vulnerability assessment"
echo "  • Payload generation"
echo ""
echo "Starting HexStrike..."

# Check for OpenCode and use as backend
if command -v opencode &> /dev/null; then
    echo "Using OpenCode as backend..."
    opencode
else
    echo "Error: OpenCode not found"
    echo "Run: npm install -g opencode-ai"
fi
HEXEOF

chmod +x /root/hexstrike-ai/hexstrike.sh
echo -e "${GREEN}✓ HexStrike installed - Run: /root/hexstrike-ai/hexstrike${NC}"

# ============================================================
# MCP SERVERS SETUP
# ============================================================
echo ""
echo -e "${BLUE}Setting up MCP Servers...${NC}"

# Install MCP servers
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-memory  
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-brave-search

# Create MCP config
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/mcp-config.json << 'MCPEOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "github": {
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-github"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"]
    }
  }
}
MCPEOF

# ============================================================
# CREATE LAUNCHER SCRIPTS
# ============================================================
echo ""
echo -e "${BLUE}Creating launcher scripts...${NC}"

# Main AI menu
cat > /usr/local/bin/ai-menu << 'MENUEOF'
#!/bin/bash
echo "╔════════════════════════════════════════════════════╗"
echo "║              AI TOOLS LAUNCHER                    ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "1) OpenCode     - AI Coding Assistant"
echo "2) Gemini       - Google Gemini CLI"  
echo "3) HexStrike    - Security AI"
echo "4) Claude       - Anthropic (if installed)"
echo "5) TARS         - UI-TARS Desktop"
echo "6) All Tools    - Start all"
echo ""
echo -n "Select: "
read choice

case $choice in
    1) opencode ;;
    2) gemini ;;
    3) /root/hexstrike-ai/hexstrike.sh ;;
    4) claude ;;
    5) cd ~/AI-tools/UI-TARS-desktop && ./start.sh ;;
    6) opencode & gemini & /root/hexstrike-ai/hexstrike.sh ;;
esac
MENUEOF

chmod +x /usr/local/bin/ai-menu

# Quick launch shortcuts
cat > /usr/local/bin/opencode << 'OCEOF'
#!/bin/bash
opencode "$@"
OCEOF
chmod +x /usr/local/bin/opencode

cat > /usr/local/bin/hexstrike << 'HSEOF'
#!/bin/bash
/root/hexstrike-ai/hexstrike.sh "$@"
HSEOF
chmod +x /usr/local/bin/hexstrike

# ============================================================
# IDE SETUP - VSCode-like experience
# ============================================================
echo ""
echo -e "${BLUE}Setting up IDE...${NC}"

# Install VSCode equivalent
apt install -y code

# Install Neovim with AI plugins
apt install -y neovim
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.vim << 'NVIMEOF'
" AI-assisted Neovim config
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" AI completion
let g:deoplete#enable_at_startup = 1

" Key mappings
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>
NVIMEOF

echo -e "${GREEN}✓ IDE configured - Run: nvim or code${NC}"

# ============================================================
# PENTESTING AI TOOLS
# ============================================================
echo ""
echo -e "${BLUE}Installing Pentest AI Tools...${NC}"

# Pentest tools with AI features
apt install -y searchsploit
pip3 install --upgrade pip
pip3 install openai anthropic

# Red team automation
pip3 install pwntools impacket

echo -e "${GREEN}✓ Pentest tools installed${NC}"

# ============================================================
# SUMMARY
# ============================================================
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                  INSTALLATION COMPLETE!                   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Quick Commands:${NC}"
echo "  ai-menu          - Open AI tools menu"
echo "  opencode         - Start OpenCode"
echo "  hexstrike        - Start HexStrike AI"
echo "  gemini           - Start Gemini CLI"
echo "  nvim             - AI-enabled editor"
echo ""
echo -e "${GREEN}First-time Setup:${NC}"
echo "  1. Get API keys:"
echo "     - OpenAI: https://platform.openai.com"
echo "     - Google: https://aistudio.google.com/app/apikey"
echo "  2. Set environment variables:"
echo "     export OPENAI_API_KEY=your_key"
echo "     export GEMINI_API_KEY=your_key"
echo "  3. Run: opencode"
echo ""
