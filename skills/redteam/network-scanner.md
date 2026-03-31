# Network Scanner Skill

## Purpose
Automated network reconnaissance and scanning using nmap, masscan, and related tools.

## Tools
- nmap - Network mapper
- masscan - Fast TCP scanner
- net-tools - ifconfig, netstat
- iproute2 - ip command

## Commands

### Quick Scan
```bash
nmap -sn 192.168.1.0/24
```

### Full Port Scan
```bash
nmap -sV -p- -T4 target
```

### UDP Scan
```bash
nmap -sU target
```

## Usage
Use this skill when user wants to:
- Scan local network
- Discover live hosts
- Port enumeration
- Service detection
- OS fingerprinting

## Safety
Only scan networks you own or have permission to test.
