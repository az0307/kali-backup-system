# Hardware Platforms: Raspberry Pi, Flipper Zero & More

## 1. RASPBERRY PI

### Models for Pentesting

| Model | Best For | Price | Specs |
|-------|----------|-------|-------|
| **Pi 5** | Full pentest lab | $80+ | 8GB RAM, 4 cores |
| **Pi 4** | Portable lab | $55+ | 4-8GB RAM |
| **Pi 400** | Desktop replacement | $100 | Keyboard form |
| **Pi Zero 2 W** | Stealth/IoT | $15 | Small, low power |

### Recommended Setup (Pi 5)
```bash
# Install Kali
sudo apt install kali-linux-arm64

# Or use PiKVM
wget https://pikvm.org/images/(latest-version)-raspios.img
```

### Wireless Pi Setup
```bash
# Compatible adapters (same as Kali):
# - TP-Link TL-WN722N v2 (AR9271)
# - Alfa AWUS036NHA
# - WiFi Pineapple (pre-configured)

# Install tools
sudo apt update
sudo apt install aircrack-ng airmon-ng reaver
```

### Best Pi Projects
| Project | Use | Install |
|---------|-----|----------|
| **Wifipumpkin3** | Rogue AP | `git clone https://github.com/mrc-node/wifipumpkin3` |
| **Pinecone** | WiFi auditing | `git clone https://github.com/pinecone-wifi/pinecone` |
| **PirateBox** | Offline comms | Pre-installed on Pi |
| **P4wnP1** | USB attacks | Pre-installed on Pi |
| **Wifiphisher** | Phishing AP | `sudo apt install wifiphisher` |
| **PiKVM** | Remote management | Pre-installed on Pi |

### Pi Accessories
| Item | Price | Notes |
|------|-------|-------|
| 7dBi antenna | $15 | Range boost |
| 16GB SD card | $10 | Kali fits |
| USB-C battery | $25 | Portable power |
| HDMI case | $20 | Stealth |

### Pi Scripts
```bash
# Auto-install all tools
wget -q https://raw.githubusercontent.com/kali-tools/kali-pi/main/install.sh -O /tmp/install.sh
chmod +x /tmp/install.sh
sudo /tmp/install.sh
```

---

## 2. FLIPPER ZERO

### Capabilities

| Feature | Frequency | Range |
|---------|-----------|-------|
| **Sub-GHz** | 300-928 MHz | ~50m |
| **NFC** | 13.56 MHz | <5cm |
| **RFID** | 125/134 kHz | <5cm |
| **IR** | Infrared | ~5m |
| **iButton** | 1-Wire | Contact |
| **BadUSB** | USB HID | N/A |

### Firmware Options
| Firmware | Pros | Cons |
|----------|------|------|
| **Official** | Stable, supported | Limited features |
| **Unleashed** | More features, community | May lose warranty |
| **Momentum** | Gaming focus | Less pentest tools |
| **RogueMaster** | Most features | Beta quality |

### Installation
```bash
# Via qFlipper (GUI)
# 1. Download qFlipper from flipper.zero
# 2. Connect Flipper via USB
# 3. Drag firmware .dfu file

# Via CLI
git clone https://github.com/flipperdevices/flipper-zero-firmware.git
./fbt
```

### Essential Apps
| App | Use | Source |
|-----|-----|--------|
| **Flipper Script Manager** | Run custom scripts | Built-in |
| **SubGHz** | Capture/replay RF | Built-in |
| **NFC** | Read/write cards | Built-in |
| **RFID** | Clone tags | Built-in |
| **BadUSB** | Keyboard attacks | Built-in |

### Pentesting Scripts (GitHub)
```bash
# Clone community scripts
git clone https://github.com/Flipper-Zero-Tools/wasp_emulator
git clone https://github.com/RocketGod-git/flipper-zero-firmware
git clone https://github.com/ADolbyB/flipper-zero-files

# Useful apps:
# - FlipperHTTP (WiFi)
# - GPSSpoof
# - SubGHz Jammer
# - Rubber Ducky attacks
```

### Common Attacks
| Attack | Description |
|--------|-------------|
| **RFID Cloning** | Copy access cards |
| **Sub-GHz Replay** | Replay garage doors |
| **NFC Dump** | Clone payment cards (test cards only!) |
| **BadUSB** | HID keyboard attacks |
| **IR Universal** | TV/AC control |

### Flipper Pricing
| Item | Price |
|------|-------|
| Flipper Zero | $170 |
| WiFi Module (beta) | $40 |
| Extra battery | $20 |
| Case | $15 |

---

## 3. ESP32/ESP8266

### Best for WiFi Attacks
| Chip | Features | Price |
|------|----------|-------|
| **ESP32-S3** | WiFi + BT | $15 |
| **ESP8266** | WiFi only | $5 |
| **ESP32-C6** | WiFi 6 + Thread | $10 |

### Popular Projects
```bash
# ESP32-S3 Deauther
git clone https://github.com/SpacehuhnTech/esp8266_deauther

# WiFi Marauder
git clone https://github.com/justcallmekoko/ESP32 Marauder

# Packet Monster
git clone https://github.com/tannewt/packet-monster
```

### Projects List
| Tool | Use |
|------|-----|
| **Deauther** | WiFi deauth attacks |
| **Evil Portal** | Captive portal |
| **WiFi Marauder** | Monitor mode capture |
| **Bettle ESP** | Bluetooth attacks |

---

## 4. OTHER HARDWARE

### Hak5 Gear
| Device | Use | Price |
|--------|-----|-------|
| **WiFi Pineapple** | Rogue AP | $100+ |
| **Rubber Ducky** | HID attack | $60 |
| **LAN Turtle** | MITM | $50 |
| **Packet Squirrel** | Sniffing | $60 |
| **Shark Jack** | Network tap | $60 |
| **USB Rubber Ducky** | Keystroke injection | $60 |

### Alternatives
| Device | Alternative | Price |
|--------|-------------|-------|
| WiFi Pineapple | Wifipumpkin3 on Pi | $80 |
| Rubber Ducky | Digispark | $10 |
| LAN Turtle | Pi Zero + USB | $20 |

---

## 5. COMPLETE PORTABLE KIT

### Budget Build ($100)
- [ ] Raspberry Pi Zero 2 W - $15
- [ ] TP-Link TL-WN722N - $10
- [ ] 16GB SD Card - $10
- [ ] USB Battery - $25
- [ ] Case + cables - $20
- [ ] WiFi adapter (extra) - $20

### Professional Build ($500+)
- [ ] Raspberry Pi 5 8GB - $80
- [ ] Alfa AWUS1900 - $60
- [ ] Flipper Zero - $170
- [ ] ESP32-S3 - $15
- [ ] 128GB SSD - $50
- [ ] Portable monitor - $100
- [ ] All accessories - $50

---

## 6. COMPARISON

### Portable Options
| Device | Portability | Power | Capabilities |
|--------|-------------|-------|-------------|
| **Pi 5** | Medium | USB-C | Full Kali |
| **Pi Zero** | High | USB | Limited |
| **Flipper** | Very High | Battery | RF/NFC |
| **ESP32** | Very High | USB/Battery | WiFi |

### Best For
| Use Case | Recommended Device |
|----------|-------------------|
| Full pentest | Raspberry Pi 5 + Kali |
| WiFi auditing | Pi + Alfa adapter |
| RF/Sub-GHz | Flipper Zero |
| Bluetooth | ESP32 |
| Physical/Cloning | Flipper + Proxmark |
| Quick attacks | USB Rubber Ducky |

---

## 7. SETUP SCRIPTS

### Pi Auto-Install
```bash
#!/bin/bash
# Install all tools on Raspberry Pi

echo "Installing pentest tools..."

# Update
sudo apt update && sudo apt upgrade -y

# Core tools
sudo apt install -y aircrack-ng reaver wash bully
sudo apt install -y nmap masscan net-tools
sudo apt install -y python3 python3-pip

# Wireless tools
sudo apt install -y wifiphisher wifipumpkin3

# Useful
sudo apt install -y git curl wget

echo "Done!"
```

### Flipper Backup
```bash
# Backup Flipper SD
cp -r /media/flipper/ /backup/flipper-$(date +%Y%m%d)

# Backup firmware version
flipper --version > firmware-backup.txt
```

---

## 8. LEGAL

⚠️ **IMPORTANT**: Only use on systems you own or have explicit written permission!

- Flipper Zero: Legal for research/testing
- WiFi adapters: Monitor mode legal on YOUR network
- RFID/NFC: Only clone cards YOU own
- ESP32 deauther: May be illegal in your jurisdiction
