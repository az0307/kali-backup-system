#!/bin/bash
# MCP Server - Filesystem
# Usage: ./start-filesystem.sh [path]

PATH_ARG="${1:-/media/kali/KaliShare}"

echo "Starting Filesystem MCP server..."
echo "Path: $PATH_ARG"

npx -y @modelcontextprotocol/server-filesystem "$PATH_ARG"