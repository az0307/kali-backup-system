#!/bin/bash
# recon-full.sh - Complete reconnaissance automation
# Usage: ./recon-full.sh target.com

TARGET=${1:-}

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target.com>"
    exit 1
fi

echo "=== Full Recon for $TARGET ==="
mkdir -p ~/recon/$TARGET && cd ~/recon/$TARGET

echo "[1/5] Subdomain enumeration..."
sublist3r -d $TARGET -o subdomains.txt 2>/dev/null
amass enum -d $TARGET -o amass.txt 2>/dev/null
cat subdomains.txt amass.txt 2>/dev/null | sort -u > all-subdomains.txt

echo "[2/5] Port scanning..."
nmap -iL all-subdomains.txt -p- -T4 -oA ports 2>/dev/null

echo "[3/5] Web probing..."
httpx -list all-subdomains.txt -threads 50 -o alive.txt 2>/dev/null

echo "[4/5] Technology detection..."
for host in $(cat alive.txt 2>/dev/null); do
    whatweb $host 2>/dev/null | tee -a tech.txt
done

echo "[5/5] Directory enumeration..."
gobuster dir -u http://$TARGET -w /usr/share/wordlists/dirb/common.txt -o dirs.txt 2>/dev/null

echo "=== Recon complete ==="
ls -la