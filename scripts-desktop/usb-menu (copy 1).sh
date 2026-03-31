#!/bin/bash

################################################################################
#  🎮 USB ALL-IN-ONE MENU - Runs on Desktop Kali after boot
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

log() { echo -e "$*"; }
log_info() { log "${BLUE}[INFO]${NC} $*"; }
log_success() { log "${GREEN}[✓]${NC} $*"; }
log_error() { log "${RED}[✗]${NC} $*"; }
log_warn() { log "${YELLOW}[⚠]${NC} $*"; }

# Check command exists
cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check internet
check_internet() {
    if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Check network mount
check_network() {
    if mount | grep -q "192.168.1.100"; then
        return 0
    fi
    return 1
}

# ============================================================================
# MENU FUNCTIONS
# ============================================================================

menu_auto_connect() {
    log_info "Running auto-connect script..."
    
    # Run the main auto-connect script
    if [ -f /root/scripts/auto-connect-ethernet.sh ]; then
        bash /root/scripts/auto-connect-ethernet.sh
    else
        # Inline quick config
        log_info "Configuring network..."
        
        # Detect interface
        ETH=$(ip -br addr show | grep -v lo | awk '{print $1}' | head -1)
        
        if [ -z "$ETH" ]; then
            log_error "No network interface found!"
            return 1
        fi
        
        log_info "Using interface: $ETH"
        
        # Configure DHCP first
        log_info "Trying DHCP..."
        dhclient "$ETH"
        
        sleep 2
        
        # Check if we got IP
        if ip addr show "$ETH" | grep -q "inet "; then
            IP=$(ip addr show "$ETH" | grep "inet " | awk '{print $2}' | cut -d/ -f1)
            log_success "Got IP: $IP"
            
            # Test internet
            if check_internet; then
                log_success "Internet connected!"
            else
                log_warn "No internet - may need static IP"
            fi
        else
            log_warn "No DHCP IP - configuring static..."
            
            # Static IP
            ip addr add 192.168.1.75/24 dev "$ETH"
            ip link set "$ETH" up
            ip route add default via 192.168.1.1
            
            # Test
            if ping -c 1 -W 3 192.168.1.100 >/dev/null 2>&1; then
                log_success "Can reach host laptop!"
            fi
        fi
    fi
}

menu_full_setup() {
    log_info "Running full setup..."
    
    # Copy scripts if USB mounted
    if [ -f /media/*/scripts/enhance-kali-v3.sh ]; then
        cp /media/*/scripts/*.sh /root/scripts/ 2>/dev/null || true
    fi
    
    # Run enhancement
    if [ -f /root/scripts/enhance-kali-v3.sh ]; then
        bash /root/scripts/enhance-kali-v3.sh
    else
        log_error "Enhancement script not found!"
    fi
}

menu_wireless() {
    log_info "Checking wireless..."
    
    if cmd_exists airmon-ng; then
        log_info "Running airmon-ng..."
        sudo airmon-ng
    else
        log_error "aircrack-ng not installed!"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

menu_ssh_setup() {
    log_info "Setting up SSH..."
    
    # Install openssh
    if ! cmd_exists sshd; then
        apt update && apt install -y openssh-server
    fi
    
    # Configure
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    
    # Start
    systemctl enable ssh
    systemctl start ssh
    
    log_success "SSH enabled!"
    log_info "Connect with: ssh root@192.168.1.75"
    
    # Show IP
    ip addr show | grep "inet " | awk '{print "IP: " $2}'
}

menu_network_share() {
    log_info "Network & Sharing Options:"
    
    echo "
    1) Connect to host laptop via SMB
    2) Mount shared folder from host
    3) Set up as VPN server
    4) Configure proxy
    5) Back to main menu
    "
    
    read -p "Select: " choice
    
    case $choice in
        1)
            # SMB connect
            log_info "Connecting to host SMB..."
            mount -t cifs //192.168.1.100/share /mnt/host -o username=guest
            ;;
        2)
            # Mount
            log_info "Mounting host share..."
            mkdir -p /mnt/host
            mount -t cifs //192.168.1.100/C$ /mnt/host -o guest
            ;;
        3)
            log_info "Installing VPN..."
            apt install -y openvpn easy-rsa
            ;;
        *)
            return
            ;;
    esac
}

menu_info() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
    ███████╗███████╗ ██████╗ ███████╗██╗   ██╗██╗  ██╗ ██████╗                    
    ██╔════╝██╔════╝██╔════╝██╔════╝██║   ██║██║  ██║██╔═══██╗                   
    █████╗  ███████╗██║  ███╗█████╗  ██║   ██║███████║██║   ██║                   
    ██╔══╝  ╚════██║██║   ██║██╔══╝  ██║   ██║██╔══██║██║   ██║                   
    ███████╗███████║╚██████╔╝███████╗╚██████╔╝██║  ██║╚██████╔╝                   
    ╚══════╝╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝                    
                                                                     
         █████╗ ██╗      ██████╗  ██████╗ ██████╗ ███████╗██████╗            
        ██╔══██╗██║     ██╔════╝ ██╔═══██╗██╔══██╗██╔════╝██╔══██╛           
        ███████║██║     ██║  ███╗██║   ██║██████╔╝█████╗  ██║  ██║           
        ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██╔══╝  ██║  ██║           
        ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║███████╗██████╔╝           
        ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝            
                                                                     
                         KALI DESKTOP v1.0
EOF
    echo -e "${NC}"
    
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  System Info:${NC}"
    echo -e "  Hostname: $(hostname)"
    echo -e "  Kernel: $(uname -r)"
    echo -e "  OS: $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
    echo ""
    echo -e "  ${WHITE}Network:${NC}"
    ip addr show | grep "inet " | awk '{print "  " $NF ": " $2}'
    echo ""
    echo -e "  ${WHITE}Disk:${NC}"
    df -h / | tail -1 | awk '{print "  Used: " $3 " / " $2 " (" $5 ")"}'
    echo ""
    echo -e "  ${WHITE}Memory:${NC}"
    free -h | grep Mem | awk '{print "  Used: " $3 " / " $2}'
    echo ""
    
    read -p "Press Enter to continue..."
}

menu_test_network() {
    log_info "Testing network connectivity..."
    
    echo "
    Testing: Host Laptop (192.168.1.100)
    "
    
    if ping -c 2 192.168.1.100 >/dev/null 2>&1; then
        log_success "Host laptop: REACHABLE"
    else
        log_error "Host laptop: NOT REACHABLE"
        log_info "Check ethernet cable!"
    fi
    
    echo "
    Testing: Internet
    "
    
    if ping -c 2 8.8.8.8 >/dev/null 2>&1; then
        log_success "Internet: REACHABLE"
    else
        log_error "Internet: NOT REACHABLE"
    fi
    
    echo "
    Testing: DNS
    "
    
    if ping -c 1 google.com >/dev/null 2>&1; then
        log_success "DNS: WORKING"
    else
        log_error "DNS: NOT WORKING"
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

menu_reboot() {
    echo "
    Are you sure you want to reboot?
    "
    read -p "Type 'yes' to confirm: " confirm
    
    if [ "$confirm" = "yes" ]; then
        reboot
    fi
}

menu_poweroff() {
    echo "
    Are you sure you want to poweroff?
    "
    read -p "Type 'yes' to confirm: " confirm
    
    if [ "$confirm" = "yes" ]; then
        poweroff
    fi
}

# ============================================================================
# MAIN MENU
# ============================================================================

main() {
    while true; do
        clear
        echo -e "${CYAN}"
        cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                                                                       ║
    ║      🐉 KALI DESKTOP - QUICK SETUP MENU v1.0                      ║
    ║                                                                       ║
    ╚═══════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
        
        echo -e "${YELLOW}┌─────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[1]${NC}  🔌 Auto-Connect Ethernet                          ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[2]${NC}  🌐 Test Network Connection                       ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[3]${NC}  🔐 Setup SSH Remote Access                       ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[4]${NC}  📡 Setup Wireless/Monitor Mode                 ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[5]${NC}  📁 Network Sharing                              ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[6]${NC}  ⚡ Full System Setup                            ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[7]${NC}  ℹ️  System Info                                 ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[8]${NC}  🔄 Reboot                                      ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[9]${NC}  ⏻ Power Off                                    ${YELLOW}│${NC}"
        echo -e "${YELLOW}│${NC}  ${GREEN}[0]${NC}  ❌ Exit                                         ${YELLOW}│${NC}"
        echo -e "${YELLOW}└─────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        
        read -p "Select option: " choice
        
        case $choice in
            1) menu_auto_connect ;;
            2) menu_test_network ;;
            3) menu_ssh_setup ;;
            4) menu_wireless ;;
            5) menu_network_share ;;
            6) menu_full_setup ;;
            7) menu_info ;;
            8) menu_reboot ;;
            9) menu_poweroff ;;
            0) 
                echo "Goodbye!"
                exit 0
                ;;
            *)
                log_error "Invalid option!"
                sleep 1
                ;;
        esac
        
        echo ""
    done
}

# Run main
main "$@"
