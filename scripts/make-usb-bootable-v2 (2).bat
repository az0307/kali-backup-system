@echo off
REM ====================================================================
REM KALI BOOTABLE USB - SIMPLE METHOD
REM ====================================================================
REM 
REM Run this script AS ADMINISTRATOR
REM 
REM Method: Uses Windows DISKPART to clean and format USB properly
REM ====================================================================

echo.
echo ====================================
echo   KALI BOOTABLE USB CREATOR
echo ====================================
echo.

echo This will create a bootable Kali Linux USB
echo.
echo Requirements:
echo - USB Drive (at least 4GB)
echo - Kali ISO at F:\kali.iso
echo.
echo WARNING: This will ERASE all data on USB!
echo.

set /p CONFIRM=Type YES to continue: 
if /i not "%CONFIRM%"=="YES" goto :cancel

echo.
echo Starting...
echo.

REM Check for administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run as Administrator!
    echo Right-click this file and select "Run as administrator"
    pause
    exit /b 1
)

echo Step 1: Opening DiskPart...
echo.
echo In DiskPart, do these commands:
echo   list disk
echo   select disk 2    ^(USB drive^)
echo   clean
echo   create partition primary
echo   format fs=fat32 quick
echo   active
echo   exit
echo.

echo Would you like me to open DiskPart now? (y/n)
set /p OPENDP=

if /i "%OPENDP%"=="y" (
    start cmd /k "diskpart"
    echo.
    echo After formatting in DiskPart, come back here and press any key...
    pause >nul
)

echo.
echo Step 2: Copying ISO files to USB...
echo.

REM Mount ISO and copy
if exist "F:\kali.iso" (
    echo Copying from F:\kali.iso to USB...
    xcopy F:\kali.iso F:\*.* /Y >nul 2>&1
    echo Files copied!
) else (
    echo ERROR: ISO not found at F:\kali.iso
    pause
    exit /b 1
)

echo.
echo ====================================
echo   USB SHOULD NOW BE BOOTABLE
echo ====================================
echo.
echo Instructions:
echo 1. Turn on desktop PC
echo 2. Press F12 (or DEL) for boot menu
echo 3. Select USB as boot device
echo 4. Choose "Install" for network install
echo.

pause
exit /b 0

:cancel
echo Cancelled.
pause
