#!/bin/bash

################################################################################
#  📶 HUAWEI HOTSPOT CONNECTIVITY TESTER
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $*"; }

# Common Huawei hotspot IPs
HUAWEI_IPS=(
    "192.168.1.1"
    "192.168.8.1"
    "192.168.9.1"
    "192.168.0.1"
    "192.168.100.1"
    "192.168.251.1"
)

main() {
    echo ""
    log_info "════════════════════════════════════════════════════════════"
    log_info "  📶 HUAWEI HOTSPOT CONNECTIVITY TESTER"
    log_info "════════════════════════════════════════════════════════════"
    echo ""
    
    # =========================================================================
    # Step 1: Find Huawei
    # =========================================================================
    log_info "Step 1: Scanning for Huawei Hotspot..."
    
    found_ip=""
    for ip in "${HUAWEI_IPS[@]}"; do
        echo -n "  Testing $ip... "
        if timeout 2 ping -c 1 "$ip" >/dev/null 2>&1; then
            echo -e "${GREEN}FOUND!${NC}"
            found_ip="$ip"
            break
        else
            echo "not found"
        fi
    done
    
    if [ -z "$found_ip" ]; then
        log_error "No Huawei hotspot found on common IPs!"
        echo "
    Possible issues:
    1. Huawei not connected to this PC
    2. Different IP address
    3. Not powered on
    4. Connected via WiFi instead of USB
        
    Check your network connections:
    - USB tethering enabled?
    - WiFi connection to Huawei?
        "
        return 1
    fi
    
    log_success "Found Huawei at: $found_ip"
    
    # =========================================================================
    # Step 2: Test Web Interface
    # =========================================================================
    log_info "Step 2: Testing web interface..."
    
    if timeout 5 curl -s -o /dev/null -w "%{http_code}" "http://$found_ip" 2>/dev/null | grep -q "200\|302\|401"; then
        log_success "Web interface accessible!"
    else
        log_warn "Web interface not accessible (may be normal)"
    fi
    
    # =========================================================================
    # Step 3: Test Internet
    # =========================================================================
    log_info "Step 3: Testing internet connectivity..."
    
    if timeout 3 ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        log_success "Internet: CONNECTED!"
    else
        log_error "Internet: NOT CONNECTED"
        log_info "Check:
    1. Mobile data enabled on Huawei?
    2. SIM card inserted?
    3. Data plan active?"
        return 1
    fi
    
    # =========================================================================
    # Step 4: Check Network Interfaces
    # =========================================================================
    log_info "Step 4: Network interfaces..."
    
    echo "
    Current network interfaces:
    "
    ip -br addr show | grep -v lo
    
    # =========================================================================
    # Step 5: Desktop Connection Info
    # =========================================================================
    log_info "Step 5: Desktop connection info..."
    
    echo "
    To connect DESKTOP PC to internet:
    
    OPTION A - WiFi:
    1. Desktop connects to Huawei WiFi
    2. SSID: Check Huawei label
    3. Password: Check Huawei label
    
    OPTION B - USB Tethering:
    1. Connect desktop to Huawei via USB
    2. Enable USB tethering in Huawei settings
    3. Desktop gets internet automatically
    
    OPTION C - Ethernet (via this laptop):
    1. Connect desktop to this laptop via ethernet
    2. Enable internet sharing on this laptop
    3. Desktop gets internet
    
    OPTION D - Router:
    1. Connect Huawei to router WAN
    2. Desktop connects to router LAN
    "
    
    # =========================================================================
    # Summary
    # =========================================================================
    echo ""
    log_success "════════════════════════════════════════════════════════════"
    log_success "  ✅ HUAWEI HOTSPOT STATUS"
    log_success "════════════════════════════════════════════════════════════"
    echo "
    IP Address:     $found_ip
    Internet:       ✅ Working
    Desktop:       See options above
    "
}

main "$@"
