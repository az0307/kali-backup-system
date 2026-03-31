# Kali Linux VM Setup Guide

## VM Specifications

- **Name**: Kali-Linux-Wireless
- **OS**: Debian 64-bit (Kali Linux)
- **RAM**: 4096 MB (4 GB)
- **CPUs**: 2
- **VRAM**: 128 MB
- **Disk**: 50 GB (VDI, Dynamic)
- **Network**: Bridged Adapter (Atheros AR9271 for WiFi monitoring)

---

## Installation Steps

### 1. Download Kali Linux
```bash
# Option A: Netinst ISO (smallest, ~50MB)
https://www.kali.org/get-kali/#kali-installer-images

# Option B: Full ISO (~4GB)
https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-installer-amd64.iso
```

### 2. Create VM in VirtualBox
1. Open VirtualBox → New
2. Name: Kali-Linux-Wireless
3. Type: Linux, Version: Debian (64-bit)
4. Memory: 4096 MB
5. Create virtual hard disk: 50 GB (VDI, Dynamic)
6. Settings → System → Processor: 2 CPUs
7. Settings → Display → VRAM: 128 MB
8. Settings → Network → Bridged Adapter (choose WiFi adapter for monitor mode)
9. Settings → USB → Enable USB 3.0 (xHCI)
10. Add USB Filter: TP-Link TL-WN721N (Vendor: 0bda, Product: 8179)

### 3. Install Kali
1. Start VM with Kali ISO
2. Follow installation wizard
3. Root password: toor (or your preference)
4. Partition: Guided - Use entire disk
5. Install GRUB: Yes

---

## Post-Installation Setup

### Quick Install (Recommended)
```bash
# In Kali terminal
curl -fsSL https://raw.githubusercontent.com/your-repo/kali-setup/main/quick-install-kali.sh | sudo bash
```

### Manual Install
```bash
# Update
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt install -y nodejs

# Install AI Tools
sudo npm install -g opencode-ai @google/gemini-cli @agent-tars/cli

# Install Python tools
sudo apt install -y python3-pip
pip3 install --break-system-packages requests pwntools scapy
```

---

## Enable SSH
```bash
sudo systemctl enable ssh
sudo systemctl start ssh
sudo sed -i 'PermitRootLogin yes' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

---

## USB WiFi Adapter (Monitor Mode)

### For TP-Link TL-WN721N (AR9271)
```bash
# Check if detected
lsusb
iw dev

# Start monitor mode
sudo airmon-ng start wlan0

# Test
sudo airodump-ng wlan0mon
```

---

## Copy Scripts from Windows

### Method 1: Shared Folder
1. VirtualBox → Kali VM → Settings → Shared Folders
2. Add folder: C:\Users\User\KaliShare
3. Mount in Kali:
```bash
sudo mkdir /mnt/share
sudo mount -t vboxsf KaliShare /mnt/share
```

### Method 2: USB Drive
1. Create ISO of scripts folder
2. Copy to Kali via shared folder after install

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `opencode` | Start OpenCode |
| `gemini` | Start Gemini CLI |
| `agent-tars` | Start TARS |
| `sudo airmon-ng` | Check wireless interfaces |
| `sudo airodump-ng wlan0mon` | Scan WiFi networks |
| `ssh root@<IP>` | SSH into Kali from Windows |

---

## VM Backup

### Take Snapshot
```bash
VBoxManage snapshot "Kali-Linux-Wireless" take "clean-install"
```

### Export OVA
```bash
VBoxManage export "Kali-Linux-Wireless" -o kali-backup.ova
```
