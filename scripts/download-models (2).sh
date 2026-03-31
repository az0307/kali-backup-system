#!/bin/bash
# ====================================================================
# Download AI Models - Hugging Face
# For offline use on USB
# ====================================================================

set -euo pipefail

MODELS_DIR="/media/kali/KaliShare/models"
mkdir -p "$MODELS_DIR"

echo "=============================================="
echo "  AI MODELS DOWNLOADER"
echo "=============================================="
echo "Models will be saved to: $MODELS_DIR"
echo ""

# Check pip
if ! command -v pip3 &> /dev/null; then
    apt update && apt install -y python3-pip
fi

# Install huggingface-hub
echo "[1/4] Installing huggingface-hub..."
pip3 install -q huggingface-hub

# Download function
download_model() {
    local model_id=$1
    local dest=$2
    echo "Downloading $model_id..."
    huggingface-cli download "$model_id" --local-dir "$dest" --ignore-files "*.md" "*.txt" "*.json" 2>/dev/null || true
}

echo "[2/4] Downloading Pentester Model..."
# Pentester-focused models
download_model "TheBloke/CodeLlama-7B-Instruct-GGUF" "$MODELS_DIR/codellama-7b"
download_model "TheBloke/Mistral-7B-Instruct-v0.2-GGUF" "$MODELS_DIR/mistral-7b"

echo "[3/4] Downloading Privacy-Focused Models..."
# Privacy/Local models (don't send to external API)
download_model "TheBloke/deepseek-coder-6.7B-instruct-GGUF" "$MODELS_DIR/deepseek-coder"
download_model "TheBloke/Phi-2-GGUF" "$MODELS_DIR/phi-2"

echo "[4/4] Creating Ollama configs..."
# Create Ollama Modelfile for each
cat > "$MODELS_DIR/codellama-7b/Modelfile" << 'EOF'
FROM ./codellama-7b-instruct.Q5_K_M.gguf
SYSTEM You are a penetration testing expert. Help with security assessments, CTFs, and best practices.
EOF

cat > "$MODELS_DIR/mistral-7b/Modelfile" << 'EOF'
FROM ./mistral-7b-instruct-v0.2.Q5_K_M.gguf
SYSTEM You are a cybersecurity expert. Help with network security, exploits, and hardening.
EOF

echo ""
echo "=============================================="
echo "  Download Complete!"
echo "=============================================="
echo ""
echo "Models saved to: $MODELS_DIR"
echo ""
echo "To use with Ollama:"
echo "  1. Install Ollama: curl -fsSL https://ollama.com/install.sh | sh"
echo "  2. Create model: ollama create pentester --file $MODELS_DIR/codellama-7b/Modelfile"
echo "  3. Run: ollama run pentester"
echo ""
echo "Manual download: https://huggingface.co/TheBloke"