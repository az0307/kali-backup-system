# USB WiFi Adapter Fix for Kali VM

## Problem: TP-Link TL-WN721N not detected

### Step 1: Check if USB is being passed through

In VirtualBox:
1. Make sure VM is **powered off** (not saved state)
2. Right-click Kali → Settings → USB
3. Enable **USB 3.0 (xHCI) Controller**
4. Add filter: Devices → USB → Add new → TP-Link

### Step 2: In Kali - Check USB devices
```bash
lsusb
# Look for: TP-Link or 0bda:8179
```

### Step 3: Install driver
```bash
apt update
apt install firmware-atheros
```

### Step 4: Check wireless interface
```bash
ip link show
iw dev
```

### Step 5: Common fixes
```bash
# Kill network manager interference
airmon-ng check kill

# Load driver
modprobe ath9k_htc

# Check dmesg
dmesg | grep -i usb
dmesg | grep -i ath
```

### Step 6: If still not working
```bash
# Install VirtualBox Extension Pack
# Download from: https://www.virtualbox.org/wiki/Downloads

# Make sure USB 3.0 is enabled in BIOS
```

---

## Quick Fix Script
```bash
#!/bin/bash
echo "Fixing USB WiFi..."

# Check USB
lsusb | grep -i tp-link || echo "TP-Link not found!"

# Install firmware
apt install firmware-atheros -y

# Load driver
modprobe ath9k_htc

# Check
iw dev
```
