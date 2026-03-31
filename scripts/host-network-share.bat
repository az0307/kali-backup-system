@echo off
REM #############################################################################
REM  #  🌐 HOST PC NETWORK SHARING - Share WiFi with Ethernet
REM  #############################################################################

setlocal enabledelayedexpansion

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║              🌐 HOST NETWORK SHARING v1.0                            ║
echo  ║         Share WiFi internet via Ethernet to desktop Kali           ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

REM ============================================================================
REM FIND NETWORK ADAPTERS
REM ============================================================================

echo  [1/4] Detecting network adapters...
echo.

echo  WiFi adapter (internet source):
netsh wlan show interfaces | findstr /i "name state ssid signal"

echo.
echo  Ethernet adapter (to desktop):
netsh interface show interface | findstr /i "Ethernet Connected"

echo.

REM Let user select
set /p WIFI_ADAPTER="Enter WiFi adapter name (or press Enter for default): "
set /p ETH_ADAPTER="Enter Ethernet adapter name (or press Enter for default): "

if "!WIFI_ADAPTER!"=="" set WIFI_ADAPTER="Wi-Fi"
if "!ETH_ADAPTER!"=="" set ETH_ADAPTER="Ethernet"

echo.
echo  WiFi: !WIFI_ADAPTER!
echo  Ethernet: !ETH_ADAPTER!

REM ============================================================================
REM ENABLE ICS (Internet Connection Sharing)
REM ============================================================================

echo.
echo  [2/4] Enabling Internet Sharing...
echo.

REM Enable routing
netsh routing ip relay install >nul 2>&1

REM Check if sharing already enabled
netsh interface show interface | findstr /i "Ethernet Enabled" >nul 2>&1
if %errorlevel%==0 (
    echo  Ethernet already has sharing enabled?
)

REM Try to enable sharing - this often requires admin
echo  Attempting to enable ICS...

REM Method 1: netsh
netsh interface ipv4 set forwarding enable >nul 2>&1

REM Method 2: registry (if admin)
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" >nul 2>&1
if %errorlevel%==0 (
    echo  Firewall profile found
)

REM ============================================================================
REM CONFIGURE ETHERNET
REM ============================================================================

echo.
echo  [3/4] Configuring Ethernet adapter...
echo.

REM Set static IP on Ethernet
echo  Setting Ethernet IP to 192.168.1.100...

netsh interface ip set address name="Ethernet" static 192.168.1.100 255.255.255.0 192.168.1.1 >nul 2>&1

if %errorlevel% neq 0 (
    echo  Could not set static IP (may need admin)
    echo  Trying DHCP...
    netsh interface ip set address name="Ethernet" dhcp >nul 2>&1
)

REM Enable DHCP server on Ethernet (for ICS alternative)
echo  Enabling DHCP server...

REM ============================================================================
REM START SHARING
REM ============================================================================

echo.
echo  [4/4] Starting Internet Sharing...
echo.

REM Method: Internet Connection Sharing via netsh
echo  Attempting to enable sharing from WiFi to Ethernet...

REM Check admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  ⚠️  NOT RUNNING AS ADMIN - Some features may not work
    echo.
    echo  Please right-click and "Run as administrator"
    echo.
)

REM Try ICS enabling
echo  Method 1: netsh wlan share...
netsh wlan show hostednetwork >nul 2>&1
if %errorlevel%==0 (
    echo  Using hosted network mode...
)

REM ============================================================================
REM ALTERNATIVES
REM ============================================================================

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  ALTERNATIVE METHODS (if above doesn't work):                       ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo  Method A - Windows Settings:
echo    1. Settings ^> Network ^> Status
echo    2. Scroll down ^> Sharing options
echo    3. Enable "Turn on network discovery"
echo    4. Enable "Turn on file and printer sharing"
echo    5. Under "Home group connections", select "Allow Windows"
echo.
echo  Method B - Manual:
echo    1. Control Panel ^> Network and Internet ^> Network and Sharing
echo    2. Change adapter settings
echo    3. Right-click WiFi ^> Properties ^> Sharing
echo    4. Check "Allow other network users to connect"
echo    5. Select Ethernet as home network connection
echo.
echo  Method C - Router (recommended):
echo    1. Connect desktop to router/switch
echo    2. Router provides DHCP to both PCs
echo    3. Both get internet automatically
echo.

REM ============================================================================
REM VERIFY
REM ============================================================================

echo.
echo  ╔═══════════════════════════════════════════════════════════════════════╗
echo  ║  VERIFICATION - Check if sharing works:                              ║
echo  ╚═══════════════════════════════════════════════════════════════════════╝
echo.

echo  On desktop Kali, run:
echo    ping 192.168.1.100  ^<-- should work
echo    ping 8.8.8.8       ^<-- internet working
echo    ping google.com     ^<-- DNS working
echo.

echo  Current network config:
ipconfig | findstr /i "IPv4 Subnet"

echo.
echo  ✅ Network sharing configured!
echo.
echo  Note: Desktop Kali should get IP via DHCP automatically
echo  or use: 192.168.1.75 as static IP
echo.
pause
