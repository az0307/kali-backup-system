#!/bin/bash
# ====================================================================
# Skeleton Key USB Creator - Automated Windows Password Reset USB
# ====================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly USB_DEVICE=""  # Set to your USB device (e.g., /dev/sdb)
readonly KALI_ISO_URL="https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-live-amd64.iso"
readonly WORKDIR="/tmp/skeleton-key-build"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

detect_usb() {
    log_info "Detecting USB drives..."
    lsblk -d -o NAME,SIZE,TYPE,MOUNTPOINT | grep -E "usb|sd"
}

select_usb() {
    detect_usb
    echo ""
    echo -n "Enter USB device (e.g., sdb): "
    read USB_DEVICE
    
    if [[ -z "$USB_DEVICE" ]]; then
        log_error "No device selected"
        return 1
    fi
    
    # Add /dev/ prefix if not present
    if [[ ! "$USB_DEVICE" =~ ^/dev/ ]]; then
        USB_DEVICE="/dev/$USB_DEVICE"
    fi
    
    log_info "Selected: $USB_DEVICE"
}

partition_usb() {
    log_info "Partitioning USB..."
    
    # Unmount any mounted partitions
    umount "${USB_DEVICE}"* 2>/dev/null || true
    
    # Create partition table
    parted -s "$USB_DEVICE" mklabel msdos
    
    # Create single partition (15GB is plenty)
    parted -s "$USB_DEVICE" mkpart primary ntfs 0% 100%
    
    # Set boot flag
    parted -s "$USB_DEVICE" set 1 boot on
    
    # Format as NTFS
    mkfs.ntfs -f "${USB_DEVICE}1" -L SKELETON_KEY
    
    log_info "USB partitioned and formatted"
}

mount_usb() {
    mkdir -p "$WORKDIR"
    mount "${USB_DEVICE}1" "$WORKDIR"
    log_info "USB mounted at $WORKDIR"
}

copy_tools() {
    log_info "Copying password reset tools..."
    
    # Copy skeleton-key scripts
    mkdir -p "$WORKDIR/scripts/skeleton-key"
    cp -r "$SCRIPT_DIR"/* "$WORKDIR/scripts/skeleton-key/" 2>/dev/null || true
    
    # Copy CLI tools
    mkdir -p "$WORKDIR/cli"
    cp -r "C:/Users/User/KaliShare/cli/"* "$WORKDIR/cli/" 2>/dev/null || true
    
    # Make scripts executable
    find "$WORKDIR" -name "*.sh" -exec chmod +x {} \;
    
    log_info "Tools copied"
}

create_autostart() {
    log_info "Creating autostart configuration..."
    
    cat > "$WORKDIR/autorun.inf" << 'EOF'
[autorun]
icon=skeleton-key.ico
label=Skeleton Key USB
open=scripts\skeleton-key\start.bat
action=Open Skeleton Key Menu
EOF

    cat > "$WORKDIR/scripts/skeleton-key/start.bat" << 'EOF'
@echo off
cd /d %~dp0
echo ========================================
echo   SKELETON KEY USB - Windows Password Reset
echo ========================================
echo.
echo This tool requires:
echo   1. Boot from Kali Linux Live USB
echo   2. Run: sudo ./scripts/skeleton-key/start.sh
echo.
pause
EOF

    log_info "Autostart created"
}

create_quick_start() {
    log_info "Creating QUICK-START.txt..."
    
    cat > "$WORKDIR/QUICK-START.txt" << 'EOF'
=================================================================
SKELETON KEY USB - Windows Password Reset Tool
=================================================================

QUICK START:
-----------
1. Boot target machine from this USB
2. Select "Try Kali Linux" (Live Mode)
3. Open terminal and run:

   sudo mount /dev/sdb1 /mnt
   cd /mnt/scripts/skeleton-key
   sudo ./start.sh

4. Follow the menu:
   [1] Auto Reset Password (Recommended)
   [2] Set New Password
   [3] Promote to Admin
   [4] Unlock Account

REQUIREMENTS:
------------
- Target: Windows 10/11 with NTFS
- Access: Physical access to machine
- Permissions: Root (sudo)

TOOLS INCLUDED:
--------------
- chntpw (password reset)
- ntfs-3g (mount utilities)
- ntpwd (SAM database editor)

SAFETY:
-------
- Always backup data first
- Use option 1 for blank password
- Works on local accounts only
- Microsoft accounts require offline reset

For full documentation, see: docs/README.md
=================================================================
EOF

    log_info "Quick start guide created"
}

create_readme() {
    log_info "Creating README..."
    
    cat > "$WORKDIR/README.md" << 'EOF'
# Skeleton Key USB

Windows password reset toolkit for Kali Linux Live USB.

## Usage

### From Kali Live:
```bash
sudo mount /dev/sdX1 /mnt
cd /mnt/scripts/skeleton-key
sudo ./start.sh
```

### Options:
- Auto Reset: Clear password to blank
- Set Password: Set new password
- Promote: Add to Administrators group
- Unlock: Enable disabled account

## Files

```
scripts/skeleton-key/
├── start.sh          # Main menu
├── auto-reset.sh     # Quick reset
├── detect-windows.sh # Find Windows
├── reset-password.sh # Core reset logic
├── verify-reset.sh   # Verify success
├── mount-utils.sh    # Mount helpers
├── error-handler.sh  # Error handling
├── banner.sh        # UI banners
└── README.txt       # This file
```

## Requirements

- Kali Linux Live USB
- Root access (sudo)
- NTFS partition access
- chntpw package

## Legal Notice

For authorized use only. Password reset may violate
local laws. Use on systems you own or have explicit
written permission to test.
EOF

    log_info "README created"
}

cleanup() {
    log_info "Cleaning up..."
    umount "$WORKDIR" 2>/dev/null || true
    rmdir "$WORKDIR" 2>/dev/null || true
}

main() {
    check_root
    
    echo ""
    echo "=============================================="
    echo "  SKELETON KEY USB CREATOR"
    echo "=============================================="
    echo ""
    
    # Detect and select USB
    select_usb
    
    echo ""
    read -p "WARNING: This will ERASE all data on $USB_DEVICE. Continue? (YES/no): " CONFIRM
    if [[ "$CONFIRM" != "YES" ]]; then
        log_info "Aborted"
        exit 0
    fi
    
    # Build USB
    partition_usb
    mount_usb
    copy_tools
    create_autostart
    create_quick_start
    create_readme
    
    echo ""
    echo "=============================================="
    log_info "Skeleton Key USB created successfully!"
    echo "=============================================="
    
    cleanup
}

main "$@"