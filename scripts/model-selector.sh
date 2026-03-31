#!/bin/bash
# ====================================================================
# AI Model Selector Widget
# Switch between models - Best & Free options
# ====================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Model database
MODELS=(
    "opencode/minimax-m2.5-free:OpenCode Built-in:Free:Best overall for coding"
    "opencode/gpt-5-nano:OpenCode Built-in:Free:Fast, good for simple tasks"
    "github-copilot/claude-sonnet-4.6:GitHub Copilot:Free:Excellent coding, analysis"
    "github-copilot/gemini-2.5-pro:GitHub Copilot:Free:Google's best, multimodal"
    "ollama/codellama-7b:Ollama Local:Free:Offline, privacy - needs download"
    "ollama/mistral-7b:Ollama Local:Free:Offline, fast"
    "ollama/deepseek-coder:Ollama Local:Free:Code-focused, privacy"
    "openrouter/google/gemini-2.0-flash-exp:OpenRouter:Free API:Limited, may expire"
    "openrouter/anthropic/claude-3-opus:OpenRouter:Paid:Best for complex reasoning"
    "openrouter/microsoft/wizardlm-2-8x22b:OpenRouter:Free API:Good reasoning, large"
)

show_models() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              AI MODEL SELECTOR - PENTESTER EDITION              ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}┌────┬────────────────────────────────┬──────────┬──────────────────┐${NC}"
    echo -e "${GREEN}│ #  │ Model                          │ Pricing  │ Notes            │${NC}"
    echo -e "${GREEN}├────┼────────────────────────────────┼──────────┼──────────────────┤${NC}"
    
    for i in "${!MODELS[@]}"; do
        IFS=':' read -r model name price notes <<< "${MODELS[$i]}"
        printf "${GREEN}│ %2d │ %-30s │ %-8s │ %-16s │${NC}\n" "$((i+1))" "$name" "$price" "$notes"
    done
    
    echo -e "${GREEN}└────┴────────────────────────────────┴──────────┴──────────────────┘${NC}"
    echo ""
}

show_best() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}                    RECOMMENDED BY USE CASE                       ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}[Best Overall]${NC}  github-copilot/claude-sonnet-4.6"
    echo -e "${GREEN}[Best Free]${NC}     github-copilot/gemini-2.5-pro"  
    echo -e "${GREEN}[Best Coding]${NC}    opencode/minimax-m2.5-free"
    echo -e "${GREEN}[Best Offline]${NC}   ollama/codellama-7b (requires download)"
    echo -e "${GREEN}[Fastest]${NC}       opencode/gpt-5-nano"
    echo -e "${YELLOW}[Privacy]${NC}       ollama/* (all run locally)"
    echo ""
}

show_quota() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}                         FREE QUOTA STATUS                         ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}✓ OpenCode Built-in:${NC} Unlimited (recommended)"
    echo -e "${GREEN}✓ GitHub Copilot:${NC} 2000 requests/month (sign up with GitHub)"
    echo -e "${GREEN}✓ Ollama Local:${NC} Unlimited (download once)"
    echo -e "${YELLOW}△ OpenRouter Free:${NC} Limited, may exhaust - use sparingly"
    echo -e "${RED}✗ OpenAI/Claude Pro:${NC} Requires paid API key"
    echo ""
}

set_model() {
    local model="$1"
    echo "Setting model to: $model"
    
    # Update opencode.json
    if [[ -f "$HOME/.config/opencode/opencode.json" ]]; then
        sed -i "s/\"model\": \"[^\"]*\"/\"model\": \"$model\"/" "$HOME/.config/opencode/opencode.json"
        echo -e "${GREEN}✓ Model updated in opencode.json${NC}"
    else
        echo -e "${YELLOW}Creating new opencode.json...${NC}"
        cat > "$HOME/.config/opencode/opencode.json" << EOF
{
  "model": "$model",
  "skills": { "paths": ["$HOME/.config/opencode/skills"] },
  "mcp": {}
}
EOF
        echo -e "${GREEN}✓ Created opencode.json with model: $model${NC}"
    fi
    
    echo ""
    echo "Test with: opencode run 'Hello'"
}

install_ollama() {
    echo -e "${YELLOW}Installing Ollama for local models...${NC}"
    curl -fsSL https://ollama.com/install.sh | sh
    
    echo ""
    echo -e "${GREEN}Ollama installed!${NC}"
    echo "Pull models with:"
    echo "  ollama pull codellama:7b"
    echo "  ollama pull mistral"
    echo "  ollama pull deepseek-coder"
}

main() {
    while true; do
        show_models
        echo -e "${CYAN}Menu:${NC}"
        echo "  [1-$(( ${#MODELS[@]} ))] Select model"
        echo "  [B]est recommendations"
        echo "  [Q]uota status"
        echo "  [I]install Ollama"
        echo "  [T]est current model"
        echo "  [E]xit"
        echo ""
        echo -ne "${YELLOW}Select: ${NC}"
        read choice
        
        case "$choice" in
            b|B) show_best ;;
            q|Q) show_quota ;;
            i|I) install_ollama ;;
            t|T) echo "Testing: opencode run 'Hello'" && opencode run "Hello" 2>&1 | head -5 ;;
            e|E) echo "Goodbye!"; exit 0 ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#MODELS[@]} ]; then
                    idx=$((choice - 1))
                    model=$(echo "${MODELS[$idx]}" | cut -d: -f1)
                    set_model "$model"
                else
                    echo -e "${RED}Invalid option${NC}"
                fi
                ;;
        esac
        echo ""
        echo -ne "${CYAN}Press Enter to continue...${NC}"
        read
    done
}

main "$@"