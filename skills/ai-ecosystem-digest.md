---
name: ai-ecosystem-digest
description: Consolidated knowledge from all AI tools - Gemini, Claude, ChatGPT, OpenCode, Grok, Qwen, and Minimax. Provides unified access to skills, agents, and configurations.
---

# AI Ecosystem Digest

This skill consolidates knowledge from all AI tools in your ecosystem.

## Your AI Tools

| Tool | Type | Sessions | Config Location |
|------|------|----------|-----------------|
| OpenCode | CLI/Coding Agent | Active | `C:\Users\User\.config\opencode\` |
| Claude Desktop | Desktop App | `C:\Users\User\AppData\Roaming\Claude\` | `C:\Users\User\.claude\` |
| Gemini CLI | CLI | `C:\Users\User\.gemini\` | `C:\Users\User\.gemini\settings.json` |
| ChatGPT | Desktop App | Not accessible | `C:\Users\User\AppData\Local\Microsoft\WindowsApps\OpenAI.ChatGPT-Desktop` |
| Grok CLI | CLI (@vibe-kit/grok-cli) | None found | `C:\Users\User\AppData\Roaming\npm\node_modules\@vibe-kit\grok-cli\` |
| Perplexity | Desktop App | `C:\Users\User\AppData\Local\Perplexity\` | - |
| Desktop Commander | OpenCode UI | - | `C:\Users\User\AppData\Roaming\npm\@wonderwhy-er\desktop-commander` |
| TARS CLI | Agent CLI | - | `C:\Users\User\AppData\Roaming\npm\@agent-tars\cli` |

## Installed MCP Servers (16)

1. **filesystem** - File operations
2. **github** - GitHub API (via Bitwarden)
3. **git** - Git operations
4. **brave-search** - Web search (via Bitwarden)
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

## Your Skills (Consolidated)

### Red Team & Security
- `ai-2026.md` - Emerging AI red team tools 2026
- `automation-learning.md` - AI automation learning
- `claude-redteam-agent.md` - Claude red team agent
- `gemini-redteam-gem.md` - Gemini red team guide
- `kali-expert.md` - Kali Linux expert
- `kali-redteam-curator.md` - Red team curation
- `redteam-guide.md` - General red team guide

### Development & Coding
- `coding-expert.md` - Coding expertise
- `commands.md` - CLI commands
- `deepdive-complete.md` - Deep dive资料
- `linux-expert.md` - Linux expert
- `test-expert.md` - Testing expert

### Hardware & Systems
- `hardware.md` - Hardware knowledge
- `hardware-platforms.md` - Hardware platforms
- `virtualbox-setup.md` - VirtualBox setup
- `packages.md` - Package management

### Specialized Agents (from Gemini)
- `advanced-prompt-engineering-suite/` - Prompt engineering
- `cognitive-architecture-designer/` - Cognitive architecture
- `community-knowledge-synthesizer/` - Knowledge synthesis
- `emerging-technology-impact-assessor/` - Tech assessment
- `research-strategic-foresight-department/` - Strategic research
- `tool-capability-explorer/` - Tool exploration

### Templates & References
- `templates.md` - Templates
- `legal.md` - Legal considerations
- `file-creator.md` - File creation helper

## Plugins (5)

1. `oh-my-opencode` - Background agents
2. `superpowers` - Workflow orchestrator
3. `micode` - Brainstorm-Plan-Implement
4. `background-agents` - Async delegation
5. `envsitter-guard` - .env protection

## OpenCodeTools Repos (7)

| Repo | Purpose |
|------|---------|
| `awesome-opencode` | Curated plugins list |
| `openwork` | Desktop AI agent framework |
| `oh-my-opencode` | Multi-agent harness |
| `micode` | Workflow methodology |
| `cc-safety-net` | Blocks destructive commands |
| `background-agents` | Async delegation |
| `envsitter-guard` | Prevents .env leaks |

## Active Models

- **Default**: `openrouter/google/gemini-2.0-flash-exp:free`
- **OpenRouter**: Multiple models available via OpenRouter API

## Usage Notes

- Use `opencode mcp list` to check MCP server status
- Use `opencode skills list` to see all available skills
- Plugins add additional capabilities beyond base OpenCode
- Skills paths include imported Gemini skills and Claude commands

## Key Paths

```
OpenCode Config:  C:\Users\User\.config\opencode\opencode.json
Claude Config:    C:\Users\User\.claude\settings.json
Gemini Config:    C:\Users\User\.gemini\settings.json
Skills:          C:\Users\User\.config\opencode\skills\
MCP Servers:     C:\Users\User\AppData\Roaming\npm\mcp-server-*.cmd
```