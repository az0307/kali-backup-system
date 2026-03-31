@echo off
REM Setup Ethernet for Desktop Connection
REM Run as Administrator

echo Configuring Ethernet...
echo.

REM Set static IP for laptop
netsh interface ip set address name="Ethernet" static 192.168.1.100 255.255.255.0

REM Set DNS
netsh interface ip set dns name="Ethernet" static 8.8.8.8
netsh interface ip add dns name="Ethernet" 8.8.4.4 index=2

echo.
echo Laptop configured:
echo   IP: 192.168.1.100
echo   Subnet: 255.255.255.0
echo   Gateway: (none - this is the gateway)
echo.
echo Now connect Ethernet cable to desktop PC
echo.
echo Desktop will get IP or use: 192.168.1.200
echo.
pause
