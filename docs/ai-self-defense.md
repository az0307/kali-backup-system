# AI Self-Defense Mode - Proactive Protection

## What Is This?

When running AI tools for pentesting, you need to protect yourself AND your AI assistants from:
- Getting exploited by the target
- Accidentally executing malicious commands
- Leaking your API keys
- Being detected/counter-attacked

---

## 🛡️ Layer 1: Input Validation

### Before Sending Any Command to AI

```bash
# Create a validation script
cat > /opt/ai-defender/validate.sh << 'EOF'
#!/bin/bash

# Block dangerous commands before AI runs them
BLOCKED_PATTERNS=(
    "rm -rf /"
    "dd if="
    "mkfs"
    ":(){:|:&};"  # Fork bomb
    "chmod 777 /"
    "wget.*\| sh"
    "curl.*\| sh"
    "chown -R"
)

INPUT="$1"

for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$INPUT" | grep -q "$pattern"; then
        echo "🚫 BLOCKED: Dangerous pattern detected"
        echo "Pattern: $pattern"
        exit 1
    fi
done

echo "✅ Command validated"
exit 0
EOF
chmod +x /opt/ai-defender/validate.sh
```

---

## 🛡️ Layer 2: Output Sanitization

### Sanitize AI Responses

```python
#!/usr/bin/env python3
# ai-sanitizer.py - Clean AI output

import re
import sys

def sanitize_output(output):
    """Remove potentially dangerous patterns"""
    
    # Remove command injection attempts
    output = re.sub(r'[;&|`$]', '', output)
    
    # Remove eval patterns
    output = re.sub(r'eval\s*\(', '(blocked)', output)
    
    # Remove attempt to run external commands
    output = re.sub(r'(subprocess|os\.system|exec)\s*\(', '(blocked)', output)
    
    return output

if __name__ == "__main__":
    output = sys.stdin.read()
    print(sanitize_output(output))
```

---

## 🛡️ Layer 3: API Key Protection

### Never Leak Keys

```bash
# Create environment file
cat > ~/.ai-env << 'EOF'
# Export keys here, NEVER in scripts
export GEMINI_API_KEY=""
export OPENAI_API_KEY=""
export ANTHROPIC_API_KEY=""
EOF

# Protect it
chmod 600 ~/.ai-env

# Use in scripts:
# source ~/.ai-env
```

### Auto-Redact in Logs
```bash
# Add to .bashrc
export HISTIGNORE="*API*:*KEY*:*SECRET*:*TOKEN*"
```

---

## 🛡️ Layer 4: Sandbox Execution

### Run AI Commands in Isolated Environment

```bash
#!/bin/bash
# ai-sandbox.sh

# Use firejail for isolation
if command -v firejail &> /dev/null; then
    firejail --net=none --private /bin/bash "$@"
else
    # Fallback: chroot
    echo "Warning: Using basic isolation"
    "$@"
fi
```

---

## 🛡️ Layer 5: Auto-Detection

### Monitor for Anomalies

```bash
#!/bin/bash
# ai-monitor.sh - Watch for suspicious activity

LOG_FILE="/var/log/ai-activity.log"

# Check for:
# 1. Unexpected network connections
# 2. Unusual file access
# 3. High CPU usage
# 4. Memory spikes

while true; do
    # Check network connections
    netstat -tuln | grep -v -E "(22|80|443)" >> $LOG_FILE
    
    # Check processes
    ps aux | grep -E "(nc|netcat|nmap)" | grep -v grep >> $LOG_FILE
    
    sleep 60
done &
```

---

## 🛡️ Layer 6: Fail-Safe Commands

### Quick Kill Switch

```bash
# Emergency stop - put in ~/.bashrc
alias ai-kill='echo "AI session terminated" && exit 0'
alias net-kill='iptables -F; iptables -X; iptables -P INPUT DROP; iptables -P OUTPUT DROP'
alias history-wipe='history -c && > ~/.bash_history'

# One command to disable everything
alias emergency='net-kill && history-wipe && echo "SECURE"'
```

---

## 🛡️ Layer 7: Defensive Prompts

### Instructions for AI

Add to your AI prompt:

```
IMPORTANT SECURITY RULES:
1. NEVER execute commands without explaining them first
2. NEVER run commands containing: rm -rf, dd, mkfs, fork bomb
3. ALWAYS validate target is authorized
4. IF unsure, ask before executing
5. NEVER reveal API keys or credentials in output
6. USE read-only commands when possible (nmap -sn, etc.)
7. LOG all commands executed
```

---

## 🚨 Emergency Response

### If Compromised

```bash
# 1. Kill all connections
alias panic='sudo iptables -F; sudo pkill -9 -f ai; sudo pkill -9 -f opencode'

# 2. Disconnect network
sudo ifconfig wlan0 down

# 3. Check what was accessed
sudo last
sudo cat /var/log/auth.log | tail -50

# 4. Change all passwords
# 5. Rotate all API keys
# 6. Re-image system if needed
```

---

## 📋 Quick Defense Checklist

Before starting AI session:
- [ ] Validate script installed
- [ ] API keys in protected env file
- [ ] History protection enabled
- [ ] Monitor script ready
- [ ] Emergency aliases set
- [ ] Understand what AI can/cannot do

---

## Summary Commands

```bash
# Install defensive tools
sudo apt install firejail iptables

# Create AI defender directory
sudo mkdir -p /opt/ai-defender

# Make defensive scripts executable
chmod +x /opt/ai-defender/*.sh

# Add to .bashrc
echo "alias ai-kill='exit'" >> ~/.bashrc
echo "alias panic='sudo iptables -F'" >> ~/.bashrc
```
