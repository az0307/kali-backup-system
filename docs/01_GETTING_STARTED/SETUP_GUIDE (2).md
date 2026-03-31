# 🚀 Complete Setup Guide - Kali Linux Red Team + AI Coding

## What We're Building

We're setting up a powerful penetration testing lab with AI assistants:

1. **Kali Linux VM** - Your security testing computer (runs inside VirtualBox)
2. **OpenCode** - AI coding assistant (works on Windows + Kali)
3. **Claude Code** - Another AI coding assistant
4. **MCP Servers** - Tools that give AI superpowers (search, memory, etc.)
5. **Red Team Skills** - Special instructions for AI to help with hacking

---

# PART 1: What You Need First

## Items You Should Have

- [ ] **TP-Link TL-WN721N** wireless adapter ($10, AR9271 chip)
- [ ] **VirtualBox** installed on Windows
- [ ] **Kali Linux VM** created and running
- [ ] **Bitwarden** account with your API keys

---

# PART 2: Windows Setup (Already Done!)

Your Windows machine already has these installed:

✅ **OpenCode** - AI coding assistant  
✅ **Claude Code** - Another AI coding tool  
✅ **MCP Servers**:
  - Filesystem access
  - GitHub
  - Brave Search
  - Memory
  - Sequential Thinking
  - Postgres
  - Context7 (documentation)
  - Notion
  - Composio
  - Google Workspace
  - Desktop Commander

✅ **API Keys Configured** in `C:\Users\User\.opencode.json`

---

# PART 3: Kali VM Setup (Follow These Steps)

## Step 1: Start Your Kali VM

1. Open **VirtualBox** on Windows
2. Click on **Kali** in the left sidebar
3. Click the green **Start** button (▶️)
4. Wait for Kali to boot up (takes 1-2 minutes)
5. Login with: `root` / `toor` (or your password)

## Step 2: Enable Shared Folder

The shared folder lets Windows and Kali share files!

1. With Kali running, click **Devices** menu in VirtualBox
2. Click **Shared Folders** → **Settings**
3. Click the **+** button (add new folder)
4. Folder Path: `C:\Users\User\KaliShare`
5. Folder Name: `KaliShare`
6. ✅ Check **Auto-mount**
7. ✅ Check **Make Permanent**
8. Click **OK**

Now the folder is at `/mnt/sf_KaliShare/` in Kali

## Step 3: Install Pentest Tools

Open terminal in Kali and run:

```bash
cd /mnt/sf_KaliShare
chmod +x kali-install.sh
sudo ./kali-install.sh
```

**This will install:**
- ✅ Gemini CLI (AI helper - FREE!)
- ✅ Aircrack-ng (WiFi hacking)
- ✅ Nmap (network scanner)
- ✅ Hashcat (password cracker)
- ✅ Metasploit (exploitation framework)
- ✅ And 50+ other security tools

**The script will also:**
- Test your TP-Link adapter
- Put WiFi in monitor mode
- Verify injection works

## Step 4: Install OpenCode + AI Tools

```bash
cd /mnt/sf_KaliShare
chmod +x opencode-install.sh
sudo ./opencode-install.sh
```

**This installs:**
- ✅ Node.js
- ✅ Bun (runtime)
- ✅ OpenCode
- ✅ Oh-My-OpenCode (background agents)
- ✅ Red Team Skills

## Step 5: Install Claude Code (Optional)

```bash
# Install Node.js if needed
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Claude Code
sudo npm install -g @anthropic-ai/claude-code
```

**Setup Claude Code:**
```bash
claude
```

Follow the browser login instructions!

## Step 6: Copy Red Team Skills

The install script should copy skills automatically. If not:

```bash
mkdir -p ~/.config/opencode/skills
cp /mnt/sf_KaliShare/kali-redteam-curator.md ~/.config/opencode/skills/
cp /mnt/sf_KaliShare/claude-redteam-agent.md ~/.config/opencode/skills/
cp -r /mnt/sf_KaliShare/references ~/.config/opencode/skills/
```

---

# PART 4: Configure MCP (AI Tools)

## Option A: Use Pre-Configured Keys

The `.opencode.json` in KaliShare already has API keys. Just copy it:

```bash
cp /mnt/sf_KaliShare/.opencode.json ~/.opencode.json
```

## Option B: Get Your Own Keys from Bitwarden

### Get API Keys:

1. Open **Bitwarden** on Windows
2. Search for these items and copy the passwords:

| Service | What to Search |
|---------|----------------|
| Gemini | "Gemini API Key" |
| Brave Search | "Brave Search API Key" |
| GitHub | "GitHub - Personal Access Token" |
| Notion | "Notion API Key" |
| Composio | "Composio API Key" |

3. Create `~/.opencode.json`:

```bash
nano ~/.opencode.json
```

Paste this (replace `YOUR_KEY_HERE` with actual keys):

```json
{
  "models": {
    "default": "gemini-1.5-flash",
    "providers": {
      "google": {
        "model": "gemini-1.5-flash",
        "apiKey": "YOUR_GEMINI_KEY"
      }
    }
  },
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/kali"]
    },
    "brave-search": {
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "YOUR_BRAVE_KEY" }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "YOUR_GITHUB_TOKEN" }
    }
  }
}
```

4. Save: `Ctrl + O`, then `Enter`, then `Ctrl + X`

---

# PART 5: How to Use

## Starting OpenCode (in Kali)

```bash
opencode
```

Or ask a question:
```bash
opencode --prompt "how do I crack WPA2 WiFi?"
```

## Starting Claude Code (in Kali)

```bash
claude
```

## Using Gemini CLI (in Kali)

```bash
gemini --prompt "help me with nmap scan"
```

## Red Team Commands

### WiFi Hacking
```bash
# Put WiFi in monitor mode
sudo airmon-ng start wlan0

# Scan for networks
sudo airodump-ng wlan0mon

# Capture handshake
sudo airodump-ng -c 1 --bssid MAC_ADDRESS -w capture wlan0mon

# Deauth attack
sudo aireplay-ng --deauth 10 -a MAC_ADDRESS wlan0mon

# Crack password
sudo aircrack-ng -w wordlist.txt capture-01.cap
```

### Network Scanning
```bash
sudo nmap -sV -sC target.com
rustscan -a target.com
```

### Metasploit
```bash
msfconsole
search exploit windows/smb
use exploit/windows/smb/eternalblue
set RHOSTS target_ip
run
```

---

# PART 6: Troubleshooting

## Shared Folder Not Working?

1. Make sure VirtualBox Guest Additions is installed in Kali:
```bash
sudo apt install virtualbox-guest-x11
```

2. Reboot Kali:
```bash
sudo reboot
```

3. Mount manually:
```bash
sudo mkdir -p /mnt/sf_KaliShare
sudo mount -t vboxsf KaliShare /mnt/sf_KaliShare
```

## WiFi Adapter Not Working?

1. Check if adapter is detected:
```bash
iw dev
lsusb
```

2. Make sure it's connected to VM:
- VirtualBox → Kali → USB → Check TP-Link adapter

3. Try different USB port

## OpenCode Not Starting?

```bash
# Check version
opencode --version

# Reinstall
sudo npm install -g opencode-ai
```

---

# PART 7: What's Installed

## On Windows:
| Tool | What It Does |
|------|--------------|
| OpenCode | AI coding assistant |
| Claude Code | AI coding assistant (Anthropic) |
| 11 MCP Servers | Search, memory, GitHub, etc. |

## On Kali VM:
| Tool | What It Does |
|------|--------------|
| Aircrack-ng | WiFi hacking |
| Nmap | Network scanning |
| Metasploit | Exploitation |
| Hashcat | Password cracking |
| Gemini CLI | Free AI helper |
| OpenCode | AI coding |
| Claude Code | AI coding |
| 50+ pentest tools | Full arsenal |

---

# Quick Reference Card

```
┌─────────────────────────────────────────────────────────┐
│                  KALI SHORTCUTS                        │
├─────────────────────────────────────────────────────────┤
│ WiFi Monitor:  sudo airmon-ng start wlan0             │
│ Scan WiFi:      sudo airodump-ng wlan0mon              │
│ Scan Network:   sudo nmap -sV -sC target               │
│ Start Metasploit: msfconsole                           │
│ AI Help:        gemini --prompt "your question"        │
│ AI Coding:      opencode                               │
└─────────────────────────────────────────────────────────┘
```

---

# Files in KaliShare

```
C:\Users\User\KaliShare\
├── kali-install.sh           # Installs pentest tools
├── opencode-install.sh      # Installs OpenCode + skills
├── .opencode.json           # Config with API keys
├── kali-redteam-curator.md  # Main skill (OpenCode)
├── claude-redteam-agent.md  # Claude agent version
├── gemini-redteam-gem.md   # Gemini gem version
└── references/              # Reference guides
```

---

# That's It! 🎉

You now have:
- ✅ Full penetration testing lab
- ✅ AI assistants to help
- ✅ Wireless adapter ready
- ✅ All tools installed

**Remember:** Only test systems you own or have written permission to test!

Happy hacking! 🔐
