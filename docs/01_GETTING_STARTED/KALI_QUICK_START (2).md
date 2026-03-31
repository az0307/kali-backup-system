# Quick Start Guide for Kali VM

## Installation

### Option 1: Direct Download (Recommended)
Run this in Kali terminal:

```bash
# Quick install all AI tools
curl -fsSL https://raw.githubusercontent.com/your-repo/kali-setup/main/quick-install-kali.sh | sudo bash
```

### Option 2: Manual Copy
1. Copy `KaliShare/scripts/` folder to Kali VM via Shared Folder or USB
2. Run:
```bash
cd /media/sf_KaliShare/scripts
chmod +x quick-install-kali.sh
sudo ./quick-install-kali.sh
```

### Option 3: SSH Installation
After finding Kali's IP:
```bash
# Copy scripts
scp -r scripts/* root@<KALI_IP>:/root/

# Run install
ssh root@<KALI_IP> "chmod +x /root/scripts/*.sh && /root/scripts/quick-install-kali.sh"
```

---

## After Installation

### Start AI Tools
```bash
opencode              # OpenCode
gemini               # Gemini CLI  
agent-tars           # TARS
```

### Check WiFi Adapter (Monitor Mode)
```bash
sudo airmon-ng
sudo airmon-ng start wlan0
sudo airodump-ng wlan0mon
```

---

## Files Included

| File | Purpose |
|------|---------|
| `quick-install-kali.sh` | Quick install script |
| `enhance-kali.sh` | Full UI/UX enhancement |
| `opencode-install.sh` | OpenCode specific |
| `install-gemini.sh` | Gemini CLI |
| `install-tars.sh` | TARS |
| `hexstrike-install.sh` | HexStrike AI |
| `monitor-mode.sh` | WiFi setup |
| `ai-menu.sh` | Dashboard menu |

---

## Troubleshooting

### Can't find Kali IP?
```bash
# In Kali terminal, run:
ip addr show
# or
hostname -I
```

### SSH not working?
```bash
# In Kali, enable SSH:
sudo systemctl enable ssh
sudo systemctl start ssh
```

### Tools not found after install?
```bash
source ~/.bashrc
# or restart terminal
```
