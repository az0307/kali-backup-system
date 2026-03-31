# Hardware Compatibility Guide

## USB Wireless Adapters

### Recommended for Monitoring

| Adapter | Chipset | Monitor | Injection | Driver | Price |
|---------|---------|---------|-----------|--------|-------|
| TP-Link TL-WN721N | AR9271 | ✅ Yes | ✅ Yes | ath9k_htc | $10 |
| Alfa AWUS036NHA | AR9271 | ✅ Yes | ✅ Yes | ath9k_htc | $40 |
| Alfa AWUS036NH | RT3070 | ✅ Yes | ✅ Yes | rt2800usb | $35 |
| TP-Link TL-WN722N v2 | AR9271 | ✅ Yes | ✅ Yes | ath9k_htc | $15 |
| Alfa AWUS1900 | RTL8814AU | ⚠️ Limited | ⚠️ Limited | 8814au | $60 |
| Panda PAU09 | RT5572 | ✅ Yes | ✅ Yes | rt2800usb | $50 |

### Not Recommended

| Adapter | Chipset | Monitor | Injection | Reason |
|---------|---------|---------|-----------|--------|
| Realtek RTL8188EU | RTL8188EU | ❌ | ❌ | No monitor mode support |
| Most built-in WiFi | Various | ⚠️ Limited | ⚠️ Limited | Often blocked by manufacturer |

## Driver Installation

### Atheros AR9271 (TL-WN721N)
```bash
# Check if loaded
lsmod | grep ath9k

# Load manually
modprobe ath9k_htc

# Verify
lsusb | grep 0cf3:9271
# Output: Bus 001 Device 002: ID 0cf3:9271 Atheros Communications AR9271

# Check interface
ip link show
iw dev
```

### Ralink RT3070
```bash
# Load driver
modprobe rt2800usb

# Verify
lsusb | grep 0e8d:3072
```

### Realtek RTL8812AU
```bash
# Install driver (may need to build from source)
apt install realtek-rtl88xxau-dkms
```

## VirtualBox USB Passthrough

### Enable USB for Kali VM
1. Install VirtualBox Extension Pack
2. VM Settings → USB
3. Enable USB Controller (USB 3.0)
4. Add USB Filter:
   - Vendor ID: 0cf3
   - Product ID: 9271

### Command Line Setup
```bash
# List USB devices
VBoxManage list usbhost

# Add USB filter
VBoxManage usbfilter add 0 \
  --name "TL-WN721N" \
  --vendorid 0cf3 \
  --productid 9271 \
  --target "Kali-Linux-Wireless"
```

## Common Issues

### Device Not Detected
```bash
# Check USB
lsusb

# Try different port
# Use USB 2.0 ports when possible

# Reload driver
modprobe -r ath9k_htc
modprobe ath9k_htc
```

### Monitor Mode Fails
```bash
# Kill network managers
airmon-ng check kill
systemctl stop NetworkManager

# Manual enable
ip link set wlan0 down
iw dev wlan0 set type monitor
ip link set wlan0 up

# Verify
iw dev | grep -A3 wlan0
```

### Injection Not Working
```bash
# Check driver supports injection
aireplay-ng -9 wlan0mon

# Get closer to AP
# Most adapters need strong signal

# Try different adapter
```

## Signal Strength Requirements

| Action | Minimum Signal |
|--------|---------------|
| Basic scan | -80 dBm |
| Deauth attack | -70 dBm |
| ARP injection | -60 dBm |
| Fragmentation | -55 dBm |

## External Antennas

For better range, consider:
- Alfa 7dBi antenna
- TP-Link 8dBi antenna
- Mini PCIe cards with antenna connectors
