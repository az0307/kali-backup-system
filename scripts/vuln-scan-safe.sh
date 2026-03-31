#!/bin/bash
# vuln-scan-safe.sh - Vulnerability scan with fallbacks
# Usage: ./vuln-scan-safe.sh target

source "$(dirname "$0")/error-fallback.sh"

TARGET=${1:-}

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "=== Safe Vuln Scan: $TARGET ==="

echo "[1/4] Nuclei scan..."
if check_deps nuclei; then
    nuclei -u $TARGET -severity critical,high -silent -json -o nuclei.json 2>/dev/null
else
    echo "Nuclei not available, skipping..."
fi

echo "[2/4] Nmap vuln scripts..."
if check_deps nmap; then
    nmap --script vuln -sV $TARGET -oA vuln-nmap 2>/dev/null
else
    fallback_nmap "$TARGET"
fi

echo "[3/4] Wapiti scan..."
if command -v wapiti &> /dev/null; then
    wapiti -u $TARGET --flush-session -o wapiti 2>/dev/null
else
    echo "Wapiti not available"
fi

echo "[4/4] Nikto scan..."
if check_deps nikto; then
    nikto -h $TARGET -o nikto.txt 2>/dev/null
else
    echo "Nikto not available"
    echo "Fallback: manual curl checks..."
    curl -s "http://$TARGET" | grep -i "error\|warning\|debug" | head -5
fi

echo "=== Done ==="