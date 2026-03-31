# Learning & Automation System

## 1. Knowledge Refresh System

### Daily Study Routine
```bash
#!/bin/bash
# daily-refresh.sh - Study one topic per day

TOPICS=(
    "network-scanning"
    "wireless-security"
    "web-app-testing"
    "privilege-escalation"
    "social-engineering"
    "crypto-basics"
    "post-exploitation"
    "red-team-ops"
)

DAY=$(date +%u)
TOPIC=${TOPICS[$((DAY % 8))]}

echo "Today's topic: $TOPIC"

case $TOPIC in
    network-scanning)
        echo "Review: nmap flags, masscan, rustscan"
        echo "Practice: scan localhost, enumerate ports"
        ;;
    wireless-security)
        echo "Review: aircrack-ng suite, monitor mode"
        echo "Practice: capture handshake, deauth attack"
        ;;
    web-app-testing)
        echo "Review: Burp, SQLi, XSS"
        echo "Practice: DVWA, OWASP Juice Shop"
        ;;
    privilege-escalation)
        echo "Review: Linux privesc, Windows privesc"
        echo "Practice: linpeas, winpeas"
        ;;
    social-engineering)
        echo "Review: SET, phishing techniques"
        echo "Practice: create phishing template"
        ;;
    crypto-basics)
        echo "Review: hashcat, john, encryption types"
        echo "Practice: crack sample hashes"
        ;;
    post-exploitation)
        echo "Review: persistence, lateral movement"
        echo "Practice: setup persistence"
        ;;
    red-team-ops)
        echo "Review: opsec, stealth"
        echo "Practice: plan red team engagement"
        ;;
esac
```

### Weekly Challenge Generator
```bash
#!/bin/bash
# weekly-challenge.sh

CHALLENGES=(
    "nmap:Scan top 100 ports on localhost in stealth mode"
    "wireless:Capture WPA handshake and crack with wordlist"
    "web:Find and exploit SQLi in DVWA"
    "privesc:Escalate from user to root on Metasploitable"
    "crypto:Crack MD5 hash using hashcat with rules"
    "phishing:Create phishing email with SET"
    "osint:Gather info on target using only OSINT"
    "wifi:Audit WPS security on nearby networks"
)

RANDOM_CHALLENGE=${CHALLENGES[$RANDOM % ${#CHALLENGES[@]}]}
echo "This week's challenge:"
echo "$RANDOM_CHALLENGE"
```

### Flashcard System
```bash
#!/bin/bash
# flashcards.sh

DECK=(
    "What port does SSH use?:22"
    "What port does HTTP use?:80"
    "What port does HTTPS use?:443"
    "What port does SMB use?:445"
    "What port does DNS use?:53"
    "What port does FTP use?:21"
    "What port does Telnet use?:23"
    "What is the NTLM hash length?:32 characters (128 bits)"
    "WPA2 uses what encryption?:AES-CCMP"
    "What is a rainbow table?:Precomputed hash table for fast cracking"
)

CARD=${DECK[$((RANDOM % ${#DECK[@]}))]}
QUESTION="${CARD%%:*}"
ANSWER="${CARD#*:}"

echo "Question: $QUESTION"
echo "Press enter for answer..."
read
echo "Answer: $ANSWER"
```

---

## 2. Report Generation System

### Pentest Report Generator
```bash
#!/bin/bash
# generate-report.sh

OUTPUT_DIR="pentest-report-$(date +%Y%m%d)"
mkdir -p "$OUTPUT_DIR"

echo "# Penetration Test Report" > "$OUTPUT_DIR/report.md"
echo "Date: $(date)" >> "$OUTPUT_DIR/report.md"
echo "" >> "$OUTPUT_DIR/report.md"

echo "## Executive Summary" >> "$OUTPUT_DIR/report.md
echo "" >> "$OUTPUT_DIR/report.md"

echo "### Scope" >> "$OUTPUT_DIR/report.md
echo "- Target: $TARGET" >> "$OUTPUT_DIR/report.md"
echo "- Type: $TYPE" >> "$OUTPUT_DIR/report.md"
echo "" >> "$OUTPUT_DIR/report.md"

echo "### Findings Summary" >> "$OUTPUT_DIR/report.md
echo "| Severity | Count |" >> "$OUTPUT_DIR/report.md
echo "|----------|-------|" >> "$OUTPUT_DIR/report.md
echo "| Critical | $CRITICAL |" >> "$OUTPUT_DIR/report.md
echo "| High | $HIGH |" >> "$OUTPUT_DIR/report.md
echo "| Medium | $MEDIUM |" >> "$OUTPUT_DIR/report.md
echo "| Low | $LOW |" >> "$OUTPUT_DIR/report.md"
echo "" >> "$OUTPUT_DIR/report.md"

echo "## Detailed Findings" >> "$OUTPUT_DIR/report.md

# Add nmap results
echo "### Network Scan Results" >> "$OUTPUT_DIR/report.md
echo '```' >> "$OUTPUT_DIR/report.md
cat nmap-scan.txt >> "$OUTPUT_DIR/report.md 2>/dev/null || echo "No scan data" >> "$OUTPUT_DIR/report.md
echo '```' >> "$OUTPUT_DIR/report.md"

# Add vulnerability findings
echo "### Vulnerabilities Found" >> "$OUTPUT_DIR/report.md
echo "1. **SQL Injection** (Critical)" >> "$OUTPUT_DIR/report.md"
echo "   - Location: $TARGET/login.php" >> "$OUTPUT_DIR/report.md"
echo "   - Impact: Full database compromise" >> "$OUTPUT_DIR/report.md"
echo "   - Remediation: Use parameterized queries" >> "$OUTPUT_DIR/report.md"

echo "Report generated: $OUTPUT_DIR/report.md"
```

### Auto-Notes During Engagement
```bash
#!/bin/bash
# auto-notes.sh

NOTES_FILE="engagement-notes.md"

log_finding() {
    echo "## $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$NOTES_FILE"
    echo "$2" >> "$NOTES_FILE"
    echo "" >> "$NOTES_FILE"
}

# Usage
log_finding "Nmap Scan" "Found open port 22 (SSH)"
log_finding "Nikto Scan" "Found /admin path"
```

---

## 3. Google Sheets Integration

### Setup Google Sheets API
```bash
# 1. Go to Google Cloud Console
# 2. Enable Google Sheets API
# 3. Create credentials (OAuth or Service Account)
# 4. Download credentials.json

# Install required packages
pip3 install gspread oauth2client

# Create service-account.json with your credentials
```

### Python Script to Push to Sheets
```python
#!/usr/bin/env python3
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import json
from datetime import datetime

def push_to_sheets(data, spreadsheet_name="Pentest Findings"):
    scope = ["https://spreadsheets.google.com/feeds", 
             "https://www.googleapis.com/auth/drive"]
    
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        'service-account.json', scope)
    
    gc = gspread.authorize(credentials)
    
    # Open or create spreadsheet
    try:
        sh = gc.open(spreadsheet_name)
    except:
        sh = gc.create(spreadsheet_name)
    
    # Get first worksheet
    ws = sh.sheet1
    
    # Add data
    row = [
        datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        data.get('target', ''),
        data.get('finding', ''),
        data.get('severity', ''),
        data.get('status', 'Open')
    ]
    
    ws.append_row(row)
    print(f"Pushed to {spreadsheet_name}")

# Usage
if __name__ == "__main__":
    finding = {
        'target': '10.0.0.1',
        'finding': 'SQL Injection in login',
        'severity': 'Critical',
        'status': 'Open'
    }
    push_to_sheets(finding)
```

### Email Report Script
```bash
#!/bin/bash
# email-report.sh

SUBJECT="Pentest Report - $(date +%Y%m%d)"
ATTACHMENT="pentest-report.md"
RECIPIENT="client@company.com"

# Send with mailx or msmtp
echo "Please find attached the penetration test report." | \
    mailx -s "$SUBJECT" -A "$ATTACHMENT" "$RECIPIENT"

# Or using sendemail
sendemail -f pentester@company.com \
    -t "$RECIPIENT" \
    -u "$SUBJECT" \
    -m "Please find attached the pentest report." \
    -a "$ATTACHMENT" \
    -s smtp.company.com:587 \
    -xu pentester -xp password
```

---

## 4. MCP Integration

### Setup MCP Server
```bash
# Install MCP
pip3 install mcp

# Create MCP config
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/mcp_config.json << 'EOF'
{
  "mcpServers": {
    "pentest-tools": {
      "command": "python3",
      "args": ["/path/to/pentest-mcp-server.py"]
    }
  }
}
```

### Pentest MCP Server Example
```python
#!/usr/bin/env python3
from mcp.server import Server
import subprocess

app = Server("pentest-tools")

@app.tool()
def nmap_scan(target, ports="1-1000"):
    """Run nmap scan on target"""
    result = subprocess.run(
        ["nmap", "-sV", "-p", ports, target],
        capture_output=True, text=True
    )
    return result.stdout

@app.tool()
def nikto_scan(target):
    """Run nikto web scan"""
    result = subprocess.run(
        ["nikto", "-h", target],
        capture_output=True, text=True
    )
    return result.stdout

if __name__ == "__main__":
    app.run()
```

### Attach Skill to MCP
```json
{
  "mcpServers": {
    "kali-redteam": {
      "command": "python3",
      "args": ["~/.config/opencode/skills/kali-redteam/mcp-server.py"]
    }
  }
}
```

---

## 5. Hooks System

### Pre-Engagement Hooks
```bash
#!/bin/bash
# pre-engagement.sh - Runs before any testing

echo "[*] Pre-engagement checks..."

# Check authorization
if [ ! -f authorization.pdf ]; then
    echo "[!] ERROR: No authorization letter found!"
    exit 1
fi

# Check scope
echo "[*] Verifying scope..."
grep -q "10.0.0.1" scope.txt || echo "[!] WARNING: Target not in scope"

# Backup tools
echo "[*] Backing up tools..."
tar -czf tools-backup.tar.gz /usr/share/metasploit*/

# Clean environment
echo "[*] Cleaning environment..."
rm -f ~/.*history 2>/dev/null

echo "[+] Pre-engagement complete"
```

### Post-Exploitation Hooks
```bash
#!/bin/bash
# post-exploit.sh - Auto-runs after shell gained

# Auto-document
echo "[*] Documenting access..." >> ~/findings.log
echo "Shell on $(hostname) at $(date)" >> ~/findings.log

# Auto-enumerate
echo "[*] Running enumeration..."
uname -a >> ~/findings.log
ifconfig >> ~/findings.log 2>/dev/null || ip addr >> ~/findings.log

# Auto-persistence
echo "[*] Setting up persistence..."
# (Add persistence mechanisms here)
```

### Report Hook
```bash
#!/bin/bash
# report-hook.sh - Auto-generates report on completion

echo "[*] Generating final report..."

# Compile all findings
cat ~/findings.log ~/enum-results/* > all-findings.md

# Generate markdown report
python3 report-generator.py

# Send email
./email-report.sh

echo "[+] Report sent!"
```

---

## 6. API Integrations

### VirusTotal API
```bash
#!/bin/bash
# check-ip-virustotal.sh

API_KEY="your-virustotal-api-key"
IP="8.8.8.8"

curl -s -H "x-apikey: $API_KEY" \
    "https://www.virustotal.com/api/v3/ip_addresses/$IP" | \
    jq '.data.attributes.last_analysis_stats'
```

### Shodan API
```bash
#!/bin/bash
# shodan-scan.sh

API_KEY="your-shodan-api-key"
TARGET="example.com"

# Get IP info
curl -s "https://api.shodan.io/dns/resolve?hostnames=$TARGET&key=$API_KEY"

# Port scan
curl -s "https://api.shodan.io/shodan/host/$TARGET?key=$API_KEY"
```

### HaveIBeenPwned API
```bash
#!/bin/bash
# check-email-breach.sh

EMAIL="target@example.com"
API_KEY="your-hibp-api-key"

curl -s -H "hibp-api-key: $API_KEY" \
    "https://haveibeenpwned.com/api/v3/breachedaccount/$EMAIL"
```

---

## 7. AI Integration - Gemini CLI (Kali Built-in!)

### Install Gemini CLI (IN KALI)
```bash
# Kali now has gemini-cli in repos!
sudo apt update
sudo apt install gemini-cli

# Configure
gemini --setup
# Enter your API key when prompted
```

### Using Gemini in Kali
```bash
# Interactive mode
gemini

# Ask security questions
gemini "Explain how to crack WPA2 handshake"

# Get command help
gemini "nmap command for stealth scan"

# Pentest assistance
gemini "suggest commands to enumerate SMB"
```

### Gemini in Pentest Workflow
```bash
#!/bin/bash
# ai-assist.sh - Use Gemini for pentest help

QUERY="$1"

gemini --prompt "$QUERY"
```

### Alternative Free AI Options (Cloud-Based)

| Service | Free Tier | Notes |
|---------|----------|-------|
| **Gemini CLI** | 60 req/min | Already in Kali! |
| **Ollama** | Local only | Best for local |
| **HuggingFace** | 1000/day | Good APIs |
| **Perplexity** | Limited | Web search |
| **GitHub Copilot** | Free for students | Code help |

### Best Free Option for Kali (NOT LOCAL)
**Gemini CLI** is your best bet:
- Already in Kali repos (`sudo apt install gemini-cli`)
- Free tier available (60 requests/min)
- No local GPU needed
- Uses Google's AI models

### Setup HexStrike with Cloud AI
```bash
# Already in your workspace at C:\Users\User\hexstrike-ai\
# Run with cloud API

cd ~/hexstrike-ai
export OPENAI_API_KEY="sk-..."  # Or use Anthropic
export ANTHROPIC_API_KEY="sk-ant-..."

python3 hexstrike_server.py
# Now accessible via MCP!
```

---

## 8. Complete Automation Example

### One-Button Pentest
```bash
#!/bin/bash
# autopentest.sh - Complete automated pentest

TARGET="$1"
if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "[*] Starting automated pentest on $TARGET"

# Setup
mkdir -p ~/pentests/$TARGET
cd ~/pentests/$TARGET
export REPORT_DIR=$(pwd)

# Pre-engagement
./hooks/pre-engagement.sh

# Recon
echo "[*] Phase 1: Reconnaissance"
nmap -sV -sC -O -oA nmap-scan $TARGET

# AI analysis
echo "[*] Analyzing with AI..."
gemini "Analyze this nmap output and suggest next steps: $(cat nmap-scan.nmap)"

# Vulnerability scan
echo "[*] Phase 2: Vulnerability Scanning"
nikto -h $TARGET -o nikto-scan.txt 2>/dev/null
nuclei -u $TARGET -o nuclei-scan.txt 2>/dev/null

# Web testing
echo "[*] Phase 3: Web Testing"
if which dirbuster >/dev/null; then
    # Basic directory scan
    echo "Skipping - use manual dirb"
fi

# AI analysis of vulns
echo "[*] Analyzing vulnerabilities..."
gemini "Prioritize these vulnerabilities: $(cat nuclei-scan.txt 2>/dev/null)"

# Generate report
echo "[*] Generating report..."
./scripts/generate-report.sh

# Email report
echo "[*] Sending report..."
./scripts/email-report.sh

echo "[+] Pentest complete! Report in $REPORT_DIR"
```

---

## Quick Commands Reference

### Daily Workflow
```bash
# Morning refresh
./daily-refresh.sh

# Start engagement
./autopentest.sh target.com

# During engagement
log_finding "Finding" "Details..."

# End of day
./generate-report.sh
./email-report.sh
```

### Update Knowledge Base
```bash
# Pull latest techniques
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/voidsec/pentest-scripts

# Update tools
sudo apt update && sudo apt upgrade
```

---

## Legal Reminder
**Only test systems you own or have explicit written authorization to test!**
