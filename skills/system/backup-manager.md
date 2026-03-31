# Backup Manager Skill

## Purpose
Automated backup and restore for Kali configurations.

## Commands

### Backup All
```bash
tar -czvf kali-backup.tar.gz ~/.bashrc ~/.ssh /etc/network /opt/tools
```

### Backup to USB
```bash
rsync -avz ~/Documents/ /media/usb/backup/
```

### Restore
```bash
tar -xzvf kali-backup.tar.gz -C /
```

## Locations to Backup
- ~/.bashrc
- ~/.ssh/
- /etc/network/
- /opt/tools/
- ~/scripts/
- ~/notes/

## Usage
Use for:
- System backup
- Config restoration
-迁移
- Disaster recovery
