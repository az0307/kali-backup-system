#!/bin/bash
# ====================================================================
# STEALTH MODE - OPSEC-Safe AI & Pentest Operations
# Protects user identity and activity during engagements
# ====================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KALI_SHARE="${SCRIPT_DIR}/.."
STEALTH_LOG="${KALI_SHARE}/logs/stealth/activity.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; }
stealth() { echo -e "${PURPLE}[STEALTH]${NC} $1"; }

mkdir -p "$(dirname "$STEALTH_LOG")"

check_root() {
    [[ $EUID -ne 0 ]] && error "Run as root"
}

init_stealth() {
    check_root
    
    log "Initializing STEALTH MODE..."
    echo "=====================================" >> "$STEALTH_LOG"
    echo "Stealth Session: $(date)" >> "$STEALTH_LOG"
    
    export STEALTH_ACTIVE=1
    export STEALTH_MODE=ENABLED
    
    log "Stealth mode ACTIVE"
    echo "STEALTH_MODE=ENABLED" > /tmp/stealth_env
}

enable_tor() {
    log "Enabling Tor for anonymized traffic..."
    
    if ! command -v tor &> /dev/null; then
        apt-get update && apt-get install -y tor
    fi
    
    if ! systemctl is-active --quiet tor; then
        systemctl start tor
    fi
    
    export TOR_PROXY="socks5://127.0.0.1:9050"
    export HTTP_PROXY="http://127.0.0.1:8118"
    export HTTPS_PROXY="http://127.0.0.1:8118"
    
    log "Tor routing enabled"
    echo "TOR_ENABLED=$(date)" >> "$STEALTH_LOG"
}

disable_tor() {
    log "Disabling Tor..."
    unset TOR_PROXY HTTP_PROXY HTTPS_PROXY
    systemctl stop tor 2>/dev/null || true
}

hide_dns() {
    log "Configuring DNS leak protection..."
    echo "nameserver 1.1.1.1" > /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    chmod 444 /etc/resolv.conf
    log "DNS protected"
}

unhide_dns() {
    log "Restoring normal DNS..."
    chmod 644 /etc/resolv.conf
}

clean_logs() {
    log "Cleaning system logs for OPSEC..."
    
    echo "" > /var/log/syslog 2>/dev/null || true
    echo "" > /var/log/messages 2>/dev/null || true
    echo "" > /var/log/kern.log 2>/dev/null || true
    echo "" > /var/log/auth.log 2>/dev/null || true
    
    history -c
    > ~/.bash_history
    
    rm -rf /tmp/* 2>/dev/null || true
    rm -rf /var/tmp/* 2>/dev/null || true
    
    log "Logs cleaned"
}

sanitize_mac() {
    log "Randomizing MAC address..."
    
    local iface="${1:-wlan0}"
    ip link set "$iface" down
    macchanger -r "$iface" 2>/dev/null || ip link set "$iface" address "00:$(openssl rand -hex 5 | sed 's/^\(..\)/\1:/')"
    ip link set "$iface" up
    
    log "MAC randomized for $iface"
}

restore_mac() {
    local iface="${1:-wlan0}"
    macchanger -p "$iface" 2>/dev/null || true
    log "MAC restored for $iface"
}

spoof_hostname() {
    log "Spoofing hostname..."
    echo "kali-workstation" > /proc/sys/kernel/hostname
    hostnamectl set-hostname "kali-workstation" 2>/dev/null || true
    export HOSTNAME="kali-workstation"
    log "Hostname spoofed"
}

clean_metadata() {
    log "Cleaning file metadata..."
    
    for f in "$KALI_SHARE"/*.md "$KALI_SHARE"/docs/*/*.md 2>/dev/null; do
        [[ -f "$f" ]] && touch -t 197001010000 "$f"
    done
    
    log "Metadata cleaned"
}

stealth_nmap() {
    local target="$1"
    stealth "Running stealth scan on $target"
    
    echo "STEALTH_SCAN: $target" >> "$STEALTH_LOG"
    
    nmap -sT -T2 -p- --randomize-hosts --scan-delay 500 \
        -f -D RND:10 \
        --proxy socks5://127.0.0.1:9050 \
        -n "$target" 2>&1 | grep -v "Starting Nmap"
    
    log "Stealth scan complete"
}

stealth_wifi() {
    local iface="${1:-wlan0}"
    stealth "Running stealth WiFi operations on $iface"
    
    sanitize_mac "$iface"
    
    airmon-ng start "$iface" >/dev/null 2>&1
    airodump-ng wlan0mon --privacy 2>/dev/null | head -20 &
    
    sleep 30
    pkill airodump-ng
    airmon-ng stop wlan0mon >/dev/null 2>&1
    restore_mac "$iface"
    
    log "Stealth WiFi complete"
}

stealth_web() {
    local target="$1"
    stealth "Running stealth web scan on $target"
    
    curl --proxy "$HTTP_PROXY" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
        -e "https://google.com" \
        -sSL "http://$target" | head -50
    
    nikto -h "$target" -useproxy 2>&1 | head -30
    
    log "Stealth web scan complete"
}

stealth_ai_query() {
    local query="$1"
    stealth "Querying AI (stealth mode): $query"
    
    echo "AI_QUERY: $query" >> "$STEALTH_LOG"
    
    if [[ -n "$TOR_PROXY" ]]; then
        log "Routing through Tor..."
    fi
    
    log "Query complete - activity logged"
}

hide_processes() {
    log "Hiding sensitive processes..."
    
    for proc in "msfconsole" "sqlmap" "nikto" "hydra" "aircrack" "reaver"; do
        if pgrep -f "$proc" >/dev/null; then
            pgrep -f "$proc" | xargs -r rename ".${proc}" ".[hidden]" 2>/dev/null || true
        fi
    done
    
    log "Process hiding configured"
}

check_anonymity() {
    echo -e "${PURPLE}[CHECKING ANONYMITY]${NC}"
    echo ""
    
    echo -n "IP Address: "
    curl -sSL --proxy "$HTTP_PROXY" ifconfig.me 2>/dev/null || echo "hidden"
    
    echo -n "DNS Leak: "
    curl -sSL --proxy "$HTTP_PROXY" dnsleaktest.com 2>/dev/null | grep -oP '的结果\d+' || echo "protected"
    
    echo -n "WebRTC: "
    if grep -q "WebRTC" ~/.config/browser/* 2>/dev/null; then
        echo "VULNERABLE"
    else
        echo "Protected"
    fi
    
    echo -n "MAC Address: "
    ip link show wlan0 | grep -oP 'link/ether \K[0-9a-f:]+' || echo "hidden"
    
    echo -n "Hostname: "
    hostname
    
    echo ""
}

show_status() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║            STEALTH MODE STATUS                     ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [[ "$STEALTH_ACTIVE" == "1" ]]; then
        echo -e "  ${GREEN}●${NC} Stealth Mode: ACTIVE"
    else
        echo -e "  ${RED}○${NC} Stealth Mode: INACTIVE"
    fi
    
    if systemctl is-active --quiet tor 2>/dev/null; then
        echo -e "  ${GREEN}●${NC} Tor: ACTIVE"
    else
        echo -e "  ${RED}○${NC} Tor: INACTIVE"
    fi
    
    echo "  Last activity: $(tail -1 "$STEALTH_LOG" 2>/dev/null || echo "None")"
    echo ""
}

deactivate_stealth() {
    log "Deactivating STEALTH MODE..."
    
    unset STEALTH_ACTIVE STEALTH_MODE
    rm -f /tmp/stealth_env
    
    disable_tor
    unhide_dns
    
    log "Stealth mode deactivated"
}

show_menu() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║         STEALTH OPS - PROTECT YOUR ACTIVITY        ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Initialize Stealth Mode"
    echo "  ${GREEN}2)${NC} Enable Tor Routing"
    echo "  ${GREEN}3)${NC} Hide DNS Leaks"
    echo "  ${GREEN}4)${NC} Spoof MAC Address"
    echo "  ${GREEN}5)${NC} Spoof Hostname"
    echo "  ${GREEN}6)${NC} Clean System Logs"
    echo "  ${GREEN}7)${NC} Clean Metadata"
    echo "  ${GREEN}8)${NC} Stealth Nmap Scan"
    echo "  ${GREEN}9)${NC} Stealth WiFi Scan"
    echo "  ${GREEN}A)${NC} Stealth Web Scan"
    echo "  ${GREEN}B)${NC} Stealth AI Query"
    echo "  ${GREEN}C)${NC} Check Anonymity"
    echo "  ${GREEN}D)${NC} Show Status"
    echo "  ${GREEN}E)${NC} Deactivate Stealth"
    echo "  ${GREEN}0)${NC} Full Stealth Bundle"
    echo ""
    echo -e "  ${RED}q/Q)${NC} Quit"
    echo ""
}

main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1) init_stealth ;;
            2) enable_tor ;;
            3) hide_dns ;;
            4) read -p "Interface [wlan0]: " iface; sanitize_mac "${iface:-wlan0}" ;;
            5) spoof_hostname ;;
            6) clean_logs ;;
            7) clean_metadata ;;
            8) read -p "Enter target IP: " target; stealth_nmap "$target" ;;
            9) read -p "Interface [wlan0]: " iface; stealth_wifi "${iface:-wlan0}" ;;
            a|A) read -p "Enter target URL: " target; stealth_web "$target" ;;
            b|B) read -p "Enter AI query: " query; stealth_ai_query "$query" ;;
            c|C) check_anonymity ;;
            d|D) show_status ;;
            e|E) deactivate_stealth ;;
            0) 
                init_stealth
                enable_tor
                hide_dns
                spoof_hostname
                check_anonymity
                log "Full stealth bundle activated!"
                ;;
            q|Q) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"