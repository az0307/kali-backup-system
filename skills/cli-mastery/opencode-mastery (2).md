---
name: opencode-mastery
description: Expert guide to OpenCode CLI - commands, MCP, skills, plugins, and best practices
---

# OpenCode Mastery

Complete reference for OpenCode CLI.

## Core Commands

```bash
# Basic
opencode                    # Start TUI
opencode [project]          # Open project
opencode -c                 # Continue last session
opencode -s [session-id]    # Continue specific session
opencode -m [model]         # Use specific model
opencode -p "prompt"        # Run single prompt

# Server
opencode serve              # Start headless server
opencode web                # Start server + web UI
opencode attach <url>       # Attach to running server

# MCP
opencode mcp list           # List MCP servers
opencode mcp start <name>   # Start MCP server
opencode mcp stop <name>    # Stop MCP server

# Skills
opencode skills list        # List available skills
opencode skills search <query>  # Search skills

# Models
opencode models             # List available models
opencode models [provider]  # List by provider

# Sessions
opencode session list       # List sessions
opencode session export <id>    # Export session
opencode session import <file> # Import session

# Providers/Auth
opencode providers          # Manage providers
opencode auth               # Alias for providers

# Database
opencode db                 # Database tools

# GitHub
opencode github             # GitHub agent
opencode pr <number>        # Fetch PR

# Debugging
opencode debug              # Debug tools

# Stats
opencode stats              # Token usage & cost
```

## Configuration

### opencode.json Structure

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/google/gemini-2.0-flash-exp:free",
  "mcp": {
    "server-name": {
      "type": "local|remote",
      "command": ["path/to/cmd"],
      "url": "https://..."
    }
  },
  "skills": {
    "paths": [
      "path/to/skills",
      "path/to/more-skills"
    ]
  },
  "plugin": [
    "path/to/plugin"
  ]
}
```

## MCP Servers Available

1. **filesystem** - File operations
2. **github** - GitHub API (via Bitwarden token)
3. **git** - Git operations
4. **brave-search** - Web search
5. **bitwarden** - Password vault
6. **file-search** - Advanced file search
7. **openrouter** - Multi-model routing
8. **context7** - Documentation lookup
9. **sequential-thinking** - Reasoning
10. **postgres** - Database
11. **puppeteer** - Browser automation
12. **playwright** - Browser automation
13. **chrome-devtools** - Chrome debugging
14. **slack** - Slack integration
15. **redis** - Cache/DB
16. **notion** - Notion integration
17. **gdrive** - Google Drive

## Skills Paths

Your configured paths:
- `C:\Users\User\.config\opencode\skills`
- `C:\Users\User\.config\opencode\skills\marketplace`
- `C:\Users\User\.config\opencode\skills\references`
- `C:\Users\User\.config\opencode\skills\gemini-imported`
- `C:\Users\User\.config\opencode\superpowers\skills`
- `C:\Users\User\.config\opencode\oh-my-opencode\src\skills`
- `C:\Users\User\.claude\commands`
- `C:\Users\User\.gemini\custom_skills`

## Plugins

1. **oh-my-opencode** - Multi-agent harness
2. **superpowers** - Workflow orchestrator
3. **micode** - Brainstorm-Plan-Implement
4. **background-agents** - Async delegation
5. **envsitter-guard** - .env protection

## Tips

- Use `opencode mcp list` to verify MCP status
- Skills are auto-discovered from configured paths
- Plugins extend base functionality
- Model can be changed per-session with `-m` flag
- Use `opencode attach` to connect to remote servers