# NetHunter S10 — Arsenal cheatsheet / playbook
# Drop this in ~/.arsenal/ (or pass with `arsenal -p`). Use <vars> as global
# variables in Arsenal; set them once (e.g. ip, domain) and every command fills.
# AUTHORIZED TARGETS ONLY.

# Toolkit

## Scaffold a new engagement
```
newengagement.sh <name>
```

## Session identity + leak check
```
opsec.sh all
```

## Lock the loot vault
```
vault.sh lock ./loot
```

## Snapshot the chroot
```
su -c 'bash ~/bin/nh-backup.sh'
```

# Wireless

## Enable monitor mode (Nexmon, internal chip)
```
wifi-audit.sh on
```

## Survey nearby APs
```
wifi-audit.sh scan
```

## Capture a handshake on a target
```
wifi-audit.sh capture <bssid> <channel>
```

## Deauth a client to force the handshake (own lab)
```
aireplay-ng -0 3 -a <bssid> wlan0
```

# Web recon

## Full recon chain (subfinder → httpx → nuclei)
```
recon.sh <domain>
```

## Subdomains only
```
subfinder -d <domain> -all -silent
```

## Probe live hosts
```
httpx -l subs.txt -silent -follow-redirects -status-code -title -tech-detect
```

## Templated scan
```
nuclei -l urls.txt -severity low,medium,high,critical -rl 50
```

# Network

## Fast port sweep
```
nmap -sS -T4 -p- <ip>
```

## Service/version + default scripts
```
nmap -sCV -p <ports> <ip>
```

# AI assist

## Local suggest — explain output + next command (offline, Ollama/Needle)
```
ai-suggest.sh "<paste output>"
```

## Pipe a tool's output straight into the local model
```
nmap -sV <ip> | ai-suggest.sh
```

## Cloud Gemini (fast, off-device — OpSec tradeoff)
```
gemini -p "explain this nmap output and suggest next steps: <text>"
```
