# 🏠 Home Lab - Updated Configuration
## Current Setup - March 2026

---

## 📋 DEVICE INVENTORY

| Device | Type | IP | Purpose |
|--------|------|-----|---------|
| **This Laptop** | Windows Host | 192.168.1.100 | Control Center + Kali VM |
| **XP Laptop** | Old 400GB PC | 10.0.0.66 | NAS/Backup/Target Practice |
| **OPPO Phone** | Android | TBD | Mobile AI + Termux |
| **Home Computer** | Unknown | ? | (You mentioned - needs checking) |
| **Huawei Hotspot** | Mobile Data | 192.168.1.1 | Internet |
| **TP-Link** | USB WiFi | → Kali | Monitor Mode |

---

## 🔧 CURRENT CONFIG

### This Laptop (Windows Host)
```
IP: 192.168.1.100
Running:
  - OpenCode v1.2.25
  - Claude Code v2.1.76
  - Gemini CLI v0.33.1
  - TARS v0.3.0
  - VirtualBox with Kali VM
```

### XP Laptop (Old Slow PC)
```
IP: 10.0.0.66 (confirmed online ✅)
Specs: 400GB HDD, Windows XP (slow)
Best Use: NAS, Storage, Backup, CTF Target
```

### OPPO Phone
```
Status: Next to you, needs setup
Setup: Install Termux from F-Droid
```

---

## ☁️ CLOUD/VPS OPTIONS

### Recommended Options for Pentesting

| Provider | Type | Cost | Features |
|----------|------|------|----------|
| **DigitalOcean** | VPS | $4-24/mo | Droplets, good network |
| **Linode** | VPS | $5-30/mo | Akamai, reliable |
| **Hetzner** | VPS | €3-30/mo | Cheap, EU focus |
| **AWS** | Cloud | Pay as you go | EC2, many services |
| **Oracle Cloud** | VPS | Free tier | Always free ARM |
| **Google Cloud** | Cloud | $300 credit | Powerful VMs |

### VPS for Your Setup:
1. **Cheap pentest VPS** ($5/mo) - For C2, redirectors
2. **Recon VPS** - Nmap scanning, Osint
3. **Storage VPS** - Store wordlists, payloads

### Quick VPS Setup Scripts:
```bash
# DigitalOcean (use referral for credits)
doctl compute droplet create pentest-vm \
  --size s-1vcpu-1gb \
  --image ubuntu-22-04 \
  --region nyc1

# Oracle Cloud (Free ARM)
# https://cloud.oracle.com/
```

---

## 🎯 RECOMMENDED XP LAPTOP USE

Since it's slow, use it for:
1. **Network Storage (NAS)** - Share 400GB on network
2. **Backup Target** - Store VM backups, PCAPs
3. **Practice Target** - Set up vulnerable VMs
4. **Wordlist Storage** - Store rockyou, crackstation

**DO NOT** try to run heavy tools on it!

---

## 📝 ACTION ITEMS

### Immediate:
1. ✅ XP Laptop found at 10.0.0.66 - Use as NAS
2. 📱 Setup OPPO with Termux
3. 🌐 Find home computer IP
4. ☁️ Consider VPS for cloud pentesting

### Next Steps:
- [ ] Configure XP as NAS (run xp-nas.bat on XP)
- [ ] Setup OPPO Termux
- [ ] Add cloud VPS for extra power
- [ ] Document home computer specs

---

## 📁 SCRIPT QUICK REFERENCE

| Script | Run On | Purpose |
|--------|--------|---------|
| `home-lab-launcher.bat` | Windows | Main menu |
| `enhance-kali-v3.sh` | Kali VM | Full setup |
| `xp-nas.bat` | XP Laptop | Make it NAS |
| `orchestrate.sh` | Linux | Device control |

---

## 🔗 CONNECT QUICKLY

```bash
# SSH to XP (slow but works)
ssh administrator@10.0.0.66

# Copy to XP
scp file.txt administrator@10.0.0.66:/c/pen-test/

# Map XP drive
net use Z: \\10.0.0.66\c$
```
