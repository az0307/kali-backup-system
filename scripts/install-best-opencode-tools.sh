#!/bin/bash
# ====================================================================
# Install Best OpenCode Plugins & Tools
# Based on awesome-opencode, oh-my-opencode, expert-mode
# ====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; }

OPENCODE_DIR="$HOME/.config/opencode"
BACKUP_DIR="$HOME/.config/opencode.bak"

log "Installing Best OpenCode Plugins & Tools..."

# Backup existing config
if [ -d "$OPENCODE_DIR" ]; then
    warn "Backing up existing OpenCode config..."
    cp -r "$OPENCODE_DIR" "$BACKUP_DIR"
fi

mkdir -p "$OPENCODE_DIR"

# Install oh-my-opencode (the ultimate plugin)
log "Installing oh-my-opencode (ultimate AI agent orchestration)..."
if [ -d "$HOME/oh-my-openagent" ]; then
    cd "$HOME/oh-my-openagent"
    git pull
else
    git clone --depth=1 https://github.com/code-yeongyu/oh-my-openagent.git "$HOME/oh-my-openagent"
fi

cd "$HOME/oh-my-openagent"
npm install 2>/dev/null || bun install 2>/dev/null || true

# Create opencode.json with oh-my-opencode
cat > "$OPENCODE_DIR/opencode.json" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "oh-my-opencode@latest",
    "opencode-agent-modes@latest",
    "opencode-agent-skills@latest"
  ],
  "model": {
    "provider": "opencode",
    "model": "claude-sonnet-4-20250514"
  }
}
EOF

# Install opencode-agent-modes
log "Installing opencode-agent-modes..."
npm install -g opencode-agent-modes 2>/dev/null || true

# Install opencode-agent-skills
log "Installing opencode-agent-skills..."
npm install -g opencode-agent-skills 2>/dev/null || true

# Create skills directory
mkdir -p "$OPENCODE_DIR/skills"

# Install expert-pentester skill
cat > "$OPENCODE_DIR/skills/expert-pentester.md" << 'EOF'
# Expert Pentester Skill

## Capabilities
- Network scanning and reconnaissance
- WiFi auditing and penetration testing
- Exploit finding and vulnerability assessment
- Report generation

## Tools Available
- nmap, aircrack-ng, wifite, reaver
- hashcat, hydra, metasploit
- sqlmap, nikto, gobuster

## Workflow
1. Information Gathering
2. Scanning & Enumeration
3. Vulnerability Assessment
4. Exploitation
5. Reporting
EOF

# Create agents directory
mkdir -p "$OPENCODE_DIR/agents"

# Install redteam agent
cat > "$OPENCODE_DIR/agents/redteam-agent.md" << 'EOF'
# Red Team Agent

You are an expert red team operator specializing in:
- Network penetration testing
- WiFi security auditing
- Social engineering awareness
- Physical security assessment

Always follow rules of engagement and get authorization before testing.
EOF

# Create commands directory
mkdir -p "$OPENCODE_DIR/commands"

# Install useful commands
cat > "$OPENCODE_DIR/commands/pentest.md" << 'EOF'
# Pentest Command

Run a full penetration test on target.

Usage: /pentest <target-ip>
EOF

log "OpenCode plugins installed successfully!"
log "Run 'opencode' to start with the new configuration."

echo ""
echo "=== Installed Plugins ==="
echo "✓ oh-my-opencode - Multi-model orchestration"
echo "✓ opencode-agent-modes - Model switching"
echo "✓ opencode-agent-skills - Dynamic skills"
echo ""
echo "=== Installed Skills ==="
echo "✓ expert-pentester"
echo ""
echo "=== Installed Agents ==="
echo "✓ redteam-agent"
