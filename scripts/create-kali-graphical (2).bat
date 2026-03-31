@echo off
REM Create Kali VM with VirtualBox - Graphical Edition

setlocal

echo.
echo ═════════════════════════════════════════════════════════════
echo        Creating NEW Kali Linux VM (Graphical)
echo ═════════════════════════════════════════════════════════════
echo.

REM Set variables
set "VM_NAME=Kali-Linux-Graphical"
set "ISO_PATH=C:\Users\User\kali-linux-netinst.iso"
set "RAM=4096"
set "CPUS=2"
set "VRAM=128"
set "DISK_SIZE=50000"

REM Check for ISO
if not exist "%ISO_PATH%" (
    echo [ERROR] Kali ISO not found at: %ISO_PATH%
    echo.
    echo Please download Kali Linux ISO from:
    echo https://www.kali.org/get-kali/#kali-installer-images
    echo.
    echo Options:
    echo   1. NetInst (~50MB):kali-linux-netinst.iso
    echo   2. Live (~4GB): kali-linux-live-amd64.iso
    echo   3. Weekly: kali-weekly-amd64.iso
    echo.
    pause
    exit /b 1
)

echo [INFO] Using ISO: %ISO_PATH%
echo.

REM Create VM
echo [1/6] Creating Virtual Machine...
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" createvm --name "%VM_NAME%" --ostype Debian_64 --register
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create VM
    pause
    exit /b 1
)
echo        VM created: %VM_NAME%

REM Configure VM
echo [2/6] Configuring VM settings...

"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%VM_NAME%" --memory %RAM% --cpus %CPUS% --vram %VRAM%
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%VM_NAME%" --nic1 bridged --bridgeadapter1 "Atheros AR9271 Wireless Network Adapter"
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%VM_NAME%" --usb on --usbxhci on
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%VM_NAME%" --clipboard bidirectional --draganddrop bidirectional
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%VM_NAME%" --graphicscontroller vmsvga

REM Create disk
echo [3/6] Creating virtual hard disk...
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" createmedium disk --filename "C:\Users\User\VirtualBox VMs\%VM_NAME%\%VM_NAME%.vdi" --size %DISK_SIZE% --format VDI --variant Dynamic

REM Attach disk
echo [4/6] Attaching hard disk...
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" storagectl "%VM_NAME%" --name "SATA Controller" --add sata
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" storageattach "%VM_NAME%" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "C:\Users\User\VirtualBox VMs\%VM_NAME%\%VM_NAME%.vdi"

REM Attach ISO
echo [5/6] Attaching ISO...
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" storagectl "%VM_NAME%" --name "IDE Controller" --add ide
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" storageattach "%VM_NAME%" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "%ISO_PATH%"

REM Add USB filter for TP-Link
echo [6/6] Adding USB filter for WiFi adapter...
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" usbfilter add 0 --vmname "%VM_NAME%" --name "TP-Link" --vendorid 0bda --productid 8179

echo.
echo ═════════════════════════════════════════════════════════════
echo        ✅ Kali VM Created Successfully!
echo ═════════════════════════════════════════════════════════════
echo.
echo VM Name: %VM_NAME%
echo RAM: %RAM% MB
echo CPUs: %CPUS%
echo Disk: %DISK_SIZE% MB
echo Network: Bridged (WiFi adapter)
echo.
echo Next Steps:
echo   1. Start VirtualBox
echo   2. Click on %VM_NAME%
echo   3. Click Start
echo   4. Install Kali Linux with Graphical Desktop
echo.
echo Installation Options:
echo   - Use "Graphical Install"
echo   - Software selection: ^(^)
echo       [X] GNOME (or XFCE/KDE)
echo       [X] Kali Linux Live System
echo       [X] Common tools (metapackages)
echo.
echo After installation, run enhance-kali.sh to set up AI tools
echo.
pause
