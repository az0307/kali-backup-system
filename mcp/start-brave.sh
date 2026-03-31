#!/bin/bash
# MCP Server - Brave Search
# Requires: BRAVE_API_KEY environment variable

if [ -z "$BRAVE_API_KEY" ]; then
    echo "ERROR: BRAVE_API_KEY not set"
    echo "Set with: export BRAVE_API_KEY=xxx"
    exit 1
fi

echo "Starting Brave Search MCP server..."
npx -y @modelcontextprotocol/server-brave-search