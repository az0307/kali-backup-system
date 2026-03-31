#!/bin/bash
# ====================================================================
# Boot Takeover & Password Reset Tools
# For Windows password reset and system recovery
# ====================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

log "Installing Boot Takeover & Password Tools..."

# Install chntpw
log "Installing chntpw (Windows password reset)..."
apt update
apt install -y chntpw ntfs-3g testdisk photorec

# Create password reset script
log "Creating Windows Password Reset Script..."

cat > /usr/local/bin/win-password-reset << 'EOF'
#!/bin/bash
# ====================================================================
# Windows Password Reset using chntpw
# ====================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   WINDOWS PASSWORD RESET TOOL       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# List partitions
echo "Available partitions:"
fdisk -l | grep -E "NTFS|FAT32|/dev/" | head -20
echo ""

# Get Windows partition
read -p "Enter Windows partition (e.g., /dev/sda1): " PARTITION

if [ ! -b "$PARTITION" ]; then
    echo -e "${RED}Invalid partition!${NC}"
    exit 1
fi

# Mount
MOUNT="/mnt/windows"
echo "Mounting $PARTITION to $MOUNT..."
mkdir -p $MOUNT
mount -t ntfs-3g $PARTITION $MOUNT -o force

if [ ! -f "$MOUNT/Windows/system32/config/SAM" ]; then
    echo -e "${RED}Windows SAM not found! Wrong partition?${NC}"
    umount $MOUNT 2>/dev/null
    exit 1
fi

cd $MOUNT/Windows/system32/config

echo ""
echo "Users found:"
chntpw -l SAM | grep -E "^=|Username"
echo ""

read -p "Enter username to reset: " USERNAME

echo "Resetting password for: $USERNAME"
echo "Options:"
echo "  1 - Clear password (blank)"
echo "  2 - Set new password"
echo "  3 - Unlock account"
echo "  4 - Make admin"
read -p "Choice [1]: " CHOICE

case $CHOICE in
    2)
        read -p "Enter new password: " NEWPASS
        chntpw -u "$USERNAME" -p "$NEWPASS" SAM
        ;;
    3)
        chntpw -u "$USERNAME" -e SAM <<< "unlock"
        ;;
    4)
        chntpw -u "$USERNAME" -e SAM <<< "admin"
        ;;
    *)
        chntpw -u "$USERNAME" SAM
        ;;
esac

echo ""
echo "Done! Unmounting..."
cd /
umount $MOUNT

echo -e "${GREEN}Password reset complete!${NC}"
echo "Reboot to Windows and login."
EOF

chmod +x /usr/local/bin/win-password-reset

# Create system recovery script
cat > /usr/local/bin/system-recovery << 'EOF'
#!/bin/bash
echo "╔═══════════════════════════════════════╗"
echo "║   SYSTEM RECOVERY MENU              ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "1. Windows Password Reset (chntpw)"
echo "2. Partition Recovery (TestDisk)"
echo "3. File Recovery (PhotoRec)"
echo "4. Boot Repair"
echo "5. Mount Windows"
echo "0. Exit"
read -p "Select: " c
case $c in
    1) win-password-reset ;;
    2) testdisk ;;
    3) photorec ;;
    4) boot-repair ;;
    5) 
        echo "Available partitions:"
        fdisk -l | grep NTFS
        read -p "Partition: " p
        mkdir -p /mnt/win
        mount -t ntfs-3g $p /mnt/win -o force
        echo "Mounted to /mnt/win"
        ;;
esac
EOF

chmod +x /usr/local/bin/system-recovery

# Create boot takeover menu
cat > /usr/local/bin/boot-menu << 'EOF'
#!/bin/bash
echo "╔═══════════════════════════════════════╗"
echo "║   BOOT TAKEOVER & RECOVERY MENU      ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "1. Windows Password Reset"
echo "2. Linux Password Reset"
echo "3. Partition Recovery"
echo "4. File Recovery"
echo "5. Clone Disk"
echo "6. Disk Wipe (DANGEROUS)"
echo "7. Boot Repair"
echo "8. System Info"
echo "9. Network Tools"
echo "0. Exit"
echo ""
read -p "Select: " c
case $c in
    1) win-password-reset ;;
    2) 
        echo "Linux password reset - use 'passwd root' or boot to single user"
        ;;
    3) testdisk ;;
    4) photorec ;;
    5) 
        echo "Usage: dd if=/dev/source of=/dev/target bs=4M status=progress"
        ;;
    6) 
        echo "DANGEROUS - use 'shred' or 'dd' with caution"
        ;;
    7) 
        echo "Boot repair - run: boot-repair"
        ;;
    8) 
        echo "=== SYSTEM INFO ==="
        uname -a
        echo ""
        fdisk -l
        ;;
    9) 
        echo "Network tools: nmap, netdiscover, arp-scan"
        ;;
esac
EOF

chmod +x /usr/local/bin/boot-menu

log "Boot takeover tools installed!"
echo ""
echo "=== Installed Commands ==="
echo "✓ win-password-reset  - Reset Windows password"
echo "✓ system-recovery    - Recovery menu"
echo "✓ boot-menu          - Full boot takeover menu"
echo ""
echo "Run: boot-menu"
