@echo off
REM =============================================================================
REM   🏠 HOME LAB LAUNCHER v2.0 - Updated Config
REM =============================================================================

setlocal enabledelayedexpansion

:menu
cls
color 0B
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                                                                       ║
echo  ║      🏠 HOME LAB MULTI-DEVICE CONTROL CENTER v2.0                 ║
echo  ║                                                                       ║
echo  ║         This Laptop (Host) + XP Laptop + OPPO + Cloud             ║
echo  ║                                                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  ┌───────────────────────────────────────────────────────────────────────┐
echo  │                        DEVICE STATUS                                  │
echo  ├───────────────────────────────────────────────────────────────────────┤
echo  │                                                                        │
echo  │   [1] This Laptop    : 192.168.1.100  ^(Control Center^)          │
echo  │   [2] XP Laptop      : 10.0.0.66      ^(NAS/Storage^)             │
echo  │   [3] OPPO Phone     : Setup Ready    ^(Termux^)                  │
echo  │   [4] Home Computer : ???            ^(Needs Discovery^)         │
echo  │   [5] Kali VM       : Ready          ^(VirtualBox^)              │
echo  │   [6] Cloud/VPS     : Not Configured                               │
echo  │   [7] Huawei Hotspot: 192.168.1.1   ^(Internet^)                 │
echo  │                                                                        │
echo  └───────────────────────────────────────────────────────────────────────┘
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                         MAIN MENU                                    ║
echo  ╠═══════════════════════════════════════════════════════════════════════╣
echo  ║                                                                        ║
echo  ║   [A] 🤖 AI Tools                    [H] ☁️  Cloud/VPS Setup    ║
echo  ║   [B] 🐉 Kali VM Control             [I] 📶 WiFi/Network        ║
echo  ║   [C] 💻 XP Laptop (NAS)             [J] 💾 Storage/Backups     ║
echo  ║   [D] 📱 OPPO Phone                  [K] 🌐 Network Scan       ║
echo  ║   [E] 🏠 Home Computer               [L] 📊 Diagnostics        ║
echo  ║   [F] 🔄 Sync All Devices            [M] ⚡ Quick Commands      ║
echo  ║   [G] 📜 Scripts & Docs              [0] Exit                           ║
echo  ║                                                                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
set /p choice="  Select option: "

if /i "%choice%"=="A" goto ai_tools
if /i "%choice%"=="B" goto kali_vm
if /i "%choice%"=="C" goto xp_laptop
if /i "%choice%"=="D" goto oppo_phone
if /i "%choice%"=="E" goto home_computer
if /i "%choice%"=="F" goto sync_devices
if /i "%choice%"=="G" goto scripts_docs
if /i "%choice%"=="H" goto cloud_vps
if /i "%choice%"=="I" goto wifi_network
if /i "%choice%"=="J" goto storage
if /i "%choice%"=="K" goto network_scan
if /i "%choice%"=="L" goto diagnostics
if /i "%choice%"=="M" goto quick_cmds
if /i "%choice%"=="0" goto end

echo Invalid option
timeout /t 2 >nul
goto menu

:ai_tools
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                         🤖 AI TOOLS                                  ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] OpenCode
echo  [2] Claude Code  
echo  [3] Gemini CLI
echo  [4] TARS Agent
echo  [5] Check All Status
echo  [0] Back
echo.
set /p ai="Select: "

if "!ai!"=="1" opencode
if "!ai!"=="2" claude
if "!ai!"=="3" gemini
if "!ai!"=="4" agent-tars
if "!ai!"=="5" (
    echo.
    where opencode >nul 2>&1 && echo [✓] OpenCode || echo [✗] OpenCode
    where claude >nul 2>&1 && echo [✓] Claude Code || echo [✗] Claude Code
    where gemini >nul 2>&1 && echo [✓] Gemini CLI || echo [✗] Gemini CLI
    where agent-tars >nul 2>&1 && echo [✓] TARS || echo [✗] TARS
    pause
)
goto ai_tools

:kali_vm
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                      🐉 KALI VM CONTROL                              ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Start Kali VM
echo  [2] Stop Kali VM
echo  [3] SSH to Kali
echo  [4] Copy Scripts to Kali
echo  [5] Run Wireless Scan
echo  [6] VM Status
echo  [7] Create New Kali VM
echo  [0] Back
echo.
set /p kv="Select: "

if "!kv!"=="1" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "Kali-Linux-Wireless" --type headless
    echo VM Started!
)
if "!kv!"=="2" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "Kali-Linux-Wireless" poweroff
    echo VM Stopped!
)
if "!kv!"=="3" ssh root@192.168.1.50
if "!kv!"=="4" (
    scp -r "C:\Users\User\KaliShare\scripts\*" root@192.168.1.50:/root/scripts/
    echo Scripts copied!
)
if "!kv!"=="5" ssh root@192.168.1.50 "sudo airodump-ng wlan0mon"
if "!kv!"=="6" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo "Kali-Linux-Wireless" | findstr /i "state memory cpu"
)
if "!kv!"=="7" start "" "C:\Users\User\KaliShare\scripts\create-kali-graphical.bat"
echo.
pause
goto kali_vm

:xp_laptop
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    💻 XP LAPTOP CONTROL (NAS/Storage)              ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  XP Laptop IP: 10.0.0.66 (400GB HDD - Slow, use for storage only!)
echo.
echo  [1] Access XP Shared Folders
echo  [2] SSH to XP
echo  [3] Remote Desktop to XP
echo  [4] Map Network Drive
echo  [5] Run NAS Setup Script
echo  [6] Check XP Online Status
echo  [0] Back
echo.
set /p xp="Select: "

if "!xp!"=="1" start \\10.0.0.66\c$
if "!xp!"=="2" ssh administrator@10.0.0.66
if "!xp!"=="3" start mstsc /v:10.0.0.66
if "!xp!"=="4" (
    net use X: \\10.0.0.66\c$ /user:administrator 2>nul
    echo Drive X: mapped!
)
if "!xp!"=="5" start "" "C:\Users\User\KaliShare\scripts\xp-nas.bat"
if "!xp!"=="6" (
    ping -n 2 10.0.0.66
)
echo.
pause
goto xp_laptop

:oppo_phone
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    📱 OPPO PHONE CONTROL                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  Setup Instructions:
echo  ===================
echo  1. Install F-Droid on OPPO
echo  2. Install Termux from F-Droid
echo  3. Run in Termux:
echo     pkg update && pkg upgrade
echo     pkg install git curl wget python nodejs
echo     npm install -g opencode-ai @google/gemini-cli
echo.
echo  ─────────────────────────────────
echo.
echo  [1] SSH via USB (recommended)
echo  [2] SSH via WiFi
echo  [3] Setup USB Debugging
echo  [4] Show Full Instructions
echo  [5] Backup Termux
echo  [0] Back
echo.
set /p op="Select: "

if "!op!"=="1" (
    echo Ensure USB debugging enabled on phone!
    adb forward tcp:8022 tcp:8022
    ssh -p 8022 localhost
)
if "!op!"=="2" ssh -p 22 root@192.168.1.100
if "!op!"=="3" (
    echo Starting ADB...
    adb start-server
    adb devices
    echo.
    echo On your OPPO:
    echo 1. Settings ^> About Phone
    echo 2. Tap Build Number 7 times
    echo 3. Settings ^> Developer Options
    echo 4. Enable USB Debugging
)
if "!op!"=="4" (
    start https://f-droid.org
    start https://wiki.termux.com
    echo Also see: docs/TERMUX_SETUP.md
)
if "!op!"=="5" (
    adb forward tcp:8022 tcp:8022
    ssh -p 8022 localhost "tar -czf /sdcard/termux-backup.tar.gz -C /home termux"
    adb pull /sdcard/termux-backup.tar.gz "C:\Users\User\Backups\"
    echo Backup complete!
)
echo.
pause
goto oppo_phone

:home_computer
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    🏠 HOME COMPUTER                                ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Scan for Home Computer
echo  [2] Add Known IP
echo  [3] View Network Map
echo  [0] Back
echo.
set /p hc="Select: "

if "!hc!"=="1" (
    echo Scanning network...
    for /L %%i in (1,1,254) do (
        ping -n 1 -w 100 192.168.1.%%i >nul 2>&1 && echo [✓] 192.168.1.%%i
    )
    for /L %%i in (1,1,254) do (
        ping -n 1 -w 100 10.0.0.%%i >nul 2>&1 && echo [✓] 10.0.0.%%i
    )
    pause
)
if "!hc!"=="2" (
    set /p new_ip="Enter IP: "
    set /p new_name="Enter Name: "
    echo !new_ip! - !new_name! >> C:\Users\User\KaliShare\docs\network_devices.txt
    echo Added: !new_ip! (!new_name!)
)
if "!hc!"=="3" (
    type C:\Users\User\KaliShare\docs\network_devices.txt 2>nul || echo No devices saved
    echo.
    echo Current known devices:
    echo 192.168.1.100 - This Laptop
    echo 10.0.0.66 - XP Laptop
    pause
)
goto home_computer

:sync_devices
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    🔄 SYNC ALL DEVICES                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Sync Scripts to Kali
echo  [2] Sync Wordlists from XP
echo  [3] Backup Kali to XP
echo  [4] Sync All Now
echo  [0] Back
echo.
set /p sync="Select: "

if "!sync!"=="1" scp -r "C:\Users\User\KaliShare\scripts\*" root@192.168.1.50:/root/scripts/
if "!sync!"=="2" (
    net use X: \\10.0.0.66\c$ /user:administrator 2>nul
    xcopy "C:\Users\User\wordlists\*" X:\pen-test\wordlists\ /E /I
)
if "!sync!"=="3" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" export "Kali-Linux-Wireless" -o \\10.0.0.66\backups\kali.ova
)
if "!sync!"=="4" (
    echo Syncing all...
    scp -r "C:\Users\User\KaliShare\scripts\*" root@192.168.1.50:/root/scripts/
    echo Kali synced!
)
echo Done!
pause
goto sync_devices

:scripts_docs
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    📜 SCRIPTS & DOCS                               ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Open Scripts Folder
echo  [2] Open Docs Folder
echo  [3] View README
echo  [4] Edit Config
echo  [0] Back
echo.
set /p sd="Select: "

if "!sd!"=="1" start explorer "C:\Users\User\KaliShare\scripts"
if "!sd!"=="2" start explorer "C:\Users\User\KaliShare\docs"
if "!sd!"=="3" start notepad "C:\Users\User\KaliShare\README.md"
if "!sd!"=="4" start notepad "C:\Users\User\KaliShare\docs\HOME_LAB_CONFIG.md"
pause
goto scripts_docs

:cloud_vps
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    ☁️  CLOUD/VPS SETUP                            ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  Recommended VPS Options:
echo  ========================
echo  [1] DigitalOcean   - $4-24/mo - Good for pentest VPS
echo  [2] Linode         - $5-30/mo - Reliable
echo  [3] Hetzner        - €3-30/mo - Cheapest
echo  [4] Oracle Cloud   - FREE - ARM always free
echo  [5] AWS            - Pay as you go
echo  ─────────────────────────────────
echo  [6] Create VPS Script
echo  [7] List Current VPS
echo  [8] SSH to VPS
echo  [0] Back
echo.
set /p cv="Select: "

if "!cv!"=="1" start https://digitalocean.com
if "!cv!"=="2" start https://linode.com
if "!cv!"=="3" start https://hetzner.com
if "!cv!"=="4" start https://cloud.oracle.com
if "!cv!"=="5" start https://aws.amazon.com
if "!cv!"=="6" (
    echo Creating VPS setup script...
    echo See: docs/CLOUD_VPS.md
)
if "!cv!"=="7" (
    echo Current VPS:
    doctl compute droplet list 2>nul || echo Install doctl: winget install digitalocean.doctl
)
if "!cv!"=="8" (
    set /p vps_ip="Enter VPS IP: "
    ssh root@!vps_ip!
)
echo.
pause
goto cloud_vps

:wifi_network
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    📶 WIFI & NETWORK                               ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  TP-Link TL-WN721N (Atheros AR9271)
echo  Status: Ready for Kali VM
echo.
echo  [1] SSH to Kali for Wireless Tools
echo  [2] Check USB Devices on Kali
echo  [3] View Wireless Commands
echo  [4] Huawei Hotspot Status
echo  [5] Network Speed Test
echo  [0] Back
echo.
set /p wn="Select: "

if "!wn!"=="1" ssh root@192.168.1.50 "sudo airmon-ng"
if "!wn!"=="2" ssh root@192.168.1.50 "lsusb | grep -i atheros"
if "!wn!"=="3" start notepad "C:\Users\User\KaliShare\docs\commands.md"
if "!wn!"=="4" ping -n 2 192.168.1.1
if "!wn!"=="5" (
    curl -s https://speed.cloudflare.com/__down?bytes=10000000 -o nul
    echo Speed test complete
)
pause
goto wifi_network

:storage
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    💾 STORAGE & BACKUPS                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  Storage Locations:
echo  =================
echo  XP Laptop (400GB): \\10.0.0.66\c$
echo  Windows Host:      C:\Users\User\Backups
echo  Kali VM:          /root (via SSH)
echo.
echo  [1] Open XP Storage
echo  [2] Open Windows Backups
echo  [3] Create New Backup
echo  [4] Backup Kali VM
echo  [5] Check Disk Space
echo  [0] Back
echo.
set /p st="Select: "

if "!st!"=="1" start \\10.0.0.66\c$
if "!st!"=="2" start explorer "C:\Users\User\Backups"
if "!st!"=="3" (
    mkdir "C:\Users\User\Backups\%date:~-4%%date:~3,2%%date:~0,2%"
    echo Created: C:\Users\User\Backups\%date:~-4%%date:~3,2%%date:~0,2%
)
if "!st!"=="4" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" export "Kali-Linux-Wireless" -o "C:\Users\User\Backups\kali-%date:~-4%%date:~3,2%%date:~0,2%.ova"
)
if "!st!"=="5" (
    echo XP Laptop:
    net use X: \\10.0.0.66\c$ 2>nul
    dir X: 2>nul
    echo.
    echo Local:
    wmic logicaldisk get name,size,freespace
)
pause
goto storage

:network_scan
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    🌐 NETWORK SCAN                                   ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  Scanning for devices...
echo.
echo  192.168.1.x subnet:
for /L %%i in (1,1,254) do (
    ping -n 1 -w 50 192.168.1.%%i >nul 2>&1 && echo   [✓] 192.168.1.%%i
)
echo.
echo  10.0.0.x subnet:
for /L %%i in (1,1,254) do (
    ping -n 1 -w 50 10.0.0.%%i >nul 2>&1 && echo   [✓] 10.0.0.%%i
)
echo.
echo  Scan complete!
pause
goto menu

:diagnostics
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    📊 DIAGNOSTICS                                    ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"Total Physical Memory" /C:"Processor"
echo.
echo Network:
ipconfig | findstr /i "ipv4"
echo.
echo VMs:
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list runningvms
echo.
pause
goto menu

:quick_cmds
echo.
set /p qc="Command to run: "
%qc%
echo.
pause
goto menu

:end
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                                                                       ║
echo  ║              🏠 Home Lab v2.0 - Goodbye!                          ║
echo  ║                                                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
exit /b 0
