# Connect Termux (Phone) to Kali VM

## Option 1: Same WiFi Network (Local)

### On Kali VM (Run once):
```bash
# Install SSH server
sudo apt install -y openssh-server

# Start SSH
sudo service ssh start

# Get Kali's IP address
hostname -I
```

### On Termux (Phone):
```bash
# Install SSH client
pkg update
pkg install openssh

# Connect to Kali
ssh root@192.168.1.X
# Replace with Kali's actual IP address
```

---

## Option 2: Anywhere (Using Tailscale VPN)

### Step 1: Install Tailscale on Both

**On Kali:**
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

**On Termux:**
```
Download from F-Droid or Google Play:
https://f-droid.org/packages/com.tailscale.ipn/
```

### Step 2: Get Tailscale IPs

**On Kali:**
```bash
tailscale ip -4
# Example output: 100.64.1.2
```

**On Termux:**
- Open Tailscale app
- Note your IP (similar format: 100.64.x.x)

### Step 3: Connect

**From Termux:**
```bash
ssh root@100.64.1.2
```

---

## Option 3: Using Ngrok (No VPN)

### On Kali:
```bash
# Install ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.zip -o ngrok.zip
unzip ngrok.zip
sudo mv ngrok /usr/local/bin/

# Authenticate (get token from https://dashboard.ngrok.com)
./ngrok authtoken YOUR_TOKEN

# Forward SSH
./ngrok tcp 22
```

### On Termux:
```bash
# Install ngrok for Termux
pkg install wget
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
./ngrok tcp 22

# Or just use the URL from Kali's ngrok
ssh root@0.tcp.ngrok.io -p XXXXX
```

---

## Complete Termux Setup Script

```bash
# Update packages
pkg update && pkg upgrade

# Install openssh
pkg install openssh

# Set password
passwd

# Start SSH server
sshd

# Get username
whoami

# Get IP (if on same network)
hostname -I

# Connect from Kali:
# ssh <username>@<phone_ip> -p 8022
```

---

## Quick Reference

| Scenario | Command |
|----------|---------|
| **Same WiFi** | `ssh root@192.168.1.X` |
| **With Tailscale** | `ssh root@100.64.X.X` |
| **With Ngrok** | `ssh root@X.tcp.ngrok.io -p XXXXX` |

---

## Security Tips

1. **Use key-based auth** instead of passwords
2. **Change default SSH port** (edit `/etc/ssh/sshd_config`)
3. **Use fail2ban** to prevent brute force
4. **Keep Termux awake** with `termux-wake-lock`

---

## Troubleshooting

### "Connection refused"
- Make sure `sshd` is running on Termux
- Check port: `sshd -p 8022` (specify port)

### "Permission denied"
- Check password with `passwd`
- Make sure password is set on Termux

### "Connection timed out"
- Check both devices on same network
- Check firewall: `sudo ufw allow 22`

---

## Use Cases

- Access Kali from phone while away
- Run tools remotely
- Monitor scans from phone
- Quick checks without laptop
