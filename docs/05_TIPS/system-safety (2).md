# System Specifications & Safety Guide

## Your Laptop Specs

### Hardware
| Component | Specification |
|-----------|---------------|
| **Model** | Acer TravelMate Spin P414RN-51 |
| **CPU** | Intel Core i5-1135G7 (4 cores, 2.4GHz) |
| **RAM** | 16GB DDR4 |
| **Storage** | 256GB SSD |
| **GPU** | Intel Iris Xe Graphics (1GB) |
| **WiFi** | Intel Wi-Fi 6 AX201 |
| **USB** | USB 3.0, USB-C |

### Virtualization
| Setting | Status |
|---------|--------|
| VirtualBox | ✅ Installed |
| VT-x/AMD-V | ✅ Enabled |
| Nested Paging | ✅ Enabled |

---

## What NOT To Do (Safety Rules)

### ❌ NEVER Do These Things

1. **Don't run VM at full CPU**
   - Your laptop will overheat
   - Set VM CPUs to 2 (not all 4)
   
2. **Don't allocate all RAM to VM**
   - Keep 8GB for Windows host
   - VM max: 8GB

3. **Don't use WiFi adapter in VM carelessly**
   - Only use for authorized testing
   - Don't connect to wrong networks

4. **Don't disable your Windows WiFi**
   - Keep host WiFi working
   - Use USB adapter only in VM

5. **Don't install everything at once**
   - Install tools gradually
   - Test each tool works

6. **Don't ignore overheating**
   - Monitor laptop temperature
   - Stop if too hot

---

## Safe VM Settings

### Recommended VM Configuration

```
CPUs: 2 (NOT 4!)
RAM: 4GB-6GB (NOT 8GB+)
Video Memory: 128MB
Storage: 50GB
USB: 2.0 or 3.0 (for adapter)
```

### How To Check/Change VM Settings

1. **Close VM completely** (not saved state)
2. Open VirtualBox
3. Right-click Kali → Settings
4. Adjust as above
5. Start VM

---

## Temperature Monitoring

### Safe Temperature Ranges
| Component | Safe | Warning | Danger |
|-----------|------|---------|--------|
| CPU | <70°C | 70-85°C | >85°C |
| Battery | <40°C | 40-50°C | >50°C |

### Check Temperature in Kali
```bash
# Install sensors
sudo apt install lm-sensors

# Check temps
sensors
```

### Signs of Overheating
- Laptop hot to touch
- Fan running loud constantly
- System slow
- Random shutdowns

### If Overheating:
1. **STOP** the VM immediately
2. Let laptop cool down
3. Reduce VM resources
4. Don't run intensive tools

---

## Resource Limits

### Maximum Resource Usage
| Resource | Host (Windows) | VM (Kali) |
|----------|----------------|------------|
| **CPU** | Keep 2 cores | Use max 2 cores |
| **RAM** | 8GB minimum | 4-6GB maximum |
| **Disk** | 50GB free | 50GB allocated |

### How Much Each Tool Uses

| Tool | CPU | RAM | Notes |
|------|-----|-----|-------|
| nmap scan | Low | Low | Lightweight |
| Metasploit | Medium | Medium | Uses ~2GB |
| Hashcat (GPU) | High | Medium | Avoid in VM |
| Aircrack | Low | Low | Lightweight |
| HexStrike AI | Medium-High | High | Uses ~3GB |

---

## Backup Plan

### Before Major Changes
1. ✅ Take VirtualBox snapshot
2. ✅ Backup important files
3. ✅ Note current working state

### How To Create Snapshot
1. Close VM (power off, not save state)
2. VirtualBox → Kali → Snapshots
3. Click camera icon 📷
4. Name: "Before [change]"
5. Save

### How To Restore
1. Close VM
2. Snapshots → Select snapshot
3. Click "Restore"

---

## If Something Goes Wrong

### VM Won't Start
1. Check VT-x enabled in BIOS
2. Reduce RAM allocation
3. Reinstall Guest Additions

### Laptop Overheats
1. Stop VM immediately
2. Unplug from power
3. Let cool 30 minutes
4. Reduce VM resources

### USB Adapter Not Working
1. Check VirtualBox USB filter
2. Try different USB port
3. Install VirtualBox Extension Pack

### Internet Not Working in VM
1. Check NAT vs Bridged adapter
2. Restart VM
3. Check Windows firewall

---

## Quick Safety Checklist

Before each session:
- [ ] VM has 2 CPUs max
- [ ] VM has 4-6GB RAM max
- [ ] Laptop has good ventilation
- [ ] Temperature monitoring ready
- [ ] Snapshot taken (optional)

During session:
- [ ] Laptop not too hot
- [ ] Fan not running max speed
- [ ] No random slowdowns
- [ ] Windows still responsive

---

## Emergency Contacts

### If Bricked
1. **Hold power button 10s** → Hard shutdown
2. **F2 on boot** → BIOS recovery
3. **F12 on boot** → Boot menu

### Resources
- VirtualBox Forum: https://forums.virtualbox.org/
- Kali Docs: https://www.kali.org/docs/

---

## Summary

**Safe Settings:**
- CPUs: 2
- RAM: 4-6GB
- Temperature: <70°C
- Take snapshots before changes

**Remember:** Your laptop is not a server! Don't push it too hard. Better to run fewer tools smoothly than crash everything.
