# Desktop Kali Quick Reference

## Network
| Setting | Value |
|---------|-------|
| IP | 192.168.1.200 |
| Gateway | 192.168.1.100 |
| DNS | 8.8.8.8 |

## Commands
```bash
# Setup network
sudo bash ~/scripts/desktop-network.sh

# Full setup (after install)
sudo bash ~/scripts/desktop-full-setup.sh

# Test connection
ping 192.168.1.100  # Laptop
ping 8.8.8.8        # Internet

# SSH from laptop
ssh root@192.168.1.200
```

## Tools
| Tool | Command |
|------|---------|
| OpenCode | `opencode` or `o` |
| TARS | `agent-tars` or `t` |
| Nmap | `nmap -sn 192.168.1.0/24` |
| Airodump | `airodump-ng wlan0mon` |

## USB Scripts Location
```
/media/usb/tools/scripts/
```

## Access
- SSH: `ssh root@192.168.1.200`
- SCP: `scp file root@192.168.1.200:/root/`
