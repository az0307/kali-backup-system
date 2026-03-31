# GEMINI KALI GEM - Password Cracking

## WiFi (WPA2)
```
# Capture handshake first
sudo aircrack-ng -w wordlist.hccapx
```

## Hashcat
```
# MD5
hashcat -m 0 hash.txt wordlist

# SHA256
hashcat -m 1400 hash.txt wordlist

# WPA2
hashcat -m 22000 handshake.hccapx wordlist
```

## John the Ripper
```
john --wordlist=wordlist hash.txt
```

## Hydra (Online)
```
hydra -l user -P wordlist target ssh
hydra -L users.txt -P wordlist target ftp
```

---

## Wordlists
```
/usr/share/wordlists/rockyou.txt
/usr/share/seclists/Passwords/
```

⚠️ Use only on systems you own!
