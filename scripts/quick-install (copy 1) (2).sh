#!/bin/bash
# Quick Stage Selector - Run specific stages
# Run: sudo ./quick-install.sh

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     QUICK INSTALL - Select Stages               ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Available stages:"
echo "  1. Core Tools       - Pentest basics"
echo "  2. AI Tools        - Claude, OpenCode, Gemini, HexStrike"
echo "  3. Resources       - Wordlists, SecLists"
echo "  4. Network         - SSH, VPN"
echo "  5. Productivity    - CLI utils"
echo "  6. All            - Everything"
echo "  7. Exit"
echo ""

read -p "Select stage (1-7): " choice

case $choice in
    1)
        echo "Running Stage 1: Core Tools..."
        sudo bash setup-stage1-core.sh
        ;;
    2)
        echo "Running Stage 2: AI Tools..."
        sudo bash setup-stage2-ai.sh
        ;;
    3)
        echo "Running Stage 3: Resources..."
        sudo bash setup-stage3-resources.sh
        ;;
    4)
        echo "Running Stage 4: Network..."
        sudo bash setup-stage4-network.sh
        ;;
    5)
        echo "Running Stage 5: Productivity..."
        sudo bash setup-stage5-productivity.sh
        ;;
    6)
        echo "Running ALL stages..."
        sudo bash install-all.sh
        ;;
    7)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
