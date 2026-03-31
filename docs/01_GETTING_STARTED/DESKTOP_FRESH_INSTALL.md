# 🖥️ Desktop PC Fresh Install - Bypass Guest Mode

## The Problem
```
PC boots to Windows XP Guest account
No admin access
Can't install anything
400GB hard drive
```

## Solutions (Easiest First)

### Option 1: Boot from USB (RECOMMENDED)

**What you need:**
- Another PC to create USB
- 8GB+ USB flash drive

**Steps:**
1. On THIS laptop, download Kali ISO
2. Create bootable USB with Rufus
3. Plug USB into desktop
4. Turn on desktop, press **F12** or **Del** or **F2** for boot menu
5. Select USB to boot
6. Install Kali!

---

### Option 2: Network Boot (PXE)

If USB doesn't work:
1. Connect desktop to router
2. This laptop as PXE server
3. Boot over network

---

### Option 3: Remove Hard Drive

**Quickest way:**
1. Turn off desktop, unplug power
2. Open tower case
3. Remove 400GB hard drive
4. Connect to this laptop as external drive
5. Wipe and install Kali using this laptop
6. Put drive back in desktop

---

## What To Download

### Kali Linux (Recommended)
```
Download: https://kali.org/download

Choose:
- Kali Live ISO (~4GB) - Easiest
- Kali Installer ISO (~500MB) - Smaller, downloads packages
```

### Tools to Make USB
```
Rufus: https://rufus.ie
- Select USB drive
- Select Kali ISO
- Click Start
```

---

## After Install - Network Setup

Once Kali is installed on the desktop:

```bash
# Set static IP
sudo nano /etc/network/interfaces

# Add:
auto eth0
iface eth0 inet static
address 192.168.1.75
netmask 255.255.255.0
gateway 192.168.1.1
dns-nameservers 8.8.8.8

# Restart
sudo systemctl restart networking

# Enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Set root password
sudo passwd root
```

---

## Home Lab Then:

```
                    ┌─────────────────┐
                    │  HUAWEI HOTSPOT│ ← Internet
                    │  192.168.1.1    │
                    └────────┬────────┘
                             │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  THIS LAPTOP  │   │  DESKTOP     │   │  OLD XP      │
│  Control      │   │  NEW KALI    │   │  (maybe NAS) │
│  192.168.1.100│   │  192.168.1.75│   │  10.0.0.66   │
└───────────────┘   └───────────────┘   └───────────────┘
```

---

## Need Help With?

1. **Download Kali** - I can give you the direct link
2. **Create bootable USB** - I can walk you through Rufus
3. **Boot from USB** - What key does your desktop use? (F12, Del, F2?)
4. **Remove hard drive** - Need case opening guide
