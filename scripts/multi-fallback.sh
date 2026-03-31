#!/bin/bash
# multi-fallback.sh - Multi-tool fallback orchestration
# Usage: ./multi-fallback.sh [scan|web|password|wifi|exploit]

source "$(dirname "$0")/error-fallback.sh"

MODE=${1:-menu}

echo "=== Multi-Tool Fallback System ==="

case $MODE in
    scan)
        echo "Target: "
        read TARGET
        fallback_nmap "$TARGET"
        ;;
    web)
        echo "Target: "
        read TARGET
        fallback_web "$TARGET"
        ;;
    password)
        echo "Hash file: "
        read FILE
        fallback_password "$FILE"
        ;;
    wifi)
        fallback_wifi
        ;;
    exploit)
        echo "Target: "
        read TARGET
        fallback_exploit "$TARGET"
        ;;
    all)
        echo "=== Full Fallback Test ==="
        echo "Testing all fallbacks..."
        
        echo "[1] Network fallback:"
        echo "8.8.8.8" | timeout 2 nc -zv 8.8.8.8 443 2>&1 | head -2
        
        echo "[2] Web fallback:"
        curl -sI https://example.com | head -3
        
        echo "[3] Tools fallback:"
        for tool in nmap curl wget; do
            echo -n "$tool: "
            command -v $tool &>/dev/null && echo "OK" || echo "MISSING"
        done
        
        echo "All fallbacks tested"
        ;;
    menu|*)
        echo "1) Scan fallback"
        echo "2) Web fallback"
        echo "3) Password fallback"
        echo "4) WiFi fallback"
        echo "5) Exploit fallback"
        echo "6) Test all fallbacks"
        read -p "Choice: " choice
        case $choice in
            1) $0 scan ;;
            2) $0 web ;;
            3) $0 password ;;
            4) $0 wifi ;;
            5) $0 exploit ;;
            6) $0 all ;;
        esac
        ;;
esac