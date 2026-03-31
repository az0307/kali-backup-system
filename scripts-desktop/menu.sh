#!/bin/bash
# KALI RED TEAM - Interactive Menu
# Run: sudo ./menu.sh

while true; do
    clear
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║       🐉 KALI RED TEAM MENU 🐉                     ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    echo "  📦 INSTALLATION"
    echo "     1. Install ALL (full setup)"
    echo "     2. Install Core Tools only"
    echo "     3. Install AI Tools only"
    echo "     4. Install Resources only"
    echo "     5. Install Network Tools only"
    echo "     6. Install Productivity only"
    echo ""
    echo "  🚀 QUICK START"
    echo "     7. Activate WiFi Adapter"
    echo "     8. Start SSH Server"
    echo "     9. Check System Status"
    echo ""
    echo "  ⚡ AI TOOLS"
    echo "     a. OpenCode"
    echo "     b. Claude Code"
    echo "     c. Gemini CLI"
    echo "     d. HexStrike AI"
    echo "     e. Ollama"
    echo ""
    echo "  🛡️  EMERGENCY"
    echo "     x. RED BUTTON (destroy everything)"
    echo "     q. Quit"
    echo ""
    echo -n "Select option: "
    read choice
    
    case $choice in
        1) sudo bash install-all.sh ;;
        2) sudo bash setup-stage1-core.sh ;;
        3) sudo bash setup-stage2-ai.sh ;;
        4) sudo bash setup-stage3-resources.sh ;;
        5) sudo bash setup-stage4-network.sh ;;
        6) sudo bash setup-stage5-productivity.sh ;;
        7) sudo bash monitor-mode.sh ;;
        8) sudo bash ssh-install.sh ;;
        9) 
            echo "=== System Status ==="
            echo "RAM: $(free -h | grep Mem)"
            echo "Disk: $(df -h / | tail -1)"
            echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
            read -p "Press Enter to continue..."
            ;;
        a) opencode ;;
        b) claude ;;
        c) gemini --prompt "help" ;;
        d) cd /opt/hexstrike && python3 hexstrike.py ;;
        e) ollama ;;
        x) sudo bash red-button.sh ;;
        q) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
