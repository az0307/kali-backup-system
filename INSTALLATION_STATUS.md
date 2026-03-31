# AI Tools Installation Status

## Current Status: March 16, 2026

---

## Windows Host (Current Machine)

### ✅ Installed & Working

| Tool | Version | MCP Servers | Status |
|------|---------|-------------|--------|
| **Claude Code** | 2.1.76 | 6 connected | ✅ Working |
| **OpenCode** | 1.2.25 | Skills loaded | ✅ Working |
| **Gemini CLI** | 0.33.1 | 5 configured | ✅ Working |
| **TARS** | 0.3.0 | N/A | ✅ Working |

### MCP Servers (Claude Code)
- github ✅
- filesystem ✅
- brave-search ✅
- memory ✅
- context7 ✅
- notion ✅
- composio ❌ (failed)

### Skills Installed
- 18 custom skills (~/.config/opencode/skills/)
- VoltAgent marketplace (549+ skills)
- oh-my-opencode plugin
- superpowers plugin

---

## Kali VM (VirtualBox)

### 📁 Scripts Ready (KaliShare)
Located at: `C:\Users\User\KaliShare\scripts\`

| Script | Purpose |
|--------|---------|
| install-all-kali.sh | Main installer |
| opencode-install.sh | OpenCode for Linux |
| install-gemini.sh | Gemini CLI |
| install-tars.sh | TARS agent |
| hexstrike-install.sh | HexStrike AI |
| quick-ai-install.sh | Quick AI tools |
| super-install.sh | Superpowers |
| monitor-mode.sh | WiFi monitor setup |

### Skills Ready for Kali
Located at: `C:\Users\User\KaliShare\skills\`

### Documentation
Located at: `C:\Users\User\KaliShare\docs\`

---

## To Install in Kali VM

### Step 1: Copy KaliShare to Kali
```bash
# From Windows (or mount shared folder)
# Copy C:\Users\User\KaliShare to /root/KaliShare
```

### Step 2: Run Installation
```bash
cd /root/KaliShare/scripts
chmod +x *.sh
./install-all-kali.sh
```

### Step 3: Configure AI Tools
```bash
# OpenCode
./opencode-install.sh

# Gemini CLI  
./install-gemini.sh

# TARS
./install-tars.sh
```

---

## OPPO Phone (Termux)

### Not Yet Installed
- Termux not configured
- Need to install from F-Droid
- SSH keys not set up

---

## Summary

| Location | Installed | Ready to Install |
|----------|-----------|------------------|
| Windows | ✅ Claude, OpenCode, Gemini, TARS | - |
| Kali VM | 📁 Scripts ready | Copy & run |
| OPPO | ❌ Not started | Termux needed |

---

## Quick Commands

### Windows
```bash
opencode              # Start OpenCode
claude               # Start Claude Code
gemini               # Start Gemini CLI
agent-tars           # Start TARS
```

### Kali (after install)
```bash
opencode              # Start OpenCode
claude                # Start Claude Code  
gemini                # Start Gemini CLI
agent-tars           # Start TARS
```
