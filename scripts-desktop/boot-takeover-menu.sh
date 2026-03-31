#!/bin/bash
# ============================================================
# KALI LIVE USB - COMPREHENSIVE BOOT & TAKEOVER TOOLKIT
# ============================================================
# This is the MAIN MENU for all boot & takeover operations
# Run: sudo ./boot-takeover-menu.sh
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
   echo -e "${RED}Run with sudo: sudo $0${NC}"
   exit 1
fi

while true; do
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       KALI LIVE USB - BOOT & TAKEOVER TOOLKIT        ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}━━━ SYSTEM ACCESS ━━━${NC}"
    echo -e " ${GREEN}1${NC}) Windows Password Reset     - Reset/admin bypass Windows passwords"
    echo -e " ${GREEN}2${NC}) Linux Password Reset       - Reset root password on Linux systems"
    echo -e " ${GREEN}3${NC}) SAM Database Viewer       - View Windows user accounts"
    echo -e " ${GREEN}4${NC}) LUKS Encryption Cracker  - Attempt LUKS password recovery"
    echo ""
    echo -e "${CYAN}━━━ NETWORK ACCESS ━━━${NC}"
    echo -e " ${GREEN}5${NC}) Network Scanner          - Quick nmap network discovery"
    echo -e " ${GREEN}6${NC}) WiFi Password Recovery    - Find saved WiFi passwords"
    echo -e " ${GREEN}7${NC}) Responder/LLMNR          - Intercept network credentials"
    echo -e " ${GREEN}8${NC}) HTTP Server              - Start Python/Apache for file serving"
    echo ""
    echo -e "${CYAN}━━━ WIRELESS ATTACKS ━━━${NC}"
    echo -e " ${GREEN}9${NC}) WiFi Scanner            - Find nearby wireless networks"
    echo -e " ${GREEN}10${NC}) Handshake Capture        - Capture WPA handshakes"
    echo -e " ${GREEN}11${NC}) WPS Attack              - WPS PIN attacks with Reaver"
    echo -e " ${GREEN}12${NC}) Evil Twin              - Create fake AP"
    echo ""
    echo -e "${CYAN}━━━ PASSWORD ATTACKS ━━━${NC}"
    echo -e " ${GREEN}13${NC}) Hash Dumping            - Mimikatz, pwdump, secretsdump"
    echo -e " ${GREEN}14${NC}) Hash Cracking           - Hashcat, John the Ripper"
    echo -e " ${GREEN}15${NC}) Rainbow Tables         - Precomputed hash lookup"
    echo -e " ${GREEN}16${NC}) Password Spraying      - Try common passwords across accounts"
    echo ""
    echo -e "${CYAN}━━━ EXPLOITATION ━━━${NC}"
    echo -e " ${GREEN}17${NC}) Metasploit Framework   - Start MSF console"
    echo -e " ${GREEN}18${NC}) Exploit Search         - Searchsploit database"
    echo -e " ${GREEN}19${NC}) Reverse Shell Generator - Create bind/reverse shells"
    echo -e " ${GREEN}20${NC}) Payload Encoder         - MSFVenom encoding"
    echo ""
    echo -e "${CYAN}━━━ POST-EXPLOITATION ━━━${NC}"
    echo -e " ${GREEN}21${NC}) Persistence              - Create backdoor/persistence"
    echo -e " ${GREEN}22${NC}) Privilege Escalation   - Linux/Windows privesc tools"
    echo -e " ${GREEN}23${NC}) Credential Harvesting   - Keylogging, clipboard, memory"
    echo -e " ${GREEN}24${NC}) Lateral Movement       - PsExec, WMI, Impacket"
    echo ""
    echo -e "${CYAN}━━━ FORENSICS & RECOVERY ━━━${NC}"
    echo -e " ${GREEN}25${NC}) File Recovery           - Recover deleted files"
    echo -e " ${GREEN}26${NC}) Memory Dump            - Dump RAM for analysis"
    echo -e " ${GREEN}27${NC}) Disk Imaging           - Create forensic disk image"
    echo -e " ${GREEN}28${NC}) Registry Viewer        - Windows registry analysis"
    echo ""
    echo -e "${CYAN}━━━ SYSTEM INFO & UTILS ━━━${NC}"
    echo -e " ${GREEN}29${NC}) System Info            - Hardware, OS, network details"
    echo -e " ${GREEN}30${NC}) Hardware Detection      - USB, GPU, wireless adapters"
    echo -e " ${GREEN}31${NC}) Driver Installer       - Install WiFi/GPU drivers"
    echo -e " ${GREEN}32${NC}) Package Manager         - Install additional tools"
    echo ""
    echo -e "${CYAN}━━━ AI TOOLS ━━━${NC}"
    echo -e " ${GREEN}33${NC}) Install OpenCode        - AI assistant for pentesting"
    echo -e " ${GREEN}34${NC}) Install Claude Code     - Another AI assistant"
    echo ""
    echo -e "${CYAN}━━━ QUICK ACTIONS ━━━${NC}"
    echo -e " ${GREEN}A${NC}) Auto-Pentest Mode       - Run automated reconnaissance"
    echo -e " ${GREEN}W${NC}) WiFi Audit Mode         - Wireless assessment"
    echo -e " ${GREEN}M${NC}) Monitor Mode Setup      - Enable monitor mode"
    echo -e " ${GREEN}S${NC}) Start Services          - Start SSH, HTTP, etc"
    echo ""
    echo -e "${CYAN}━━━ REFERENCE ━━━${NC}"
    echo -e " ${GREEN}R${NC}) Read Saved Credentials   - WiFi passwords, etc"
    echo -e " ${GREEN}H${NC}) Commands Reference      - Quick command reference"
    echo -e " ${GREEN}N${NC}) Network Info           - Current network status"
    echo ""
    echo -e "${RED}0${NC}) Exit"
    echo ""
    echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
    echo -n "Select: "
    read choice

    case $choice in
        1) bash /scripts-desktop/windows-password-reset.sh ;;
        2) bash /scripts-desktop/linux-password-reset.sh ;;
        3) bash /scripts-desktop/sam-viewer.sh ;;
        4) echo "Coming soon..." ;;
        5) bash /scripts-desktop/network-scan.sh ;;
        6) bash /scripts-desktop/wifi-recovery.sh ;;
        7) bash /scripts-desktop/responder.sh ;;
        8) bash /scripts-desktop/http-server.sh ;;
        9) bash /scripts-desktop/wifi-scanner.sh ;;
        10) bash /scripts-desktop/handshake-capture.sh ;;
        11) bash /scripts-desktop/wps-attack.sh ;;
        12) bash /scripts-desktop/evil-twin.sh ;;
        13) bash /scripts-desktop/hash-dump.sh ;;
        14) bash /scripts-desktop/hash-crack.sh ;;
        15) echo "Rainbow tables - use CrackStation or online tools" ;;
        16) bash /scripts-desktop/password-spray.sh ;;
        17) echo "Starting Metasploit..."; msfconsole ;;
        18) searchsploit ;;
        19) bash /scripts-desktop/shell-generator.sh ;;
        20) echo "Run: msfvenom -l encoders" ;;
        21) bash /scripts-desktop/persistence.sh ;;
        22) bash /scripts-desktop/privesc.sh ;;
        23) bash /scripts-desktop/credential-harvest.sh ;;
        24) bash /scripts-desktop/lateral-movement.sh ;;
        25) bash /scripts-desktop/file-recovery.sh ;;
        26) bash /scripts-desktop/memory-dump.sh ;;
        27) bash /scripts-desktop/disk-imaging.sh ;;
        28) bash /scripts-desktop/registry-viewer.sh ;;
        29) bash /scripts-desktop/system-info.sh ;;
        30) bash /scripts-desktop/hardware-detect.sh ;;
        31) bash /scripts-desktop/driver-install.sh ;;
        32) bash /scripts-desktop/kali-tools-installer.sh ;;
        33) bash /scripts-desktop/install-opencode.sh ;;
        34) echo "Install Claude Code from claude.ai/downloads" ;;
        A|a) bash /scripts-desktop/auto-pentest.sh ;;
        W|w) bash /scripts-desktop/wifi-audit.sh ;;
        M|m) airmon-ng start wlan0; iwconfig ;;
        S|s) systemctl start ssh; systemctl start apache2; echo "Services started" ;;
        R|r) cat /wifi-passwords/NETWORK-CREDENTIALS.txt ;;
        H|h) cat /scripts-desktop/QUICK-REF.txt ;;
        N|n) echo "=== Network Status ==="; ip addr; echo "=== Routes ==="; ip route; echo "=== DNS ==="; cat /etc/resolv.conf ;;
        0) exit 0 ;;
        *) echo "Invalid"; read ;;
    esac
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
done
