#!/bin/bash
# Download Password Wordlists to USB

echo "Downloading password wordlists..."

cd /tmp

# Download SecLists (comprehensive)
echo "Downloading SecLists..."
wget -q https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip -O seclists.zip 2>/dev/null

# Download RockYou
echo "Downloading RockYou2024..."
wget -q https://download.githubusercontent.com/vanhauser-thc/thc-hydra/master/tests/rockyou.txt -O rockyou.txt 2>/dev/null

echo "Wordlists downloaded!"
echo "Location: /tmp/"
echo ""
echo "To copy to USB:"
echo "cp -r /tmp/*.zip /media/..."
