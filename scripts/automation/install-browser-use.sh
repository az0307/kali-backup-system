#!/bin/bash
set -e

echo "=========================================="
echo "Installing browser-use - AI Browser Automation"
echo "=========================================="

if ! command -v python3 &> /dev/null; then
    echo "Installing Python3..."
    apt-get update && apt-get install -y python3 python3-pip python3-venv
fi

if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    apt-get update && apt-get install -y nodejs npm
fi

echo "Installing browser-use (Python)..."
pip3 install browser-use agentforge

echo "Installing browser-use (Node.js)..."
npm install -g browser-use

echo ""
echo "browser-use installed!"
echo "Python: from browser_use import Browser"
echo "Node: npx browser-use"