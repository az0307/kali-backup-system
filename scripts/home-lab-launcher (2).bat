@echo off
REM =============================================================================
REM   🏠 HOME LAB MULTI-DEVICE ORCHESTRATOR - WINDOWS LAUNCHER
REM =============================================================================

setlocal enabledelayedexpansion

:menu
cls
color 0A
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                                                                       ║
echo  ║      🏠 HOME LAB MULTI-DEVICE CONTROL CENTER                       ║
echo  ║           Windows + Kali VM + XP Laptop + OPPO                    ║
echo  ║                                                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  ┌───────────────────────────────────────────────────────────────────────┐
echo  │                        STATUS OVERVIEW                                 │
echo  ├───────────────────────────────────────────────────────────────────────┤
echo  │                                                                        │
echo  │   [1] Windows Host     : 192.168.1.100    ^(This PC^)              │
echo  │   [2] Kali VM          : 192.168.1.50     ^(VirtualBox^)            │
echo  │   [3] XP Laptop        : 192.168.1.75     ^(400GB NAS/Pentest^)    │
echo  │   [4] OPPO Phone       : 192.168.1.100   ^(Termux + AI^)          │
echo  │   [5] Huawei Hotspot   : 192.168.1.1     ^(Mobile Data^)          │
echo  │   [6] TP-Link Adapter  : USB             ^(Atheros AR9271^)        │
echo  │                                                                        │
echo  └───────────────────────────────────────────────────────────────────────┘
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                         MAIN MENU                                    ║
echo  ╠═══════════════════════════════════════════════════════════════════════╣
echo  ║                                                                        ║
echo  ║   [A] 🤖 AI Tools                    [G] 📡 Wireless Tools         ║
echo  ║   [B] 🐉 Kali VM Control             [H] 📶 Hotspot Monitor       ║
echo  ║   [C] 💻 XP Laptop Control           [I] 💾 Storage/Wordlists    ║
echo  ║   [D] 📱 OPPO Phone Control          [J] 🔄 Sync All Devices      ║
echo  ║   [E] 🌐 Network Discovery           [K] ⚙️  Quick Scripts        ║
echo  ║   [F] 📊 System Diagnostics          [L] 🎯 Custom Command        ║
echo  ║                                                                        ║
echo  ║   [0] Exit                                                                 ║
echo  ║                                                                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
set /p choice="  Select option: "

if /i "%choice%"=="A" goto ai_tools
if /i "%choice%"=="B" goto kali_vm
if /i "%choice%"=="C" goto xp_laptop
if /i "%choice%"=="D" goto oppo_phone
if /i "%choice%"=="E" goto network_discovery
if /i "%choice%"=="F" goto diagnostics
if /i "%choice%"=="G" goto wireless
if /i "%choice%"=="H" goto hotspot
if /i "%choice%"=="I" goto storage
if /i "%choice%"=="J" goto sync_all
if /i "%choice%"=="K" goto quick_scripts
if /i "%choice%"=="L" goto custom_cmd
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
echo  [5] Run All AI Tools Status Check
echo  [0] Back
echo.
set /p ai_choice="Select: "

if "!ai_choice!"=="1" opencode
if "!ai_choice!"=="2" claude
if "!ai_choice!"=="3" gemini
if "!ai_choice!"=="4" agent-tars
if "!ai_choice!"=="5" goto ai_status

:ai_status
echo.
echo Checking AI tools...
where opencode >nul 2>&1 && echo [✓] OpenCode || echo [✗] OpenCode
where claude >nul 2>&1 && echo [✓] Claude Code || echo [✗] Claude Code
where gemini >nul 2>&1 && echo [✓] Gemini CLI || echo [✗] Gemini CLI
where agent-tars >nul 2>&1 && echo [✓] TARS || echo [✗] TARS
pause
goto ai_tools

:kali_vm
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                      🐉 KALI VM CONTROL                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Start Kali VM
echo  [2] Stop Kali VM
echo  [3] SSH to Kali
echo  [4] Copy Scripts to Kali
echo  [5] Run Wireless Scan
echo  [6] VM Status
echo  [0] Back
echo.
set /p kali_choice="Select: "

if "!kali_choice!"=="1" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "Kali-Linux-Wireless" --type headless
    echo VM Started!
    timeout /t 3 >nul
)
if "!kali_choice!"=="2" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "Kali-Linux-Wireless" poweroff
    echo VM Stopped!
    timeout /t 3 >nul
)
if "!kali_choice!"=="3" (
    echo Connecting to Kali...
    ssh root@192.168.1.50
)
if "!kali_choice!"=="4" (
    echo Copying scripts to Kali...
    scp -r "C:\Users\User\KaliShare\scripts\*" root@192.168.1.50:/root/scripts/
    echo Done!
    timeout /t 2 >nul
)
if "!kali_choice!"=="5" (
    echo Running wireless scan on Kali...
    ssh root@192.168.1.50 "sudo airodump-ng wlan0mon"
)
if "!kali_choice!"=="6" (
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo "Kali-Linux-Wireless" | findstr /i "state memory cpu"
    pause
)
goto kali_vm

:xp_laptop
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    💻 XP LAPTOP CONTROL                              ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Remote Desktop to XP
echo  [2] SSH to XP
echo  [3] Access Shared Folders
echo  [4] Run XP Setup Script
echo  [5] Run NAS Setup Script
echo  [0] Back
echo.
set /p xp_choice="Select: "

if "!xp_choice!"=="1" (
    echo Opening Remote Desktop...
    start mstsc /v:192.168.1.75
)
if "!xp_choice!"=="2" (
    echo Connecting via SSH...
    ssh administrator@192.168.1.75
)
if "!xp_choice!"=="3" (
    echo Opening shared folders...
    start \\192.168.1.75\c$
)
if "!xp_choice!"=="4" (
    echo Running XP setup script...
    start "" "C:\Users\User\KaliShare\scripts\xp-setup.bat"
)
if "!xp_choice!"=="5" (
    echo Running NAS setup script...
    start "" "C:\Users\User\KaliShare\scripts\xp-nas.bat"
)
goto xp_laptop

:oppo_phone
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    📱 OPPO PHONE CONTROL                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] SSH to OPPO (via USB)
echo  [2] SSH to OPPO (via WiFi)
echo  [3] USB Debugging Connect
echo  [4] Show Setup Instructions
echo  [5] Run Termux Backup
echo  [0] Back
echo.
set /p oppo_choice="Select: "

if "!oppo_choice!"=="1" (
    echo Connect USB and enable USB debugging first!
    echo Then: adb forward tcp:8022 tcp:8022
    ssh -p 8022 localhost
)
if "!oppo_choice!"=="2" (
    echo Ensure phone is on same network as this PC
    ssh -p 22 root@192.168.1.100
)
if "!oppo_choice!"=="3" (
    echo Starting ADB server...
    adb start-server
    echo Forwarding port...
    adb forward tcp:8022 tcp:8022
    echo Ready! Use option [1] to connect
    pause
)
if "!oppo_choice!"=="4" (
    start https://f-droid.org
    start https://wiki.termux.com
    echo Open F-Droid, install Termux, then run in Termux:
    echo   pkg update ^&^& pkg upgrade
    echo   pkg install git curl wget
    echo   npm install -g opencode-ai
    pause
)
if "!oppo_choice!"=="5" (
    echo Backing up Termux...
    adb forward tcp:8022 tcp:8022
    ssh -p 8022 localhost "tar -czf /sdcard/termux-backup.tar.gz -C /home termux"
    adb pull /sdcard/termux-backup.tar.gz "C:\Users\User\Backups\"
    echo Backup complete!
    pause
)
goto oppo_phone

:network_discovery
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                     🌐 NETWORK DISCOVERY                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo Scanning network for devices...
echo.
for /L %%i in (1,1,254) do (
    ping -n 1 -w 100 192.168.1.%%i >nul 2>&1 && (
        echo [✓] 192.168.1.%%i - FOUND
    )
)
echo.
echo Complete!
pause
goto menu

:diagnostics
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                     📊 SYSTEM DIAGNOSTICS                             ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo System Info:
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo.
echo Network:
ipconfig | findstr /i "ipv4 subnet"
echo.
echo VMs Running:
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list runningvms
echo.
echo Disk Space:
wmic logicaldisk get name,size,freespace /format:list
echo.
pause
goto menu

:wireless
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                     📡 WIRELESS TOOLS                                ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  TP-Link TL-WN721N (Atheros AR9271)
echo  Status: Ready in Kali VM
echo.
echo  [1] SSH to Kali for Wireless Tools
echo  [2] Check USB Devices
echo  [3] View Wireless Commands Reference
echo  [4] Quick Monitor Mode Test
echo  [0] Back
echo.
set /p wl_choice="Select: "

if "!wl_choice!"=="1" ssh root@192.168.1.50
if "!wl_choice!"=="2" (
    echo Checking USB...
    ssh root@192.168.1.50 "lsusb | grep -i atheros"
)
if "!wl_choice!"=="3" (
    start notepad "C:\Users\User\KaliShare\docs\commands.md"
)
if "!wl_choice!"=="4" (
    echo Testing monitor mode...
    ssh root@192.168.1.50 "sudo airmon-ng"
)
pause
goto wireless

:hotspot
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    📶 HUAWEI HOTSPOT MONITOR                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Open Hotspot Admin Panel
echo  [2] Check Hotspot Status
echo  [3] Port Forwarding Setup
echo  [4] Monitor Hotspot Connection
echo  [0] Back
echo.
set /p hs_choice="Select: "

if "!hs_choice!"=="1" start http://192.168.1.1
if "!hs_choice!"=="2" (
    ping -n 3 192.168.1.1
)
if "!hs_choice!"=="3" (
    echo Configure port forwarding in Huawei admin panel
    echo Common ports:
    echo   SSH: 22 -> Kali VM (192.168.1.50)
    echo   RDP: 3389 -> XP Laptop (192.168.1.75)
    pause
)
if "!hs_choice!"=="4" (
    echo Starting hotspot monitor...
    bash "C:\Users\User\KaliShare\scripts\hotspot-monitor.sh"
)
pause
goto hotspot

:storage
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    💾 STORAGE & WORDLISTS                           ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  XP Laptop (400GB) - NAS
echo  Kali VM - Current Use
echo  Windows Host - Backup
echo.
echo  [1] Open XP Share
echo  [2] Sync Wordlists to Kali
echo  [3] Copy PCAP Files to XP
echo  [4] Backup Kali to XP
echo  [5] Create New Backup
echo  [0] Back
echo.
set /p st_choice="Select: "

if "!st_choice!"=="1" start \\192.168.1.75\pentest-share
if "!st_choice!"=="2" (
    echo Syncing wordlists...
    rsync -avz root@192.168.1.50:/usr/share/wordlists/ \\192.168.1.75\pentest-share\wordlists\
)
if "!st_choice!"=="3" (
    echo Copying PCAP files...
    xcopy "C:\Users\User\KaliShare\*.cap" \\192.168.1.75\pentest-share\pcaps\ /E /I
)
if "!st_choice!"=="4" (
    echo Backing up Kali...
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" export "Kali-Linux-Wireless" -o \\192.168.1.75\pentest-share\backups\kali-backup.ova
)
if "!st_choice!"=="5" (
    echo Creating backup folder...
    mkdir "C:\Users\User\Backups\%date:~-4%%date:~3,2%%date:~0,2%"
    echo Backup location: C:\Users\User\Backups\
    pause
)
goto storage

:sync_all
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    🔄 SYNC ALL DEVICES                              ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo Syncing scripts to Kali...
scp -r "C:\Users\User\KaliShare\scripts\*" root@192.168.1.50:/root/scripts/ 2>nul
echo Syncing configs to OPPO...
adb forward tcp:8022 tcp:8022 2>nul
echo Syncing wordlists from XP...
net use Z: \\192.168.1.75\pentest-share 2>nul
echo.
echo Sync Complete!
pause
goto menu

:quick_scripts
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                      ⚡ QUICK SCRIPTS                                ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Run Kali Enhancement Script
echo  [2] Create New Kali VM
echo  [3] Update All Scripts
echo  [4] Open Scripts Folder
echo  [5] Open Documentation
echo  [0] Back
echo.
set /p qs_choice="Select: "

if "!qs_choice!"=="1" (
    echo Copying enhance script to Kali...
    scp "C:\Users\User\KaliShare\scripts\enhance-kali-v3.sh" root@192.168.1.50:/root/
    echo Now SSH to Kali and run: sudo ./enhance-kali-v3.sh
    pause
)
if "!qs_choice!"=="2" (
    start "" "C:\Users\User\KaliShare\scripts\create-kali-graphical.bat"
)
if "!qs_choice!"=="3" (
    echo Updating scripts from Git...
    echo (Git repository not configured yet)
    pause
)
if "!qs_choice!"=="4" (
    start explorer "C:\Users\User\KaliShare\scripts"
)
if "!qs_choice!"=="5" (
    start explorer "C:\Users\User\KaliShare\docs"
)
goto quick_scripts

:custom_cmd
echo.
set /p custom="Enter command: "
%custom%
echo.
pause
goto menu

:end
cls
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                                                                       ║
echo  ║              🏠 Home Lab Multi-Device Controller                    ║
echo  ║                      GoodBye!                                       ║
echo  ║                                                                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
exit /b 0
