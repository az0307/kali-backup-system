# Android Developer Mode - Quick Guide

## Enable Developer Mode (All Androids)

### Method 1: Settings (Easiest)
1. **Open Settings** → **About Phone**
2. **Find "Build Number"** (bottom of list)
3. **Tap Build Number 7 times**
4. Enter your PIN/pattern if asked
5. ✅ Done! See "Developer options" in Settings

### Method 2: Quick Access
1. Swipe down → ⚙️ Settings
2. Search "Developer"
3. Tap "Developer Options"

---

## Enable USB Debugging

1. **Settings** → **Developer Options**
2. Turn **ON** "Developer Options" toggle
3. Enable **"USB Debugging"**
4. Enable **"Install via USB"** (for APK installs)
5. **Optional:** Disable "Verify apps over USB"

---

## Connect to Computer

### Windows
```bash
# Install ADB
# Download from: https://developer.android.com/studio/releases/platform-tools

# Or via Chocolatey:
choco install adb

# Connect
adb devices
```

### Linux/Kali
```bash
sudo apt install adb
adb devices
```

---

## Useful ADB Commands

| Command | What it does |
|---------|-------------|
| `adb devices` | List connected devices |
| `adb shell` | Open phone terminal |
| `adb push file /sdcard/` | Copy file to phone |
| `adb pull /sdcard/file` | Copy file from phone |
| `adb install app.apk` | Install APK |
| `adb reboot` | Restart phone |
| `adb reboot recovery` | Boot to recovery |
| `adb tcpip 5555` | Enable wireless debugging |

---

## Wireless ADB (No USB)

### On Phone:
1. Connect via USB
2. `adb tcpip 5555`
3. Unplug USB

### On Computer:
```bash
adb connect PHONE_IP:5555
# Get IP from phone: Settings → About Phone → IP Address
```

---

## For Termux

### Install Termux (Best Source)
```
# Use F-Droid (NOT Google Play - outdated!)
https://f-droid.org/packages/com.termux/
```

### In Termux:
```bash
# Update
pkg update && pkg upgrade

# Install basics
pkg install python git curl wget

# Install openssh
pkg install openssh
passwd
sshd

# Get IP
hostname -I
```

---

## Quick Checklist

- [ ] Enable Developer Mode (tap Build Number 7x)
- [ ] Enable USB Debugging
- [ ] Connect USB → Allow computer
- [ ] Install ADB on Kali
- [ ] Test: `adb devices`

---

## Troubleshooting

### "Unauthorized"
- Unlock phone → Click "Allow USB Debugging"

### "No devices found"
- Try different USB cable
- Check USB Debugging is ON
- Try USB port (not hub)

### "Device offline"
- Revoke USB debugging authorizations
- Reconnect and allow again
