#!/bin/bash
set -e

echo "=========================================="
echo "Installing HuggingFace CLI & Transformers"
echo "=========================================="

if ! command -v python3 &> /dev/null; then
    echo "Installing Python3..."
    apt-get update && apt-get install -y python3 python3-pip python3-venv
fi

echo "Installing HuggingFace Hub..."
pip3 install huggingface-hub

echo "Installing Transformers and related libraries..."
pip3 install transformers torch torchvision torchaudio

echo "Installing additional AI/ML dependencies..."
pip3 install accelerate datasets peft bitsandbytes sentencepiece protobuf

echo ""
echo "HuggingFace tools installed!"
echo "Download models: huggingface-cli download"
echo "Login: huggingface-cli login"