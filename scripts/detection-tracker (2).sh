#!/bin/bash
# ====================================================================
# DETECTION TRACKER - Track and Monitor Detection Events
# Tracks IDS/IPS alerts, WAF blocks, and security events
# ====================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KALI_SHARE="${SCRIPT_DIR}/.."
LOG_DIR="${KALI_SHARE}/logs/detection"
DB_FILE="${LOG_DIR}/detections.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; }

mkdir -p "$LOG_DIR"

init_db() {
    if [[ ! -f "$DB_FILE" ]]; then
        echo '{"detections":[],"stats":{"total":0,"high":0,"medium":0,"low":0}}' > "$DB_FILE"
    fi
}

add_detection() {
    local severity="$1"
    local tool="$2"
    local description="$3"
    local target="$4"
    local timestamp=$(date +%Y-%m-%d_%H:%M:%S)
    
    local id=$(date +%s)
    
    local detection="{\"id\":$id,\"timestamp\":\"$timestamp\",\"severity\":\"$severity\",\"tool\":\"$tool\",\"description\":\"$description\",\"target\":\"$target\"}"
    
    python3 -c "
import json
with open('$DB_FILE', 'r') as f:
    data = json.load(f)
data['detections'].append($detection)
data['stats']['total'] += 1
if '$severity' == 'high':
    data['stats']['high'] += 1
elif '$severity' == 'medium':
    data['stats']['medium'] += 1
else:
    data['stats']['low'] += 1
with open('$DB_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
    log "Detection logged: $severity - $tool"
}

show_stats() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          DETECTION STATISTICS                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    python3 -c "
import json
with open('$DB_FILE', 'r') as f:
    data = json.load(f)
stats = data['stats']
print(f'  ${GREEN}Total Detections:${NC} {stats[\"total\"]}')
print(f'  ${RED}High Severity:${NC}    {stats[\"high\"]}')
print(f'  ${YELLOW}Medium Severity:${NC}  {stats[\"medium\"]}')
print(f'  ${BLUE}Low Severity:${NC}     {stats[\"low\"]}')
"
    echo ""
}

show_detections() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          RECENT DETECTIONS                         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    python3 -c "
import json
with open('$DB_FILE', 'r') as f:
    data = json.load(f)
for d in data['detections'][-20:][::-1]:
    sev = d['severity']
    color = '${RED}' if sev == 'high' else '${YELLOW}' if sev == 'medium' else '${BLUE}'
    print(f'{color}[{sev.upper()}]{NC} {d[\"timestamp\"]}')
    print(f'  Tool: {d[\"tool\"]} | Target: {d[\"target\"]}')
    print(f'  {d[\"description\"]}')
    print('')
"
}

track_nmap() {
    local target="$1"
    log "Tracking Nmap scan on $target..."
    echo "Starting Nmap scan..." | tee /tmp/nmap_track.log
    nmap -sV "$target" 2>&1 | tee /tmp/nmap_track.log
    
    if grep -q "reset" /tmp/nmap_track.log 2>/dev/null; then
        add_detection "medium" "nmap" "Potential reset detected" "$target"
    fi
    if grep -q "blocked" /tmp/nmap_track.log 2>/dev/null; then
        add_detection "high" "nmap" "Connection blocked" "$target"
    fi
}

track_wifi() {
    local interface="${1:-wlan0mon}"
    log "Monitoring WiFi on $interface..."
    
    timeout 30 airodump-ng "$interface" > /tmp/wifi_scan.log 2>&1 &
    PID=$!
    
    while kill -0 $PID 2>/dev/null; do
        if grep -q "handshake" /tmp/wifi_scan.log 2>/dev/null; then
            add_detection "low" "airodump" "Handshake captured" "$interface"
        fi
        sleep 2
    done
    
    add_detection "low" "airodump" "WiFi scan completed" "$interface"
}

track_web() {
    local target="$1"
    log "Tracking web scan on $target..."
    
    nikto -h "$target" 2>&1 | tee /tmp/nikto_track.log &
    PID=$!
    
    while kill -0 $PID 2>/dev/null; do
        if grep -q "403\|401\|419" /tmp/nikto_track.log 2>/dev/null; then
            add_detection "medium" "nikto" "Access denied detected" "$target"
        fi
        if grep -q "WAF" /tmp/nikto_track.log 2>/dev/null; then
            add_detection "high" "nikto" "WAF detected" "$target"
        fi
        sleep 3
    done
    
    log "Web scan completed"
}

track_password() {
    local target="$1"
    local service="$2"
    log "Tracking password attack on $target/$service..."
    
    add_detection "high" "hydra" "Password attack started" "$target/$service"
    
    hydra -L /usr/share/wordlists/usernames.txt -P /usr/share/wordlists/rockyou.txt "$target" "$service" 2>&1 | tee /tmp/hydra_track.log
    
    if grep -q "1 of 1 valid" /tmp/hydra_track.log 2>/dev/null; then
        add_detection "high" "hydra" "Password found!" "$target/$service"
    else
        add_detection "low" "hydra" "Attack completed - no success" "$target/$service"
    fi
}

clear_detections() {
    echo '{"detections":[],"stats":{"total":0,"high":0,"medium":0,"low":0}}' > "$DB_FILE"
    log "Detection database cleared"
}

export_csv() {
    local csv_file="${LOG_DIR}/detections_$(date +%Y%m%d).csv"
    python3 -c "
import json
import csv
with open('$DB_FILE', 'r') as f:
    data = json.load(f)
with open('$csv_file', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['ID','Timestamp','Severity','Tool','Description','Target'])
    for d in data['detections']:
        writer.writerow([d['id'], d['timestamp'], d['severity'], d['tool'], d['description'], d['target']])
"
    log "Exported to $csv_file"
}

show_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         DETECTION TRACKER v1.0                       ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} View Statistics"
    echo "  ${GREEN}2)${NC} View Recent Detections"
    echo "  ${GREEN}3)${NC} Track Nmap Scan"
    echo "  ${GREEN}4)${NC} Track WiFi Audit"
    echo "  ${GREEN}5)${NC} Track Web Scan"
    echo "  ${GREEN}6)${NC} Track Password Attack"
    echo "  ${GREEN}7)${NC} Add Manual Detection"
    echo "  ${GREEN}8)${NC} Export to CSV"
    echo "  ${GREEN}9)${NC} Clear All Detections"
    echo ""
    echo -e "  ${RED}q/Q)${NC} Quit"
    echo ""
}

main() {
    init_db
    
    while true; do
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1) show_stats ;;
            2) show_detections ;;
            3) read -p "Enter target IP: " target; track_nmap "$target" ;;
            4) read -p "Enter interface [wlan0mon]: " iface; track_wifi "${iface:-wlan0mon}" ;;
            5) read -p "Enter target URL: " target; track_web "$target" ;;
            6) read -p "Enter target: " target; read -p "Enter service (ssh/ftp/http): " svc; track_password "$target" "$svc" ;;
            7) 
                read -p "Severity [high/medium/low]: " sev
                read -p "Tool name: " tool
                read -p "Description: " desc
                read -p "Target: " tgt
                add_detection "$sev" "$tool" "$desc" "$tgt"
                ;;
            8) export_csv ;;
            9) clear_detections ;;
            q|Q) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"