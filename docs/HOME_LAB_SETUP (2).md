# 🏠 Home Lab Multi-Device Orchestration
## Complete Setup Guide - 2026

---

## 📋 DEVICE INVENTORY

| Device | Type | IP Address | Purpose |
|--------|------|------------|---------|
| **Windows Host** | Primary PC | 192.168.1.100 | Control Center |
| **Kali VM** | VirtualBox | 192.168.1.50 | Pentesting |
| **XP Laptop** | Old PC (400GB) | 10.0.0.66 | NAS/Storage |
| **OPPO Phone** | Android | TBD | Mobile AI |
| **Huawei Hotspot** | Mobile Data | 192.168.1.1 | Internet |
| **TP-Link** | WiFi Adapter | USB | Monitor Mode |

---

## 🚀 QUICK START

### 1. Run the Launcher
```bash
# Windows - Double click this file:
scripts/home-lab-launcher.bat
```

### 2. Or manually connect to devices:
```bash
# SSH to Kali
ssh root@192.168.1.50

# SSH to XP Laptop  
ssh administrator@10.0.0.66

# Connect to OPPO (via USB)
adb forward tcp:8022 tcp:8022
ssh -p 8022 localhost
```

---

## 📁 SCRIPT FILES

### Windows Scripts (run from Windows)
| Script | Purpose |
|--------|---------|
| `home-lab-launcher.bat` | Main menu launcher |
| `create-kali-graphical.bat` | Create new Kali VM |
| `ai-dashboard.ps1` | PowerShell dashboard |
| `ai-launcher.bat` | Quick AI tool launcher |

### Linux Scripts (copy to Kali/XP)
| Script | Purpose |
|--------|---------|
| `enhance-kali-v3.sh` | Full Kali enhancement |
| `home-lab-orchestrator.sh` | Multi-device control |
| `wireless-quick.sh` | Quick wireless commands |
| `hotspot-monitor.sh` | Monitor Huawei |

---

## 🔧 SETUP BY DEVICE

### Windows Host (This PC)
**Already configured with:**
- OpenCode v1.2.25
- Claude Code v2.1.76  
- Gemini CLI v0.33.1
- TARS v0.3.0
- 19 MCP servers (via Claude)

### Kali VM
**To install, run in Kali:**
```bash
# Quick install
curl -fsSL https://raw.githubusercontent.com/.../quick-install-kali.sh | sudo bash

# Or manual
sudo ./enhance-kali-v3.sh
```

**Features:**
- AI Tools (OpenCode, Gemini, TARS)
- Zsh + Oh My Zsh + Powerlevel10k
- Pentest tools (aircrack-ng, metasploit, etc.)
- Modern CLI (bat, eza, btop)
- Docker

### XP Laptop (400GB)
**Recommended uses:**
1. **NAS** - Share 400GB on network
2. **Backup** - Store VM backups, wordlists
3. **Target** - Practice Windows exploitation

**Setup:**
```batch
# On XP, run:
xp-setup.bat      # Basic setup
xp-nas.bat       # Convert to NAS
```

### OPPO Phone
**Installation:**
1. Install F-Droid (not Play Store!)
2. Install Termux from F-Droid
3. Run in Termux:
```bash
pkg update && pkg upgrade
pkg install git curl wget python nodejs
npm install -g opencode-ai @google/gemini-cli
```

**Connect:**
```bash
# Via USB (recommended)
adb forward tcp:8022 tcp:8022
ssh -p 8022 localhost

# Via WiFi (same network)
ssh -p 22 root@<phone-ip>
```

### Huawei Hotspot
**Default IP:** 192.168.1.1 or 192.168.8.1
**Default login:** admin / admin

**Features to enable:**
- USB tethering for Kali
- Port forwarding
- Data usage monitoring

### TP-Link TL-WN721N
**Chipset:** Atheros AR9271
**Status:** Monitor mode supported ✅

**Commands:**
```bash
# In Kali
sudo airmon-ng          # Check interfaces
sudo airmon-ng start wlan0   # Start monitor
sudo airodump-ng wlan0mon    # Scan networks
```

---

## 🔄 WORKFLOW EXAMPLES

### Full Pentest Workflow
```
1. home-lab-launcher.bat
2. [B] Start Kali VM  
3. [G] Connect TP-Link adapter
4. [B] SSH to Kali
5. Run wireless reconnaissance
6. [I] Save captures to XP NAS
```

### Mobile AI Workflow
```
1. [D] Connect OPPO via USB
2. Enable USB debugging
3. Run AI tools on Termux
4. [J] Sync scripts between devices
```

### Backup Workflow
```
1. [I] Backup Kali to XP
2. [I] Copy wordlists to Kali
3. [J] Sync all devices
```

---

## 📊 NETWORK DIAGRAM

```
                    ┌─────────────────┐
                    │  HUAWEI         │
                    │  HOTSPOT        │ ◄── Mobile Data (4G)
                    │  192.168.1.1    │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │   WINDOWS    │  │   KALI VM    │  │  XP LAPTOP  │
    │   HOST       │  │  (Pentest)   │  │  (NAS)      │
    │ 192.168.1.100│  │ 192.168.1.50│  │ 10.0.0.66   │
    └─────────────┘  └─────────────┘  └─────────────┘
              │              │              │
              │    ┌─────────┴─────────┐    │
              │    │                   │    │
              ▼    ▼                   ▼    ▼
              ┌─────────────────────────────┐
              │     OPPO PHONE             │
              │     (Termux + AI)          │
              │     TBD                    │
              └─────────────────────────────┘
              
              ┌─────────────────────────────┐
              │   TP-LINK TL-WN721N        │
              │   (Atheros AR9271)         │
              │   USB → Kali VM            │
              └─────────────────────────────┘
```

---

## ⚡ QUICK COMMANDS

### Windows
```batch
home-lab-launcher.bat           # Main menu
ai-launcher.bat               # Quick AI tools
```

### Kali
```bash
./ai-menu.sh                  # Dashboard
opencode                     # AI Coding
gemini                       # Google AI
agent-tars                  # TARS Agent
sudo airmon-ng             # Check WiFi
```

### Network Scan
```bash
# Find all devices
for /L %i in (1,1,254) do @ping -n 1 -w 100 192.168.1.%i | find "Reply"
```

---

## 🔧 TROUBLESHOOTING

### Can't connect to Kali?
```bash
# Check if VM is running
VBoxManage list runningvms

# Start VM
VBoxManage startvm "Kali-Linux-Wireless"

# Get IP
ssh root@192.168.1.50 "hostname -I"
```

### Can't connect to XP?
```bash
# Check IP
arp -a | findstr "255"

# Try different subnet
ping 10.0.0.66
```

### OPPO not detected?
```bash
# Restart ADB
adb kill-server
adb start-server

# Enable USB debugging on phone
# Settings → Developer Options → USB Debugging
```

---

## 📝 NOTES

- XP Laptop IP: 10.0.0.66 (not on 192.168.1.x!)
- Kali IP: 192.168.1.50 (via bridged adapter)
- OPPO: Use USB for stable connection
- TP-Link: Must be passed through to Kali VM (USB filter)

---

**Last Updated:** 2026-03-16
**Version:** 1.0
