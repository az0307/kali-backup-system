# Chain: Full Recon

## Trigger: Manual
## Purpose: Complete network reconnaissance

### Steps

1. **DNS Enumeration**
```bash
dnsenum target.com
```

2. **Network Scan**
```bash
nmap -sV -p- -T4 target
```

3. **Web Scan**
```bash
nikto -h target
gobuster dir -u target -w /usr/share/wordlists/dirb/big.txt
```

4. **Report**
```bash
cat > recon-report.txt << EOF
Target: $TARGET
Date: $(date)
Results:
EOF
```

### Output
- recon-report.txt
- nmap-results.xml
- nikto-output.txt
