#!/bin/bash
# Windows Password Reset using chntpw

echo "=== WINDOWS PASSWORD RESET TOOL ==="
echo ""

if [ "$(id -u)" -ne 0 ]; then
   echo "Run with sudo"
   exit 1
fi

echo "Finding Windows partitions..."
fdisk -l | grep -E "NTFS|/dev/sd"

echo ""
read -p "Enter Windows partition (e.g., /dev/sda1): " part

if [ ! -b "$part" ]; then
    echo "Invalid partition"
    exit 1
fi

echo "Mounting $part ..."
mkdir -p /mnt/win
mount "$part" /mnt/win

if [ ! -f "/mnt/win/Windows/System32/config/SAM" ]; then
    echo "SAM file not found - is this Windows?"
    umount /mnt/win
    exit 1
fi

echo "SAM found. Launching chntpw..."
cd /mnt/win/Windows/System32/config
chntpw -i SAM

echo ""
echo "Unmounting..."
cd /
umount /mnt/win

echo "Done! Reboot and remove USB."
