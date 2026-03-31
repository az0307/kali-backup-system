#!/bin/bash
set -e

echo "=========================================="
echo "Installing Puppeteer - Browser Automation"
echo "=========================================="

if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    apt-get update && apt-get install -y nodejs npm
fi

if [ -d "node_modules" ]; then
    echo "Puppeteer already installed in current directory"
    node -e "require('puppeteer')" && echo "Puppeteer is working!"
    exit 0
fi

echo "Installing Puppeteer..."
npm init -y
npm install puppeteer puppeteer-core

echo ""
echo "Puppeteer installed!"
echo "Run: node -e \"const puppeteer = require('puppeteer');\""
echo "Example: https://github.com/puppeteer/puppeteer/tree/main/examples"