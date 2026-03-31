#!/bin/bash
# ====================================================================
# ORGANIZE KALISHARE - Reorganize and structure everything
# ====================================================================

set -euo pipefail

KALI_SHARE="/root/KaliShare"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }

organize_structure() {
    log "Creating organized directory structure..."
    
    # Ensure directories exist
    mkdir -p "${KALI_SHARE}/logs/detection"
    mkdir -p "${KALI_SHARE}/logs/stealth"
    mkdir -p "${KALI_SHARE}/sweeps"
    mkdir -p "${KALI_SHARE}/workflows"
    mkdir -p "${KALI_SHARE}/payloads"
    mkdir -p "${KALI_SHARE}/handshakes"
    mkdir -p "${KALI_SHARE}/reports"
    mkdir -p "${KALI_SHARE}/backups"
    mkdir -p "${KALI_SHARE}/temp"
    
    log "Directories created"
}

fix_permissions() {
    log "Fixing script permissions..."
    
    find "${KALI_SHARE}" -name "*.sh" -type f -exec chmod +x {} \;
    find "${KALI_SHARE}/cli" -type f -exec chmod +x {} \;
    
    log "Permissions fixed"
}

create_index() {
    log "Creating index files..."
    
    # Scripts index
    find "${KALI_SHARE}/scripts" -name "*.sh" -type f | while read -r script; do
        basename "$script" .sh
    done > "${KALI_SHARE}/SCRIPTS_INDEX.txt"
    
    # Skills index
    find "${KALI_SHARE}/skills" -name "*.md" -type f | while read -r skill; do
        basename "$skill" .md
    done > "${KALI_SHARE}/SKILLS_INDEX.txt"
    
    log "Indexes created"
}

setup_git() {
    log "Setting up Git (if not initialized)..."
    
    if [[ ! -d "${KALI_SHARE}/.git" ]]; then
        cd "${KALI_SHARE}"
        git init
        git config user.email "kalishare@local"
        git config user.name "KaliShare"
        log "Git initialized"
    else
        log "Git already initialized"
    fi
}

show_structure() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          KALISHARE STRUCTURE                         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Main Directories:"
    echo "  cli/          - Command interface"
    echo "  scripts/      - 75+ automation scripts"
    echo "  skills/       - 32 AI skills"
    echo "  docs/         - Documentation"
    echo "  chains/       - Workflow chains"
    echo "  mcp/          - MCP servers"
    echo "  agents/       - AI agents"
    echo "  gems/         - Quick references"
    echo ""
    echo "Runtime Directories:"
    echo "  logs/         - Detection & stealth logs"
    echo "  sweeps/       - Area sweep results"
    echo "  workflows/    - Automation outputs"
    echo "  payloads/     - Generated payloads"
    echo "  handshakes/   - WiFi handshakes"
    echo "  reports/      - Pentest reports"
    echo "  backups/       - Config backups"
    echo "  temp/         - Temporary files"
    echo ""
    echo "Root Files:"
    echo "  aliases.sh    - Shell aliases"
    echo "  QUICK-REF.txt - Quick reference"
    echo "  README.md     - Main docs"
    echo "  AGENTS.md     - AI guidelines"
}

main() {
    organize_structure
    fix_permissions
    create_index
    setup_git
    show_structure
    
    log "Organization complete!"
    echo ""
    echo "Run './cli/go status' to verify"
    echo "Run './cli/go audit' for test suite"
}

main "$@"