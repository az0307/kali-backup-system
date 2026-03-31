# 🎯 KALI RED TEAM SETUP - FINAL

## Quick Start

### 1. Start VM Safely
```bash
cd /mnt/sf_KaliShare/scripts
chmod +x *.sh

# Safe VM startup with checks
sudo ./start-kali.sh

# OR manually:
# VirtualBox → Start Kali
```

### 2. Install in Order
```bash
# Login: root / toor

# Stage 1: Core Tools
sudo ./setup-stage1-core.sh

# Stage 2: AI Tools (Claude, OpenCode, Gemini, HexStrike)
sudo ./setup-stage2-ai.sh

# Stage 3: Wordlists & Resources  
sudo ./setup-stage3-resources.sh

# Stage 4: Remote Access
sudo ./setup-stage4-network.sh

# Stage 5: Productivity (optional)
sudo ./setup-stage5-productivity.sh
```

### 3. Activate WiFi Adapter
```bash
sudo ./monitor-mode.sh
```

---

## AI Tools Available

| Tool | Command | API Needed? |
|------|---------|--------------|
| **OpenCode** | `opencode` | Yes |
| **Claude Code** | `claude` | Yes |
| **Gemini CLI** | `gemini --prompt "..."` | Free! |
| **HexStrike AI** | `cd /opt/hexstrike && python3 hexstrike.py` | Yes |
| **Ollama** | `ollama run llama3` | No! |

---

## Quick Commands

### WiFi
```bash
sudo airmon-ng start wlan0
sudo airodump-ng wlan0mon
sudo aireplay-ng --deauth 10 -a MAC wlan0mon
sudo aircrack-ng -w wordlist capture.cap
```

### Network
```bash
sudo nmap -sV -sC target.com
rustscan -a target.com
```

### Web
```bash
nikto -h target.com
sqlmap -u target.com
gobuster dir -u target.com -w wordlist
```

---

## Emergency

### Red Button (Destroy Everything)
```bash
sudo /mnt/sf_KaliShare/scripts/red-button.sh
```

### Quick Exit
```bash
sudo poweroff
# Or close VM window
```

---

## Files Location

| Category | Path |
|----------|------|
| Scripts | `/mnt/sf_KaliShare/scripts/` |
| Skills | `~/.config/opencode/skills/` |
| Wordlists | `/usr/share/wordlists/` |
| Tools | `/opt/pentest-tools/` |
| Config | `~/.opencode.json` |

---

## ⚠️ Warnings

1. **Don't run Ollama in VM** - Use host or cloud
2. **Don't run heavy tools together** - Will crash
3. **Your VM has 4GB RAM, 2 CPUs** - Don't exceed!
4. **Monitor temperature** - Stop if hot

---

## Legal

⚠️ Only test systems you own or have written authorization!

---

## Support

- Docs: `/mnt/sf_KaliShare/docs/`
- Skills: `/mnt/sf_KaliShare/skills/`
- References: `/mnt/sf_KaliShare/references/`
