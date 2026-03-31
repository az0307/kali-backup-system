# 🚀 FIRST TIME SETUP - Complete Walkthrough

## Pre-Requisites (Before Starting)

- [ ] Kali VM created in VirtualBox
- [ ] Shared folder enabled
- [ ] USB WiFi adapter (TP-Link TL-WN721N)
- [ ] Internet connection

---

## STEP 1: Enable Shared Folder

### In VirtualBox (Host):
1. Devices → Shared Folders → Settings
2. Add new: `C:\Users\User\KaliShare`
3. Auto-mount: Yes
4. Make Permanent: Yes

### In Kali (Guest):
```bash
# Test it's working
ls /mnt/sf_KaliShare

# If not mounted:
sudo mkdir /mnt/sf_KaliShare
sudo mount -t vboxsf KaliShare /mnt/sf_KaliShare
```

---

## STEP 2: Run Installer

```bash
cd /mnt/sf_KaliShare/scripts
chmod +x *.sh

# OPTION A: Everything at once (RECOMMENDED)
sudo bash install-all.sh
# Type YES when prompted

# OPTION B: Interactive menu
sudo bash menu.sh

# OPTION C: Individual stages
sudo bash setup-stage1-core.sh
sudo bash setup-stage2-ai.sh
sudo bash setup-stage3-resources.sh
sudo bash setup-stage4-network.sh
sudo bash setup-stage5-productivity.sh
```

---

## STEP 3: Copy Skills

```bash
mkdir -p ~/.config/opencode/skills
cp -r /mnt/sf_KaliShare/skills/* ~/.config/opencode/skills/
```

---

## STEP 4: Configure API Keys

```bash
# Edit config
nano ~/.opencode.json

# Add your keys (from Bitwarden):
# - Gemini API key
# - Anthropic key
# - OpenAI key
```

---

## STEP 5: Test WiFi Adapter

```bash
# Run monitor mode script
sudo bash /mnt/sf_KaliShare/scripts/monitor-mode.sh

# Should see wlan0mon
iw dev
```

---

## STEP 6: Test AI Tools

```bash
# Gemini CLI (free - test first!)
gemini --prompt "hello"

# OpenCode (need API)
opencode

# Claude Code (need API)
claude
```

---

## STEP 7: Take Snapshot

In VirtualBox:
1. Close Kali (power off, not save state)
2. Right-click Kali → Take Snapshot
3. Name: "Fresh Install with All Tools"
4. Take Snapshot

---

## Troubleshooting

### Problem: Shared folder not working
```bash
# Install guest additions
sudo apt install virtualbox-guest-x11
sudo reboot
```

### Problem: WiFi adapter not detected
```bash
# Check USB
lsusb

# In VirtualBox: Devices → USB → Enable TP-Link
```

### Problem: AI not responding
```bash
# Check API keys
nano ~/.opencode.json
```

---

## Daily Startup

```bash
# 1. Start VirtualBox
# 2. Start Kali
# 3. Open terminal
# 4. Start tools!

# Quick test
sudo airmon-ng start wlan0
opencode
```

---

## You're Ready! 🎉

Now you have:
- ✅ Full Kali installation
- ✅ AI tools (Claude, OpenCode, Gemini, HexStrike)
- ✅ WiFi auditing
- ✅ Network scanning
- ✅ Wordlists & resources
- ✅ Remote access
- ✅ Productivity tools
- ✅ Skills & docs

**Go practice!** 🕵️
