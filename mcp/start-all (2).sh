#!/bin/bash
# Start All MCP Servers
# Run this to start all MCP servers at once

echo "════════════════════════════════════════════════════════════"
echo "  Starting All MCP Servers"
echo "════════════════════════════════════════════════════════════"
echo ""

# Set your API keys here or via environment
# export GITHUB_TOKEN="ghp_xxx"
# export BRAVE_API_KEY="xxx"

echo "[1/4] Starting Filesystem MCP..."
npx -y @modelcontextprotocol/server-filesystem /media/kali/KaliShare &
FS_PID=$!
echo "  PID: $FS_PID"

echo "[2/4] Starting GitHub MCP..."
if [ -n "$GITHUB_TOKEN" ]; then
    npx -y @modelcontextprotocol/server-github &
    GH_PID=$!
    echo "  PID: $GH_PID"
else
    echo "  SKIPPED (GITHUB_TOKEN not set)"
fi

echo "[3/4] Starting Brave Search MCP..."
if [ -n "$BRAVE_API_KEY" ]; then
    npx -y @modelcontextprotocol/server-brave-search &
    BS_PID=$!
    echo "  PID: $BS_PID"
else
    echo "  SKIPPED (BRAVE_API_KEY not set)"
fi

echo "[4/4] Starting Sequential Thinking MCP..."
npx -y @modelcontextprotocol/server-sequential-thinking &
ST_PID=$!
echo "  PID: $ST_PID"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  MCP Servers Started!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "To verify: opencode mcp list"
echo "To stop:   pkill -f mcp-server"