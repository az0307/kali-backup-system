# Stealth & Clean Exit Guide

## 🎭 Overview

When conducting authorized testing, always leave no trace.

---

## 🔄 MAC Address Spoofing

### Before Attack
```bash
# Check current MAC
ip link show wlan0

# Spoof MAC (need to be root)
sudo macchanger -r wlan0

# Verify
macchanger -s wlan0
```

### Auto-spoof on Boot
```bash
# Edit /etc/network/interfaces
sudo nano /etc/network/interfaces

# Add:
pre-up macchanger -r wlan0
```

---

## 🛡️ VPN + Kill Switch

### Install VPN
```bash
# Install WireGuard or OpenVPN
sudo apt install wireguard openvpn

# Connect to your VPN
sudo wg-quick up your-vpn
```

### Kill Switch Script
```bash
#!/bin/bash
# Save as: /opt/kill-switch.sh

VPN_INTERFACE="wg0"  # Change to your VPN interface
FALLBACK_INTERFACE="wlan0"

# Allow traffic through VPN only
iptables -F
iptables -X

# Default DROP everything
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow VPN
iptables -A INPUT -i $VPN_INTERFACE -j ACCEPT
iptables -A OUTPUT -o $VPN_INTERFACE -j ACCEPT

echo "✅ Kill switch enabled - only VPN traffic allowed"

# If VPN drops, internet dies
```

---

## 🧹 Log Cleaning

### Before You Start
```bash
# Clear bash history for this session
history -c
export HISTSIZE=0

# Disable history temporarily
set +o history
```

### After You're Done
```bash
# Clear bash history
history -c
> ~/.bash_history

# Clear system logs (careful!)
sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/auth.log

# Clear temp files
rm -rf /tmp/*
rm -rf ~/.cache/*
```

### Individual Files
```bash
# Timestomp (Metasploit)
# In meterpreter:
timestomp file.txt -m "01/01/2020 10:10:10"
timestomp file.txt -v

# Or use touch
touch -t 202001011010.10 file.txt
```

---

## 🚪 Clean Exit Checklist

Before closing session:
- [ ] Disconnect from all targets
- [ ] Close all shells/terminals
- [ ] Delete any uploaded files
- [ ] Clear browser history/cache
- [ ] Clear clipboard
- [ ] Remove any scripts left on target
- [ ] Kill any background processes
- [ ] Restore original MAC if changed
- [ ] Disconnect VPN
- [ ] Clear bash history
- [ ] Take screenshot of completed work (for report)

---

## 🔍 Detection Awareness

### They Can See
- Your IP address
- DNS queries
- Traffic patterns
- Login times
- File modifications
- Process activity

### You Can Hide
- Use VPN
- Use Tor
- Change MAC
- Use burner accounts
- Time your attacks
- Blend in with normal traffic

---

## 📝 Evidence to Remove

| Evidence | How to Remove |
|----------|---------------|
| Bash history | `history -c` |
| System logs | `truncate -s 0 /var/log/...` |
| Temp files | `rm -rf /tmp/*` |
| Downloads | Clear browser DL folder |
| Screenshots | Delete from ~/Pictures |
| Emails | Delete sent emails |

---

## ⚠️ LEGAL REMINDER

Only use on systems you own or have written authorization!
