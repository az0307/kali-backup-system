# Quick Reference Card

## Go Command

```bash
go <command> [target] [options]
```

### Network
| Command | Description |
|---------|-------------|
| `go pentest <ip>` | Full AI pentest |
| `go full <ip>` | Manual pentest |
| `go quick <ip>` | Quick scan |
| `go web <ip>` | Web test |
| `go auto <ip>` | Auto pentest |

### WiFi
| Command | Description |
|---------|-------------|
| `go wifi` | Start audit |
| `go wifi-menu` | WiFi menu |
| `go wpa <bssid>` | Capture handshake |

### Recovery
| Command | Description |
|---------|-------------|
| `go boot-menu` | Boot menu |
| `go win-reset` | Windows reset |
| `go recovery` | Recovery tools |

### Setup
| Command | Description |
|---------|-------------|
| `go home-lab` | Full setup |
| `go validate` | Check tools |
| `go status` | Check systems |

---

## Network

```
Laptop:  192.168.1.100
Desktop: 192.168.1.200
Gateway: 192.168.1.1
```

---

## WiFi

### Enable Monitor Mode
```bash
airmon-ng start wlan0
```

### Scan
```bash
airodump-ng wlan0mon
```

### Capture Handshake
```bash
airodump-ng -c 6 --bssid XX:XX:XX:XX:XX:XX -w capture wlan0mon
```

### Crack
```bash
aircrack-ng -w rockyou.txt capture-01.cap
```

---

## Nmap

| Flag | Description |
|------|-------------|
| `-sn` | Ping scan |
| `-sS` | SYN scan |
| `-sT` | TCP scan |
| `-sV` | Version |
| `-p-` | All ports |
| `-O` | OS detection |
| `-A` | Aggressive |

---

## Quick Commands

```bash
# Full setup
sudo bash /root/KaliShare/scripts/home-lab-complete.sh

# WiFi menu
sudo wifi-menu

# Recon menu
recon-menu

# AI tools
ai-pentest-menu
```

---

## Tools Location

```
Scripts:  /root/KaliShare/scripts/
Go:       /root/KaliShare/cli/go
Chains:   /root/KaliShare/chains/
Skills:   /root/KaliShare/skills/
Docs:     /root/KaliShare/docs/
```

---

*Quick Reference - Home Lab v3.0*
