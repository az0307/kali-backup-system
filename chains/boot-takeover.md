# Chain: Boot Takeover

## Trigger: Manual
## Purpose: Password reset and system recovery

### Steps

1. **Identify Target OS**
```bash
fdisk -l | grep -E "NTFS|FAT32|Linux"
```

2. **Mount Windows Partition**
```bash
mkdir -p /mnt/win
mount -t ntfs-3g /dev/sda1 /mnt/win
```

3. **Reset Password (if Windows)**
```bash
cd /mnt/win/Windows/system32/config
chntpw -l SAM
chntpw -u USERNAME SAM
```

4. **Create New Admin User**
```bash
chntpw -u USERNAME -e SAM
# Select: make admin
```

### Tools Used
- chntpw
- ntfs-3g
- testdisk (for recovery)

### Output
- Password reset
- New admin account created
