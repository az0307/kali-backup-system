@echo off
REM Create bootable Kali USB - Run as Administrator
REM ISO location: F:\kali.iso

echo.
echo ====================================
echo   KALI BOOTABLE USB CREATOR
echo ====================================
echo.

REM Check ISO
if not exist "F:\kali.iso" (
    echo ERROR: F:\kali.iso not found!
    pause
    exit /b 1
)

echo ISO found: F:\kali.iso
echo.

REM Method 1: Try using dd via Git Bash
echo Trying method 1: dd via Git Bash...
where dd >nul 2>&1
if %errorlevel%==0 (
    echo Running dd...
    dd if=F:\kali.iso of=\\.\PHYSICALDRIVE2 bs=4M status=progress
    goto :success
)

REM Method 2: Use PowerShell
echo Trying method 2: PowerShell...
powershell -Command "Copy-Item -Path 'F:\kali.iso' -Destination '\\.\PHYSICALDRIVE2' -Force"

:success
echo.
echo ====================================
echo   DONE! USB should be bootable now
echo ====================================
echo.
echo Next: Boot desktop from USB
pause
