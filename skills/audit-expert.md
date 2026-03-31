---
name: audit-expert
description: >
  System auditing expert. Use for: diagnosing errors, troubleshooting failures,
  debugging issues, analyzing crashes, checking logs, verification, validation,
  health checks, system diagnostics, root cause analysis.
compatibility:
  tools: [bash, python, git, docker, MCP]
  os: [linux, windows, macos]
---

# Audit Expert - System Diagnostics & Error Resolution

## MCP Server Diagnostics

### GitHub MCP Issues
```bash
# Check auth status
gh auth status

# Re-authenticate
gh auth logout
gh auth login --web -h github.com

# Test API
curl -s -u <username>:<token> https://api.github.com/user
```

### Browser MCP Issues
```bash
# Check if Chrome installed
where chrome  # Windows
which google-chrome  # Linux

# Install Chrome
# Windows: Download from chrome.com
# Linux: apt install google-chrome-stable
```

### Docker MCP
```bash
docker ps
docker info
docker compose ps
```

## Error Fallbacks

### Network Tools Fallback
```bash
# No nmap? Try:
- rustscan
- netcat (nc)
- masscan

# Manual check:
for port in 22 80 443; do
  timeout 2 bash -c "echo >/dev/tcp/$host/$port" && echo "open: $port"
done
```

### Password Tools Fallback
```bash
# No hashcat? Try:
- john (John the Ripper)
- hashid (identify hash type)
- samdump2 (Windows hashes)

# Manual:
unshadow /etc/passwd /etc/shadow > combined.txt
john combined.txt
```

### WiFi Tools Fallback
```bash
# No aircrack? Try:
- wifite (automated)
- wpa_supplicant
- NetworkManager: nmcli device wifi list
```

## Health Check Commands

### System
```bash
# Check all tools
which nmap msfconsole hashcat aircrack-ng sqlmap nikto burpsuite

# Disk space
df -h

# Memory
free -h

# Services
systemctl status docker
```

### Git Status
```bash
git status
git log --oneline -10
git remote -v
gh auth status
```

## Troubleshooting Steps

1. Identify the error
2. Check dependencies
3. Verify permissions
4. Test connectivity
5. Review logs
6. Apply fallback
7. Document solution