# GEMINI KALI GEM - Network Scanning

## Quick Scans

### Basic Scan
```
nmap target.com
```

### Full Scan
```
sudo nmap -sV -sC -p- -A target
```

### Fast Scan
```
rustscan -a target --ulimit 5000
```

### Ping Sweep
```
nmap -sn 192.168.1.0/24
```

### Service Detection
```
nmap -sV target
```

### OS Detection
```
sudo nmap -O target
```

---

## Common Ports
| Port | Service |
|------|---------|
| 21 | FTP |
| 22 | SSH |
| 80 | HTTP |
| 443 | HTTPS |
| 3306 | MySQL |
| 3389 | RDP |
| 8080 | HTTP-Proxy |
