#!/bin/bash
# web-enum.sh - Web application enumeration
# Usage: ./web-enum.sh target.com

TARGET=${1:-}

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target.com>"
    exit 1
fi

echo "=== Web Enum: $TARGET ==="

echo "[1/6] Technology detection..."
whatweb -q $TARGET > tech.txt

echo "[2/6] Subdomain enum..."
sublist3r -d $TARGET -o subs.txt 2>/dev/null

echo "[3/6] Directory busting..."
gobuster dir -u http://$TARGET -w /usr/share/wordlists/dirb/common.txt -o dirs.txt 2>/dev/null

echo "[4/6] Parameter discovery..."
parameth -u http://$TARGET 2>/dev/null | tee params.txt

echo "[5/6] CMS detection..."
wpscan --url http://$TARGET --enumerate vp 2>/dev/null | tee cms.txt || echo "Not WP"

echo "[6/6] SSL check..."
testssl --json file://$TARGET.json $TARGET 2>/dev/null || sslyze $TARGET 2>/dev/null

echo "=== Done ==="
ls -la *.txt *.json 2>/dev/null