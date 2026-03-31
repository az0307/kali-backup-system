# 🤖 AI IN KALI VM - QUICK START

## Install (Run Once)

```bash
cd /mnt/sf_KaliShare/scripts
chmod +x *.sh
sudo bash quick-ai-install.sh
```

---

## USE AI IN KALI (No Switching to Windows!)

### Option 1: Gemini CLI ⭐ (RECOMMENDED - FREE!)
```bash
# Just works! No API key needed!

gemini --prompt "hello"

gemini --prompt "help me with nmap scan"

gemini --prompt "explain how WPA2 cracking works"

gemini --prompt "write a bash script for network scanning"
```

### Option 2: OpenCode
```bash
# Needs API key in ~/.opencode.json
opencode

# Then type your question
```

### Option 3: Claude Code
```bash
# Needs API key
claude

# Then type your question
```

---

## Example Conversations

### WiFi Hacking
```
gemini --prompt "show me commands to capture WPA handshake"
```

### Network Scanning
```
gemini --prompt "help me scan a network with nmap"
```

### Learning
```
gemini --prompt "explain SQL injection simply"
```

### Script Writing
```
gemini --prompt "write a bash script to automate recon"
```

---

## Why Gemini CLI?

| Feature | Gemini CLI | OpenCode | Claude Code |
|---------|------------|----------|-------------|
| **Cost** | FREE | $ | $ |
| **API Key** | Not needed | Needed | Needed |
| **Works** | Immediately | After config | After config |
| **Speed** | Fast | Fast | Fast |

---

## Configure API Keys (Optional)

If you want OpenCode or Claude Code:

```bash
nano ~/.opencode.json
```

Add your keys:
```json
{
  "models": {
    "providers": {
      "google": {
        "apiKey": "YOUR_GEMINI_KEY"
      },
      "anthropic": {
        "apiKey": "YOUR_CLAUDE_KEY"
      }
    }
  }
}
```

---

## Tips

- Use Gemini CLI for quick questions - it's FREE!
- OpenCode/Claude for complex coding tasks
- You can have all 3 running!

---

## Still Slow?

- Close other apps
- Don't run heavy tools (Metasploit) + AI
- Use Gemini (lightest)
