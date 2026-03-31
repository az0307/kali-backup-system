#!/bin/bash
# ====================================================================
# ESSENTIAL TOOLS - Install Must-Have Pentest Tools
# ====================================================================

set -euo pipefail

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

install_network_tools() {
    log "Installing network tools..."
    apt-get update
    apt-get install -y nmap masscan netdiscover tcpdump wireshark hping3 socat netcat-openbsd
    log "Network tools installed"
}

install_wifi_tools() {
    log "Installing WiFi tools..."
    apt-get install -y aircrack-ng reaver wifite wpasupplicant hostapd mdk3 bully
    log "WiFi tools installed"
}

install_web_tools() {
    log "Installing web tools..."
    apt-get install -y nikto sqlmap gobuster dirb whatweb wpscan curl wget
    apt-get install -y python3-pip
    pip3 install --no-input dirsearch
    log "Web tools installed"
}

install_password_tools() {
    log "Installing password tools..."
    apt-get install -y hashcat john hydra medusa crowbar
    log "Password tools installed"
}

install_exploit_tools() {
    log "Installing exploit tools..."
    apt-get install -y metasploit-framework searchsploit exploitdb
    log "Exploit tools installed"
}

install_recon_tools() {
    log "Installing recon tools..."
    apt-get install -y whois dnsenum dnsmap theHarvester sublist3r
    pip3 install --no-input subfinder
    log "Recon tools installed"
}

install_ai_tools() {
    log "Installing AI tools..."
    pip3 install --no-input openai anthropic google-generativeai
    
    if ! command -v ollama &> /dev/null; then
        curl -fsSL https://ollama.com/install.sh | sh
    fi
    
    log "AI tools installed"
}

install_productivity() {
    log "Installing productivity tools..."
    apt-get install -y tmux vim git curl wget rsync tree htop bpytop
    log "Productivity tools installed"
}

install_all() {
    check_root
    log "Installing all essential tools..."
    
    install_productivity
    install_network_tools
    install_wifi_tools
    install_web_tools
    install_password_tools
    install_exploit_tools
    install_recon_tools
    install_ai_tools
    
    log "All essential tools installed!"
    log "Quick commands: ./cli/go validate"
}

show_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       ESSENTIAL TOOLS INSTALLER v1.0                ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  ${GREEN}1)${NC} Install ALL tools"
    echo "  ${GREEN}2)${NC} Network Tools       (nmap, masscan, wireshark)"
    echo "  ${GREEN}3)${NC} WiFi Tools          (aircrack-ng, reaver, wifite)"
    echo "  ${GREEN}4)${NC} Web Tools           (nikto, sqlmap, gobuster)"
    echo "  ${GREEN}5)${NC} Password Tools      (hashcat, john, hydra)"
    echo "  ${GREEN}6)${NC} Exploit Tools       (metasploit, searchsploit)"
    echo "  ${GREEN}7)${NC} Recon Tools         (whois, dnsenum, subfinder)"
    echo "  ${GREEN}8)${NC} AI Tools            (OpenAI, Ollama)"
    echo "  ${GREEN}9)${NC} Productivity       (tmux, vim, git, htop)"
    echo "  ${GREEN}0)${NC} Validate installed tools"
    echo ""
    echo -e "  ${RED}q/Q)${NC} Quit"
    echo ""
}

main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1) install_all ;;
            2) check_root; install_network_tools ;;
            3) check_root; install_wifi_tools ;;
            4) check_root; install_web_tools ;;
            5) check_root; install_password_tools ;;
            6) check_root; install_exploit_tools ;;
            7) check_root; install_recon_tools ;;
            8) check_root; install_ai_tools ;;
            9) check_root; install_productivity ;;
            0) log "Checking tools..."; which nmap masscan aircrack-ng nikto sqlmap hashcat john msfconsole searchsploit 2>/dev/null || warn "Some tools missing" ;;
            q|Q) log "Goodbye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"