# Chain: Backup All

## Trigger: Daily or manual
## Purpose: Backup Kali configurations

### Steps

1. **Create Backup Dir**
```bash
BACKUP_DIR="/media/usb/backups/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR
```

2. **Backup Configs**
```bash
tar -czvf $BACKUP_DIR/configs.tar.gz ~/.bashrc ~/.ssh /etc/network
```

3. **Backup Tools**
```bash
tar -czvf $BACKUP_DIR/tools.tar.gz /opt/tools
```

4. **Backup Scripts**
```bash
tar -czvf $BACKUP_DIR/scripts.tar.gz ~/scripts
```

5. **Backup Scripts List**
```bash
ls -la $BACKUP_DIR/
```

### Output
- configs.tar.gz
- tools.tar.gz  
- scripts.tar.gz
