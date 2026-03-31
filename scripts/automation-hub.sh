#!/bin/bash
# ====================================================================
# AUTOMATION HUB - Orchestrate All Pentest Tools
# Run multiple tools in sequence, manage workflows
# ====================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KALI_SHARE="${SCRIPT_DIR}/.."
WORKFLOWS_DIR="${KALI_SHARE}/workflows"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; exit 1; }

mkdir -p "$WORKFLOWS_DIR"

workflow_recon() {
    local target="$1"
    
    log "=== WORKFLOW: RECON ==="
    
    log "Step 1: Whois..."
    whois "$target" > "${WORKFLOWS_DIR}/whois.txt" 2>&1
    
    log "Step 2: DNS Enum..."
    dnsenum "$target" > "${WORKFLOWS_DIR}/dnsenum.txt" 2>&1
    
    log "Step 3: Subdomain Enum..."
    subfinder -d "$target" -o "${WORKFLOWS_DIR}/subdomains.txt" 2>/dev/null || \
    sublist3r -d "$target" -o "${WORKFLOWS_DIR}/subdomains.txt" 2>/dev/null || \
    echo "Subdomain tools not installed" > "${WORKFLOWS_DIR}/subdomains.txt"
    
    log "Step 4: Port Scan..."
    nmap -sV -p- -T4 "$target" -oA "${WORKFLOWS_DIR}/nmap" 2>/dev/null
    
    log "=== RECON COMPLETE ==="
    echo "Results in: $WORKFLOWS_DIR/"
}

workflow_web() {
    local target="$1"
    
    log "=== WORKFLOW: WEB TEST ==="
    
    log "Step 1: Nikto..."
    nikto -h "http://$target" > "${WORKFLOWS_DIR}/nikto.txt" 2>&1
    
    log "Step 2: Directory Scan..."
    gobuster dir -u "http://$target" -w /usr/share/wordlists/dirb/big.txt \
        -o "${WORKFLOWS_DIR}/gobuster.txt" 2>/dev/null || \
    dirb "http://$target" > "${WORKFLOWS_DIR}/dirb.txt" 2>&1
    
    log "Step 3: SQLMap..."
    sqlmap -u "http://$target" --batch --smart \
        --output-dir="${WORKFLOWS_DIR}/sqlmap" 2>/dev/null || \
    echo "SQLMap scan complete" > "${WORKFLOWS_DIR}/sqlmap.txt"
    
    log "Step 4: CMS Detect..."
    whatweb "http://$target" > "${WORKFLOWS_DIR}/whatweb.txt" 2>&1
    
    log "=== WEB TEST COMPLETE ==="
}

workflow_wifi() {
    local iface="${1:-wlan0}"
    local bssid="$2"
    
    log "=== WORKFLOW: WIFI AUDIT ==="
    
    log "Step 1: Monitor Mode..."
    airmon-ng start "$iface" >/dev/null 2>&1
    sleep 2
    
    log "Step 2: Scan Networks..."
    timeout 30 airodump-ng wlan0mon -w "${WORKFLOWS_DIR}/wifi_scan" >/dev/null 2>&1
    sleep 25
    
    log "Step 3: Capture Handshake..."
    if [[ -n "$bssid" ]]; then
        airodump-ng --bssid "$bssid" -c 6 -w "${WORKFLOWS_DIR}/handshake" wlan0mon >/dev/null 2>&1 &
        DUMP_PID=$!
        sleep 5
        aireplay-ng --deauth 50 -a "$bssid" wlan0mon >/dev/null 2>&1
        sleep 30
        kill $DUMP_PID 2>/dev/null
    fi
    
    log "Step 4: Crack (if handshake captured)..."
    if ls "${WORKFLOWS_DIR}"/*.cap >/dev/null 2>&1; then
        aircrack-ng -w /usr/share/wordlists/rockyou.txt \
            "${WORKFLOWS_DIR}"/*.cap > "${WORKFLOWS_DIR}/crack_result.txt" 2>&1
    fi
    
    log "Step 5: Cleanup..."
    airmon-ng stop wlan0mon >/dev/null 2>&1
    
    log "=== WIFI AUDIT COMPLETE ==="
}

workflow_exploit() {
    local target="$1"
    local service="$2"
    
    log "=== WORKFLOW: EXPLOIT ==="
    
    log "Step 1: Vulnerability Scan..."
    nmap --script vuln -p "$service" "$target" \
        -oA "${WORKFLOWS_DIR}/vuln_scan" 2>/dev/null
    
    log "Step 2: Exploit Search..."
    searchsploit "$service" > "${WORKFLOWS_DIR}/exploits.txt" 2>&1
    
    log "Step 3: Metasploit Check..."
    echo "Run: msfconsole -q -x 'search $service'" > "${WORKFLOWS_DIR}/msf_commands.txt"
    
    log "=== EXPLOIT COMPLETE ==="
}

workflow_password() {
    local target="$1"
    local service="$2"
    
    log "=== WORKFLOW: PASSWORD ATTACK ==="
    
    log "Step 1: SSH Brute Force..."
    hydra -L /usr/share/wordlists/usernames.txt \
        -P /usr/share/wordlists/rockyou.txt \
        -s 22 "$target" ssh -t 4 -V \
        > "${WORKFLOWS_DIR}/hydra_ssh.txt" 2>&1
    
    log "Step 2: SMB Brute Force..."
    hydra -L /usr/share/wordlists/usernames.txt \
        -P /usr/share/wordlists/rockyou.txt \
        "$target" smb -t 4 -V \
        > "${WORKFLOWS_DIR}/hydra_smb.txt" 2>&1
    
    log "Step 3: HTTP Basic Auth..."
    hydra -L /usr/share/wordlists/usernames.txt \
        -P /usr/share/wordlists/rockyou.txt \
        "http-get://$target/" \
        > "${WORKFLOWS_DIR}/hydra_http.txt" 2>&1
    
    log "=== PASSWORD ATTACK COMPLETE ==="
}

workflow_full() {
    local target="$1"
    
    log "=== FULL PENTEST WORKFLOW ==="
    
    workflow_recon "$target"
    workflow_web "$target"
    workflow_exploit "$target" "80"
    workflow_password "$target" "ssh"
    
    log "=== FULL PENTEST COMPLETE ==="
    log "Results in: $WORKFLOWS_DIR/"
}

workflow_mixed() {
    local target="$1"
    
    log "=== MIXED TARGET RECON ==="
    
    log "Network scan..."
    nmap -sn -oX "${WORKFLOWS_DIR}/net_scan.xml" "$target" 2>/dev/null
    
    log "OS detection..."
    nmap -O -oA "${WORKFLOWS_DIR}/os_detect" "$target" 2>/dev/null
    
    log "Service version detection..."
    nmap -sV -oA "${WORKFLOWS_DIR}/service_versions" "$target" 2>/dev/null
    
    log "Default script scan..."
    nmap -sC -oA "${WORKFLOWS_DIR}/script_scan" "$target" 2>/dev/null
    
    log "Vuln detection..."
    nmap --script vuln -oA "${WORKFLOWS_DIR}/vuln_detect" "$target" 2>/dev/null
    
    log "=== MIXED SCAN COMPLETE ==="
}

workflow_quick() {
    local target="$1"
    
    log "=== QUICK SCAN ==="
    nmap -sn -T4 "$target" 2>/dev/null
    nmap -sV -F "$target" 2>/dev/null
    log "=== DONE ==="
}

run_parallel() {
    local cmd1="$1"
    local cmd2="$2"
    
    log "Running parallel: $cmd1 & $cmd2"
    
    ($cmd1 > "${WORKFLOWS_DIR}/parallel1.txt" 2>&1) &
    PID1=$!
    
    ($cmd2 > "${WORKFLOWS_DIR}/parallel2.txt" 2>&1) &
    PID2=$!
    
    wait $PID1
    wait $PID2
    
    log "Parallel tasks complete"
}

show_workflows() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║            AVAILABLE WORKFLOWS                      ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  recon <target>      - Whois, DNS, subdomains, port scan"
    echo "  web <target>       - Nikto, gobuster, sqlmap, whatweb"
    echo "  wifi [iface] [bssid] - Scan, capture handshake, crack"
    echo "  exploit <target> <port> - Vuln scan, exploit search"
    echo "  password <target> <service> - SSH, SMB, HTTP brute"
    echo "  full <target>      - All above in sequence"
    echo "  mixed <target>     - Nmap scripts, OS, vuln"
    echo "  quick <target>     - Fast scan"
    echo "  parallel <cmd1> <cmd2> - Run two commands together"
    echo ""
}

show_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          AUTOMATION HUB v1.0                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Recon Workflow       (OSINT + Port Scan)"
    echo "  ${GREEN}2)${NC} Web Test Workflow    (Full web audit)"
    echo "  ${GREEN}3)${NC} WiFi Audit Workflow  (Capture + Crack)"
    echo "  ${GREEN}4)${NC} Exploit Workflow     (Vuln + Exploits)"
    echo "  ${GREEN}5)${NC} Password Workflow    (Brute force)"
    echo "  ${GREEN}6)${NC} Full Pentest         (Complete workflow)"
    echo "  ${GREEN}7)${NC} Mixed Scan           (All nmap scripts)"
    echo "  ${GREEN}8)${NC} Quick Scan           (Fast discovery)"
    echo "  ${GREEN}9)${NC} Parallel Execution   (Two tools)"
    echo "  ${GREEN}L)${NC} List Workflows"
    echo "  ${GREEN}V)${NC} View Results"
    echo ""
    echo -e "  ${RED}q/Q)${NC} Quit"
    echo ""
}

main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1)
                read -p "Target: " target
                workflow_recon "$target"
                ;;
            2)
                read -p "Target: " target
                workflow_web "$target"
                ;;
            3)
                read -p "Interface [wlan0]: " iface
                read -p "BSSID (optional): " bssid
                workflow_wifi "${iface:-wlan0}" "$bssid"
                ;;
            4)
                read -p "Target: " target
                read -p "Service/Port: " svc
                workflow_exploit "$target" "$svc"
                ;;
            5)
                read -p "Target: " target
                read -p "Service: " svc
                workflow_password "$target" "$svc"
                ;;
            6)
                read -p "Target: " target
                workflow_full "$target"
                ;;
            7)
                read -p "Target: " target
                workflow_mixed "$target"
                ;;
            8)
                read -p "Target: " target
                workflow_quick "$target"
                ;;
            9)
                read -p "Command 1: " cmd1
                read -p "Command 2: " cmd2
                run_parallel "$cmd1" "$cmd2"
                ;;
            l|L) show_workflows ;;
            v|V) ls -la "$WORKFLOWS_DIR" ;;
            q|Q) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"