#!/bin/bash
# wifi-map.sh - WiFi database mapping & monitoring
# Usage: ./wifi-map.sh [scan|monitor|db|map|locate]

MODE=${1:-menu}
WIFI_DB="$HOME/wifi-db"
mkdir -p "$WIFI_DB"

case $MODE in
    scan)
        echo "=== WiFi Network Scan ==="
        IFACE=$(iw dev | grep Interface | awk '{print $2}')
        echo "Interface: $IFACE"
        
        echo "[*] Active APs..."
        airodump-ng --wps --band abg $IFACE --write "$WIFI_DB/scan-$(date +%Y%m%d-%H%M%S)" 2>/dev/null &
        PID=$!
        echo "Scanning... (PID: $PID)"
        sleep 15
        kill $PID 2>/dev/null
        
        echo "[*] Nearby networks..."
        iw dev $IFACE scan | grep -E "SSID:|signal:|freq:" | head -30
        ;;
    monitor)
        echo "=== WiFi Monitor Mode ==="
        echo "Interfaces:"
        ip link show | grep -E "wlan[0-9]"
        echo ""
        echo "Enable monitor mode:"
        echo "  ip link set wlan0 down"
        echo "  iw wlan0 set type monitor"
        echo "  ip link set wlan0 up"
        ;;
    db)
        echo "=== WiFi Database ==="
        echo "1) Add current network"
        echo "2) List all networks"
        echo "3) Search by SSID"
        echo "4) Search by BSSID"
        echo "5) Export to CSV"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "SSID: "
                read SSID
                echo "BSSID (MAC): "
                read MAC
                echo "Channel: "
                read CH
                echo "Notes: "
                read NOTE
                echo "$SSID|$MAC|$CH|$(date +%Y%m%d)|$NOTE" >> "$WIFI_DB/networks.db"
                echo "Added to database"
                ;;
            2)
                cat "$WIFI_DB/networks.db" 2>/dev/null || echo "Empty database"
                ;;
            3)
                echo "SSID to find: "
                read SSID
                grep -i "$SSID" "$WIFI_DB/networks.db" 2>/dev/null
                ;;
            4)
                echo "BSSID to find: "
                read MAC
                grep -i "$MAC" "$WIFI_DB/networks.db" 2>/dev/null
                ;;
            5)
                echo "SSID,BSSID,Channel,Date,Notes" > "$WIFI_DB/export.csv"
                cat "$WIFI_DB/networks.db" >> "$WIFI_DB/export.csv"
                echo "Exported to $WIFI_DB/export.csv"
                ;;
        esac
        ;;
    map)
        echo "=== WiFi Mapper (GPS) ==="
        echo "Requires: gpsd + airodump-ng with GPS"
        echo ""
        echo "Start mapping:"
        echo "  airodump-ng --gpsd wlan0"
        echo ""
        echo "Or use WiFiGmap:"
        echo "  wifigmap.py -i wlan0 -o kml"
        echo ""
        echo "Export to KML for Google Earth:"
        echo "  python3 airodump-ng-kml.py capture.kml output.kml"
        ;;
    locate)
        echo "=== WiFi Geolocation ==="
        echo "1) Lookup by MAC (Wigle)"
        echo "2) Find by SSID"
        echo "3) Map current location"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "MAC address: "
                read MAC
                curl -s "https://api.wigle.net/api/v2/network/search?mac=$MAC" -u "anonymous:anonymous" | head -50
                ;;
            2)
                echo "SSID: "
                read SSID
                curl -s "https://api.wigle.net/api/v2/network/search?ssid=$SSID" -u "anonymous:anonymous" | head -50
                ;;
            3)
                echo "Using Mozilla Location Service..."
                echo "Scan nearby APs first: airodump-ng wlan0"
                ;;
        esac
        ;;
    wardrive)
        echo "=== Wardrive Mode ==="
        echo "Recording: GPS + WiFi"
        echo ""
        echo "Tools:"
        echo "  - kismet (GPS + WiFi logging)"
        echo "  - airodump-ng --gpsd"
        echo "  - wifimap-android app"
        echo ""
        echo "Upload to:"
        echo "  - wigle.net"
        echo "  - openwips.net"
        ;;
    menu|*)
        echo "=== WiFi Database & Mapping ==="
        echo "1) Scan networks"
        echo "2) Monitor mode info"
        echo "3) Database management"
        echo "4) GPS mapping"
        echo "5) Geolocation lookup"
        echo "6) Wardrive mode"
        read -p "Choice: " choice
        case $choice in
            1) $0 scan ;;
            2) $0 monitor ;;
            3) $0 db ;;
            4) $0 map ;;
            5) $0 locate ;;
            6) $0 wardrive ;;
        esac
        ;;
esac