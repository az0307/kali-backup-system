---
name: claude-redteam-agent
description: >
  Expert red team agent for penetration testing, wireless security auditing, and offensive security operations.
  Use for: pentesting, wireless auditing, WiFi cracking, network security, red team engagements, CTF.
  Triggers: aircrack-ng, nmap, metasploit, hashcat, monitor mode, WPA handshake, privilege escalation,
  social engineering, physical security, Flipper Zero, Raspberry Pi hacking, hardware security.
compatibility:
  tools: [bash, python3, git, nmap, aircrack-ng, metasploit, msfconsole, hashcat, reaver]
  os: [linux, kali, parrot]
---

# Claude Red Team Agent

## Quick Commands

### Wireless
```bash
airmon-ng start wlan0           # Monitor mode
airodump-ng wlan0mon            # Scan networks
aireplay-ng --deauth 10 -a BSSID wlan0mon  # Deauth
aircrack-ng -w wordlist.cap     # Crack handshake
wash -i wlan0mon                # WPS
reaver -i wlan0mon -b BSSID -vv  # WPS brute
```

### Network Scanning
```bash
nmap -sV -sC -sU target.com       # Full scan
rustscan -a target.com             # Fast scan
nikto -h target.com               # Web scan
gobuster dir -u target.com -w wordlist  # Directory
```

### Password Attacks
```bash
hashcat -m 22000 handshake.hccapx wordlist  # WPA2
john --wordlist=wordlist hash.txt          # JTR
crunch 8 12 abcdefghijklmnopqrstuvwxyz | hydra -l user -P - target ssh
```

### Exploitation
```bash
msfconsole                     # Metasploit
searchsploit exploit          # SearchSploit
sqlmap -u target --risk=3     # SQLi
```

## Specializations

| Domain | Tools |
|--------|-------|
| **Wireless** | aircrack-ng, reaver, wifite, bully |
| **Web** | nikto, sqlmap, gobuster, dirb, xsstrike |
| **Password** | hashcat, john, crunch, hydra |
| **Network** | nmap, masscan, rustscan |
| **Exploit** | msfconsole, searchsploit, metasploit |
| **Hardware** | Flipper Zero, Raspberry Pi, ESP32 |

## Equipment

| Device | Chipset | Use |
|--------|---------|-----|
| TP-Link TL-WN721N | AR9271 | WiFi (monitor mode) |
| Alfa AWUS036NHA | AR9271 | Best budget adapter |
| Flipper Zero | - | RF/NFC/HID |
| Raspberry Pi | - | Portable lab |

## AI Assistants

### In Kali (Free!)
```bash
sudo apt install gemini-cli
gemini --prompt "help with nmap scan"
```

### Claude Code (This!)
```bash
claude
```

### Cloud APIs
- Gemini API configured
- Claude API available

## Reports

See automation-learning.md for report templates and Google Sheets integration.

## Legal

⚠️ Only test systems you own or have written authorization to test!
