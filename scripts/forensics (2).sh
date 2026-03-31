#!/bin/bash
# forensics.sh - Digital forensics quick collect
# Usage: ./forensics.sh <target_dir>

OUT=${1:-forensics-$(date +%Y%m%d)}

echo "=== Forensics Collection: $OUT ==="
mkdir -p $OUT

echo "[1/5] Memory dump (if volatility available)..."
which volatility3 2>/dev/null && echo "Volatility available" || echo "Volatility not found"

echo "[2/5] Timeline..."
log2timeline.py --output file:$OUT/timeline.plaso image.raw 2>/dev/null || echo "log2timeline not available"

echo "[3/5] File recovery..."
 photorec image.raw 2>/dev/null || extundelete image.raw 2>/dev/null || echo "No recovery tool"

echo "[4/5] Registry analysis (Windows)..."
which regripper 2>/dev/null && regripper -r registry.raw 2>/dev/null || echo "regripper not available"

echo "[5/5] Carving..."
foremost -i image.raw -o $OUT/carved 2>/dev/null || strings image.raw | grep -i password > $OUT/strings.txt

echo "=== Done: $OUT ==="