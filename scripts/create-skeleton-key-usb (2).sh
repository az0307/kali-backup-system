#!/bin/bash
# ====================================================================
# AUTO-BOOT SKELETON KEY USB Creator
# Creates USB that auto-boots and can reset Windows password
# ====================================================================

echo "=== SKELETON KEY USB CREATOR ==="
echo ""
echo "This will modify boot to auto-run password reset"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo $0"
    exit 1
fi

# Get USB device
echo "Available drives:"
lsblk -o NAME,SIZE,TYPE | grep sd

read -p "Enter USB device (e.g., sdb): " USB_DEVICE
DEVICE="/dev/$USB_DEVICE"

# Mount USB
MOUNT="/mnt/usb"
mkdir -p $MOUNT
mount ${DEVICE}1 $MOUNT

echo ""
echo "=== CREATING AUTO-BOOT MENU ==="

# Create custom grub config
cat > $MOUNT/boot/grub/custom.cfg << 'EOF'
# Custom Boot Menu

menuentry "Kali Live - Standard" {
    set root='(hd0,1)'
    linux /live/vmlinuz boot=live components
    initrd /live/initrd.img
}

menuentry "Kali Live - RAM Mode (All Tools)" {
    set root='(hd0,1)'
    linux /live/vmlinuz boot=live components persistence
    initrd /live/initrd.img
}

menuentry "Windows Password Reset" {
    set root='(hd0,1)'
    linux /live/vmlinuz boot=live components
    initrd /live/initrd.img
}
EOF

# Create auto-reset script
cat > $MOUNT/auto-reset.sh << 'EOF'
#!/bin/bash
# Auto Windows Password Reset

echo "=== WINDOWS PASSWORD RESET ==="
echo "This will reset Windows admin password"
echo ""

# Find Windows partitions
echo "Available partitions:"
fdisk -l | grep NTFS

read -p "Enter Windows partition (e.g., /dev/sda1): " PARTITION

if [ ! -b "$PARTITION" ]; then
    echo "Invalid partition!"
    exit 1
fi

# Mount
MOUNT="/mnt/windows"
mkdir -p $MOUNT
mount -t ntfs-3g $PARTITION $MOUNT -o force

if [ ! -f "$MOUNT/Windows/system32/config/SAM" ]; then
    echo "Windows SAM not found!"
    umount $MOUNT 2>/dev/null
    exit 1
fi

cd $MOUNT/Windows/system32/config

echo ""
echo "Users found:"
chntpw -l SAM

read -p "Enter username to reset: " USERNAME

echo ""
echo "Options:"
echo "1. Clear password (blank)"
echo "2. Set new password"
read -p "Choice [1]: " CHOICE

case $CHOICE in
    2)
        read -p "Enter new password: " NEWPASS
        chntpw -u "$USERNAME" -p "$NEWPASS" SAM
        ;;
    *)
        chntpw -u "$USERNAME" SAM <<< "1"
        ;;
esac

cd /
umount $MOUNT

echo ""
echo "Password reset complete!"
echo "Reboot to Windows"
read -p "Press Enter to reboot..."
reboot
EOF

chmod +x $MOUNT/auto-reset.sh

# Create startup script
cat > $MOUNT/start.sh << 'EOF'
#!/bin/bash
echo "╔═══════════════════════════════════════╗"
echo "║   SKELETON KEY USB v1.0              ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "1. Windows Password Reset"
echo "2. Kali Live Standard"
echo "3. Kali RAM Mode"
echo "4. Exit to Shell"
echo ""
read -p "Select: " CHOICE

case $CHOICE in
    1) /mnt/auto-reset.sh ;;
    2) systemctl start graphical ;;
    3) systemctl start graphical ;;
    4) /bin/bash ;;
esac
EOF

chmod +x $MOUNT/start.sh

echo ""
echo "=== INSTALLED ==="
echo "Auto-boot options created"
echo ""
echo "To use:"
echo "1. Boot to Kali Live"
echo "2. Run: /mnt/start.sh"
echo "3. Select password reset"
echo ""
echo "Files created:"
ls -la $MOUNT/*.sh
