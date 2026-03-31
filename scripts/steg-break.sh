#!/bin/bash
# steg-break.sh - Steganography tools wrapper
# Usage: ./steg-break.sh <imagefile>

IMG=${1:-}

if [ -z "$IMG" ]; then
    echo "Usage: $0 <imagefile>"
    exit 1
fi

echo "=== Steg Analysis: $IMG ==="

echo "[1/4] Metadata..."
exiftool $IMG 2>/dev/null || echo "exiftool not installed"

echo "[2/4] Hidden data..."
binwalk $IMG 2>/dev/null

echo "[3/4] Steghide..."
steghide extract -sf $IMG 2>/dev/null || echo "No steghide data"

echo "[4/4] Zsteg..."
zsteg $IMG 2>/dev/null || echo "zsteg not installed"

echo "=== Done ==="