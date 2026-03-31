#!/bin/bash
# STAGE 3: Resources, Wordlists & Extras
# Run as root: sudo ./scripts/setup-stage3-resources.sh

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     STAGE 3: Resources, Wordlists & Extras        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "[1/6] Installing wordlists..."
sudo apt install -y wordlists seclists

echo "[2/6] Downloading PayloadsAllTheThings..."
mkdir -p /opt/pentest-tools
cd /opt/pentest-tools
git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git 2>/dev/null || true

echo "[3/6] Downloading SecLists..."
git clone --depth 1 https://github.com/danielmiessler/SecLists.git 2>/dev/null || true

echo "[4/6] Downloading FuzzDB..."
git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git 2>/dev/null || true

echo "[5/6] Installing privilege escalation tools..."
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o /opt/linpeas.sh
chmod +x /opt/linpeas.sh

echo "[6/6] Installing cupp (password generator)..."
git clone --depth 1 https://github.com/Mebus/cupp.git /opt/cupp 2>/dev/null || true

echo ""
echo "✅ Stage 3 Complete!"
echo ""
echo "Resources:"
echo "  Wordlists: /usr/share/wordlists/"
echo "  SecLists: /usr/share/seclists/"
echo "  Payloads: /opt/pentest-tools/PayloadsAllTheThings/"
echo "  LinPEAS: /opt/linpeas.sh"
