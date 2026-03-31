#!/bin/bash
set -e

echo "=========================================="
echo "Installing Ollama - Local LLM Runtime"
echo "=========================================="

if command -v ollama &> /dev/null; then
    echo "Ollama already installed"
    ollama --version
    exit 0
fi

echo "Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo ""
echo "Ollama installed successfully!"
echo "To start: ollama serve"
echo "To pull a model: ollama pull llama2"
echo "To list models: ollama list"