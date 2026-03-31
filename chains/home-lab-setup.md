# Chain: Home Lab Setup

## Trigger: go home-lab
## Purpose: Complete home lab configuration

### Steps

1. **Network Configuration**
```bash
# Set static IP
ip addr add 192.168.1.100/24 dev eth0
ip route add default via 192.168.1.1

# Edit /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
```

2. **Install Core Tools**
```bash
# Update
apt update && apt upgrade -y

# Install pentest tools
apt install -y kali-linux-all

# Install WiFi tools
apt install -y aircrack-ng reaver mdk4 wifite
```

3. **Install AI Tools**
```bash
# OpenCode
curl -fsSL https://opencode.ai/install | bash

# Claude Code
npm install -g @anthropic-ai/claude-code

# Gemini CLI
curl -fsSL https://google.github.io/gemini-cli/install | bash
```

4. **Configure Go Command**
```bash
cp /root/KaliShare/cli/go /usr/local/bin/go
chmod +x /usr/local/bin/go
```

5. **Verify Setup**
```bash
go validate
go status
```

### Output
- Fully configured pentest environment
- Network: 192.168.1.100
- Tools: All installed and verified
