#!/bin/bash
# recon-full-safe.sh - Recon with error fallback
# Usage: ./recon-full-safe.sh target.com

source "$(dirname "$0")/error-fallback.sh"

TARGET=${1:-}

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target.com>"
    exit 1
fi

echo "=== Safe Recon for $TARGET ==="
mkdir -p ~/recon/$TARGET && cd ~/recon/$TARGET

echo "[1/5] Subdomain enum..."
check_deps sublist3r amass || echo "Falling back to basic methods..."

if command -v sublist3r &> /dev/null; then
    sublist3r -d $TARGET -o subdomains.txt 2>/dev/null
elif command -v amass &> /dev/null; then
    amass enum -d $TARGET -o subdomains.txt 2>/dev/null
else
    for sub in www mail ftp admin; do
        host "$sub.$TARGET" 2>/dev/null | grep "has address" >> subdomains.txt
    done
fi

echo "[2/5] Port scanning..."
if check_deps nmap rustscan; then
    fallback_nmap "$TARGET"
else
    echo "Checking common ports..."
    for port in 22 80 443 445 3389 3306 5432 8080; do
        timeout 2 bash -c "echo >/dev/tcp/$TARGET/$port" 2>/dev/null && echo "$port open"
    done
fi

echo "[3/5] Web probing..."
if command -v httpx &> /dev/null; then
    httpx -list subdomains.txt -threads 50 -o alive.txt 2>/dev/null
elif command -v curl &> /dev/null; then
    while read host; do
        curl -s -o /dev/null -w "%{http_code} $host\n" "http://$host" | grep -v "000"
    done < subdomains.txt > alive.txt
fi

echo "[4/5] Technology detection..."
if command -v whatweb &> /dev/null; then
    whatweb -i alive.txt --log-xml=tech.xml 2>/dev/null
else
    for host in $(head -5 alive.txt 2>/dev/null); do
        curl -sI "$host" | grep -i "server\|x-powered-by" | head -3
    done
fi

echo "[5/5] Directory enumeration..."
fallback_web "$TARGET"

echo "=== Recon complete ==="
ls -la