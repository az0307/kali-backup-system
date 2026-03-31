# 📱 OPENCODE ON MOBILE
## Complete Guide for Android & iOS

---

## 🎯 OPTIONS OVERVIEW

| Option | Platform | Method | Difficulty |
|--------|----------|--------|------------|
| **Web UI** | Both | Browser | ⭐ Easy |
| **Termux** | Android | Terminal | ⭐⭐ Medium |
| **PocketCode** | Android | App | ⭐ Easy |
| **WhisperCode** | iOS/Android | Native App | ⭐ Easy |
| **Remote Code** | iOS | App + Mac | ⭐⭐ Medium |
| **Tailscale** | Both | SSH/Web | ⭐⭐ Easy |

---

## 🌐 OPTION 1: WEB UI (EASIEST)

### From Kali VM
```bash
# In Kali terminal:
opencode web
# Opens at http://0.0.0.0:4096
```

### Access from Phone
Open phone browser → Go to: `http://KALI_IP:4096`

**Get Kali IP:**
```bash
# In Kali:
hostname -I
```

**Access from anywhere (with Tailscale):**
```bash
# On Kali:
tailscale up

# On Phone:
# Install Tailscale app
# Access: http://tailscale-ip:4096
```

---

## 📲 OPTION 2: POCKETCODE (ANDROID)

### Install PocketCode
```bash
# In Termux:
pkg install git
git clone https://github.com/rajbreno/PocketCode.git
cd PocketCode
bash install.sh
```

### Features
- ✅ Runs OpenCode, Claude, Gemini on Android
- ✅ Secure sandbox
- ✅ Fast native execution
- ✅ Web + Terminal interface

### Quick Setup
```bash
# 2 commands only:
curl -s https://raw.githubusercontent.com/rajbreno/PocketCode/main/install.sh | bash
pocketcode
```

---

## 📱 OPTION 3: WHISPERCODE (iOS/Android)

### iOS (App Store)
1. Download: https://apps.apple.com/us/app/whispercode/id6759430954
2. Open app
3. Link with your OpenCode account

### Android (APK)
1. Download: https://github.com/DNGriffin/whispercode/releases/tag/v1.0.0
2. Install APK
3. Open app

### Features
- ✅ Native mobile app
- ✅ iOS & Android support
- ✅ Latest animations
- ✅ Free (no catch!)

---

## 🔗 OPTION 4: TERMUX + OPENCODE

### Install OpenCode in Termux
```bash
# Update
pkg update && pkg upgrade -y

# Install Node.js
pkg install nodejs

# Install OpenCode
npm install -g opencode-ai

# Test
opencode --version
```

### Use OpenCode in Termux
```bash
# Terminal mode
opencode

# Web mode
opencode web
# Then access from browser
```

### Issues & Fixes

**Problem:** OpenCode crashes in Termux
**Solution:** Use proot distro
```bash
pkg install proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
# Now install OpenCode in Ubuntu
```

---

## 🖥️ OPTION 5: REMOTE CODE (iOS)

### Setup Remote Code
1. **On Mac/Windows:** Install Uplink from https://remote-code.com
2. **On iPhone:** Download from TestFlight
3. **Pair devices:** Use pairing code
4. **Access OpenCode:** Via app

### Features
- ✅ Full OpenCode on iPhone
- ✅ Git integration
- ✅ Session continuity
- ✅ Gesture navigation

---

## 🔐 OPTION 6: TAILSCALE + WEB

### Setup Tailscale
```bash
# On Kali VM:
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Get auth key from: https://login.tailscale.com/admin/settings
```

### On Phone
1. Install Tailscale app
2. Login with same account
3. Access Kali services from anywhere

### Access OpenCode
```bash
# On Kali:
opencode web

# On Phone browser:
http://tailscale-ip:4096
```

---

## 🎨 MOBILE-OPTIMIZED WORKFLOWS

### Workflow 1: Quick Coding
```
Phone → Browser → OpenCode Web → Code
```

### Workflow 2: Terminal Access
```
Phone → Termux → SSH → Kali VM → opencode
```

### Workflow 3: Remote Control
```
Phone → Tailscale → Kali → opencode web
```

### Workflow 4: Native App
```
Phone → WhisperCode/PocketCode → AI coding
```

---

## 📊 COMPARISON TABLE

| Method | Platform | Setup | Speed | Features |
|--------|----------|-------|-------|----------|
| Web UI | Both | Easy | Fast | Full |
| PocketCode | Android | Easy | Fast | Full |
| WhisperCode | iOS/Android | Easy | Fast | Full |
| Termux | Android | Medium | Medium | Terminal |
| Remote Code | iOS | Medium | Fast | Full |
| Tailscale | Both | Easy | Fast | Full |

---

## 🚀 QUICK START BY DEVICE

### Android Phone
**Best option: PocketCode**
```bash
pkg install git
git clone https://github.com/rajbreno/PocketCode.git
cd PocketCode && bash install.sh
```

### iPhone
**Best option: WhisperCode or Remote Code**
- Download WhisperCode from App Store
- OR setup Remote Code with Uplink

### Any Phone + Kali VM
**Best option: Web UI + Tailscale**
1. Run `opencode web` on Kali
2. Access from phone browser
3. Use Tailscale for remote access

---

## 🔧 TROUBLESHOOTING

### "opencode: command not found"
```bash
# Reinstall
npm install -g opencode-ai
```

### "Port already in use"
```bash
# Kill process
pkill -f opencode
# Or use different port
opencode web --port 4097
```

### "Can't connect from phone"
```bash
# Check Kali IP
hostname -I
# Make sure phone is on same network
# Or use Tailscale
```

### Termux issues
```bash
# Use proot distro
proot-distro install ubuntu
proot-distro login ubuntu
# Then install in Ubuntu
```

---

## 📦 INSTALL SCRIPT FOR ANDROID

Create `mobile-opencode.sh`:
```bash
#!/bin/bash
# MOBILE OPENCODE INSTALLER

echo "Installing OpenCode on mobile..."

# Update
pkg update && pkg upgrade -y

# Install essentials
pkg install -y nodejs git curl wget

# Install OpenCode
npm install -g opencode-ai

# Test
opencode --version

# Create web start script
cat > ~/start-opencode.sh << 'EOF'
#!/bin/bash
echo "Starting OpenCode Web..."
opencode web
echo "Open in browser: http://$(hostname -I | awk '{print $1}'):4096"
EOF
chmod +x ~/start-opencode.sh

echo "✅ Done! Run ~/start-opencode.sh to start web UI"
```

---

## 🎯 BEST SETUP BY USE CASE

### For Quick Checks
→ **Web UI** - Just open browser

### For Full Coding
→ **PocketCode (Android)** or **WhisperCode (iOS)**

### For Remote Access
→ **Tailscale + Web UI**

### For Terminal Lovers
→ **Termux + SSH to Kali**

---

## 📱 TODAY'S RECOMMENDATION

**If you have Android:**
1. Install PocketCode
2. Open app
3. Code anywhere!

**If you have iPhone:**
1. Download WhisperCode
2. Or setup Remote Code
3. Code on the go!

**If you have Kali VM:**
1. Run `opencode web`
2. Access from phone browser
3. Use Tailscale for remote

---

**Bottom line:** OpenCode on mobile is very possible and easy to set up! 🚀

Which device do you have? I can give specific instructions!
