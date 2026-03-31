# SSH Manager Skill

## Purpose
Manage SSH connections and automate remote access.

## Config

### SSH Key Setup
```bash
ssh-keygen -t ed25519
ssh-copy-id root@192.168.1.200
```

### SSH Config (~/.ssh/config)
```
Host desktop
    HostName 192.168.1.200
    User root
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    
Host laptop
    HostName 192.168.1.100
    User user
    Port 22
```

## Commands

### Connect
```bash
ssh desktop
ssh laptop
```

### Tunnel
```bash
ssh -L 8080:localhost:80 root@192.168.1.200
ssh -R 9000:localhost:3000 root@192.168.1.200
```

## Usage
Use for:
- Remote access
- Port forwarding
- Tunneling
- Key management
