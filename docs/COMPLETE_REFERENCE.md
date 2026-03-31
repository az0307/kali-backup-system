# Home Lab - Complete Reference Guide

## Table of Contents
1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Go Command Reference](#go-command-reference)
4. [Scripts](#scripts)
5. [Chains](#chains)
6. [Skills](#skills)
7. [Agents](#agents)
8. [Tools](#tools)
9. [Network Configuration](#network-configuration)
10. [Troubleshooting](#troubleshooting)

---

## Overview

This is a comprehensive pentesting home lab setup with:
- **Kali Linux** - Primary pentest distribution
- **AI Tools** - OpenCode, Claude Code, Gemini CLI, HexStrike, KaliGPT
- **WiFi Tools** - Aircrack-ng suite, Fluxion, Wifyte, WiFiSentry
- **Network Tools** - Nmap, Naabu, Httpx, Nuclei, AutoRecon
- **Recovery Tools** - chntpw, TestDisk, PhotoRec
- **Full Automation** - `go` command for unified control

---

## Quick Start

### On Kali Live USB

```bash
# 1. Run complete setup
sudo bash /root/KaliShare/scripts/home-lab-complete.sh

# 2. Verify installation
go validate

# 3. Check status
go status
```

### Network Setup

| Machine | IP | Role |
|---------|-----|------|
| Laptop (Kali VM) | 192.168.1.100 | Main attack box |
| Desktop (Target) | 192.168.1.200 | Target for practice |
| WiFi Adapter | N/A | TP-Link AR9271 |

---

## Go Command Reference

### Network Commands
```bash
go pentest <target>       # Full AI pentest (HexStrike)
go full <target>         # Full manual pentest
go quick <target>        # Quick scan
go web <target>          # Web app test
go exploit <target>      # Exploitation
go grab <ip> <file>      # Grab file from target
go drop <ip> <file>      # Drop file to target
go stealth <target>      # Low-profile scan
go auto <target>         # Fully automatic
```

### WiFi Commands
```bash
go wifi                  # Start basic WiFi audit
go wifi-menu            # Full WiFi tools menu
go wifyte              # Run Wifyte tool
go fluxion             # Run Fluxion attack
go wpa <bssid>         # Capture WPA handshake
go deauth <bssid>      # Deauth attack
go crack <handshake>   # Crack handshake
```

### Boot & Recovery Commands
```bash
go boot-menu            # Boot takeover menu
go win-reset           # Windows password reset
go recovery            # System recovery tools
```

### Recon Commands
```bash
go recon               # Install recon tools
go recon-menu          # Full recon tools menu
```

### AI & Setup Commands
```bash
go ai-install          # Install all AI tools
go ai-pentest-tools    # Install AI pentest frameworks
go opencode           # Install OpenCode plugins
go home-lab           # Setup complete home lab
go validate           # Check tools
go update             # Update tools
go report             # Generate report
go status             # Check systems
```

---

## Scripts

### Core Setup Scripts

| Script | Purpose |
|--------|---------|
| `home-lab-complete.sh` | Complete home lab setup |
| `install-best-opencode-tools.sh` | OpenCode plugins |
| `install-wifi-tools.sh` | WiFi pentesting tools |
| `install-ai-pentest-tools.sh` | AI pentest frameworks |
| `boot-takeover-tools.sh` | Password reset tools |
| `install-recon-tools.sh` | Network recon tools |

### Usage
```bash
# Run any script
sudo bash /root/KaliShare/scripts/<script-name>.sh

# Or copy to system
sudo cp /root/KaliShare/cli/go /usr/local/bin/go
go home-lab
```

---

## Chains

Chains are automated workflows for common tasks.

### Available Chains

| Chain | Purpose |
|-------|---------|
| `full-recon` | Complete network reconnaissance |
| `wifi-audit` | Wireless security assessment |
| `boot-takeover` | Password reset & recovery |
| `ai-pentest` | AI-powered pentest |
| `network-pivot` | Internal network pivoting |
| `credential-harvest` | Credential gathering |
| `home-lab-setup` | Initial setup |

### Usage
```bash
# Run a chain
cd /root/KaliShare/chains
./<chain-name>.md  # Manual execution
```

---

## Skills

Skills are specialized capabilities for the AI agents.

### Red Team Skills
- `network-scanner.md` - Network scanning
- `wifi-auditor.md` - WiFi auditing
- `recon-agent.md` - reconnaissance
- `exploit-finder.md` - Exploit discovery

### System Skills
- `backup-manager.md` - Backup operations
- `hardening.md` - System hardening

### Hybrid Skills
- `orchestrator.md` - Task coordination
- `ssh-manager.md` - SSH management

---

## Agents

Specialized AI agents for different tasks.

| Agent | Purpose |
|-------|---------|
| `redteam-agent.md` | Red team operations |
| `dev-agent.md` | Development tasks |
| `monitor-agent.md` | System monitoring |
| `orchestrator-agent.md` | Task orchestration |

---

## Tools

### Installed Tools

#### Network Scanning
- **nmap** - Port scanner
- **naabu** - Fast port scanner
- **masscan** - High-speed scanner

#### Web Testing
- **nikto** - Web scanner
- **gobuster** - Directory busting
- **sqlmap** - SQL injection
- **httpx** - HTTP probing
- **nuclei** - Vulnerability scanner

#### WiFi Tools
- **aircrack-ng** - WiFi cracking
- **reaver** - WPS attack
- **wifite** - Automated WiFi
- **Fluxion** - WPA phishing
- **WiFiSentry** - Rogue AP detection

#### Password Tools
- **hashcat** - GPU password cracking
- **john** - Password cracker
- **hydra** - Login brute-force
- **chntpw** - Windows password reset

#### AI Tools
- **OpenCode** - AI coding assistant
- **Claude Code** - Anthropic CLI
- **Gemini CLI** - Google AI
- **HexStrike** - Pentest AI
- **KaliGPT** - Kali AI assistant

---

## Network Configuration

### IP Settings
```
Laptop: 192.168.1.100/24
Gateway: 192.168.1.1
Desktop Target: 192.168.1.200
```

### WiFi Credentials
```
Network: Melton 1
Password: meltonone

Network: TelstraBF869B
Password: E3CF746CF4
```

### Adapter
- **TP-Link TL-WN722N** (Atheros AR9271)
- Works in Linux/Kali
- Requires monitor mode driver in Windows

---

## Troubleshooting

### USB Not Mounting
```bash
# Check available drives
fdisk -l

# Mount manually
mkdir -p /mnt/usb
mount /dev/sdb1 /mnt/usb
```

### Network Issues
```bash
# Restart networking
systemctl restart networking

# Check IP
ip addr show eth0

# Test connectivity
ping 8.8.8.8
```

### Tool Not Found
```bash
# Update path
export PATH=$PATH:/usr/local/bin

# Install missing tools
go update
```

### WiFi Adapter Issues
```bash
# Check interface
iwconfig

# Kill interfering processes
airmon-ng check kill

# Restart adapter
airmon-ng start wlan0
```

---

## Quick Reference Commands

```bash
# Full setup
go home-lab

# Quick scan
go quick 192.168.1.1

# WiFi audit
go wifi-menu

# Windows password reset
go win-reset

# Check status
go status
```

---

## File Locations

| Item | Location |
|------|----------|
| Scripts | `/root/KaliShare/scripts/` |
| Go command | `/root/KaliShare/cli/go` |
| Chains | `/root/KaliShare/chains/` |
| Skills | `/root/KaliShare/skills/` |
| Agents | `/root/KaliShare/agents/` |
| Docs | `/root/KaliShare/docs/` |

---

## Legal Notice

⚠️ **FOR AUTHORIZED USE ONLY**

This tools are for:
- Penetration testing with authorization
- Security research on your own systems
- Learning in a lab environment
- CTF competitions

**DO NOT** use on systems you don't own or don't have explicit permission to test.

---

*Last Updated: 2026-03-26*
*Version: 3.0*
