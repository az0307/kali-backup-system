# Home Lab Status - March 17, 2026

## Summary

### Completed
- ✅ Kali netinst ISO downloaded (709MB) - F:\kali.iso
- ✅ Scripts and documentation created in C:\Users\User\KaliShare\
- ✅ AI tools installed: OpenCode, Claude Code, Gemini CLI, TARS

### In Progress
- ⏳ Creating bootable USB (need to run as Administrator)
- ⏳ Installing Kali on desktop PC

## Current Files

### Kali ISO
- **Location**: F:\kali.iso
- **Size**: 709MB (netinst version)
- **Note**: Requires internet during installation

### USB Drive
- **Drive**: F: (16GB, FAT32)
- **Free Space**: ~4.9GB

## Next Steps

### 1. Create Bootable USB
Run as Administrator:
```cmd
C:\Users\User\KaliShare\scripts\create-bootable-usb.bat
```

Or manually with Rufus:
1. Download Rufus from https://rufus.ie
2. Select USB drive F:
3. Select F:\kali.iso
4. Click Start

### 2. Install Kali on Desktop PC
1. Plug USB into desktop PC
2. Turn on desktop, press F12 (or Del) for boot menu
3. Select USB from boot options
4. Choose "Install" (netinst requires network)
5. Connect to Huawei hotspot (192.168.1.1) for internet
6. Complete installation

### 3. Post-Installation
Run on new Kali system:
```bash
# Connect to network via Ethernet to laptop
sudo ip addr add 192.168.1.200/24 dev eth0
sudo ip link set eth0 up
sudo route add default gw 192.168.1.1

# Or use the auto-connect script
curl -sSL https://raw.githubusercontent.com/anomalyco/opencode/main/scripts/auto-connect-ethernet.sh | bash
```

## Network Configuration

| Device | IP | Notes |
|--------|-----|-------|
| Huawei Hotspot | 192.168.1.1 | Internet gateway |
| This Laptop | 192.168.1.100 | Ethernet share |
| Desktop PC | 192.168.1.200 | After Kali install |
| XP Laptop | 10.0.0.66 | Separate network |

## Notes
- Netinst ISO downloads packages during install - requires internet
- Use Huawei mobile hotspot for internet during Kali installation
- After install, desktop can connect via Ethernet to laptop for shared internet
