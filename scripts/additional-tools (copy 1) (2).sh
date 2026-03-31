#!/bin/bash
# Additional Tools Installation Script
# Run as root in Kali

echo "=========================================="
echo "Installing Additional Tools & Repos"
echo "=========================================="

TOOLS_DIR="/opt"
mkdir -p $TOOLS_DIR

# ===== RED TEAM / PENTEST =====
echo "[1/12] Installing Red Team tools..."

# NetSentinel - Internal recon framework
git clone --depth 1 https://github.com/kaotickj/NetSentinel.git $TOOLS_DIR/NetSentinel 2>/dev/null || true

# ShadowStrike - Kali setup script
git clone --depth 1 https://github.com/S0H4M-BreachFinder/Shadow-Strike.git $TOOLS_DIR/ShadowStrike 2>/dev/null || true

# EvilKali - Missing tools installer
git clone --depth 1 https://github.com/YoruYagami/EvilKali.git $TOOLS_DIR/EvilKali 2>/dev/null || true

# ===== RECON / OSINT =====
echo "[2/12] Installing Recon/OSINT tools..."

# ReconDog
git clone --depth 1 https://github.com/s0md3v/ReconDog.git $TOOLS_DIR/ReconDog 2>/dev/null || true

# DarkSide
git clone --depth 1 https://github.com/xsoulpacket/darkside.git $TOOLS_DIR/darkside 2>/dev/null || true

# ===== WEB =====
echo "[3/12] Installing Web testing tools..."

# JWT Tool
git clone --depth 1 https://github.com/ticarpi/jwt_tool.git $TOOLS_DIR/jwt_tool 2>/dev/null || true

# GitTools
git clone --depth 1 https://github.com/internetwache/GitTools.git $TOOLS_DIR/GitTools 2>/dev/null || true

# ===== PASSWORD =====
echo "[4/12] Installing Password tools..."

# Cupp - Custom wordlist generator
git clone --depth 1 https://github.com/Mebus/cupp.git $TOOLS_DIR/cupp 2>/dev/null || true

# ===== REVERSE ENGINEERING =====
echo "[5/12] Installing RE tools..."

# Ghidra
sudo apt install -y ghidra 2>/dev/null || true

# Ghidra patterns
git clone --depth 1 https://github.com/TacticusPLanner/GhidraPatterns.git $TOOLS_DIR/GhidraPatterns 2>/dev/null || true

# ===== PRIVILEGE ESCALATION =====
echo "[6/12] Installing Privilege Escalation tools..."

# LinPEAS
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o $TOOLS_DIR/linpeas.sh
chmod +x $TOOLS_DIR/linpeas.sh

# WinPEAS
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/winpeas.exe -o $TOOLS_DIR/winpeas.exe

# GTFOBins
git clone --depth 1 https://github.com/Tib3rius/GTFOBins.git $TOOLS_DIR/GTFOBins 2>/dev/null || true

# ===== POST-EXPLOITATION =====
echo "[7/12] Installing Post-exploitation tools..."

# EvilGnome
git clone --depth 1 https://github.com/PorNeDaN/EvilGnome.git $TOOLS_DIR/EvilGnome 2>/dev/null || true

# ===== CTF / PRACTICE =====
echo "[8/12] Installing CTF/Practice tools..."

# PwnTools
pip3 install pwntools 2>/dev/null || true

# ROPgadget
pip3 install ropgadget 2>/dev/null || true

# ===== PRODUCTIVITY =====
echo "[9/12] Installing Productivity tools..."

# Tmux plugin manager
git clone --depth 1 https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm 2>/dev/null || true

# ===== MONITORING =====
echo "[10/12] Installing Monitoring tools..."

# CyberChef (browser-based, download)
curl -L "https://github.com/matthewhiggins17/cyberchef/releases/latest/download/CyberChef_enveloped.html" -o /usr/share/cyberchef.html 2>/dev/null || true

# ===== VISUALIZATION =====
echo "[11/12] Installing Visualization tools..."

# Maltego (already in Kali)
sudo apt install -y maltego 2>/dev/null || true

# ===== LEARNING =====
echo "[12/12] Installing Learning resources..."

# OverTheWire Wargames
git clone --depth 1 https://github.com/ctf101.org/ctf101.org.git /opt/ctf101 2>/dev/null || true

# ===== CLEANUP =====
echo "Cleaning up..."
sudo apt autoremove -y 2>/dev/null || true

echo ""
echo "=========================================="
echo "Additional Tools Installation Complete!"
echo "=========================================="
echo ""
echo "New tools installed:"
ls -la $TOOLS_DIR
echo ""
echo "Quick access:"
echo "  Privilege Escalation: $TOOLS_DIR/linpeas.sh"
echo "  JWT Tool: python3 $TOOLS_DIR/jwt_tool/jwt_tool.py"
echo "  GTFOBins: $TOOLS_DIR/GTFOBins/gtfobins.py"
echo ""
