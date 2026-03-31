# Chain: Sync Desktop

## Trigger: On desktop boot or manual
## Purpose: Sync tools and configs to desktop Kali

### Steps

1. **Check Connection**
```bash
ping -c 1 192.168.1.200
```

2. **Sync Tools**
```bash
rsync -avz /opt/tools/ root@192.168.1.200:/opt/tools/
```

3. **Sync Scripts**
```bash
rsync -avz ~/scripts/ root@192.168.1.200:/root/scripts/
```

4. **Sync Configs**
```bash
rsync -avz ~/.bashrc root@192.168.1.200:/root/
```

5. **Verify**
```bash
ssh root@192.168.1.200 "ls /opt/tools/"
```
