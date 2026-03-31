# CLI Reference Cards

## AI Agents

### OpenCode
```
opencode                    # Interactive mode
opencode serve              # Headless server
opencode mcp list           # Check MCP status
opencode skills list        # See skills
```

### Claude Code
```
claude-code                 # Start CLI
```

### Gemini CLI
```
gemini                      # Interactive
gemini -p "prompt"          # Single prompt
```

### Grok CLI
```
grok "message"              # Chat mode
grok git                    # Git operations
grok mcp                    # MCP management
```

## MCP Quick Start

```bash
# Via Bitwarden (recommended)
$env:GITHUB_TOKEN = $(bw get notes 'GitHub Token')
& 'mcp-server-github.cmd'

# Direct
mcp-server-filesystem "C:/Users/User"
mcp-server-bitwarden
```

## Environment Setup

```powershell
# Set API keys from Bitwarden
$env:GITHUB_TOKEN = $(bw get notes 'GitHub Token - Antigravity')
$env:OPENROUTER_API_KEY = $(bw get notes 'OpenRouter API Key')
$env:BRAVE_API_KEY = $(bw get notes 'Brave Search API Key')
```