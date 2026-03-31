# ═══════════════════════════════════════════════════════════════
# KALISHARE HIDDEN GEMS - The Real Recon & Pentest Tools
# Lesser-known but powerful tools that pros use
# ═══════════════════════════════════════════════════════════════

## 🎯 SUBDOMAIN ENUMERATION GEMS

### 1. Samoscout (LLM-Powered)
- **Stars:** 106
- **Why:** 53 passive sources + active + neural network prediction
- **Install:** `go install github.com/samogod/samoscout@latest`
- **Use:** `samoscout -d target.com`

### 2. SubHunter (Certificate Transparency)
- **Stars:** NEW (2026)
- **Why:** Fast crt.sh scanning with takeover detection
- **Install:** `git clone https://github.com/egnake/SubHunter.git`
- **Use:** `python main.py` - interactive

### 3. ReClaimor (Subdomain Takeover)
- **Why:** Accurate takeover detection with multi-tier validation
- **Install:** `git clone https://github.com/letchupkt/ReClaimor.git`
- **Use:** `python reclaimor.py --file subs.txt`

### 4. Subfinder (ProjectDiscovery)
- **Why:** Fastest passive enum, 80+ sources
- **Install:** `go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest`
- **Use:** `subfinder -d target.com`

### 5. DNSx (Fast DNS)
- **Why:** Fast DNS validation and resolution
- **Install:** `go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest`
- **Use:** `dnsx -l subs.txt -r resolvers.txt`

## 🕵️ RECONNAISSANCE GEMS

### 6. imRobust (All-in-One Recon)
- **Why:** Network + Web recon in one CLI
- **Install:** `git clone https://github.com/kalomdev/imRobust`
- **Use:** `python imRobust.py --ping --dns --whois target.com`

### 7. Rectron (Bash Automation)
- **Why:** Bug bounty automation with modular CLI
- **Install:** `git clone https://github.com/atulxerma/rectron.git`
- **Use:** `./rectron.sh -d target.com --full`

### 8. Interlace (Parallel Commands)
- **Why:** Run any command across multiple targets
- **Install:** `git clone https://github.com/codingo/Interlace.git`
- **Use:** `interlace -tL targets.txt -c "nmap -A _target_"`

### 9. Netspy (Internal Recon)
- **Why:** Internal network enumeration, red team favorite
- **Use:** `netspy -i eth0`

## 💀 EXPLOITATION GEMS

### 10. STROT (AI Red Teaming)
- **Why:** AI-powered exploitation with Metasploit integration
- **Install:** `git clone https://github.com/codexistdev/project-strot.git`
- **Features:** Auto recon → vuln analysis → exploitation

### 11. Exodus (Agentic Pentesting)
- **Why:** LLM + Kali Linux for automated attacks
- **Install:** Docker-based, uses Grok 2
- **Use:** `./start.sh && uv run main.py`

### 12. PEGASUS (Web Vuln Toolkit)
- **Why:** All-in-one web pentest (SQLi, XSS, CSRF, etc.)
- **Install:** `git clone https://github.com/sobri3195/PEGASUS---Unified-Web-Vulnerability-Toolkit.git`
- **Activation:** Code "sobri"

## 🔍 WEB TESTING GEMS

### 13. Cerberus XSS (Advanced)
- **Why:** WAF bypass, DOM-based, blind XSS
- **Install:** `git clone https://github.com/CerberusMrX/Cerberus-XSS-.git`
- **Features:** Rich TUI, proxy support, session persistence

### 14. UQUIX (Header Fuzzing)
- **Why:** Ultra-fast header manipulation and fuzzing
- **Install:** `git clone https://github.com/0arafa/uquix.git`
- **Use:** `python uquix.py -m Response-Xplore -t target.com`

### 15. Gospider (Web Crawling)
- **Why:** Fast, finds JS endpoints, admin panels
- **Install:** `go install github.com/jaeles-project/gospider@latest`
- **Use:** `gospider -s target.com`

### 16. Katana (Next-gen Crawler)
- **Why:** JS parsing, scope-aware crawling
- **Install:** `go install github.com/projectdiscovery/katana/cmd/katana@latest`
- **Use:** `katana -u target.com`

## 🤖 AI-POWERED GEMS

### 17. KaliGPT (HackerX)
- **Stars:** 152
- **Why:** AI CLI with Gemini, Ollama, ChatGPT support
- **Install:** `curl -sL https://raw.githubusercontent.com/SudoHopeX/KaliGPT/refs/heads/hackerx/install.sh | bash`
- **Use:** `kaligpt "Find XSS on target.com"`

### 18. Kali MCP Server
- **Why:** 25+ security tools via AI (Claude, etc.)
- **Install:** `git clone https://github.com/letchupkt/kali-mcp.git`
- **Use:** `python server.py` (connects to Claude Code)

### 19. HexStrike AI
- **Why:** Purpose-built MCP for pentesting
- **Features:** nuclei_scan, feroxbuster_scan, sqlmap_scan

## 🔐 WIRELESS GEMS

### 20. Wifite2 (Automated)
- **Why:** Fully automated WiFi auditing
- **Install:** Already in Kali, or `git clone https://github.com/derv82/wifite2.git`
- **Use:** `sudo wifite`

### 21. Fluxion (Evil Twin)
- **Why:** WiFi cracking with phishing
- **Install:** `git clone https://github.com/FluxionNetwork/fluxion.git`
- **Use:** `cd fluxion && ./fluxion.sh`

### 22. hcxdumptool / hcxPW
- **Why:** PMKID capture, modern WPA attacks
- **Use:** `hcxdumptool -i wlan0mon -o dump.pcap`

## 📱 MOBILE PENTEST GEMS

### 23. TermuxHunter
- **Why:** Run Kali NetHunter on Android (no root!)
- **Install:** 
  ```bash
  pkg update && pkg install wget -y
  wget -qO- https://raw.githubusercontent.com/KIRAN-KUMAR-K3/TermuxHunter/main/kali-full | bash
  ```
- **Use:** `kali` to enter, `kali vnc` for GUI

### 24. SSH into Termux
- **Why:** Remote access to Android pentest machine
- **Setup:** `pkg install openssh && passwd && sshd`
- **Connect:** `ssh -p 8022 username@ip`

## 🛠️ UTILITY GEMS

### 25. Subjack (Takeover Detection)
- **Why:** Fast subdomain takeover scanner
- **Install:** `go install github.com/haccer/subjack@latest`
- **Use:** `subjack -w subdomains.txt`

### 26. Nuclei (Vuln Scanning)
- **Why:** Template-based, massive community
- **Install:** `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest`
- **Use:** `nuclei -u target.com`

### 27.httpx (Live Probing)
- **Why:** Fast HTTP server detection
- **Install:** `go install github.com/projectdiscovery/httpx/cmd/httpx@latest`
- **Use:** `httpx -l subs.txt`

### 28.naabu (Port Scanning)
- **Why:** Fast port scanner, CDN bypass
- **Install:** `go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest`
- **Use:** `naabu -host target.com`

### 29.Tunna (Firewall Bypass)
- **Why:** Tunnel over HTTP via web shell
- **Install:** `git clone https://github.com/SECFORCE/Tunna.git`
- **Use:** `python tunna.py -l 8080 -r target.com -s 80`

## 📋 QUICK INSTALL SCRIPT

```bash
#!/bin/bash
# Install all hidden gems at once
echo "Installing Hidden Gems..."

# Subdomain
go install github.com/samogod/samoscout@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# Git clones
git clone https://github.com/egnake/SubHunter.git /opt/SubHunter
git clone https://github.com/letchupkt/kali-mcp.git /opt/kali-mcp
git clone https://github.com/letchupkt/ReClaimor.git /opt/ReClaimor
git clone https://github.com/kalomdev/imRobust.git /opt/imRobust
git clone https://github.com/sobri3195/PEGASUS---Unified-Web-Vulnerability-Toolkit.git /opt/PEGASUS
git clone https://github.com/CerberusMrX/Cerberus-XSS-.git /opt/Cerberus
git clone https://github.com/0arafa/uquix.git /opt/uquix
git clone https://github.com/FluxionNetwork/fluxion.git /opt/fluxion
git clone https://github.com/SudoHopeX/KaliGPT.git /opt/KaliGPT

echo "All gems installed!"
```

## 🎯 RECOMMENDED WORKFLOWS

### Bug Bounty Workflow
```bash
# 1. Subdomains
subfinder -d target.com > subs.txt
samoscout -d target.com >> subs.txt

# 2. Live check
httpx -l subs.txt -silent > live.txt

# 3. nuclei scan
nuclei -l live.txt -t takeover -severity critical

# 4. Directory brute
katana -list live.txt -depth 2
```

### Red Team Workflow
```bash
# 1. External recon
subfinder -d target.com -o domains.txt
httpx -list domains.txt -title -tech-detect

# 2. Vulnerability
nuclei -list live.txt -severity high,critical

# 3. Exploitation
msfconsole
```

## 📚 KEYWORD SEARCHES TO FIND MORE

- "bug bounty tools 2025"
- "recon automation github"
- "passive subdomain enumeration"
- "ai penetration testing tools"
- "red team automation frameworks"
- "termux hacking tools"

## ⚠️ LEGAL NOTICE

All tools are for **authorized testing only**. 
Check local laws and get permission before scanning.