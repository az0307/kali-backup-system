@echo off
REM ====================================================================
REM KALI USB MAKER - Using ISO2USB alternative
REM ====================================================================

echo.
echo ====================================
echo   KALI USB CREATOR
echo ====================================
echo.

REM Try to find iso
if not exist "F:\kali.iso" (
    echo ERROR: F:\kali.iso not found!
    pause
    exit /b 1
)

echo Found: F:\kali.iso
echo.

REM Check available space
powershell -Command "(Get-PSDrive F).Free / 1GB"
echo GB free on USB
echo.

echo Options:
echo 1. Use existing Rufus ^(if installed^)
echo 2. Use Windows built-in method
echo 3. Download Rufus
echo.

set /p CHOICE=Choose option [1-3]: 

if "%CHOICE%"=="1" (
    start rufus
    goto :end
)

if "%CHOICE%"=="2" goto :manual

if "%CHOICE%"=="3" goto :download

:download
echo Downloading Rufus...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe' -OutFile 'F:\rufus.exe' -UseBasicParsing"
if exist "F:\rufus.exe" (
    echo Rufus downloaded!
    start F:\rufus.exe
) else (
    echo Download failed. Try option 2.
)
goto :end

:manual
echo.
echo === MANUAL METHOD ===
echo.
echo 1. Press WIN + R, type: diskmgmt.msc
echo 2. Find USB drive F: - right click - Delete Volume
echo 3. Right click USB - New Simple Volume
echo 4. Format as FAT32
echo 5. Download Rufus from: https://rufus.ie
echo.
echo OR use the ISO as a virtual DVD:
echo 1. Right-click F:\kali.iso
echo 2. Select "Mount"
echo 3. Copy all files from mounted drive to USB
echo.

:end
pause
