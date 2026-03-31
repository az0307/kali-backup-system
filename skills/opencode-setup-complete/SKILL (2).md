---
name: opencode-setup-complete
description: Complete OpenCode setup with all MCP servers, skills, and plugins - tested and working configuration
---

# OpenCode Complete Setup

This skill provides the tested and working configuration for OpenCode.

## Working Configuration

### Model
- **Current**: `opencode/minimax-m2.5-free`
- **Fallback**: `opencode/gpt-5-nano`

### MCP Servers (10 Connected)

```json
{
  "mcp": {
    "filesystem": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\mcp-server-filesystem.cmd", "C:/Users/User"]
    },
    "github": {
      "type": "local",
      "command": ["powershell", "-NoProfile", "-Command", "$env:GITHUB_TOKEN=$(bw get notes 'GitHub Token - Antigravity'); & 'C:\\Users\\User\\AppData\\Roaming\\npm\\mcp-server-github.cmd'"]
    },
    "brave-search": {
      "type": "local",
      "command": ["powershell", "-NoProfile", "-Command", "$env:BRAVE_API_KEY=$(bw get notes 'Brave Search API Key'); & 'C:\\Users\\User\\AppData\\Roaming\\npm\\mcp-server-brave-search.cmd'"]
    },
    "bitwarden": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\mcp-server-bitwarden.cmd"]
    },
    "file-search": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\file-search-mcp.cmd"]
    },
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp"
    },
    "sequential-thinking": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\mcp-server-sequential-thinking.cmd"]
    },
    "puppeteer": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\mcp-server-puppeteer.cmd"]
    },
    "chrome-devtools": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\chrome-devtools-mcp.cmd"]
    },
    "notion": {
      "type": "local",
      "command": ["C:\\Users\\User\\AppData\\Roaming\\npm\\notion-mcp-server.cmd"]
    }
  }
}
```

### Skills Paths (10)

```json
{
  "skills": {
    "paths": [
      "C:\\Users\\User\\.config\\opencode\\skills",
      "C:\\Users\\User\\.config\\opencode\\skills\\marketplace",
      "C:\\Users\\User\\.config\\opencode\\skills\\references",
      "C:\\Users\\User\\.config\\opencode\\superpowers\\skills",
      "C:\\Users\\User\\.config\\opencode\\oh-my-opencode\\src\\skills",
      "C:\\Users\\User\\.claude\\commands",
      "C:\\Users\\User\\.gemini\\custom_skills",
      "D:\\OpenCodeTools\\openwork\\.opencode\\skills",
      "D:\\OpenCodeTools\\oh-my-opencode\\skills"
    ]
  }
}
```

### Plugins (5)

```json
{
  "plugin": [
    "C:\\Users\\User\\.config\\opencode\\oh-my-opencode",
    "C:\\Users\\User\\.config\\opencode\\superpowers",
    "D:\\OpenCodeTools\\micode",
    "D:\\OpenCodeTools\\background-agents",
    "D:\\OpenCodeTools\\envsitter-guard"
  ]
}
```

## Skills Available

### Custom Skills (in .config/opencode/skills)
- `cli-mastery/` - All CLI commands reference
- `amazing-clis.md` - Complete CLI list
- `ai-ecosystem-digest.md` - Consolidated AI knowledge
- `ai-2026.md` - Emerging AI tools 2026
- `automation-learning.md` - AI automation
- And more from Gemini imports...

### Superpowers (14 skills)
- brainstorming, writing-plans, writing-skills
- verification-before-completion, using-superpowers
- using-git-worktrees, test-driven-development
- systematic-debugging, subagent-driven-development
- requesting-code-review, receiving-code-review
- finishing-a-development-branch, executing-plans
- dispatching-parallel-agents

### Oh-My-OpenCode (6+ agents)
- Background agents for async tasks

## Verification Commands

```bash
# Check MCP status
opencode mcp list

# Test model
opencode run "Hello"

# List skills
# (skills are auto-discovered from paths)

# List models
opencode models
```

## Status: Working

- **Model**: ✓ minimax-m2.5-free working
- **MCP Servers**: ✓ 10/10 connected
- **Skills**: ✓ Auto-discovered from paths
- **Plugins**: ✓ 5 loaded