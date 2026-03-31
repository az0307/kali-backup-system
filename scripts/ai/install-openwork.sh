#!/bin/bash
set -e

echo "=========================================="
echo "Installing OpenWork AI Agent"
echo "=========================================="

if command -v python3 &> /dev/null; then
    echo "Python3 detected"
else
    echo "Installing Python3..."
    apt-get update && apt-get install -y python3 python3-pip python3-venv
fi

echo "Installing OpenWork via pip..."
pip3 install openwork-ai || pip install openwork-ai

echo ""
echo "OpenWork installed!"
echo "Run with: openwork"
echo "Configuration: ~/.openwork/config.yaml"