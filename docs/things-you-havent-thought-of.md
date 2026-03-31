# Things You Haven't Thought Of

## 🖧 Network Storage & Archives

### For Large Files (Wordlists, PCAPs, Reports)
```bash
# Store on external/network drive
# Don't clutter your VM!

# Suggested external storage:
# - USB flash drive (32GB+)
# - External SSD  
# - Network NAS

# Or cloud:
# - Google Drive
# - Dropbox
# - Mega.nz (free, encrypted)
```

### Archives to Keep
- PCAP files from captures
- Cracked handshakes
- Custom wordlists
- Screenshots
- Notes

---

## ☁️ Cloud Options (For Heavy Lifting)

### When VM is Too Slow
| Service | Use For | Cost |
|---------|---------|------|
| **Kali on Cloud** | Full Kali in cloud | $ |
| **Google Colab** | AI tools, no install | Free |
| **Paperspace** | GPU for hashcat | $$ |
| **Lambda Labs** | GPU instances | $$ |
| **Hetzner** | Cheap VPS | $ |

### Quick Cloud Access
```bash
# Google Colab - Run anywhere
# https://colab.research.google.com

# Spawn cloud Kali
# https://www.kali.org/get-kali/#cloud

# Use in combination
# - Host: Web research, documentation
# - Cloud VM: Heavy tools
# - Local VM: Quick checks
```

---

## 📱 Mobile Alternatives

### On Your Phone (Instead of VM for Some Things)
| App | Use For |
|-----|---------|
| **Termux** | Linux on phone |
| **Hacker's Keyboard** | Better keyboard |
| **BusyBox** | Linux utils |
| **Root Explorer** | File management |
| **Network Scanner** | Quick scans |
| **WiFi Analyzer** | Signal strength |

### iOS Alternatives
| App | Use For |
|-----|---------|
| **iSH** | Linux shell |
| **Termius** | SSH client |
| **Promon** | Security |

---

## ⏰ Timing Considerations

### When to Use What
| Time | Tool | Why |
|------|------|-----|
| Quick check | Gemini CLI | Free, fast |
| Learning | OpenCode/Claude | Explains things |
| Heavy attack | Cloud VM | Don't strain laptop |
| Practice | HackTheBox | Legal |
| Late night | All quiet | Less detection |

### Energy Saving
```bash
# Run during:
# - While laptop plugged in
# - Not on battery
# - Good ventilation

# Don't run:
# - On battery
# - In bed (overheating)
# - While doing other work
```

---

## 🔐 Physical Security

### What You Need
| Item | Use |
|------|-----|
| Privacy screen | Hide from others |
| Laptop lock | Physical theft |
| Faraday bag | Block wireless |
| USB cover | Prevent juice jacking |
| Ethernet cable | Avoid public WiFi |

### Burner Mindset
- Use separate email for accounts
- Don't use personal info
- VPN always
- Clear browser after

---

## 🧪 Practice Platforms

### Free Learning
| Platform | Focus | URL |
|----------|-------|-----|
| **HackTheBox** | Pen testing | hackthebox.com |
| **TryHackMe** | Beginners | tryhackme.com |
| **PentesterLab** | Web | pentesterlab.com |
| **OverTheWire** | Linux wargames | overthewire.org |
| **Root Me** | CTF | root-me.org |
| **VulnHub** | Vulnerable VMs | vulnhub.com |

### Paid (Worth It)
- TryHackMe Subscription ($10/mo)
- HackTheBox Subscription
- OffSec Pro ($1200)

---

## 📊 Reporting Tools

### Automate Reports
```bash
# Already in tools:
# - nikto - report
# - nmap -oX report.xml
# - sqlmap -v --batch

# For professional reports:
# - SerpReporter
# - Dradis
# - Faraday
```

### Report Templates
```markdown
# Quick report template:
## Scope
## Findings
## Evidence
## Impact
## Remediation
```

---

## 🐳 Docker Isolation

### Run Tools in Containers
```bash
# Don't install everything globally
# Use Docker for isolation

# Example: run nmap in container
docker run -it --rm kalilinux/kali-linux:latest \
    nmap -sV target.com

# Pre-built Kali container
docker pull kalilinux/kali-linux-docker
```

---

## 🔄 Backup Strategy

### What to Backup
- [ ] VM snapshots (before updates)
- [ ] Custom wordlists
- [ ] Scripts you wrote
- [ ] API keys (securely!)
- [ ] Notes/research

### Don't Backup
- [ ] Crack passwords
- [ ] Evidence (legal)
- [ ] Downloads from targets

---

## 🎯 Less Known Tools

### Hidden Gems
| Tool | Use |
|------|-----|
| **CyberChef** | Data decoding |
| **Wireshark** | Packet analysis |
| **Burp Suite** | Web testing |
| **Ghidra** | Reverse engineering |
| **Volatility** | Memory forensics |
| **Autopsy** | File recovery |
| **Snort** | Intrusion detection |
| **Zeek** | Network monitoring |

---

## 💡 Pro Tips

1. **Label your USB adapter** - Don't lose it
2. **Take notes in real-time** - You'll forget
3. **Screenshot everything** - For reports
4. **Use password manager** - Bitwarden (you have it!)
5. **Check your tools before engagements** - Test first
6. **Know your limits** - Don't overcommit
7. **Document what works** - Future you will thank you

---

## ⚠️ Things That Go Wrong

### Common Issues
- USB adapter not detected → Try different port
- VM slow → Close other apps
- Tools not working → Update them
- Internet slow → Check VPN
- VM won't start → Take snapshot!

### Prevention
```bash
# Before engagement:
- Test WiFi adapter
- Test internet
- Test tools work
- Have backup plan
- Know target scope
```

---

## 🆘 Quick Reference Card

```
┌─────────────────────────────────────────────┐
│  QUICK ACCESS                              │
├─────────────────────────────────────────────┤
│  Menu:        sudo bash menu.sh            │
│  WiFi:        sudo airmon-ng start wlan0  │
│  Scan:        sudo nmap -sV target        │
│  AI:          opencode / claude / gemini   │
│  Help:        gemini --prompt "help..."    │
│  Emergency:   sudo bash red-button.sh      │
└─────────────────────────────────────────────┘
```
