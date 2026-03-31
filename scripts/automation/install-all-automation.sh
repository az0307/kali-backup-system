#!/bin/bash
set -e

echo "=========================================="
echo "Installing All Browser Automation Tools"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/3] Installing Puppeteer..."
bash "$SCRIPT_DIR/install-puppeteer.sh"

echo ""
echo "[2/3] Installing Playwright..."
bash "$SCRIPT_DIR/install-playwright.sh"

echo ""
echo "[3/3] Installing browser-use..."
bash "$SCRIPT_DIR/install-browser-use.sh"

echo ""
echo "=========================================="
echo "All Automation Tools Installed!"
echo "=========================================="