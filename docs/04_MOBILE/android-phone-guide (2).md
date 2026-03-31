# Android Integration - What to Do With Your Phone

## 1. Termux Setup (Linux on Phone)

### Install Termux
- **From F-Droid** (recommended, always updated)
- Download: https://f-droid.org/packages/com.termux/

### Basic Termux Commands
```bash
# Update
pkg update && pkg upgrade

# Install basics
pkg install openssh git python nodejs

# Install Python tools
pip install requests beautifulsoup4

# Set password for SSH
passwd
```

### SSH into Kali from Phone
```bash
# In Termux, get your phone IP
termux-wifi-connectioninfo

# SSH from phone to Kali
ssh aries@192.168.1.X  # Replace with Kali IP
```

---

## 2. Android Hacking Tools

### Termux Tools to Install
```bash
# Network scanning
pkg install nmap

# Web testing
pkg install sqlmap

# Password tools
pkg install hydra

# WiFi analysis
pkg install aircrack-ng  # (limited on Android)
```

### Popular Termux Hacking Distributions
- **Kali NetHunter** - Full Kali on rooted Android
- **ZArchiver** - Extract files
- **Termux:API** - Hardware access
- **Nethunter App** - Kali interface

---

## 3. ADB (Android Debug Bridge)

### Enable on Android Phone
1. Settings → About Phone → Tap "Build Number" 7 times
2. Go back → Developer Options → Enable "USB Debugging"

### Connect from Kali
```bash
# Install ADB
sudo apt install android-tools-adb

# Connect phone via USB
adb devices

# If not detected:
adb kill-server
adb start-server
adb devices
```

### Useful ADB Commands
```bash
adb shell              # Phone terminal
adb push file /sdcard/ # Copy to phone
adb pull /sdcard/file  # Copy from phone
adb logcat             # View logs
adb install app.apk    # Install app
```

---

## 4. Remote Access Options

### Option A: SSH Server on Phone (Termux)
```bash
# In Termux:
pkg install openssh
passwd
sshd

# Connect from Kali:
ssh phoneuser@PHONE_IP
```

### Option B: Use TARS from Phone
- Access `http://KALI_IP:8888` from phone browser
- Control Kali remotely

### Option C: VNC Server
```bash
# Install VNC on Kali
sudo apt install tigervnc-standalone-server

# Start VNC
vncserver

# Connect from phone with VNC viewer app
```

---

## 5. For Hacking/WiFi on Android

### If You Want to Hack WiFi from Phone:
- **Best**: Use Kali VM (you already have!)
- **Phone WiFi**: Limited capability, needs rooted device
- **USB Adapter**: TP-Link AR9271 works in Termux!

```bash
# In Termux (with USB adapter connected)
pkg install aircrack-ng
termux-setup-storage
# (Now you need root for full WiFi hacking)
```

### For WiFi Auditing:
- **Kali + TP-Link**: Best option
- **Phone-only**: Limited to monitoring (no injection)

---

## 🎯 **Recommended Setup**

**For Pentesting from Phone:**
1. Keep Kali VM running
2. Install Termux on phone
3. SSH into Kali from Termux
4. OR access TARS web interface in phone browser

**Commands to run NOW:**
```bash
# In Kali VM
cd /media/sf_KaliShare/scripts
sudo bash install-all-kali.sh  # Installs everything

# In phone (after Termux install)
ssh aries@KALI_IP
```

---

## ⚠️ **Limitations**
- Phone WiFi can't do monitor mode without root
- ADB doesn't allow full WiFi hacking
- **Best setup**: Kali VM + SSH from phone

**Need help with specific phone task?**
