---
name: cli-mastery
description: Complete guide to all installed AI CLI tools - usage, commands, and capabilities for opencode ecosystem
---

# CLI Mastery Skill

Comprehensive guide to all your installed CLI tools.

## Quick Reference

### AI Coding Agents

```bash
# OpenCode (primary)
opencode                    # Start TUI
opencode serve              # Headless server
opencode mcp list           # List MCP servers
opencode skills list        # List skills

# Claude Code
claude-code                 # Start Claude CLI

# OpenAI Codex
codex                       # Start Codex

# Gemini CLI
gemini                      # Start Gemini CLI
gemini -p "prompt"          # Single prompt mode

# Grok CLI
grok "message"              # Send message
grok git                    # Git with AI
grok mcp                    # MCP management

# TARS CLI
tars                        # Start TARS

# Smithery
smithery                    # Start Smithery

# Cline
cline                       # Start Cline

# Qwen Code
qwen-code                   # Start Qwen

# KiloCode
kilocode                    # Start KiloCode
```

### MCP Servers

```bash
# Start individual MCP
mcp-server-filesystem "C:/Users/User"
mcp-server-github
mcp-server-brave-search
mcp-server-bitwarden
mcp-server-postgres
mcp-server-puppeteer
mcp-server-playwright
mcp-server-redis
mcp-server-slack
notion-mcp-server
mcp-server-gdrive
mcp-server-memory
mcp-server-sequential-thinking
chrome-devtools-mcp
file-search-mcp
```

### OpenCode Plugins

```bash
# oh-my-opencode
oh-my-opencode agents       # List agents
oh-my-opencode skills       # List skills

# opencode-router
opencode-router models      # List models

# opencode-swarm
opencode-swarm launch       # Launch swarm
```

### Dev Tools

```bash
# Bun
bun run <file>              # Run JS/TS
bun test                    # Run tests
bun build                   # Build

# pnpm
pnpm install                # Install
pnpm dev                    # Dev server
pnpm build                  # Build

# Vercel
vercel                      # Deploy
vercel --prod               # Production

# Turbo
turbo run build             # Build monorepo
turbo run test              # Run tests

# TypeScript
tsc                         # Compile
ts-node <file>              # Run TS

# Playwright
playwright test            # Run tests
playwright install         # Install browsers

# Prisma
prisma generate            # Generate client
prisma migrate             # Run migrations
prisma studio              # Open studio
```

### Automation

```bash
# n8n
n8n                         # Start n8n

# CLAWDBOT
clawdbot                    # Start CLAWDBOT
clawdhub                    # CLAWDBOT hub

# Composio
composio                    # Start Composio
```

## Environment Variables

```bash
# API Keys (via Bitwarden)
GITHUB_TOKEN=$(bw get notes 'GitHub Token')
BRAVE_API_KEY=$(bw get notes 'Brave Search API Key')
OPENROUTER_API_KEY=$(bw get notes 'OpenRouter API Key')
ANTHROPIC_API_KEY=$(bw get notes 'Anthropic API Key')
OPENAI_API_KEY=$(bw get notes 'OpenAI API Key')
```

## Skill Usage

This skill provides context for:
- Choosing the right AI tool for the task
- Configuring MCP servers
- Writing automation scripts
- Troubleshooting CLI issues
- Discovering available commands