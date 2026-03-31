# 🚨 EMERGENCY RED BUTTON - Complete VM Wipe

## ⚠️ WARNING: THIS WILL DESTROY EVERYTHING

**USE ONLY WHEN:**
- You need to immediately stop and cover tracks
- You've been detected and must flee
- Engagement is aborted and you must leave no trace
- Emergency withdraw from compromised position

**THIS IS UNRECOVERABLE**

---

## Option 1: Quick Wipe (Within VM)

### The Red Button Script
```bash
#!/bin/bash
# RED BUTTON - Emergency VM Wipe
# Run: sudo /mnt/sf_KaliShare/scripts/red-button.sh

echo "╔══════════════════════════════════════════════════════════╗"
echo "║         🚨 EMERGENCY WIPE INITIATED 🚨                ║"
echo "║         ALL DATA WILL BE DESTROYED                    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

read -p "Type 'DELETE' to confirm: " confirm
if [ "$confirm" != "DELETE" ]; then
    echo "Aborted."
    exit 1
fi

echo "Starting wipe sequence..."

# 1. Kill all processes
echo "[1/7] Killing all processes..."
pkill -9 -e .

# 2. Clear all logs
echo "[2/7] Clearing system logs..."
sudo find /var/log -type f -exec shred -vf -n 3 {} \; 2>/dev/null
sudo rm -rf /var/log/*

# 3. Clear bash history
echo "[3/7] Clearing history..."
history -c
> ~/.bash_history
> ~/.zsh_history
> /root/.bash_history

# 4. Clear temp files
echo "[4/7] Clearing temp files..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
sudo rm -rf ~/.cache/*

# 5. Clear browser data
echo "[5/7] Clearing browser data..."
rm -rf ~/.mozilla/firefox/*.default*
rm -rf ~/.config/chromium/*

# 6. Clear downloads/pictures
echo "[6/7] Clearing personal files..."
rm -rf ~/Downloads/*
rm -rf ~/Documents/*
rm -rf ~/Pictures/*

# 7. Overwrite disk
echo "[6/7] Overwriting free space..."
sudo dd if=/dev/zero of=/tmp/wipe bs=1M 2>/dev/null
sudo rm -f /tmp/wipe

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    WIPE COMPLETE                        ║"
echo "║         Now destroying virtual machine...               ║"
echo "╚══════════════════════════════════════════════════════════╝"

# Destroy VM from outside
echo "Execute on HOST computer:"
echo "  VBoxManage unregistervm \"Kali-Linux-Wireless\" --delete"
echo ""
echo "Or manually delete:"
echo "  C:\\Users\\User\\VirtualBox VMs\\Kali-Linux-Wireless\\"
echo ""
echo "💀 MISSION COMPLETE"
```

---

## Option 2: Nuclear (From Host Windows)

### PowerShell Script - Run on Windows Host
```powershell
# RED_BUTTON_NUCLEAR.ps1
# Run as Administrator on Windows Host

Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║         🚨 NUCLEAR WIPE INITIATED 🚨                  ║" -ForegroundColor Red
Write-Host "║         ALL DATA WILL BE DESTROYED FOREVER            ║" -ForegroundColor Red
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Red

$confirm = Read-Host "Type 'NUKE' to confirm complete destruction"
if ($confirm -ne "NUKE") {
    Write-Host "Aborted." -ForegroundColor Green
    exit
}

Write-Host "Stopping VM..." -ForegroundColor Yellow
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "Kali-Linux-Wireless" poweroff 2>$null

Write-Host "Deleting VM and all files..." -ForegroundColor Yellow
$vmPath = "C:\Users\User\VirtualBox VMs\Kali-Linux-Wireless"

if (Test-Path $vmPath) {
    # Overwrite all files before deleting
    Get-ChildItem $vmPath -Recurse -File | ForEach-Object {
        $file = $_.FullName
        $size = $_.Length
        if ($size -gt 0) {
            $bytes = [byte[]]::new($size)
            [System.IO.File]::WriteAllBytes($file, $bytes)
        }
    }
    
    # Delete everything
    Remove-Item $vmPath -Recurse -Force
}

Write-Host "Clearing VirtualBox metadata..." -ForegroundColor Yellow
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unregistervm "Kali-Linux-Wireless" 2>$null

# Clear clipboard
Set-Clipboard -Value ""

# Clear recent documents
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║                    💀 MISSION COMPLETE 💀               ║" -ForegroundColor Red
Write-Host "║         Nothing recoverable. VM destroyed.            ║" -ForegroundColor Red
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Red
```

---

## Option 3: Quick Escape (Just Close Everything)

```bash
#!/bin/bash
# QUICK_ESCAPE.sh - Just close everything, don't destroy

# Kill VM from inside
sudo poweroff

# Or from host:
# VBoxManage controlvm "Kali-Linux-Wireless" poweroff
```

---

## 📋 PRE-WRITTEN COMMANDS

### On Windows Host - Run in PowerShell (Admin):
```powershell
# Stop and delete VM immediately
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "Kali-Linux-Wireless" poweroff
Start-Sleep -Seconds 3
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unregistervm "Kali-Linux-Wireless" --delete
Remove-Item "C:\Users\User\VirtualBox VMs\Kali-Linux-Wireless" -Recurse -Force
```

---

## ⚖️ LEGAL NOTE

This is for:
- Your own VM
- Authorized testing
- Emergency withdrawal
- Self-protection

**DO NOT** use on systems you don't own or haven't been explicitly authorized to test.

---

## 🔄 RECOVERY PLAN

After using Red Button:

1. **Create fresh VM** from Kali ISO
2. **Re-install tools** using our scripts
3. **Configure fresh API keys** (rotate old ones)
4. **Take snapshot** before next engagement
5. **Document what happened** for learning

---

## 📍 Location

Save these scripts:
- `scripts/red-button.sh` - Inside VM
- `scripts/red-button-nuclear.ps1` - On Windows Host
- `scripts/quick-escape.sh` - Emergency close

---
