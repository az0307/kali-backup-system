#!/bin/bash
# hash-crack.sh - Password hash cracking automation
# Usage: ./hash-crack.sh <hashfile> <wordlist>

HASHFILE=${1:-hashes.txt}
WORDLIST=${2:-/usr/share/wordlists/rockyou.txt}

if [ ! -f "$HASHFILE" ]; then
    echo "Usage: $0 <hashfile> <wordlist>"
    exit 1
fi

echo "=== Hash Cracking: $HASHFILE ==="
echo "[1/3] Identifying hash types..."
hashid $HASHFILE > hash-type.txt

echo "[2/3] Running Hashcat..."
hashcat -m 0 $HASHFILE $WORDLIST --show > cracked.txt

echo "[3/3] Running John..."
john --wordlist=$WORDLIST $HASHFILE --format=raw 2>/dev/null
john --show $HASHFILE 2>/dev/null >> cracked.txt

echo "=== Results ==="
cat cracked.txt 2>/dev/null || echo "No passwords cracked yet"