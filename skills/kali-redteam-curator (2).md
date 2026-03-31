---
name: kali-redteam-curator
description: >
  Master skill for Kali Linux penetration testing, red team operations, and wireless security.
  Use for: pentesting, wireless auditing, WiFi cracking, network security, red team engagements.
  Triggers: aircrack-ng, nmap, metasploit, hashcat, monitor mode, WPA handshake, privilege escalation,
  social engineering, physical security, Flipper Zero, Raspberry Pi hacking, hardware security.
  This is the MASTER CURATOR skill that references all specialized sub-skills and reference files.
compatibility:
  tools: [bash, python3, git, nmap, aircrack-ng, metasploit]
  os: [linux, kali]
---

# Kali Linux Red Team - Master Curator

## Quick Commands

### Wireless
```bash
airmon-ng start wlan0           # Monitor mode
airodump-ng wlan0mon            # Scan networks
aireplay-ng --deauth 10 -a BSSID wlan0mon  # Deauth
aircrack-ng -w wordlist.cap     # Crack
```

### Network
```bash
nmap -sV -sC target.com       # Scan
msfconsole                     # Metasploit
```

### Start Here
```bash
# Choose your domain:
```

---

## Specializations (Delegates)

### For Specific Tasks, Use These Skills:

| Domain | When to Use |
|--------|---------------|
| **Wireless** | WiFi auditing, monitor mode, handshakes |
| **Web-App** | SQLi, XSS, web testing |
| **Scripts** | Writing automation scripts |
| **Physical** | Hardware, Flipper, RFID, NFC |
| **Learning** | Study guides, CTF practice |
| **Hardware** | Raspberry Pi, equipment |

---

## Reference Files

### Core Knowledge
| File | What's Inside |
|------|----------------|
| [commands.md](references/commands.md) | Complete command reference |
| [packages.md](references/packages.md) | Tool installation |
| [templates.md](references/templates.md) | Script templates |
| [hardware.md](references/hardware.md) | Adapter compatibility |
| [virtualbox-setup.md](references/virtualbox-setup.md) | VM configuration |

### Deep Dives
| File | What's Inside |
|------|----------------|
| [deepdive-complete.md](references/deepdive-complete.md) | Old school → Modern → Stealth → Brute → Crypto → Pivoting → Post-exploit |
| [automation-learning.md](references/automation-learning.md) | Learning system, reports, Google Sheets, email, MCP, hooks |
| [ai-2026.md](references/ai-2026.md) | Emerging AI tools, Cloud APIs, 2026 techniques |
| [legal.md](references/legal.md) | Authorization templates |
| [equipment-complete.md](references/equipment-complete.md) | Complete hardware, schematics, builds, levels |
| [hardware-platforms.md](references/hardware-platforms.md) | Pi, Flipper, ESP32 details |

---

## Equipment Guide

### Wireless Adapters
| Device | Chipset | Price | Notes |
|--------|---------|-------|-------|
| TP-Link TL-WN721N | AR9271 | $10 | Your device! |
| Alfa AWUS036NHA | AR9271 | $40 | Best budget |
| Alfa AWUS036NH | RT3070 | $35 | Good all-around |

### Hardware Platforms
| Platform | Use | Price |
|----------|-----|-------|
| Raspberry Pi | Portable lab | $15-80 |
| Flipper Zero | RF/NFC/HID | $170 |
| ESP32 | WiFi attacks | $10-15 |

For complete guide → see [references/hardware-platforms.md]

### Software
| Tool | Use |
|------|-----|
| VirtualBox | VM (FREE) |
| Kali Linux | Pentest OS (FREE) |
| Gemini CLI | AI Assistant (FREE in Kali!) |

---

## AI Integration

### In Kali (Already Free!)
```bash
sudo apt install gemini-cli
gemini --prompt "help with nmap scan"
```

### Cloud APIs (No Local GPU)
```bash
# HexStrike AI (already in your workspace)
# Run: python3 hexstrike_server.py
```

---

## Automation

### Quick Report
```bash
./generate-report.sh
```

### Google Sheets
See [automation-learning.md](references/automation-learning.md) for API setup.

---

## Legal Reminder
⚠️ Only test systems you own or have written authorization to test!

---

## Checklist

- [ ] Authorization letter signed
- [ ] Scope defined
- [ ] Tools tested
- [ ] Equipment ready
- [ ] Reports set up
