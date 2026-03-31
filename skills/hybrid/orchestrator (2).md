# Orchestrator Skill

## Purpose
Coordinate and sync operations between laptop and desktop Kali machines.

## Topology
```
Laptop (192.168.1.100) <---> Desktop (192.168.1.200)
     |                            |
   WiFi                      Ethernet
   (Internet)                 (Control)
```

## Commands

### SSH to Desktop
```bash
ssh root@192.168.1.200
```

### Sync Tools
```bash
rsync -avz /opt/tools/ root@192.168.1.200:/opt/tools/
```

### Execute on Desktop
```bash
ssh root@192.168.1.200 "nmap -sn 192.168.1.0/24"
```

## Usage
Use to:
- Sync tools between machines
- Run commands remotely
- Coordinate attacks
- Share resources
