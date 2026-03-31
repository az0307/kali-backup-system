# HexStrike Integration Setup

## HexStrike Location
```
/root/hexstrike-ai/
├── hexstrike_mcp.py      # MCP server
├── hexstrike_server.py  # AI server
├── start_hexstrike.sh  # Launcher
└── hexstrike-ai-mcp.json
```

## Start HexStrike
```bash
cd /root/hexstrike-ai
./start_hexstrike.sh
```

## Connect to MCP
```json
{
  "mcpServers": {
    "hexstrike": {
      "command": "python",
      "args": ["hexstrike_mcp.py"]
    }
  }
}
```

## AI Commands via HexStrike
```bash
# Start AI session
hexstrike

# Pentest mode
pentest target.com

# Analyze findings
analyze nmap-results.xml

# Generate exploit
exploit-generate windows/x64/meterpreter
```

## Integration with GO Command
```bash
go ai-pentest target.com
# → Uses HexStrike AI for decision making
```

## API Keys
Set in `~/.bashrc`:
```bash
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"
```
