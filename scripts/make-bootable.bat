@echo off
REM Create bootable Kali USB using diskpart and xcopy
REM Run as Administrator

echo.
echo ====================================
echo   Creating Bootable Kali USB
echo ====================================
echo.

REM Check if admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run as Administrator!
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo Step 1: Opening DiskPart...
echo.
echo In the DiskPart window that opens, type these commands:
echo.
echo   list disk
echo   select disk 1
echo   clean
echo   create partition primary
echo   format fs=fat32 quick
echo   active
echo   exit
echo.
echo After you exit DiskPart, come back here and press any key...
echo.
pause

echo.
echo Step 2: Copying Kali files...
echo.

REM Mount ISO
echo Mounting ISO...
powershell -Command "Mount-DiskImage -ImagePath 'F:\kali.iso'"

REM Get mounted drive letter
for /f "tokens=2" %%d in ('powershell -Command "(Get-Volume | Where-Object {$_.DriveLetter -ne 'F' -and $_.DriveLetter -ne $null} | Where-Object {(Get-DiskImage -DevicePath ('\\.\PhysicalDrive1') -ErrorAction SilentlyContinue).ImagePath -like '*kali*'}).DriveLetter"') do set ISOLETTER=%%d

echo ISO mounted as: %ISOLETTER%:

echo Copying files...
xcopy %ISOLETTER%:\*.* F:\ /E /H /Y

echo.
echo Unmounting ISO...
powershell -Command "Dismount-DiskImage -ImagePath 'F:\kali.iso'"

echo.
echo ====================================
echo   DONE! USB should be bootable
echo ====================================
echo.
pause
