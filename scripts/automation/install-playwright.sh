#!/bin/bash
set -e

echo "=========================================="
echo "Installing Playwright - Browser Automation"
echo "=========================================="

if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    apt-get update && apt-get install -y nodejs npm
fi

echo "Installing Playwright..."
npm init -y
npm install playwright

echo "Installing browser binaries..."
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit

echo ""
echo "Playwright installed!"
echo "Run: node -e \"const { chromium } = require('playwright');\""
echo "Example: npx playwright test"