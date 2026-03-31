# VirtualBox Configuration & Equipment Guide

## 1. VirtualBox Best Configurations

### Recommended Settings for Kali Linux

#### Basic (Minimum)
| Setting | Value |
|---------|-------|
| RAM | 2048 MB (2 GB) |
| CPUs | 2 cores |
| Video RAM | 128 MB |
| HDD | 20 GB |
| Network | NAT |

#### Standard (Recommended)
| Setting | Value |
|---------|-------|
| RAM | 4096 MB (4 GB) |
| CPUs | 2-4 cores |
| Video RAM | 128 MB |
| HDD | 50 GB |
| Network | NAT + Host-Only |
| USB | USB 3.0 (xHCI) |

#### High Performance
| Setting | Value |
|---------|-------|
| RAM | 8192 MB (8 GB) |
| CPUs | 4-6 cores |
| Video RAM | 256 MB |
| HDD | 100+ GB |
| Network | Bridged + Host-Only |
| USB | USB 3.0 |

### Network Configurations

#### NAT (Default)
```bash
# Internet access, isolated from host
# Good for: Basic testing, updates
```

#### Bridged Adapter
```bash
# Directly connected to host network
# Good for: Network scanning, external access
# Usage: eth0 gets IP from DHCP
```

#### Host-Only
```bash
# Communication with host only
# Good for: Isolated labs, internal networks
```

#### Internal Network
```bash
# Between VMs only
# Good for: Multi-VM lab environments
```

### USB Configuration for Wireless Adapters
```bash
# Enable USB 3.0 (xHCI)
# VirtualBox Settings → USB → Enable USB Controller
# Select: USB 3.0 (xHCI) Controller

# Add USB Filter:
# Vendor ID: 0cf3 (Atheros)
# Product ID: 9271 (AR9271)
```

### Performance Optimizations
```bash
# 1. Enable PAE/NX
# Settings → Processor → Enable PAE/NX

# 2. Disable unnecessary features
# Settings → System → Disable Floppy, ACPI

# 3. Enable 3D acceleration (carefully)
# Settings → Display → Enable 3D Acceleration

# 4. Use SSD for virtual disk
# Storage → SSD emulation

# 5. Enable nested paging
# Settings → System → Acceleration → Enable Nested Paging
```

---

## 2. VirtualBox History & Versions

### Version History
| Version | Year | Key Features |
|---------|------|--------------|
| 1.0 | 2007 | Initial release |
| 2.0 | 2008 | 64-bit support |
| 3.0 | 2009 | USB 2.0, SATA |
| 4.0 | 2010 | GUI redesign, Extension Pack |
| 5.0 | 2015 | USB 3.0, disk encryption |
| 6.0 | 2018 | NVMe, cloud integration |
| 7.0 | 2022 | Secure boot, cloud VM |

### Current: VirtualBox 7.x (2024-2026)
- ✅ USB 3.0/3.1 support
- ✅ NVMe storage
- ✅ Cloud integration
- ✅ Secure boot
- ✅ Better 3D support
- ✅ Headless mode

---

## 3. Kali Linux History

### Version History
| Version | Year | Code Name | Notes |
|---------|------|-----------|-------|
| 1.0 | 2013 | moto | Based on Debian |
| 2.0 | 2015 | sana | Major overhaul |
| 2016.1 | 2016 | roll | Rolling release start |
| 2017.1 | 2017 | kali-rolling | Default |
| 2020.1 | 2020 | Final release | XFCE default |
| 2021.1 | 2021 | Default | Modern tools |
| 2022.1 | 2022 | Default | New tools |
| 2023.1 | 2023 | Default | Updated tools |
| 2024.1 | 2024 | Default | Latest stable |
| 2026.x | 2026 | Weekly builds | Cutting edge |

### Kali Tools Evolution
- **Early**: Limited tools, manual updates
- **Now**: 600+ tools, rolling updates, cloud integration

---

## 4. Equipment Pricing Guide

### Wireless Adapters (USB)
| Adapter | Chipset | Price | Monitor | Injection |
|---------|---------|-------|---------|-----------|
| TP-Link TL-WN721N | AR9271 | $10 | ✅ | ✅ |
| TP-Link TL-WN722N v2 | AR9271 | $15 | ✅ | ✅ |
| Alfa AWUS036NHA | AR9271 | $40 | ✅ | ✅ |
| Alfa AWUS036NH | RT3070 | $35 | ✅ | ✅ |
| Alfa AWUS1900 | RTL8814AU | $60 | ⚠️ | ⚠️ |
| Panda PAU09 | RT5572 | $50 | ✅ | ✅ |

### Recommended Starter Kit
| Item | Price | Notes |
|------|-------|-------|
| TP-Link TL-WN721N | $10 | Budget option |
| Alfa AWUS036NHA | $40 | Best value |
| External Antenna (7dBi) | $15 | Range boost |
| **Total** | **$50-65** | |

### High-End Setup
| Item | Price | Notes |
|------|-------|-------|
| Alfa AWUS1900 | $60 | AC1200 |
| External 9dBi antenna | $25 | Long range |
| USB 3.0 hub | $20 | Multiple devices |
| **Total** | **$105** | |

### Virtualization Hardware
| Item | Price | Notes |
|------|-------|-------|
| VirtualBox | FREE | Open source |
| VMware Workstation Player | FREE | Basic |
| VMware Workstation Pro | $150-250 | Advanced |
| Hyper-V (Windows) | FREE | Built-in |

---

## 5. Hardware Recommendations

### Minimum (Learning)
| Component | Specification |
|-----------|--------------|
| RAM | 4 GB |
| Storage | 50 GB free |
| CPU | 2 cores |

### Recommended (Working)
| Component | Specification |
|-----------|--------------|
| RAM | 8 GB |
| Storage | 100+ GB SSD |
| CPU | 4+ cores |

### Professional (Full Labs)
| Component | Specification |
|-----------|--------------|
| RAM | 16-32 GB |
| Storage | 500+ GB SSD |
| CPU | 6-8 cores |
| GPU | Optional (for cracking) |

---

## 6. Software Configuration by Job

### Wireless Testing
```bash
# Optimal VM Settings:
RAM: 4 GB
CPUs: 2
Network: NAT + Bridged
USB: USB 3.0 with filter for adapter
```

### Web Application Testing
```bash
# Optimal VM Settings:
RAM: 4-8 GB
CPUs: 2-4
Network: Host-only + NAT
Storage: 60 GB
```

### Full Red Team
```bash
# Optimal VM Settings:
RAM: 8+ GB
CPUs: 4+
Network: Bridged + Host-only
Storage: 100+ GB
Multiple VMs for pivoting
```

### Bug Bounty
```bash
# Optimal VM Settings:
RAM: 4 GB
CPUs: 2
Network: NAT
Storage: 40 GB
Lightweight config
```

---

## 7. Quick Setup Scripts

### VM Creation (Command Line)
```bash
# Create VM
VBoxManage createvm --name "Kali-Linux" --register

# Configure
VBoxManage modifyvm "Kali-Linux" --memory 4096 --cpus 2 --vram 128

# Network
VBoxManage modifyvm "Kali-Linux" --nic1 nat --nic2 hostonly

# USB
VBoxManage modifyvm "Kali-Linux" --usbxhci on

# Create disk
VBoxManage createhd --filename "Kali.vdi" --size 50000

# Attach disk & ISO
VBoxManage storageattach "Kali-Linux" --storagectl "SATA" --port 0 --device 0 --medium "Kali.vdi"
VBoxManage storageattach "Kali-Linux" --storagectl "SATA" --port 1 --device 0 --medium "kali.iso"
```

### Guest Additions Installation
```bash
# In Kali VM:
sudo apt update
sudo apt install -y build-essential dkms linux-headers-$(uname -r)

# Insert Guest Additions CD (Devices → Insert Guest Additions)
sudo mkdir /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sudo sh /mnt/cdrom/VBoxLinuxAdditions.run
```

---

## 8. Troubleshooting

### Common Issues
| Issue | Solution |
|-------|----------|
| Slow performance | Increase RAM, enable PAE/NX |
| USB not detected | Install Extension Pack |
| No network | Use Bridged adapter |
| Screen lag | Disable 3D acceleration |
| No internet | Check NAT settings |

### Extension Pack Installation
```bash
# Download matching version
# https://www.virtualbox.org/wiki/Downloads

# Install
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack

# List installed
VBoxManage list extpacks
```

---

## 9. Alternative Virtualization

### Comparison
| Software | Pros | Cons |
|----------|------|------|
| **VirtualBox** | Free, cross-platform | Less performant |
| **VMware** | Better 3D, USB | Paid for Pro |
| **Hyper-V** | Built-in (Windows) | Windows only |
| **QEMU/KVM** | Best performance | Linux only |

### For Wireless Testing
| Platform | USB Passthrough | Best For |
|----------|---------------|-----------|
| VirtualBox | Good | General use |
| VMware | Excellent | Professional |
| Bare Metal | Perfect | Production |

---

## 10. Lab Setup Ideas

### Home Lab (Budget)
```
┌─────────────────┐
│   Host Machine   │
│   (8GB RAM)     │
├─────────────────┤
│  ┌───────────┐  │
│  │ Kali VM   │  │
│  │ (4GB RAM) │  │
│  └───────────┘  │
│  ┌───────────┐  │
│  │ Target VM │  │
│  │ (DVWA)    │  │
│  └───────────┘  │
└─────────────────┘
```

### Professional Lab
```
┌─────────────────────────────────────┐
│         Host (32GB RAM)             │
├─────────────────────────────────────┤
│  ┌─────────┐ ┌─────────┐ ┌────────┐ │
│  │ Kali    │ │ Pivoting│ │ Target │ │
│  │ (8GB)   │ │  VM     │ │  VMs  │ │
│  └─────────┘ └─────────┘ └────────┘ │
│  ┌─────────┐ ┌─────────┐            │
│  │ Windows  │ │ Linux   │            │
│  │ Target   │ │ Target  │            │
│  └─────────┘ └─────────┘            │
└─────────────────────────────────────┘
```
