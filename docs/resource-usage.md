# 💾 Resource Usage & Size Guide

## 📊 Estimated Disk Usage

| Component | Size | Notes |
|----------|------|-------|
| Kali Base VM | ~15 GB | Already installed |
| Wordlists (rockyou) | ~140 MB | /usr/share/wordlists |
| SecLists | ~500 MB | /usr/share/seclists |
| FuzzDB | ~50 MB | /usr/share/fuzzdb |
| PayloadsAllTheThings | ~200 MB | /opt/PayloadsAllTheThings |
| HexStrike AI | ~200 MB | /opt/hexstrike |
| Node.js/Bun | ~200 MB | Runtime |
| Oh-My-OpenCode | ~50 MB | Skills |
| Ollama (models) | ~4 GB+ | Per model |

### Total After Full Install
- **Without Ollama models:** ~17 GB
- **With 1-2 Ollama models:** ~21-25 GB

---

## 🔋 RAM Usage (When Running)

| Tool/Service | RAM | CPU | Notes |
|--------------|-----|-----|-------|
| **Idle Kali VM** | 512 MB | 1% | Minimal |
| **OpenCode** | 200 MB | Low | Per session |
| **Claude Code** | 300 MB | Low-Med | API calls |
| **Gemini CLI** | 150 MB | Low | Free! |
| **HexStrike AI** | 500 MB | Medium | + per tool |
| **Nmap scan** | 50 MB | High | During scan |
| **Metasploit** | 1-2 GB | Medium | Heavy |
| **Hashcat (CPU)** | 500 MB | 100% | Slows system |
| **Ollama (running)** | 2-4 GB | Medium | Per model |

---

## ⚠️ Resource Warnings

### HIGH RESOURCE (Avoid in VM)
- Hashcat with GPU - NOT in VM
- Large wordlists in memory
- Multiple heavy tools at once
- Running Ollama in VM (use host instead)

### MEDIUM RESOURCE (Use Carefully)
- Metasploit - OK but slow
- HexStrike AI - OK with 4GB RAM
- Large nmap scans

### LOW RESOURCE (Safe)
- OpenCode
- Claude Code  
- Gemini CLI
- Aircrack-ng suite
- Basic nmap
- sqlmap
- gobuster

---

## 🎯 Recommended Usage

### Your VM Specs
- RAM: 4 GB (MAX)
- CPUs: 2
- Disk: 24 GB

### Safe Combinations (DO)
✅ Run:
- OpenCode + 1 nmap scan
- Gemini CLI + aircrack-ng
- Metasploit alone
- Web testing (nikto + gobuster)

❌ Don't Run:
- Hashcat + Metasploit + HexStrike
- Ollama + anything
- Multiple brute force tools
- Large password lists at once

---

## 📈 Memory Management Tips

### Close When Not Using
```bash
# Kill heavy processes
pkill metasploit
pkill msfconsole

# Free memory
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
```

### Monitor Resources
```bash
# Watch usage
htop

# Quick check
free -h

# Disk usage
df -h
```

---

## 🚀 Optimization Tricks

### Use Lightweight Alternatives
| Heavy | Lightweight | Notes |
|--------|-------------|-------|
| Hashcat | John | CPU only |
| Metasploit | msfconsole | Same thing |
| Chrome | Firefox/CLI | Less RAM |
| VS Code | Vim/Nano | Minimal |

### Disable Unnecessary Services
```bash
# Disable services you don't need
sudo systemctl disable apache2
sudo systemctl disable mysql
sudo systemctl disable postgresql
```

---

## 📊 Quick Reference

| Task | Expected RAM | Expected CPU |
|------|-------------|--------------|
| WiFi scan | 100 MB | Low |
| Network scan | 200 MB | Medium |
| Web enum | 150 MB | Low |
| Exploitation | 500 MB | Medium |
| AI assistant | 300 MB | Low |
| ALL TOGETHER | CRASH | 100% |

---

## ✅ Safe Setup Order

1. **Stage 1** - Core tools (~2 GB) ✅ Safe
2. **Stage 2** - AI tools (~500 MB) ✅ Safe  
3. **Stage 3** - Resources (~1 GB) ✅ Safe
4. **Stage 4** - Network (~100 MB) ✅ Safe
5. **Stage 5** - Productivity (~200 MB) ✅ Safe

**Total: ~4 GB additional = 19 GB total**

**RECOMMEND: Don't install Ollama in VM, use host or cloud instead!**
