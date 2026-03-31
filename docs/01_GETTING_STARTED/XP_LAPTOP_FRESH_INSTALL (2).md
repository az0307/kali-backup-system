# Fresh Install Guide for Old XP Laptop (400GB)

## Option 1: Install Kali Linux (RECOMMENDED)

Since XP is slow and you forgot password, install Kali!

### What You Need:
1. USB flash drive (8GB+)
2. Kali Linux ISO

### Steps:

#### Step 1: Download Kali
```bash
# Option A: Kali Live (easiest)
https://kali.org/download

# Get "Kali Live" ISO (~4GB)
# Or "Kali Installer" (~500MB, downloads packages)
```

#### Step 2: Create Bootable USB
```bash
# Windows - Use Rufus
# Download: https://rufus.ie

# Or using dd (from Kali/Linux):
sudo dd if=kali-linux-2024.x-live-amd64.iso of=/dev/sdX bs=4M status=progress
```

#### Step 3: Boot from USB
1. Plug USB into XP laptop
2. Turn on, press F12/F8/Del for boot menu
3. Select USB drive
4. Choose "Live" or "Install"

#### Step 4: Install Kali
1. Select "Graphical Install"
2. Choose language, location
3. Hostname: `kali-pentest`
4. Partition: "Use Entire Disk"
5. User: `pentest` / password
6. Install GRUB: Yes

---

## Option 2: Install Ubuntu (Easier for Beginners)

If Kali seems too complex:

### Download Ubuntu
```bash
# Ubuntu Desktop 22.04 LTS
https://ubuntu.com/download/desktop

# Minimal: Xubuntu or Lubuntu (lighter)
https://xubuntu.org
https://lubuntu.net
```

### Install Steps
Same as above but with Ubuntu ISO

---

## Option 3: Quick PXE Boot (No USB Needed!)

If you have another Linux machine or can boot into recovery:

### On This Laptop (Host):
```bash
# Install dnsmasq for PXE
sudo apt install dnsmasq

# Configure
cat > /etc/dnsmasq.conf << 'EOF'
interface=eth0
dhcp-range=192.168.1.200,192.168.1.250,12h
dhcp-option=3,192.168.1.1
dhcp-option=6,192.168.1.1
pxe-service=0,"Install Linux"
enable-tftp
tftp-root=/srv/tftp
EOF

# Download Kali netboot
wget http://http.kali.org/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/netboot.tar.gz -O /tmp/netboot.tar.gz
tar -xzf /tmp/netboot.tar.gz -C /srv/tftp/

sudo systemctl restart dnsmasq
```

### On XP Laptop:
1. Boot into network/pxe mode
2. Select network boot
3. It will boot into Kali installer

---

## What's Best For You?

| Option | Pros | Cons |
|--------|------|------|
| **Kali** | All tools ready! | Learning curve |
| **Ubuntu + Tools** | Familiar, easier | More setup |
| **Kali Live USB** | Try without install | No persistence |

---

## After Install: Connect to Home Lab

### On New Kali Laptop:
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

# Restart network
sudo systemctl restart networking

# Test
ping 192.168.1.100  # This laptop
```

### SSH Access:
```bash
# On new Kali
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
sudo passwd root  # Set root password

# From this laptop
ssh pentest@192.168.1.75
```

---

## Full Home Lab Then:

```
                    ┌─────────────────┐
                    │  HUAWEI         │
                    │  HOTSPOT        │ ◄── Internet
                    │  192.168.1.1    │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
    │ THIS LAPTOP │  │ NEW KALI    │  │ XP (OLD)    │
    │ (Control)   │  │ (Pentest)   │  │ (Backup)    │
    │ 192.168.1.100│  │ 192.168.1.75│  │ 10.0.0.66   │
    └─────────────┘  └─────────────┘  └─────────────┘
```

---

## Quick Checklist

- [ ] Download Kali ISO
- [ ] Create bootable USB
- [ ] Boot XP laptop from USB
- [ ] Install Kali (entire disk)
- [ ] Set static IP: 192.168.1.75
- [ ] Install enhance-kali-v3.sh
- [ ] Add to home-lab launcher

---

## Scripts Ready for New Kali:

Copy these to new laptop:
```bash
# From this laptop
scp -r KaliShare/scripts/* pentest@192.168.1.75:/home/pentest/

# On new Kali
sudo ./enhance-kali-v3.sh
```

---

*Let me know when you want to start the install!*
