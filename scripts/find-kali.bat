@echo off
REM Kali VM Connection Helper
REM Run as: find-kali.bat

echo.
echo ========================================
echo Finding Kali VM on Network...
echo ========================================
echo.

echo Scanning network for SSH servers...
echo (This may take a minute)
echo.

set FOUND=

for /L %%i in (1,1,254) do (
    echo Checking 10.0.0.%%i...
    timeout /t 1 /nobreak >nul 2>&1
    >nul (
        powershell -Command "Test-NetConnection -ComputerName 10.0.0.%%i -Port 22 -WarningAction SilentlyContinue | Select-Object -ExpandProperty TcpTestSucceeded"
    ) && (
        echo [FOUND] 10.0.0.%%i has SSH!
        set FOUND=!FOUND! 10.0.0.%%i
    )
)

echo.
if defined FOUND (
    echo ========================================
    echo FOUND SSH SERVERS:!FOUND!
    echo ========================================
    echo.
    echo Try connecting with:
    echo   ssh root@10.0.0.66
    echo   (password: kali or toor)
) else (
    echo No SSH servers found on 10.0.0.x network
    echo.
    echo Try:
    echo   1. Check if Kali VM is running
    echo   2. Ensure SSH is enabled in Kali:
    echo      sudo systemctl enable ssh
    echo      sudo systemctl start ssh
    echo   3. Check network adapter settings
)

echo.
pause
