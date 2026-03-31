#!/bin/bash
# ====================================================================
# Offline Tool Downloader - Run on Connected Machine
# Downloads tools to USB for offline use
# ====================================================================

set -euo pipefail

USB_ROOT="/media/kali/KaliShare"
TOOLS_DIR="$USB_ROOT/tools"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[+]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

mkdir -p "$TOOLS_DIR"

echo "════════════════════════════════════════════════════════════"
echo "  OFFLINE TOOLS DOWNLOADER"
echo "  Tools will be saved to: $TOOLS_DIR"
echo "════════════════════════════════════════════════════════════"

# Wordlists
log "Downloading wordlists..."
cd "$TOOLS_DIR"
git clone --depth 1 --single-branch https://github.com/danielmiessler/SecLists.git 2>/dev/null || log "SecLists already exists"

# Recon Tools
log "Installing Go tools..."
if command -v go &> /dev/null; then
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null || true
    go install github.com/projectdiscovery/subfinder/cmd/subfinder@latest 2>/dev/null || true
    go install github.com/projectdiscovery/naabu/cmd/naabu@latest 2>/dev/null || true
    go install github.com/tomnomnom/assetfinder@latest 2>/dev/null || true
    go install github.com/projectdiscovery/katana/cmd/katana@latest 2>/dev/null || true
    log "Go tools installed to ~/go/bin"
else
    log "Go not installed - skip Go tools"
fi

# Payloads
log "Cloning payloads..."
git clone --depth 1 --single-branch https://github.com/swisskyrepo/PayloadsAllTheThings.git 2>/dev/null || log "Already exists"
git clone --depth 1 --single-branch https://github.com/01ghost/ShellPop.git 2>/dev/null || log "Already exists"

# PEASS
log "Cloning PEASS..."
git clone --depth 1 --single-branch https://github.com/carlospolop/PEASS-ng.git 2>/dev/null || log "Already exists"

# Other
log "Cloning additional..."
git clone --depth 1 --single-branch https://github.com/0x727/ShodanSpy.git 2>/dev/null || true
git clone --depth 1 --single-branch https://github.com/sullo/nikto.git 2>/dev/null || true

# Binaries
log "Downloading Windows binaries..."
mkdir -p "$TOOLS_DIR/binaries/windows"
cd "$TOOLS_DIR/binaries/windows"

# Mimikatz (from releases)
if [ ! -f mimikatz.exe ]; then
    curl -sL -o mimikatz.exe "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip" 2>/dev/null || true
fi

log "Done! Tools saved to $TOOLS_DIR"
echo ""
echo "To use Go tools: export PATH=\$PATH:\$HOME/go/bin"
echo "To use wordlists: ls $TOOLS_DIR/SecLists/"