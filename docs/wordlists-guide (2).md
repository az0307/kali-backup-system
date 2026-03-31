# Red Team Wordlists & Resources Guide

## Where Wordlists Are Located

### Kali Built-in
```bash
/usr/share/wordlists/
```

### Common Wordlists

| File | Description | Size |
|------|-------------|------|
| rockyou.txt | Most popular, 14M passwords | 134MB |
| fasttrack.txt | Common passwords | ~2MB |
| dirb/common.txt | Directory names | ~2MB |
| sqlmap.txt | SQL injection payloads | ~100KB |

### Installing Wordlists
```bash
# Kali already has these:
ls /usr/share/wordlists/

# Extract rockyou.txt
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Install additional
sudo apt install wordlists seclists
```

## Downloading More Wordlists

### SecLists (Comprehensive)
```bash
git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists
```

### FuzzDB (Fuzzing)
```bash
git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git /usr/share/fuzzdb
```

### PayloadsAllTheThings
```bash
git clone --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git /opt/PayloadsAllTheThings
```

## Common Wordlist Locations

### Directory Brute Force
```bash
/usr/share/dirb/wordlists/
/usr/share/dirbuster/wordlists/
/usr/share/seclists/Discovery/Web-Content/
```

### Password Cracking
```bash
/usr/share/wordlists/rockyou.txt
/usr/share/john/password.lst
/usr/share/metasploit-framework/data/wordlists/
```

### DNS
```bash
/usr/share/seclists/Discovery/DNS/
/usr/share/dnsmap/wordlist_TLAs.txt
```

## Usage Examples

### Aircrack-ng (WiFi)
```bash
# Basic
aircrack-ng -w /usr/share/wordlists/rockyou.txt capture.cap

# With hashcat format
aircrack-ng -w /usr/share/wordlists/rockyou.txt -J output handshake.hccapx
```

### Hashcat
```bash
# WPA2
hashcat -m 22000 handshake.hccapx /usr/share/wordlists/rockyou.txt

# MD5
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt

# NTLM
hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt
```

### John the Ripper
```bash
# Single mode
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt

# With rules
john --wordlist=/usr/share/wordlists/rockyou.txt --rules hash.txt
```

### Hydra (SSH)
```bash
hydra -l root -P /usr/share/wordlists/rockyou.txt 192.168.1.1 ssh
```

### Gobuster (Web)
```bash
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

### SQLMap
```bash
sqlmap -u "http://target.com" --wordlist=/usr/share/seclists/Payloads/SQLi/Common.txt
```

## Wordlist Tools

### Crunch (Generate Wordlists)
```bash
# Basic
crunch 8 12 abcdefghijklmnopqrstuvwxyz -o wordlist.txt

# With pattern
crunch 6 8 0123456789 -t ,%%^^%% -o wordlist.txt

# From charset
crunch 4 4 -f /usr/share/crunch/charset.lst mixalpha -o wordlist.txt
```

### CUPP (Common User Passwords Profiler)
```bash
git clone https://github.com/Mebus/cupp.git
python3 cupp.py -i
```

### Meggify (Mangling)
```bash
hashcat -r /usr/share/hashcat/rules/best64.rule wordlist.txt | tee mutated.txt
```

## Creating Custom Wordlists

### From Target Website
```bash
cewl http://target.com -w custom-wordlist.txt
```

### From GitHub
```bash
git clone https://github.com/00xBAD/kali-wordlists.git
```

### Combine Wordlists
```bash
cat wordlist1.txt wordlist2.txt | sort -u > combined.txt
```

## Practice Targets

### Vulnerable VMs
- Metasploitable 2
- DVWA
- OWASP WebGoat
- HackTheBox
- TryHackMe

### WiFi Practice
- Your own router
- OpenWrt lab
- WiFi Pineapple (if authorized)

## Legal Reminder

⚠️ Only use on systems you own or have explicit written authorization!
