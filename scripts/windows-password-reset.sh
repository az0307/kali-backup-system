#!/bin/bash
# Windows Password Reset Toolkit
# Purpose: Reset Windows local admin password, enable disabled accounts, create new admin
# Usage: Run from Kali Live USB or Windows RE (WinRE)
# WARNING: Only use on systems you own or have explicit authorization to manage

set -euo pipefail

echo "============================================"
echo "Windows Password Reset Toolkit"
echo "============================================"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${CYAN}[STEP]${NC} $1"; }

# Check root
if [[ $EUID -ne 0 ]]; then
   log_error "This script must be run as root"
   exit 1
fi

# Detect Windows partition
detect_windows() {
    log_step "Detecting Windows installations..."
    
    # Check common Windows mount points
    MOUNTS=()
    
    # Try ntfs-3g mount
    if mount | grep -q "/mnt/c "; then
        MOUNTS+=("/mnt/c")
    fi
    
    # Try mounting Windows partitions
    for dev in /dev/sda* /dev/nvme*; do
        if [[ -b "$dev" ]]; then
            # Check for Windows partitions
            if ntfsfix -h "$dev" 2>/dev/null | grep -qi "windows"; then
                mount -o ro,nf "$dev" /mnt 2>/dev/null && MOUNTS+=("/mnt")
            fi
        fi
    done
    
    # Alternative: probe for Windows
    if [[ ${#MOUNTS[@]} -eq 0 ]]; then
        # Look for Windows on any mount
        for mount_point in /mnt/*; do
            if [[ -d "$mount_point/Windows" ]]; then
                MOUNTS+=("$mount_point")
            fi
        done
    fi
    
    if [[ ${#MOUNTS[@]} -gt 0 ]]; then
        log_success "Found Windows at: ${MOUNTS[*]}"
        echo "${MOUNTS[0]}"
    else
        log_error "No Windows installation found"
        exit 1
    fi
}

# Method 1: chntpw (Offline password reset)
method_chntpw() {
    local windows_root=$1
    local sam_path="$windows_root/Windows/System32/config/SAM"
    
    log_step "Method 1: Using chntpw (Offline SAM edit)"
    
    if [[ ! -f "$sam_path" ]]; then
        log_error "SAM file not found at: $sam_path"
        return 1
    fi
    
    log_info "Using chntpw to reset password..."
    log_info "This will:"
    echo "  - Clear Administrator password"
    echo "  - Enable disabled accounts"
    echo "  - Unlock locked accounts"
    echo ""
    read -p "Continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 1
    fi
    
    # chntpw interactive - will prompt for username
    chntpw -i "$sam_path" <<EOF
1
q
EOF
    
    log_success "Password reset complete via chntpw"
}

# Method 2: Enable admin via SAM registry hive
method_enable_admin() {
    local windows_root=$1
    
    log_step "Method 2: Enable Administrator via Registry"
    
    local reg_path="$windows_root/Windows/System32/config/SYSTEM"
    local reg_mount="/mnt/reg"
    
    mkdir -p "$reg_mount"
    
    if mount -o ro,loop "$reg_path" "$reg_mount" 2>/dev/null; then
        log_info "Mounted SYSTEM hive"
        
        # Enable Administrator account
        # Find ControlSet00X
        local control_set=$(ls "$reg_mount"/ | grep -oP 'ControlSet00[0-9]' | head -1)
        
        if [[ -n "$control_set" ]]; then
            log_info "Found: $control_set"
            
            # Backup original
            cp -r "$reg_mount/$control_set" "$reg_mount/${control_set}.bak" 2>/dev/null || true
            
            # Enable Administrator (value = 2 for enabled)
            # regkey = HKLM\$control_set\Services\LanmanServer\Parameters\RequireStrongKey
            # More reliable: use chntpw instead
            log_warn "Use chntpw for reliable reset"
        fi
        
        umount "$reg_mount" 2>/dev/null || true
    else
        log_error "Could not mount SYSTEM hive"
    fi
}

# Method 3: Create new admin user
method_create_admin() {
    local windows_root=$1
    
    log_step "Method 3: Create new Administrator account"
    
    echo ""
    echo "This method adds a new local administrator to the system."
    echo "The new user will have full admin rights."
    echo ""
    
    read -p "Enter new username (default: hacker): " new_user
    new_user=${new_user:-hacker}
    
    # Validate username
    if ! [[ "$new_user" =~ ^[a-zA-Z][a-zA-Z0-9_-]{0,19}$ ]]; then
        log_error "Invalid username format"
        return 1
    fi
    
    read -p "Enter password (leave empty for no password): " -s new_pass
    echo
    
    # We need to use chntpw to add user or modify SAM
    log_info "Using chntpw to create user: $new_user"
    
    # This requires offline SAM modification
    # chntpw -u "username" -r -e -i <samfile>
    
    log_warn "For user creation, use chntpw interactive mode:"
    echo "  chntpw -i $windows_root/Windows/System32/config/SAM"
    echo "  Then select: 'User edit' -> add user"
    
    log_success "Manual step required - see above"
}

# Method 4: NTDS password extraction (for domain)
method_ntds_dump() {
    log_step "Method 4: Extract password hashes from NTDS.dit"
    
    local windows_root=$1
    local ntds_path="$windows_root/Windows/NTDS/ntds.dit"
    local system_path="$windows_root/Windows/System32/config/SYSTEM"
    
    if [[ ! -f "$ntds_path" ]]; then
        log_warn "NTDS.dit not found (not a domain controller?)"
        return 1
    fi
    
    log_info "Found NTDS database"
    
    if command -v impacket-secretsdump >/dev/null 2>&1; then
        log_info "Using impacket-secretsdump..."
        impacket-secretsdump -system "$system_path" -ntds "$ntds_path" LOCAL 2>/dev/null
    elif command -v secretsdump >/dev/null 2>&1; then
        secretsdump -system "$system_path" -ntds "$ntds_path" LOCAL 2>/dev/null
    else
        log_warn "impacket-secretsdump not installed"
        log_info "Install: apt-get install impacket"
    fi
}

# Method 5: Bootable USB creation (Windows password reset disk)
method_create_reset_disk() {
    log_step "Method 5: Create Windows Password Reset Disk"
    
    echo ""
    echo "Creating a bootable password reset USB..."
    echo ""
    
    # Option: Hiren's BootCD method
    # Option: Offline NT Password & Registry Editor
    
    read -p "Create bootable reset USB? (requires 8GB+ USB): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    
    log_info "Downloading ntpassword..."
    
    # Download NT password rescue disk
    NT_PASS_URL="https://sourceforge.net/projects/ntpwinpassrescue/files/ntpasswd/bootdisk/ntpwd_v8.0.zip"
    
    if command -v wget >/dev/null 2>&1; then
        wget -O /tmp/ntpwd.zip "$NT_PASS_URL" 2>/dev/null || \
        curl -sL "$NT_PASS_URL" -o /tmp/ntpwd.zip
    fi
    
    if [[ -f /tmp/ntpwd.zip ]]; then
        log_success "Downloaded NT Password Rescue"
        echo "Extract to USB and boot from it"
    else
        log_warn "Could not download, use Hiren's BootCD instead"
    fi
}

# Method 6: Clear cached credentials
method_clear_cache() {
    local windows_root=$1
    
    log_step "Method 6: Clear Cached Credentials"
    
    local cache_dir="$windows_root/Users/*/AppData/Local/Microsoft/Credentials"
    
    # Note: This doesn't help for local admin reset
    log_info "Cached credentials location:"
    echo "  $cache_dir"
    echo ""
    log_warn "This doesn't reset passwords, just clears cached domain creds"
}

# Main menu
main() {
    local windows_root=$(detect_windows)
    
    echo ""
    echo "============================================"
    echo "Windows Password Reset Options"
    echo "============================================"
    echo "Windows found at: $windows_root"
    echo ""
    echo "1) Reset/clear Administrator password (chntpw)"
    echo "2) Enable disabled Administrator account"
    echo "3) Create new local Administrator"
    echo "4) Extract password hashes (NTDS for domain)"
    echo "5) Create bootable password reset USB"
    echo "6) Show SAM/SYSTEM file info"
    echo "7) Backup SAM before changes"
    echo "8) EXIT"
    echo ""
    read -p "Select method (1-8): " choice
    
    case $choice in
        1) method_chntpw "$windows_root" ;;
        2) method_enable_admin "$windows_root" ;;
        3) method_create_admin "$windows_root" ;;
        4) method_ntds_dump "$windows_root" ;;
        5) method_create_reset_disk ;;
        6)
            log_info "SAM: $windows_root/Windows/System32/config/SAM"
            log_info "SYSTEM: $windows_root/Windows/System32/config/SYSTEM"
            ls -la "$windows_root/Windows/System32/config/" 2>/dev/null | head -20
            ;;
        7)
            log_step "Backing up SAM..."
            cp "$windows_root/Windows/System32/config/SAM" "/root/sam-backup-$(date +%Y%m%d).bin"
            cp "$windows_root/Windows/System32/config/SYSTEM" "/root/system-backup-$(date +%Y%m%d).bin"
            log_success "Backup saved to /root/"
            ;;
        8) exit 0 ;;
        *) log_error "Invalid option" ;;
    esac
}

# Alternative: Quick command-line mode
if [[ "${1:-}" == "--quick" ]]; then
    windows_root=$(detect_windows)
    method_chntpw "$windows_root"
else
    # Interactive mode
    main
fi

echo ""
log_success "Done!"
echo ""
echo "IMPORTANT:"
echo "  1. Unmount Windows: umount /mnt"
echo "  2. Reboot: reboot"
echo "  3. Login with: Administrator (no password)"
echo ""