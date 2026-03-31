# Package Installation Guide

## Update Kali
```bash
apt update && apt full-upgrade -y
```

## Core Wireless Tools
```bash
apt install aircrack-ng reaver bully wash
apt install fern-wifi-cracker wifite
apt install wpasupplicant
```

## Network Tools
```bash
apt install nmap masscan rustscan
apt install net-tools iproute2
```

## Password Cracking
```bash
apt install hashcat john
apt install crunch cewl cupp
```

## Web Application Testing
```bash
apt install nikto sqlmap
apt install gobuster dirb ffuf
```

## Exploitation
```bash
apt install metasploit-framework
apt install searchsploit
```

## Post-Exploitation
```bash
apt install mimikatz
apt install evil-winrm
```

## Python Security Tools
```bash
pip3 install scapy netifaces impacket pwntools
pip3 install requests beautifulsoup4
```

## Wordlists
```bash
# Install
apt install wordlists

# Download additional
curl -L -o /usr/share/wordlists/rockyou.txt.gz \
  https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt.gz
gunzip /usr/share/wordlists/rockyou.txt.gz

# SecLists
git clone https://github.com/danielmiessler/SecLists.git /usr/share/seclists
```

## Build Tools
```bash
apt install build-essential linux-headers-$(uname -r)
```

## Metapackages
```bash
# Core tools
apt install kali-tools-top10

# Wireless
apt install kali-tools-wireless

# Exploitation
apt install kali-tools-exploitation

# Password
apt install kali-tools-passwords

# All tools
apt install kali-linux-large
```

## HexStrike AI
```bash
git clone https://github.com/0x4m4/hexstrike-ai.git
cd hexstrike-ai
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
python3 hexstrike_server.py
```

## 2026 AI Tools
```bash
# OpenRT
git clone https://github.com/AI45Lab/OpenRT.git
cd OpenRT
pip install -r requirements.txt

# DeepTeam
pip install deepteam

# PyRIT (Microsoft)
pip install pyrit
```
