#!/bin/bash
# vuln-scan.sh - Automated vulnerability scanning
# Usage: ./vuln-scan.sh target

TARGET=${1:-}

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "=== Vulnerability Scan: $TARGET ==="

echo "[1/4] Nuclei scan..."
nuclei -u $TARGET -severity critical,high,medium -silent -json -o nuclei.json 2>/dev/null

echo "[2/4] Nmap vuln scripts..."
nmap --script vuln -sV $TARGET -oA vuln-nmap 2>/dev/null

echo "[3/4] Wapiti scan..."
wapiti -u $TARGET --flush-session -o wapiti 2>/dev/null

echo "[4/4] Nikto scan..."
nikto -h $TARGET -o nikto.txt 2>/dev/null

echo "=== Done. Results saved to current directory ==="
ls -la *.json *.txt 2>/dev/null | head -20