#!/bin/bash

################################################################################
#                                                                              #
#    ███████╗███████╗ ██████╗ ███████╗██╗   ██╗██╗  ██╗ ██████╗              #
#    ██╔════╝██╔════╝██╔════╝██╔════╝██║   ██║██║  ██║██╔═══██╗             #
#    █████╗  ███████╗██║  ███╗█████╗  ██║   ██║███████║██║   ██║             #
#    ██╔══╝  ╚════██║██║   ██║██╔══╝  ██║   ██║██╔══██║██║   ██║             #
#    ███████╗███████║╚██████╔╝███████╗╚██████╔╝██║  ██║╚██████╔╝             #
#    ╚══════╝╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝              #
#                                                                              #
#              🏠 HOME LAB MULTI-DEVICE ORCHESTRATION v1.0                  #
#                                                                              #
#     Integrates: Windows Host + Kali VM + XP Laptop + OPPO Phone            #
#                 + Huawei Hotspot + TP-Link WiFi Adapter                     #
#                                                                              #
################################################################################

set -euo pipefail

# ==============================================================================
# COLORS & CONFIG
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Device configurations
declare -A DEVICES=(
    ["windows-host"]="192.168.1.100"
    ["kali-vm"]="192.168.1.50"
    ["xp-laptop"]="192.168.1.75"
    ["oppo-phone"]="192.168.1.100"
    ["huawei-hotspot"]="192.168.1.1"
)

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

log() { echo -e "$*"; }
log_header() { echo -e "\n${CYAN}════════════════════════════════════════════════════════════\n  $*\n════════════════════════════════════════════════════════════${NC}\n"; }
log_success() { echo -e "${GREEN}  ✓ $*${NC}"; }
log_error() { echo -e "${RED}  ✗ $*${NC}" >&2; }
log_info() { echo -e "${BLUE}  ◆ $*${NC}"; }
log_warn() { echo -e "${YELLOW}  ⚠ $*${NC}"; }

# Check command
cmd_exists() { command -v "$1" >/dev/null 2>&1; }

# Ping check
ping_check() {
    local host=$1
    local timeout=$2
    timeout "$timeout" ping -c 1 "$host" >/dev/null 2>&1
}

# ==============================================================================
# DISCOVERY
# ==============================================================================

discover_network() {
    log_header "🌐 NETWORK DISCOVERY"
    
    log_info "Scanning network for devices..."
    
    local found=()
    
    # Scan local subnet
    for ip in 192.168.1.{1..254}; do
        if ping_check "$ip" 1; then
            log_success "Found: $ip"
            found+=("$ip")
            
            # Try to identify device
            local hostname=$(getent hosts "$ip" 2>/dev/null | awk '{print $2}' || echo "unknown")
            local mac=$(arp -n "$ip" 2>/dev/null | awk '/00:/{print $3}' || echo "unknown")
            
            log_info "  Hostname: $hostname"
            log_info "  MAC: $mac"
        fi
    done
    
    echo ""
    log_success "Found ${#found[@]} devices"
    
    # Show known devices
    echo ""
    log_info "Known devices:"
    for device in "${!DEVICES[@]}"; do
        local expected_ip="${DEVICES[$device]}"
        if ping_check "$expected_ip" 1; then
            log_success "  $device: $expected_ip [ONLINE]"
        else
            log_warn "  $device: $expected_ip [OFFLINE]"
        fi
    done
}

# ==============================================================================
# DEVICE SETUP FUNCTIONS
# ==============================================================================

setup_kali_vm() {
    log_header "🐉 KALI LINUX VM SETUP"
    
    if ! cmd_exists VBoxManage; then
        log_error "VirtualBox not found on Windows host"
        return 1
    fi
    
    log_info "Creating Kali VM..."
    
    # VM Configuration
    local VM_NAME="Kali-Linux-Pentest"
    local RAM=4096
    local CPUS=2
    local DISK=50000
    
    # Check if VM exists
    if VBoxManage list vms | grep -q "$VM_NAME"; then
        log_warn "VM $VM_NAME already exists"
        read -p "Recreate? (y/N): " confirm
        if [[ "$confirm" != "y" ]]; then
            log_info "Skipping VM creation"
            return 0
        fi
        VBoxManage unregistervm "$VM_NAME" --delete
    fi
    
    # Create VM
    VBoxManage createvm --name "$VM_NAME" --ostype Debian_64 --register
    VBoxManage modifyvm "$VM_NAME" --memory $RAM --cpus $CPUS --vram 128
    VBoxManage modifyvm "$VM_NAME" --nic1 bridged --bridgeadapter1 "Intel(R) Ethernet"
    VBoxManage modifyvm "$VM_NAME" --usb on --usbxhci on
    
    # Create disk
    VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi" --size $DISK
    
    # Attach storage
    VBoxManage storagectl "$VM_NAME" --name "SATA" --add sata
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA" --port 0 --device 0 --type hdd \
        --medium "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"
    
    log_success "Kali VM created: $VM_NAME"
    log_info "RAM: $RAM MB, CPUs: $CPUS, Disk: $DISK MB"
    log_info ""
    log_info "After installing Kali, copy enhance-kali-v3.sh to /root/"
}

setup_oppo_phone() {
    log_header "📱 OPPO PHONE SETUP (Termux)"
    
    echo "
    ┌─────────────────────────────────────────────────────────────┐
    │                    OPPO PHONE SETUP                        │
    └─────────────────────────────────────────────────────────────┘
    
    On your OPPO phone:
    
    1. Install F-Droid (https://f-droid.org)
    2. Install Termux from F-Droid (NOT Play Store!)
    3. Open Termux and run:
    
    =============================================================
    "
    
    cat << 'PHONE_SETUP'
# Update and install basics
pkg update && pkg upgrade
pkg install git curl wget vim nano htop

# Install AI tools
npm install -g opencode-ai @google/gemini-cli

# Python
pkg install python python-pip
pip install requests pwntools scapy

# SSH for remote access
pkg install openssh

# Set up SSH key
ssh-keygen -t ed25519 -C "oppo-termux"

# Create startup script
cat > $HOME/startup.sh << 'EOF'
#!/bin/bash
echo "OPPO Termux Ready"
echo "IP: $(ifconfig | grep inet | awk '{print $2}')"
echo "Services:"
echo "  - SSH: port 8022"
echo "  - AI Tools: o, g"
neofetch
EOF
chmod +x $HOME/startup.sh

PHONE_SETUP

    echo "
    =============================================================
    
    4. Start SSH:
       termux-setup-storage
       sshd (starts SSH server on port 8022)
    
    5. Connect from Windows:
       ssh -p 8022 @localhost  (if USB debugging)
       or
       ssh -p 22 root@<phone-ip>  (if on same network)
    
    USB Debugging (recommended):
    - Enable Developer Options
    - Enable USB Debugging
    - Connect via USB
    - Run: adb forward tcp:8022 tcp:8022
    - Connect: ssh -p 8022 localhost
    "
    
    log_success "OPPO setup instructions shown"
}

setup_xp_laptop() {
    log_header "💻 OLD XP LAPTOP SETUP"
    
    echo "
    ┌─────────────────────────────────────────────────────────────┐
    │                   XP LAPTOP USES                           │
    └─────────────────────────────────────────────────────────────┘
    
    Since this is an old Windows XP machine (400GB), here are
    the recommended uses:
    
    1. 🗄️ NETWORK ATTACHED STORAGE (NAS)
       - Share the 400GB hard drive on network
       - Store wordlists, pcap files, payloads
       - Backup location for Kali VMs
    
    2. 🔴 DEDICATED PENTEST TARGET
       - Practice Windows exploitation
       - Vulnerable VM hosting
       - CTF challenge server
    
    3. 🌐 PROXY/HOTSPOT BRIDGE
       - Route traffic through XP
       - Network isolation for safety
    
    4. 📡 PACKET SNIFFING
       - Dedicated monitoring interface
       - Long-term capture station
    
    ═══════════════════════════════════════════════════════════════
    
    QUICK SETUP (on XP machine):
    
    1. Install Python 2.7 (last version for XP)
    2. Install OpenSSH (comes with Git for Windows)
    3. Share folder 'pentest-share'
    
    Or use our automated script:
    "
    
    # Create XP setup script
    cat > "C:\Users\User\KaliShare\scripts\xp-setup.bat" << 'EOF'
@echo off
REM XP Laptop Pentest Station Setup
REM Run as Administrator

echo ========================================
echo XP Pentest Station Setup
echo ========================================
echo.

REM Check if admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run as Administrator
    pause
    exit /b 1
)

echo [1/5] Enabling Remote Desktop...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh firewall set service remotedesktop enable

echo [2/5] Enabling SSH (install OpenSSH first)...
echo Download from: https://github.com/PowerShell/Win32-OpenSSH/releases

echo [3/5] Creating Pentest Share...
md C:\pentest-share
net share pentest=C:\pentest-share /grant:everyone,FULL

echo [4/5] Installing Python 2.7...
echo Download from: https://www.python.org/download/python-2.7/

echo [5/5] Firewall settings...
netsh firewall add portopening TCP 22 SSH
netsh firewall add portopening TCP 3389 RDP

echo.
echo ========================================
echo Setup Complete!
echo.
echo Next steps:
echo 1. Install OpenSSH from Git for Windows
echo 2. Install Python 2.7
echo 3. Copy pentest tools to C:\pentest-share
echo.
echo Network share: \\XP\c$\pentest-share
echo.
pause
EOF

    log_success "XP setup script created: scripts/xp-setup.bat"
    
    # Create NAS/Storage script
    cat > "C:\Users\User\KaliShare\scripts\xp-nas.bat" << 'EOF'
@echo off
REM XP NAS Configuration
REM Turn XP into Network Attached Storage

echo ========================================
echo XP NAS Setup
echo ========================================

echo Creating storage folders...
md D:\wordlists
md D:\pcaps
md D:\tools
md D:\backups
md D:\payloads

echo Sharing folders...
net share wordlists=D:\wordlists /grant:everyone,READ
net share pcaps=D:\pcaps /grant:everyone,READ
net share tools=D:\tools /grant:everyone,READ
net share backups=D:\backups /grant:everyone,READ
net share payloads=D:\payloads /grant:everyone,READ

echo.
echo Shared folders created:
echo  \\%COMPUTERNAME%\wordlists
echo  \\%COMPUTERNAME%\pcaps
echo  \\%COMPUTERNAME%\tools
echo  \\%COMPUTERNAME%\backups
echo  \\%COMPUTERNAME%\payloads
echo.
pause
EOF

    log_success "XP NAS script created: scripts/xp-nas.bat"
}

setup_huawei_hotspot() {
    log_header "📡 HUAWEI HOTSPOT INTEGRATION"
    
    echo "
    ┌─────────────────────────────────────────────────────────────┐
    │                 HUAWEI HOTSPOT SETUP                        │
    └─────────────────────────────────────────────────────────────┘
    
    For the Huawei mobile hotspot:
    
    1. Connect via USB or WiFi
    2. Get IP: usually 192.168.1.1 or 192.168.8.1
    3. Access admin panel
    4. Configure port forwarding for Kali access
    
    ═══════════════════════════════════════════════════════════════
    
    Common Huawei Models:
    - E5577: 192.168.1.1 (USB) / 192.168.8.1 (WiFi)
    - E558: 192.168.1.1
    - Mobile WiFi: 192.168.1.1
    
    Default credentials: admin / admin
    
    ═══════════════════════════════════════════════════════════════
    "
    
    # Create hotspot monitoring script
    cat > "C:\Users\User\KaliShare\scripts\hotspot-monitor.sh" << 'EOF'
#!/bin/bash
# Huawei Hotspot Monitor Script
# Usage: ./hotspot-monitor.sh

HOTSPOT_IP="${1:-192.168.1.1}"
CHECK_INTERVAL=30

echo "Huawei Hotspot Monitor"
echo "======================="
echo "Hotspot IP: $HOTSPOT_IP"
echo "Check Interval: ${CHECK_INTERVAL}s"
echo ""

while true; do
    if ping -c 1 -W 2 "$HOTSPOT_IP" >/dev/null 2>&1; then
        echo "[$(date '+%H:%M:%S')] ✓ Hotspot ONLINE"
        
        # Try to get signal info
        if command -v curl >/dev/null 2>&1; then
            response=$(curl -s --connect-timeout 2 "http://$HOTSPOT_IP/" 2>/dev/null | head -c 100)
            if [ -n "$response" ]; then
                echo "  -> Admin interface accessible"
            fi
        fi
    else
        echo "[$(date '+%H:%M:%S')] ✗ Hotspot OFFLINE"
    fi
    
    sleep $CHECK_INTERVAL
done
EOF
    chmod +x "C:\Users\User\KaliShare\scripts\hotspot-monitor.sh"
    
    log_success "Hotspot monitor created: scripts/hotspot-monitor.sh"
}

setup_tp_link() {
    log_header "📶 TP-LINK WI-FI ADAPTER (AR9271)"
    
    echo "
    ┌─────────────────────────────────────────────────────────────┐
    │              TP-LINK TL-WN721N SETUP                        │
    └─────────────────────────────────────────────────────────────┘
    
    Adapter: TP-Link TL-WN721N
    Chipset: Atheros AR9271
    Status: Monitor mode supported ✓
    
    ═══════════════════════════════════════════════════════════════
    
    Commands for Kali Linux:
    
    # Check adapter
    lsusb | grep -i atheros
    iw list | grep -i monitor
    
    # Enable monitor mode
    sudo airmon-ng start wlan0
    
    # Scan networks
    sudo airodump-ng wlan0mon
    
    # Capture handshake
    sudo airodump-ng -c <channel> --bssid <MAC> -w capture wlan0mon
    
    # Deauth attack
    sudo aireplay-ng --deauth 10 -a <AP_MAC> wlan0mon
    
    # Crack password
    sudo aircrack-ng -w wordlist.txt capture-01.cap
    
    ═══════════════════════════════════════════════════════════════
    
    VirtualBox USB Filter:
    - Vendor ID: 0bda (Realtek/Atheros)
    - Product ID: 8179
    "
    
    # Create wireless quick script
    cat > "C:\Users\User\KaliShare\scripts\wireless-quick.sh" << 'EOF'
#!/bin/bash
# Quick Wireless Commands
# Usage: ./wireless-quick.sh [command]

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

case "${1:-menu}" in
    start)
        echo "Starting monitor mode..."
        airmon-ng start wlan0
        ;;
    stop)
        echo "Stopping monitor mode..."
        airmon-ng stop wlan0mon
        ip link set wlan0 up
        ;;
    scan)
        echo "Scanning networks..."
        airodump-ng wlan0mon
        ;;
    check)
        echo "Checking adapter..."
        airmon-ng
        iw list | grep -A 10 "Supported interface modes"
        ;;
    test)
        echo "Testing injection..."
        aireplay-ng -9 wlan0mon
        ;;
    menu)
        echo "Wireless Quick Commands"
        echo "======================"
        echo "  start  - Enable monitor mode"
        echo "  stop   - Disable monitor mode"
        echo "  scan   - Scan networks"
        echo "  check  - Check adapter"
        echo "  test   - Test injection"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use: start, stop, scan, check, test"
        ;;
esac
EOF
    chmod +x "C:\Users\User\KaliShare\scripts\wireless-quick.sh"
    
    log_success "Wireless quick script created"
}

# ==============================================================================
# ORCHESTRATION
# ==============================================================================

orchestrate_devices() {
    log_header "🎭 MULTI-DEVICE ORCHESTRATION"
    
    echo "
    ┌─────────────────────────────────────────────────────────────┐
    │               DEVICE CONNECTIONS DIAGRAM                    │
    └─────────────────────────────────────────────────────────────┘
    
                    ┌─────────────────┐
                    │  HUAWEI         │
                    │  HOTSPOT        │ ◄── Mobile Data
                    │  192.168.1.1    │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │   WINDOWS    │  │   KALI VM    │  │  XP LAPTOP   │
    │   HOST       │  │  (Pentest)   │  │  (NAS/VM)    │
    │ 192.168.1.100│  │ 192.168.1.50│  │ 192.168.1.75│
    └─────────────┘  └─────────────┘  └─────────────┘
              │              │              │
              │    ┌─────────┴─────────┐    │
              │    │                   │    │
              ▼    ▼                   ▼    ▼
              ┌─────────────────────────────┐
              │     OPPO PHONE             │
              │     (Termux + AI)          │
              │     192.168.1.100          │
              └─────────────────────────────┘
              
              ┌─────────────────────────────┐
              │   TP-LINK TL-WN721N        │
              │   (Atheros AR9271)        │
              │   Monitor Mode Ready       │
              └─────────────────────────────┘
    "
    
    # Create orchestration script
    cat > "C:\Users\User\KaliShare\scripts\orchestrate.sh" << 'EOF'
#!/bin/bash
# Multi-Device Orchestration Script
# Controls all devices from one location

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Device IPs
WIN_HOST="192.168.1.100"
KALI_VM="192.168.1.50"
XP_LAPTOP="192.168.1.75"
OPPO_PHONE="192.168.1.100"
HUAWEI_HOTSPOT="192.168.1.1"

# Colors
log() { echo -e "$*"; }

show_menu() {
    clear
    log "${BLUE}════════════════════════════════════════════════════════════${NC}"
    log "${GREEN}         🏠 HOME LAB MULTI-DEVICE CONTROLLER${NC}"
    log "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo "
    ${YELLOW}[1]${NC}  Check all devices online status
    ${YELLOW}[2]${NC}  SSH to Kali VM
    ${YELLOW}[3]${NC}  SSH to XP Laptop
    ${YELLOW}[4]${NC}  SSH to OPPO Phone
    ${YELLOW}[5]${NC}  Access Huawei Hotspot admin
    ${YELLOW}[6]${NC}  Run wireless scan (Kali)
    ${YELLOW}[7]${NC}  Copy tools to Kali
    ${YELLOW}[8]${NC}  Sync wordlists from XP
    ${YELLOW}[9]${NC}  Start all AI tools
    ${YELLOW}[0]${NC}  Exit
    
    "
    read -p "Select: " choice
}

ping_device() {
    local ip=$1
    if timeout 1 ping -c 1 "$ip" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
}

case "${1:-menu}" in
    status|check)
        log "Device Status:"
        echo "  Windows Host ($WIN_HOST): $(ping_device $WIN_HOST)"
        echo "  Kali VM ($KALI_VM): $(ping_device $KALI_VM)"
        echo "  XP Laptop ($XP_LAPTOP): $(ping_device $XP_LAPTOP)"
        echo "  OPPO Phone ($OPPO_PHONE): $(ping_device $OPPO_PHONE)"
        echo "  Huawei Hotspot ($HUAWEI_HOTSPOT): $(ping_device $HUAWEI_HOTSPOT)"
        ;;
    kali)
        ssh root@$KALI_VM
        ;;
    xp)
        ssh administrator@$XP_LAPTOP
        ;;
    oppo)
        ssh -p 8022 localhost
        ;;
    hotspot)
        echo "Opening Huawei admin panel..."
        start http://$HUAWEI_HOTSPOT
        ;;
    wireless)
        ssh root@$KALI_VM "sudo airodump-ng wlan0mon"
        ;;
    sync-tools)
        log "Syncing tools to Kali..."
        rsync -avzC --exclude='.git' scripts/ root@$KALI_VM:/root/scripts/
        ;;
    sync-wordlists)
        log "Syncing wordlists from XP..."
        rsync -avz administrator@$XP_LAPTOP:/pentest-share/wordlists/ /root/wordlists/
        ;;
    *)
        while true; do
            show_menu
            case $choice in
                1) $0 status ;;
                2) ssh root@$KALI_VM ;;
                3) ssh administrator@$XP_LAPTOP ;;
                4) $0 oppo ;;
                5) $0 hotspot ;;
                6) $0 wireless ;;
                7) $0 sync-tools ;;
                8) $0 sync-wordlists ;;
                9) echo "Starting AI tools..." ;;
                0) exit 0 ;;
            esac
            echo "Press Enter..."
            read
        done
        ;;
esac
EOF
    chmod +x "C:\Users\User\KaliShare\scripts\orchestrate.sh"
    
    log_success "Orchestration script created"
}

# ==============================================================================
# MAIN MENU
# ==============================================================================

main() {
    while true; do
        clear
        echo -e "${CYAN}"
        cat << 'BANNER'
    ███████╗███████╗ ██████╗ ███████╗██╗   ██╗██╗  ██╗ ██████╗              
    ██╔════╝██╔════╝██╔════╝██╔════╝██║   ██║██║  ██║██╔═══██╗             
    █████╗  ███████╗██║  ███╗█████╗  ██║   ██║███████║██║   ██║             
    ██╔══╝  ╚════██║██║   ██║██╔══╝  ██║   ██║██╔══██║██║   ██║             
    ███████╗███████║╚██████╔╝███████╗╚██████╔╝██║  ██║╚██████╔╝             
    ╚══════╝╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝              
                                                                     
         █████╗ ██╗      ██████╗  ██████╗ ██████╗ ███████╗██████╗             
        ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██╔════╝██╔══██╗            
        ███████║██║     ██║  ███╗██║   ██║██████╔╝█████╗  ██║  ██║            
        ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██╔══╝  ██║  ██║            
        ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║███████╗██████╔╝            
        ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝             
                                                                     
              🏠 HOME LAB MULTI-DEVICE ORCHESTRATOR
                        v1.0 - 2026
BANNER
        echo -e "${NC}"
        
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "  ${GREEN}[1]${NC}  Discover Network Devices"
        echo -e "  ${GREEN}[2]${NC}  Setup Kali VM"
        echo -e "  ${GREEN}[3]${NC}  Setup OPPO Phone (Termux)"
        echo -e "  ${GREEN}[4]${NC}  Setup XP Laptop"
        echo -e "  ${GREEN}[5]${NC}  Setup Huawei Hotspot"
        echo -e "  ${GREEN}[6]${NC}  Setup TP-Link WiFi Adapter"
        echo -e "  ${GREEN}[7]${NC}  Create Orchestration Script"
        echo -e "  ${GREEN}[8]${NC}  Show All Device Scripts"
        echo -e "  ${GREEN}[0]${NC}  Exit"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        
        read -p "  Select option: " choice
        echo ""
        
        case $choice in
            1) discover_network ;;
            2) setup_kali_vm ;;
            3) setup_oppo_phone ;;
            4) setup_xp_laptop ;;
            5) setup_huawei_hotspot ;;
            6) setup_tp_link ;;
            7) orchestrate_devices ;;
            8)
                echo "Scripts created in C:\Users\User\KaliShare\scripts\:"
                ls -1 scripts/*.sh scripts/*.bat 2>/dev/null | head -20
                ;;
            0)
                echo -e "${CYAN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
    done
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
