@echo off
REM #############################################################################
REM  #  💾 USB BACKUP TO GOOGLE DRIVE
REM  #############################################################################

setlocal enabledelayedexpansion

set SOURCE=F:\
set BACKUP_DIR=C:\Users\User\Backups\USB_Backup_%date:~-4%%date:~3,2%%date:~0,2%

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    💾 USB BACKUP TO GOOGLE DRIVE                   ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

REM Check if USB drive exists
if not exist F:\ (
    echo [ERROR] USB drive F: not found!
    pause
    exit /b 1
)

REM Create backup directory
echo [1/4] Creating backup folder...
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Count files
echo [2/4] Scanning USB...
for /f %%a in ('dir /b /s F:\ ^| find /c /v ""') do set FILE_COUNT=%%a
echo  Found !FILE_COUNT! files

REM Copy files
echo [3/4] Copying files to backup...
echo  From: F:\
echo  To:   %BACKUP_DIR%

xcopy /E /H /Y /Q F:\* "%BACKUP_DIR%\" >nul 2>&1

if %errorlevel% neq 0 (
    echo [ERROR] Copy failed!
    pause
    exit /b 1
)

REM Show result
echo.
echo [4/4] Backup complete!
echo.

dir "%BACKUP_DIR%" | findstr /i "File"

echo.
echo  Backup location: %BACKUP_DIR%
echo.

REM Now ask about Google Drive
echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║  Upload to Google Drive?                                          ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  [1] Upload entire backup folder
echo  [2] Open Google Drive folder
echo  [3] Skip upload
echo.
set /p gd_choice="Select: "

if "!gd_choice!"=="1" (
    echo.
    echo  Opening Google Drive upload...
    start "" "https://drive.google.com/drive/my-drive"
    timeout /t 5 >nul
    echo  Please drag folder: %BACKUP_DIR%
    echo  to Google Drive window
    pause
)
if "!gd_choice!"=="2" (
    start "" "https://drive.google.com/drive/my-drive"
)
if "!gd_choice!"=="3" (
    echo  Skipped
)

echo.
echo  ✅ Backup complete!
pause
