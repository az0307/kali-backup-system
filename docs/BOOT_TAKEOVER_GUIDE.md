# Boot Takeover & Password Recovery Guide

## Overview

This guide covers password reset and system recovery tools in the home lab.

## Quick Start

```bash
# Launch boot menu
go boot-menu

# Or use directly
win-password-reset
system-recovery
boot-menu
```

## Installed Tools

### 1. chntpw

Windows NT password editor - resets Windows passwords offline.

```bash
# Install (if not present)
sudo apt install chntpw ntfs-3g
```

### 2. TestDisk

Partition recovery tool.

```bash
# Install
sudo apt install testdisk

# Run
sudo testdisk
```

### 3. PhotoRec

File recovery tool.

```bash
# Install
sudo apt install photorec

# Run
sudo photorec
```

## Windows Password Reset

### Method 1: Using win-password-reset Script

```bash
# Run the script
sudo win-password-reset

# Follow prompts:
# 1. Select Windows partition
# 2. List users
# 3. Choose action:
#    - Clear password (blank)
#    - Set new password
#    - Unlock account
#    - Make admin
```

### Method 2: Manual

```bash
# 1. List partitions
sudo fdisk -l | grep NTFS

# 2. Mount Windows
sudo mkdir /mnt/win
sudo mount -t ntfs-3g /dev/sda1 /mnt/win -o force

# 3. Navigate to SAM
cd /mnt/win/Windows/system32/config

# 4. List users
sudo chntpw -l SAM

# 5. Reset password
sudo chntpw -u "Username" SAM

# 6. Choose option:
# 1 - Clear password
# 2 - Set new password
# 3 - Unlock account
# 4 - Make admin
# q - Quit

# 7. Unmount
cd /
sudo umount /mnt/win
```

### Method 3: Using chntpw Interactive

```bash
cd /mnt/win/Windows/system32/config
chntpw -u "Administrator" SAM

# Menu options:
# 1 - Clear (blank) user password
# 2 - Edit (change) user password
# 3 - Promote user (make admin)
# 4 - Unlock and enable user account
# q - Quit
```

## Linux Password Reset

### Reset Root Password

```bash
# At GRUB menu:
# 1. Press 'e' to edit
# 2. Add 'init=/bin/bash' to linux line
# 3. Press Ctrl+X to boot

# Then:
mount -rw -o remount /
passwd root
sync
reboot
```

### Reset User Password

```bash
# As root:
passwd username
```

## Boot Menu Commands

```bash
# Main boot menu
boot-menu

# System recovery
system-recovery

# Windows password reset
win-password-reset
```

## Recovery Options

### 1. Partition Recovery (TestDisk)

```bash
# Launch
sudo testdisk

# Steps:
# 1. Select disk
# 2. Choose partition type
# 3. Analyze
# 4. Select partition
# 5. Write recovery
```

### 2. File Recovery (PhotoRec)

```bash
# Launch
sudo photorec

# Steps:
# 1. Select disk
# 2. Choose partition
# 3. Select file types
# 4. Choose recovery location
# 5. Start recovery
```

### 3. Boot Repair

```bash
# Install
sudo apt install boot-repair

# Run
sudo boot-repair
```

## Boot Menu Options

```
1. Windows Password Reset    - Reset Windows login password
2. Linux Password Reset     - Reset Linux password
3. Partition Recovery       - Recover lost partitions
4. File Recovery           - Recover deleted files
5. Clone Disk              - Clone entire disk
6. Disk Wipe               - Securely wipe disk (DANGEROUS)
7. Boot Repair             - Fix boot issues
8. System Info            - View system information
9. Network Tools          - Network utilities
0. Exit
```

## Common Scenarios

### Scenario 1: Forgot Windows Password

```bash
# Boot Kali Live USB
# Run:
sudo win-password-reset

# Select:
# - Windows partition (usually /dev/sda1)
# - User account
# - Option 1: Clear password

# Reboot to Windows
```

### Scenario 2: Locked Out of Linux

```bash
# Boot to GRUB
# Edit boot entry
# Add: init=/bin/bash

# Reset password
mount -rw -o remount /
passwd root
reboot
```

### Scenario 3: Corrupted Boot

```bash
# Boot Kali Live USB
# Run:
sudo boot-repair

# Follow wizard
```

### Scenario 4: Accidentally Deleted Partition

```bash
# Boot Kali Live USB
# Run:
sudo testdisk

# Steps:
# 1. Select disk
# 2. Analyze
# 3. Find lost partition
# 4. Write
```

## Precautions

⚠️ **Important:**

1. **Always backup** data before modifying partitions
2. **Verify partition** before resetting passwords
3. **Use read-only** mode when possible for recovery
4. **Document original** partition layout

## Troubleshooting

### "Permission Denied" when mounting
```bash
# Use force option
mount -t ntfs-3g /dev/sda1 /mnt/win -o force
```

### SAM file not found
```bash
# Check correct partition
fdisk -l
ls /mnt/win/Windows/system32/config/
```

### NTFS partition busy
```bash
# Unmount first
umount /dev/sda1
# Or use lazy unmount
umount -l /dev/sda1
```

## Legal Notice

⚠️ **FOR AUTHORIZED USE ONLY**

These tools are for:
- Password recovery on your own systems
- System administration tasks
- Emergency access recovery

**DO NOT** use on systems you don't own.

---

*Updated: 2026-03-26*
