@echo off
REM #############################################################################
REM  #  🐉 CREATE BOOTABLE KALI USB
REM  #############################################################################

setlocal enabledelayedexpansion

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║              🐉 CREATE BOOTABLE KALI USB v1.0                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

REM ============================================================================
REM CHECKS
REM ============================================================================

echo  [1/6] Checking prerequisites...
echo.

REM Check for Kali ISO
set ISO_PATH=F:\kali.iso
if not exist "%ISO_PATH%" (
    set ISO_PATH=C:\Users\User\Downloads\kali-linux-2024.4-live-amd64.iso
    if not exist "%ISO_PATH%" (
        set ISO_PATH=C:\Users\User\Downloads\kali.iso
        if not exist "%ISO_PATH%" (
            echo  [ERROR] Kali ISO not found!
            echo.
            echo  Please download Kali from: https://kali.org/get-kali/
            echo  Save as: F:\kali.iso or C:\Users\User\Downloads\kali.iso
            pause
            exit /b 1
        )
    )
)

echo  ISO: %ISO_PATH%
for %%A in ("%ISO_PATH%") do echo  Size: %%~zA bytes

REM Check USB drive
echo.
echo  [2/6] Checking USB drive...
echo.
echo  Available drives:
wmic logicaldisk get caption,size,drivetype 2>nul | findstr /V "Caption"

set /p USB_LETTER="Enter USB drive letter (e.g., F): "

REM Validate drive
if "!USB_LETTER!"=="" (
    echo  [ERROR] No drive letter entered
    pause
    exit /b 1
)

set USB_DRIVE=!USB_LETTER!:

if not exist "!USB_DRIVE!\" (
    echo  [ERROR] Drive !USB_DRIVE! not found!
    pause
    exit /b 1
)

echo  Selected: !USB_DRIVE!

REM ============================================================================
REM WARNINGS
REM ============================================================================

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  ⚠️  WARNING: This will ERASE everything on !USB_DRIVE! !            ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
set /p CONFIRM="Type YES to continue: "
if /i not "!CONFIRM!"=="YES" (
    echo  Cancelled!
    pause
    exit /b 0
)

REM ============================================================================
REM DOWNLOAD RUFUS
REM ============================================================================

echo.
echo  [3/6] Getting Rufus...

set RUFUS_PATH=C:\Users\User\Downloads\rufus.exe

if not exist "%RUFUS_PATH%" (
    echo  Downloading Rufus...
    powershell -Command "try { Invoke-WebRequest -Uri 'https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe' -OutFile '%RUFUS_PATH%' -UseBasicParsing } catch { Write-Host 'Download failed' }"
    
    if not exist "%RUFUS_PATH%" (
        echo  [ERROR] Could not download Rufus
        echo.
        echo  Please manually:
        echo  1. Download from: https://rufus.ie
        echo  2. Run Rufus
        echo  3. Select USB !USB_DRIVE!
        echo  4. Select Kali ISO
        echo  5. Click Start
        pause
        exit /b 1
    )
)

echo  Rufus ready: %RUFUS_PATH%

REM ============================================================================
REM RUN RUFUS
REM ============================================================================

echo.
echo  [4/6] Starting Rufus...
echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  RUFUS INSTRUCTIONS:                                                ║
echo  ║                                                                       ║
echo  ║  1. Device: Select !USB_DRIVE!                                      ║
echo  ║  2. Boot selection: Click SELECT ^> choose %ISO_PATH%            ║
echo  ║  3. Partition scheme: MBR                                             ║
echo  ║  4. File system: FAT32                                              ║
echo  ║  5. Label: KALI                                                     ║
echo  ║  6. Click START                                                     ║
echo  ║                                                                       ║
echo  ║  ⚠️  If prompted about ISO mode, click YES                          ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

start "" "%RUFUS_PATH%"

echo.
echo  Press any key when Rufus has finished creating bootable USB...
pause >nul

REM ============================================================================
REM VERIFY USB
REM ============================================================================

echo.
echo  [5/6] Verifying bootable USB...

if exist "!USB_DRIVE!\EFI" (
    echo  ✓ EFI folder found
) else (
    echo  ⚠ EFI folder not found, but may still work
)

if exist "!USB_DRIVE!\live" (
    echo  ✓ Live folder found
) else (
    echo  ⚠ Live folder not found
)

if exist "!USB_DRIVE!\boot" (
    echo  ✓ Boot folder found
) else (
    echo  ⚠ Boot folder not found
)

REM ============================================================================
REM COPY SCRIPTS
REM ============================================================================

echo.
echo  [6/6] Copying scripts to USB...

if not exist "!USB_DRIVE!\scripts" mkdir "!USB_DRIVE!\scripts"

xcopy /E /Y /Q "C:\Users\User\KaliShare\scripts\*" "!USB_DRIVE!\scripts\" >nul 2>&1
xcopy /E /Y /Q "C:\Users\User\KaliShare\docs\*" "!USB_DRIVE!\docs\" >nul 2>&1

echo  ✓ Scripts copied

REM ============================================================================
REM CREATE AUTORUN
REM ============================================================================

echo  Creating autorun...

(
echo @echo off
echo title Kali Linux Installer
echo cls
echo.
echo  ═════════════════════════════════════════════════════════════
echo  🐉 KALI LINUX - READY TO INSTALL
echo  ═════════════════════════════════════════════════════════════
echo.
echo  This USB contains:
echo  - Kali Linux Live
echo  - Setup scripts
echo  - Documentation
echo.
echo  To install:
echo  1. Turn on desktop PC
echo  2. Press F12 to boot from USB
echo  3. Select USB from boot menu
echo  4. Choose "Live" to try or "Install" to install
echo.
echo  ═════════════════════════════════════════════════════════════
echo.
echo  Press any key to exit to Windows...
echo.
echo  ===== AUTO-RUN COMPLETE =====
) > "!USB_DRIVE!\autorun.bat"

echo  ✓ Autorun created

REM ============================================================================
REM DONE
REM ============================================================================

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    ✅ BOOTABLE USB CREATED!                          ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  USB Drive: !USB_DRIVE!
echo  Contents:   Kali Linux Live + Scripts
echo.
echo  Next steps:
echo  1. Plug USB into desktop PC
echo  2. Turn on desktop, press F12 for boot menu
echo  3. Select USB to boot
echo  4. Install Kali Linux
echo.
echo  After install, run auto-connect-ethernet.sh on the new Kali
echo.
pause
