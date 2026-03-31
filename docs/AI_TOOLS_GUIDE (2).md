# AI Tools Guide

## Overview

This home lab includes multiple AI tools for enhanced pentesting and coding.

## Installed AI Tools

### 1. OpenCode

AI coding assistant for terminal.

```bash
# Install
go opencode

# Or
bash /root/KaliShare/scripts/install-best-opencode-tools.sh

# Usage
opencode
```

**Features:**
- Code completion
- Multi-file editing
- MCP server integration
- Skill system

**Plugins:**
- oh-my-opencode - Multi-model orchestration
- opencode-agent-modes - Model switching
- opencode-agent-skills - Dynamic skills

### 2. Claude Code

Anthropic's CLI AI assistant.

```bash
# Install
npm install -g @anthropic-ai/claude-code

# Usage
claude
```

### 3. Gemini CLI

Google's AI CLI.

```bash
# Install
curl -fsSL https://google.github.io/gemini-cli/install | bash

# Usage
gemini
```

### 4. HexStrike

AI-powered pentesting assistant.

```bash
# Location
/root/hexstrike-ai/

# Usage
go pentest <target>
```

### 5. KaliGPT

AI assistant for ethical hackers.

```bash
# Install
cd /opt/pentest-ai/KaliGPT
bash kaligptinstaller.sh

# Usage
kaligpt

# Modes:
# -g  --gemini    Use Gemini
# -o  --ollama    Use local Ollama
# -or --openrouter Use OpenRouter
# -c  --chatgpt   Use ChatGPT

# Examples:
kaligpt "Scan target.com for vulnerabilities"
kaligpt -g "Find XSS on example.com"
```

### 6. Pentest-Automator-CLI

Automated pentest with AI analysis.

```bash
# Run
cd /opt/pentest-ai/pentest-automator-cli
sudo python3 pentest-automator.py

# Features:
# - Nmap integration
# - Nuclei scanning
# - Nikto web scan
# - AI analysis (GPT/Gemini)
```

### 7. AI Pentest Menu

```bash
# Launch
ai-pentest-menu

# Options:
# 1. KaliGPT         - AI hacking assistant
# 2. Pentest-Automator - Automated pentest
# 3. Pentest_AI      - AI-powered pentesting
# 4. Mahakal-Framework - Full framework
# 5. Kalitellingence - Threat Intelligence
# 6. Kali Ops Center - Autonomous AI pentesting
# 7. WeaponizeKali   - Extra tools
```

## AI Tools Installation Script

```bash
# Install all AI tools
bash /root/KaliShare/scripts/install-best-opencode-tools.sh
bash /root/KaliShare/scripts/install-ai-pentest-tools.sh
```

## Configuration

### OpenCode Config

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "oh-my-opencode@latest",
    "opencode-agent-modes@latest"
  ],
  "model": {
    "provider": "opencode",
    "model": "claude-sonnet-4-20250514"
  }
}
```

### Environment Variables

```bash
# API Keys
export OPENAI_API_KEY="sk-..."
export GOOGLE_API_KEY="..."
export ANTHROPIC_API_KEY="sk-ant-..."
```

## Quick Commands

```bash
# Install OpenCode plugins
go opencode

# Install AI pentest tools
go ai-pentest-tools

# Run AI pentest
go ai-pentest <target>

# Start KaliGPT
kaligpt -g "help"
```

## Best Practices

1. **Use local models** when possible (Ollama) for offline capability
2. **Combine tools** - Use AI for analysis, automated tools for scanning
3. **Review AI suggestions** - Always verify before executing
4. **Keep API keys secure** - Never commit to version control

## Troubleshooting

### API Key Issues
```bash
# Set environment variable
export OPENAI_API_KEY="your-key-here"

# Or use config file
nano ~/.openai/api-key
```

### Model Not Available
```bash
# Check available models
opencode --models
claude --models
gemini --models
```

### Connection Issues
```bash
# Test internet
ping google.com

# Check firewall
sudo ufw status
```

---

*Updated: 2026-03-26*
