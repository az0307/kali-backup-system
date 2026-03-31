# Reconnaissance Tools Guide

## Overview

Comprehensive network reconnaissance and scanning tools.

## Quick Start

```bash
# Install all recon tools
go recon

# Launch menu
go recon-menu
```

## Installed Tools

### 1. Nmap

The classic network scanner.

```bash
# Basic scan
nmap 192.168.1.1

# Full scan
nmap -sV -p- -T4 192.168.1.1

# Stealth scan
nmap -sT -T2 -p- 192.168.1.1

# OS detection
nmap -O 192.168.1.1

# Scripts
nmap --script vuln 192.168.1.1
```

### 2. Naabu

Fast port scanner by ProjectDiscovery.

```bash
# Quick scan
naabu -host 192.168.1.1

# Top ports
naabu -host 192.168.1.1 -top-ports 100

# Full scan
naabu -host 192.168.1.1 -ports -1

# With nmap
naabu -host 192.168.1.1 -nmap-cli 'nmap -sV'
```

### 3. Httpx

HTTP toolkit for probing.

```bash
# From file
cat targets.txt | httpx

# From naabu output
naabu -host target.com -json | jq -r '.host' | httpx

# With techniques
httpx -list targets.txt -threads 50 -sc -title -server
```

### 4. Nuclei

Vulnerability scanner.

```bash
# Scan targets
nuclei -u target.com

# From file
nuclei -l targets.txt

# Critical only
nuclei -l targets.txt -severity critical,high

# With reporting
nuclei -l targets.txt -o results.txt -json
```

### 5. Subfinder

Subdomain enumeration.

```bash
# Basic
subfinder -d target.com

# With all sources
subfinder -d target.com -all

# Output
subfinder -d target.com -o subdomains.txt
```

### 6. Amass

In-depth subdomain enumeration.

```bash
# Passive
amass enum -passive -d target.com

# Active
amass enum -active -d target.com

# All
amass enum -d target.com
```

### 7. AutoRecon

Automated enumeration.

```bash
# Single target
python3 autorecon.py 192.168.1.1

# Multiple
python3 autorecon.py 192.168.1.1 192.168.1.2

# Specific ports
python3 autorecon.py 192.168.1.1 -p 80,443,22
```

### 8. SpyHunt

Full recon framework.

```bash
# Full scan
python3 spyhunt.py -s target.com

# Port scan
python3 spyhunt.py -n target.com

# Subdomains
python3 spyhunt.py -d target.com
```

## Recon Menu

```bash
# Launch
recon-menu

# Options:
# 1. AutoRecon      - Full automated enumeration
# 2. Naabu          - Fast port scanner
# 3. Httpx          - HTTP probing
# 4. Nuclei         - Vulnerability scanner
# 5. Subfinder      - Subdomain enum
# 6. Amass          - Subdomain enum
# 7. PythMap        - Nmap with banner grab
# 8. SpyHunt        - Full recon framework
# 9. Quick Nmap     - Basic nmap scan
```

## Common Workflows

### Full Recon Workflow

```bash
# 1. Subdomain enum
subfinder -d target.com -o subs.txt

# 2. Port scan
naabu -list subs.txt -top-ports 100 -o ports.txt

# 3. HTTP probe
httpx -list ports.txt -threads 50 -o live.txt

# 4. Nuclei scan
nuclei -l live.txt -severity critical,high,medium -o nuclei.txt
```

### Quick Network Scan

```bash
# Discover hosts
nmap -sn 192.168.1.0/24

# Quick port scan
nmap -F 192.168.1.1

# Full scan
nmap -sV -p- 192.168.1.1 -oA scan
```

### Web Recon

```bash
# Directory busting
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/big.txt

# Nikto
nikto -h target.com

# WhatWeb
whatweb target.com
```

## Wordlists

| Wordlist | Path |
|----------|------|
| SecLists | /usr/share/seclists/ |
| Dirb | /usr/share/wordlists/dirb/ |
| Dirbuster | /usr/share/dirbuster/ |
| RockYou | /usr/share/wordlists/rockyou.txt |

## Installation Script

```bash
# Install all recon tools
bash /root/KaliShare/scripts/install-recon-tools.sh
```

---

*Updated: 2026-03-26*
