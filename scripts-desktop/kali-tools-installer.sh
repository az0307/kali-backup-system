#!/bin/bash
# ============================================================
# KALI TOOLS INSTALLER MENU
# Kali Live USB - Main Installer
# ============================================================
# This script provides a menu to install various tools
# and packages for Kali Linux
# ============================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
   echo -e "${RED}This script must be run as root${NC}"
   echo "Please run with sudo: sudo $0"
   exit 1
fi

# Main menu
while true; do
    clear
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE}  KALI TOOLS INSTALLER MENU${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo ""
    echo -e "${GREEN}1${NC}) ${YELLOW}Core System Updates${NC}        - Update apt, upgrade system"
    echo -e "${GREEN}2${NC}) ${YELLOW}Pentesting Tools${NC}           - Nmap, Metasploit, Burp Suite, etc"
    echo -e "${GREEN}3${NC}) ${YELLOW}Wireless Tools${NC}            - Aircrack, Reaver, Wifite, Wash"
    echo -e "${GREEN}4${NC}) ${YELLOW}Web Assessment${NC}            - Nikto, SQLMap, Gobuster, Dirb"
    echo -e "${GREEN}5${NC}) ${YELLOW}Password Tools${NC}            - John, Hashcat, Hydra, CeWL"
    echo -e "${GREEN}6${NC}) ${YELLOW}Exploitation${NC}            - Metasploit, Searchsploit, MSFC"
    echo -e "${GREEN}7${NC}) ${YELLOW}Forensics${NC}                - Autopsy, Binwalk, Foremost, Volatility"
    echo -e "${GREEN}8${NC}) ${YELLOW}Reverse Engineering${NC}      - Ghidra, IDA (free), Radare2"
    echo -e "${GREEN}9${NC}) ${YELLOW}Sniffing & Spoofing${NC}      - Wireshark, Ettercap, Bettercap"
    echo -e "${GREEN}10${NC}) ${YELLOW}Information Gathering${NC}     - Recon-ng, TheHarvester, Maltego"
    echo -e "${GREEN}11${NC}) ${YELLOW}Post Exploitation${NC}        - Mimikatz, PowerSploit, Empire"
    echo -e "${GREEN}12${NC}) ${YELLOW}Social Engineering${NC}       - SET, Gophish, King Phisher"
    echo -e "${GREEN}13${NC}) ${YELLOW}Reporting Tools${NC}           - Pipal, Dradis, Faraday"
    echo -e "${GREEN}14${NC}) ${YELLOW}AI Tools (OpenCode)${NC}       - Install OpenCode CLI for AI assistance"
    echo -e "${GREEN}15${NC}) ${YELLOW}Python & Dev Tools${NC}        - Python, pip, Git, Docker"
    echo -e "${GREEN}16${NC}) ${YELLOW}Wordlists & Resources${NC}    - SecLists, RockYou, password lists"
    echo -e "${GREEN}A${NC}) ${YELLOW}Install ALL Tools${NC}          - Install everything (takes long time)"
    echo -e "${GREEN}S${NC}) ${YELLOW}Quick Setup${NC}               - Common tools for most pentests"
    echo -e "${GREEN}R${NC}) ${YELLOW}Remove Tools${NC}               - Remove installed tools"
    echo -e "${GREEN}H${NC}) ${YELLOW}Hardware & Drivers${NC}          - WiFi adapters, GPU drivers"
    echo ""
    echo -e "${RED}0${NC}) ${YELLOW}Exit${NC}"
    echo ""
    echo -e "${BLUE}====================================================${NC}"
    echo -n "Select option: "
    read choice

    case $choice in
        1) # Core System Updates
            echo -e "${YELLOW}Installing system updates...${NC}"
            apt update && apt upgrade -y
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        2) # Pentesting Tools
            echo -e "${YELLOW}Installing pentesting tools...${NC}"
            apt install -y nmap zenmap metasploit-framework burpsuite openvas nikto
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        3) # Wireless Tools
            echo -e "${YELLOW}Installing wireless tools...${NC}"
            apt install -y aircrack-ng reaver wifite wash bully fern-wifi-cracker
            echo "NOTE: For monitor mode, use: airmon-ng start wlan0"
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        4) # Web Assessment
            echo -e "${YELLOW}Installing web assessment tools...${NC}"
            apt install -y nikto sqlmap gobuster dirb wpscan davtest jq
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        5) # Password Tools
            echo -e "${YELLOW}Installing password tools...${NC}"
            apt install -y john hashcat hydra cewl crunch wordlists
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        6) # Exploitation
            echo -e "${YELLOW}Installing exploitation tools...${NC}"
            apt install -y metasploit-framework searchsploit msfvenom exploitdb
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        7) # Forensics
            echo -e "${YELLOW}Installing forensics tools...${NC}"
            apt install -y autopsy binwalk foremost volatility sleuthkit
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        8) # Reverse Engineering
            echo -e "${YELLOW}Installing reverse engineering tools...${NC}"
            apt install -y ghidra radare2 IDA-freeware binutils objdump
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        9) # Sniffing & Spoofing
            echo -e "${YELLOW}Installing sniffing & spoofing tools...${NC}"
            apt install -y wireshark ettercap-graphical bettercap dsniff sslstrip
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        10) # Information Gathering
            echo -e "${YELLOW}Installing information gathering tools...${NC}"
            apt install -y recon-ng theharvester maltegoce spiderfoot masscan
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        11) # Post Exploitation
            echo -e "${YELLOW}Installing post exploitation tools...${NC}"
            apt install -y mimikatz powersploit
            echo -e "${GREEN}Note: Some tools require manual download${NC}"
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        12) # Social Engineering
            echo -e "${YELLOW}Installing social engineering tools...${NC}"
            apt install -y setoolkit gophish
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        13) # Reporting Tools
            echo -e "${YELLOW}Installing reporting tools...${NC}"
            apt install -y pipal dradisce
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        14) # OpenCode AI Tools
            echo -e "${YELLOW}Installing OpenCode CLI (AI Assistant)...${NC}"
            # Install Bun
            curl -fsSL https://bun.sh/install | bash
            export BUN_INSTALL="$HOME/.bun"
            export PATH="$BUN_INSTALL/bin:$PATH"
            # Install OpenCode
            npm install -g opencode-ai
            echo -e "${GREEN}OpenCode installed!${NC}"
            echo "Run with: opencode"
            read -p "Press Enter to continue..."
            ;;
        15) # Python & Dev Tools
            echo -e "${YELLOW}Installing Python & development tools...${NC}"
            apt install -y python3 python3-pip python3-venv git curl wget vim nano
            pip3 install pipenv virtualenv
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        16) # Wordlists
            echo -e "${YELLOW}Installing wordlists & resources...${NC}"
            apt install -y seclists wordlists rockyou
            # Also get additional wordlists
            cd /usr/share/wordlists
            wget -q https://github.com/danielmiessler/SecLists/archive/master.zip -O seclists.zip
            unzip -o seclists.zip
            echo -e "${GREEN}Done!${NC}"
            read -p "Press Enter to continue..."
            ;;
        A|a) # Install ALL
            echo -e "${YELLOW}Installing ALL tools (this will take a LONG time)...${NC}"
            read -p "Are you sure? (y/n): " confirm
            if [ "$confirm" = "y" ]; then
                apt update && apt upgrade -y
                apt install -y kali-linux-all
                echo -e "${GREEN}ALL tools installed!${NC}"
            fi
            read -p "Press Enter to continue..."
            ;;
        S|s) # Quick Setup
            echo -e "${YELLOW}Installing common pentest tools...${NC}"
            apt update && apt upgrade -y
            apt install -y nmap metasploit-framework searchsploit aircrack-ng reaver
            apt install -y nikto sqlmap gobuster hydra john hashcat
            apt install -y wireshark ettercap-graphical bettercap
            apt install -y python3 python3-pip git curl wget
            echo -e "${GREEN}Quick setup complete!${NC}"
            read -p "Press Enter to continue..."
            ;;
        R|r) # Remove Tools
            echo -e "${YELLOW}Removing tools is not recommended.${NC}"
            echo "Use: apt remove <package-name>"
            read -p "Press Enter to continue..."
            ;;
        H|h) # Hardware & Drivers
            echo -e "${YELLOW}Checking hardware & drivers...${NC}"
            echo ""
            echo "=== Network Interfaces ==="
            ip link show
            echo ""
            echo "=== Wireless Interfaces ==="
            iwconfig 2>/dev/null || echo "No wireless interfaces"
            echo ""
            echo "=== USB Devices ==="
            lsusb
            echo ""
            echo "=== WiFi Adapter Setup ==="
            echo "To enable monitor mode:"
            echo "  airmon-ng start wlan0"
            echo ""
            echo "To check if adapter supports monitor mode:"
            echo "  iw list | grep -i monitor"
            read -p "Press Enter to continue..."
            ;;
        0) # Exit
            echo -e "${GREEN}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
