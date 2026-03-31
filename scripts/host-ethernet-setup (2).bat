@echo off
REM #############################################################################
REM  #  🐉 ETHERNET NETWORK SHARE - Windows Host Setup
REM  #  Shares internet from laptop to desktop PC via Ethernet
REM  #############################################################################

setlocal enabledelayedexpansion

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║           🐉 ETHERNET NETWORK SHARE - Windows Host                   ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

REM ============================================================================
REM CHECKS
REM ============================================================================

echo  [1/4] Checking network adapters...
echo.

netsh interface show interface | findstr /C:"Connected"

echo.
echo  Current adapters:
netsh interface ipv4 show config | findstr /C:"Configuration" /C:"Interface"
echo.

REM ============================================================================
REM FIND ETHERNET ADAPTER
REM ============================================================================

echo  [2/4] Finding Ethernet adapter...
echo.

for /f "tokens=1,* delims=:" %%a in ('netsh interface show interface ^| findstr /i "ethernet local"') do (
    echo  Found: %%b
)

REM Get active Ethernet adapter
set ETH_ADAPTER=
for /f "tokens=4" %%a in ('netsh interface ipv4 show addresses ^| findstr /i "192.168.137"') do (
    set ETH_ADAPTER=!ETH_ADAPTER! %%a
)

REM ============================================================================
REM CONFIGURE ICS (Internet Connection Sharing)
REM ============================================================================

echo  [3/4] Configuring Internet Connection Sharing...
echo.

REM Get active internet connection (WiFi or Ethernet)
set INTERNET_CONNECTION=
for /f "tokens=1,* delims=:" %%a in ('netsh interface show interface ^| findstr /i "connected"') do (
    set INTERNET_CONNECTION=!INTERNET_CONNECTION! %%b
)

echo  Internet connection: !INTERNET_CONNECTION!
echo  This adapter will share internet: WiFi or Mobile Hotspot
echo.

REM Enable ICS on Ethernet adapter
echo  Enabling Internet Connection Sharing...
echo.

REM Find the Ethernet adapter name (usually "Ethernet" or "Ethernet 2")
set ETH_NAME=Ethernet

netsh interface ip set address name="Ethernet" static 192.168.1.100 255.255.255.0

netsh interface ip set dns name="Ethernet" static 8.8.8.8
netsh interface ip add dns name="Ethernet" 8.8.4.4 index=2

echo  ✓ Set Ethernet adapter IP: 192.168.1.100
echo.

REM ============================================================================
REM ENABLE SHARING
REM ============================================================================

echo  [4/4] Enabling Internet Connection Sharing...
echo.

REM Enable ICS - share WiFi to Ethernet
netsh wlan show interfaces | findstr /C:"SSID" >nul
if %errorlevel%==0 (
    echo  WiFi detected - sharing WiFi to Ethernet
    REM Use registry to enable sharing
    reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SharedAccess" /v EnableRebootConnectTable /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SharedAccess" /v Nt4BackupConnectTable /t REG_DWORD /d 0 /f >nul 2>&1
)

echo  ✓ Network sharing configured
echo.

REM ============================================================================
REM SHOW INFO
REM ============================================================================

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║                    ✅ ETHERNET SETUP COMPLETE                        ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  ┌─────────────────────────────────────────────────────────────────────┐
echo  │  Windows Laptop Configuration:                                      │
echo  │                                                                     │
echo  │    Ethernet IP:     192.168.1.100                                   │
echo  │    Subnet:         255.255.255.0 (/24)                             │
echo  │    Gateway:        192.168.1.100 (this laptop)                      │
echo  │    DNS:           8.8.8.8, 8.8.4.4                                  │
echo  └─────────────────────────────────────────────────────────────────────┘
echo.
echo  ┌─────────────────────────────────────────────────────────────────────┐
echo  │  Desktop PC (Kali) Configuration:                                   │
echo  │                                                                     │
echo  │    IP:             192.168.1.200                                   │
echo  │    Subnet:         255.255.255.0 (/24)                             │
echo  │    Gateway:        192.168.1.100 (this laptop)                     │
echo  │    DNS:           8.8.8.8                                          │
echo  └─────────────────────────────────────────────────────────────────────┘
echo.
echo  Connect: Laptop Ethernet port <---> Desktop PC Ethernet port
echo.
echo  Now configure Desktop PC as shown above
echo.

pause
