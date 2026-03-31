@echo off
REM =============================================================================
REM   🐉 KALI BOOTABLE USB CREATOR
REM   Creates bootable Kali Linux USB from drive F:
REM ==============================================================================

setlocal

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║           🐉 KALI BOOTABLE USB CREATOR v1.0                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

REM Check for USB drive
echo  Detecting drives...
echo.
echo  Available drives:
echo  ──────────────
wmic logicaldisk get caption,size,drivetype 2>nul | findstr /V "Caption"
echo.

REM Set drive letter
set USB_DRIVE=F

echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  IMPORTANT: This will ERASE everything on drive %USB_DRIVE%:!    ║
echo  ║                                                                     ║
echo  ║  Your 16GB USB should be drive %USB_DRIVE%:                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

set /p confirm="Type YES to confirm: "

if /i not "%confirm%"=="YES" (
    echo Cancelled!
    pause
    exit /b 0
)

echo.
echo  [1/4] Downloading Rufus...
echo  Downloading portable Rufus...

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe' -OutFile 'rufus.exe'"

if not exist rufus.exe (
    echo  Download failed! Trying alternative...
    powershell -Command "Invoke-WebRequest -Uri 'https://rufus.ie/files/rufus-4.4.exe' -OutFile 'rufus.exe'"
)

echo.
echo  [2/4] Downloading Kali Linux ISO...
echo  This will take a while (~4GB)...

powershell -Command "Invoke-WebRequest -Uri 'https://kali.org/get/kali/kali-linux-2024.1-live-amd64.iso' -OutFile 'kali.iso' -ProgressPreference SilentlyContinue"

if not exist kali.iso (
    echo  Download failed! Trying alternative mirror...
    powershell -Command "Invoke-WebRequest -Uri 'https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-live-amd64.iso' -OutFile 'kali.iso' -ProgressPreference SilentlyContinue"
)

if not exist kali.iso (
    echo.
    echo  ╔═══════════════════════════════════════════════════════════════════╗
    echo  ║  ERROR: Could not download Kali ISO                              ║
    echo  ║                                                                       ║
    echo  ║  Please manually:                                                  ║
    echo  ║  1. Download Kali from: https://kali.org/download              ║
    echo  ║  2. Save as kali.iso in this folder                           ║
    echo  ║  3. Run this script again                                        ║
    echo  ╚═══════════════════════════════════════════════════════════════════╝
    pause
    exit /b 1
)

echo.
echo  [3/4] Creating bootable USB...
echo  Starting Rufus...

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  Rufus will open now:                                                ║
echo  ║                                                                       ║
echo  ║  1. Device: Select your USB drive (%USB_DRIVE%:)                     ║
echo  ║  2. Boot selection: Click SELECT and choose kali.iso                ║
echo  ║  3. Partition scheme: MBR                                             ║
echo  ║  4. File system: FAT32                                              ║
echo  ║  5. Click START                                                      ║
echo  ║                                                                       ║
echo  ║  ⚠️  Click YES to any warnings about ISO mode!                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

start "" rufus.exe

echo.
echo  Press any key when Rufus has finished creating the bootable USB...
pause >nul

echo.
echo  [4/4] Done!
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  ✅ Bootable Kali USB created!                                       ║
echo  ║                                                                       ║
echo  ║  Next steps:                                                         ║
echo  ║  1. Plug USB into your desktop PC                                   ║
echo  ║  2. Turn on desktop, press F12 for boot menu                       ║
echo  ║  3. Select USB drive to boot                                         ║
echo  ║  4. Choose "Live" to try or "Install" to install                    ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

pause
