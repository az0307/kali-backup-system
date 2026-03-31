@echo off
REM Mount ISO and Copy to USB - No Extra Software!
echo.
echo ====================================
echo   MOUNT ISO TO USB
echo ====================================
echo.

echo Step 1: Mounting ISO...
powershell -Command "Mount-DiskImage -ImagePath 'F:\kali.iso'"

echo.
echo Step 2: Finding mounted drive...
for /f "tokens=2" %%d in ('powershell -Command "(Get-Volume | Where-Object {$_.DriveLetter -ne $null -and (Get-DiskImage -DevicePath $_.DiskPath -ErrorAction SilentlyContinue | Where-Object {$_.ImagePath -like '*kali*'})}).DriveLetter"') do set DVDLETTER=%%d

echo Mounted as drive: %DVDLETTER%

echo.
echo Step 3: Copying files to USB...
xcopy %DVDLETTER%:\*.* F:\ /E /H /Y

echo.
echo Step 4: Unmounting ISO...
powershell -Command "Dismount-DiskImage -ImagePath 'F:\kali.iso'"

echo.
echo DONE! USB should be bootable now.
pause
