#!/bin/bash
# ====================================================================
# KALISHARE AUDIT & TEST SUITE
# Verify all tools, scripts, and configurations
# ====================================================================

set -euo pipefail

KALI_SHARE="/root/KaliShare"
REPORT_FILE="${KALI_SHARE}/audit_report.txt"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

echo "╔══════════════════════════════════════════════════════╗"
echo "║       KALISHARE AUDIT & TEST SUITE v1.0              ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Initialize report
echo "KaliShare Audit Report - $(date)" > "$REPORT_FILE"
echo "=============================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Test 1: Directory structure
echo -n "Testing directory structure... "
if [[ -d "$KALI_SHARE" ]] && [[ -d "$KALI_SHARE/scripts" ]] && [[ -d "$KALI_SHARE/cli" ]]; then
    pass "Directories exist"
    echo "✓ Directories OK" >> "$REPORT_FILE"
else
    fail "Missing directories"
    echo "✗ Directories FAIL" >> "$REPORT_FILE"
fi

# Test 2: CLI executable
echo -n "Testing CLI... "
if [[ -x "$KALI_SHARE/cli/go" ]]; then
    pass "CLI executable"
    echo "✓ CLI OK" >> "$REPORT_FILE"
else
    fail "CLI not executable"
    chmod +x "$KALI_SHARE/cli/go" 2>/dev/null || true
fi

# Test 3: Script count
echo -n "Testing scripts... "
script_count=$(find "$KALI_SHARE/scripts" -name "*.sh" 2>/dev/null | wc -l)
if [[ $script_count -gt 30 ]]; then
    pass "Scripts: $script_count"
    echo "✓ Scripts: $script_count" >> "$REPORT_FILE"
else
    warn "Low script count: $script_count"
fi

# Test 4: Key scripts exist
echo -n "Checking key scripts... "
key_scripts=("tool-widget.sh" "stealth-mode.sh" "detection-tracker.sh" "area-sweeper.sh" "payload-generator.sh" "automation-hub.sh" "essential-tools.sh")
missing=0
for script in "${key_scripts[@]}"; do
    if [[ ! -f "$KALI_SHARE/scripts/$script" ]]; then
        missing=$((missing + 1))
    fi
done
if [[ $missing -eq 0 ]]; then
    pass "All key scripts present"
    echo "✓ Key scripts OK" >> "$REPORT_FILE"
else
    fail "Missing: $missing scripts"
fi

# Test 5: Tools available (optional - won't fail if missing)
echo ""
echo "=== TOOL AVAILABILITY TEST ==="

tools=("nmap" "aircrack-ng" "nikto" "sqlmap" "hashcat" "hydra" "msfconsole" "searchsploit")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        pass "$tool installed"
    else
        warn "$tool not found"
    fi
done

# Test 6: Aliases file
echo ""
echo -n "Testing aliases... "
if [[ -f "$KALI_SHARE/aliases.sh" ]]; then
    pass "aliases.sh exists"
    alias_count=$(grep -c "^alias " "$KALI_SHARE/aliases.sh" 2>/dev/null || echo 0)
    info "$alias_count aliases defined"
else
    warn "aliases.sh not found"
fi

# Test 7: Skills
echo ""
echo -n "Testing skills... "
skill_count=$(find "$KALI_SHARE/skills" -name "*.md" 2>/dev/null | wc -l)
if [[ $skill_count -gt 10 ]]; then
    pass "Skills: $skill_count"
    echo "✓ Skills: $skill_count" >> "$REPORT_FILE"
else
    warn "Low skill count: $skill_count"
fi

# Test 8: Documentation
echo ""
echo -n "Testing docs... "
doc_count=$(find "$KALI_SHARE/docs" -name "*.md" -o -name "*.txt" 2>/dev/null | wc -l)
if [[ $doc_count -gt 10 ]]; then
    pass "Docs: $doc_count"
    echo "✓ Docs: $doc_count" >> "$REPORT_FILE"
else
    warn "Low doc count: $doc_count"
fi

# Test 9: Network connectivity (optional)
echo ""
echo "=== NETWORK TESTS ==="
if ping -c 1 8.8.8.8 &> /dev/null; then
    pass "Internet connectivity"
else
    warn "No internet"
fi

# Test 10: Permissions
echo ""
echo "=== PERMISSION TESTS ==="
echo -n "Scripts executable... "
perm_issues=0
find "$KALI_SHARE/scripts" -name "*.sh" -exec test -x {} \; -print 2>/dev/null | wc -l | read -r exec_count
info "$exec_count executable scripts"

# Summary
echo ""
echo "═══════════════════════════════════════════════════════"
echo "AUDIT SUMMARY"
echo "═══════════════════════════════════════════════════════"

echo "Total Scripts: $(find "$KALI_SHARE/scripts" -name "*.sh" | wc -l)"
echo "Total Skills: $(find "$KALI_SHARE/skills" -name "*.md" | wc -l)"
echo "Total Docs: $(find "$KALI_SHARE/docs" -name "*.md" -o -name "*.txt" | wc -l)"

echo ""
echo "Report saved to: $REPORT_FILE"
echo ""

# Quick validation command
echo "Run: ./cli/go validate     # Check tools"
echo "Run: ./cli/go status      # System status"
echo "Run: ./cli/go quick-help  # Quick reference"