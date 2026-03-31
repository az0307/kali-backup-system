#!/bin/bash
set -e

echo "=========================================="
echo "Installing All AI Tools"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/3] Installing Ollama..."
bash "$SCRIPT_DIR/install-ollama.sh"

echo ""
echo "[2/3] Installing OpenWork..."
bash "$SCRIPT_DIR/install-openwork.sh"

echo ""
echo "[3/3] Installing HuggingFace..."
bash "$SCRIPT_DIR/install-huggingface.sh"

echo ""
echo "=========================================="
echo "All AI Tools Installed Successfully!"
echo "=========================================="