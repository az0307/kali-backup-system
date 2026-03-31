# GEMINI KALI GEM - Web Testing

## Quick Commands

### Basic Scan
```
nikto -h target.com
```

### SQL Injection
```
sqlmap -u target.com --risk=3 --level=5
```

### Directory Busting
```
gobuster dir -u target.com -w /usr/share/wordlists/dirb/common.txt
```

### WordPress
```
wpscan --url target.com
```

### XSS Testing
```
xsstrike -u target.com
```

---

## Useful Wordlists
```
/usr/share/wordlists/dirb/common.txt
/usr/share/wordlists/dirbuster/
/usr/share/seclists/Discovery/Web-Content/
```
