#!/bin/bash
# MCP Server - GitHub
# Requires: GITHUB_TOKEN environment variable

if [ -z "$GITHUB_TOKEN" ]; then
    echo "ERROR: GITHUB_TOKEN not set"
    echo "Set with: export GITHUB_TOKEN=ghp_xxx"
    exit 1
fi

echo "Starting GitHub MCP server..."
npx -y @modelcontextprotocol/server-github