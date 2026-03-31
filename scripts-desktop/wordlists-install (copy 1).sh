#!/bin/bash
# Download Wordlists for Password Cracking
# Run as root in Kali

echo "=========================================="
echo "Downloading Wordlists"
echo "=========================================="

WORDLIST_DIR="/usr/share/wordlists"
mkdir -p $WORDLIST_DIR

# Download rockyou.txt (if not exists)
echo "[1/5] Checking rockyou.txt..."
if [ ! -f "$WORDLIST_DIR/rockyou.txt" ]; then
    echo "Downloading rockyou.txt.gz..."
    wget -q -O "$WORDLIST_DIR/rockyou.txt.gz" "https://github.com/00xBAD/kali-wordlists/raw/master/rockyou.txt.gz" || \
    wget -q -O "$WORDLIST_DIR/rockyou.txt.gz" "https://gist.githubusercontent.com/hkphh/e28a8e1e4f4a2edd3a5a/raw/rockyou.txt.gz" || \
    echo "Will use Kali's built-in: apt install wordlists"
else
    echo "rockyou.txt already exists"
fi

# Download SecLists (comprehensive)
echo "[2/5] Downloading SecLists..."
if [ ! -d "$WORDLIST_DIR/seclists" ]; then
    cd $WORDLIST_DIR
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git seclists
else
    echo "SecLists already exists"
fi

# Download darkweb wordlist
echo "[3/5] Downloading darkweb2017-top10000..."
wget -q -O "$WORDLIST_DIR/darkweb2017-top10000.txt" "https://raw.githubusercontent.com/fbctf/easy-challenges/master/wordlists/darkweb2017-top10000.txt" 2>/dev/null || echo "Skipping darkweb"

# Download CrackStation wordlist
echo "[4/5] Downloading CrackStation..."
wget -q -O "$WORDLIST_DIR/crackstation.txt.gz" "https://crackstation.net/files/crackstation-human-only.txt.gz" 2>/dev/null || echo "Skipping crackstation"

# Download fasttrack
echo "[5/5] Installing fasttrack..."
sudo apt install -y sefasttrack 2>/dev/null || sudo apt install -y wordlists

echo ""
echo "=========================================="
echo "Wordlists Download Complete!"
echo "=========================================="
echo ""
echo "Location: $WORDLIST_DIR"
ls -la $WORDLIST_DIR
echo ""
echo "To extract rockyou.txt:"
echo "  gunzip $WORDLIST_DIR/rockyou.txt.gz"
echo ""
echo "To use with hashcat:"
echo "  hashcat -m 22000 handshake.hccapx $WORDLIST_DIR/rockyou.txt"
echo ""
echo "To use with aircrack:"
echo "  aircrack-ng -w $WORDLIST_DIR/rockyou.txt capture.cap"
