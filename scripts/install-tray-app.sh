#!/bin/bash
# System Tray Auto-Start Installer
# Purpose: Install auto-start system tray application for Kali
# Usage: chmod +x install-tray-app.sh && sudo ./install-tray-app.sh

set -euo pipefail

echo "=========================================="
echo "Kali System Tray Auto-Start Installer"
echo "=========================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check root
if [[ $EUID -ne 0 ]]; then
   log_error "This script must be run as root"
   exit 1
fi

TRAY_DIR="/opt/kali-tray"
DESKTOP_FILE="/etc/xdg/autostart/kali-tray.desktop"
SYSTEMD_SERVICE="/etc/systemd/system/kali-tray.service"

# ============================================
# CREATE SYSTEM TRAY APPLICATION
# ============================================

log_info "Creating system tray application..."

mkdir -p "$TRAY_DIR"

# Main tray script
cat > "$TRAY_DIR/kali-tray.sh" << 'TRAYEOF'
#!/bin/bash
# Kali System Tray Application
# Auto-starts on desktop login, provides quick access to tools

# Configuration
TRAY_ICON="/usr/share/icons/hicolor/48x48/apps/kali-menu.png"
LOG_FILE="/var/log/kali-tray.log"
PID_FILE="/var/run/kali-tray.pid"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo "[$(date '+%Y-%m-%d %H:%M')] $1" >> "$LOG_FILE"
}

# Check dependencies
check_deps() {
    local deps=("zenity" "yad" "notify-send" "nm-applet" "volumeicon")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            log "Installing missing dep: $dep"
            apt-get install -y "$dep" 2>/dev/null
        fi
    done
}

# Create tray menu
show_menu() {
    while true; do
        choice=$(zenity --list \
            --title="Kali Linux Toolkit" \
            --text="Select a tool to launch:" \
            --column="Action" \
            --column="Description" \
            "Network Scan" "Quick nmap network scan" \
            "WiFi Monitor" "Start airmon-ng monitoring" \
            "Password Audit" "Launch hashcat/john" \
            "Web Scanner" "Start Nikto/ZAP" \
            "Metasploit" "Open msfconsole" \
            "Recon Tools" "Launch recon-ng" \
            "OSINT" "Start SpiderFoot" \
            "Forensics" "Open Autopsy" \
            "Update Tools" "Update all tools" \
            "System Info" "Show system status" \
            "Wordlists" "Open wordlist folder" \
            "Tools Folder" "Open /opt/tools" \
            "Documents" "Open docs folder" \
            "Terminal" "Open terminal" \
            "Exit" "Exit tray app" \
            --height=500 \
            --width=400 \
            2>/dev/null)

        case "$choice" in
            "Network Scan")
                xterm -title "Network Scanner" -e "sudo nmap -sn 192.168.1.0/24" &
                ;;
            "WiFi Monitor")
                xterm -title "WiFi Monitor" -e "sudo airmon-ng start wlan0" &
                ;;
            "Password Audit")
                xterm -title "Password Cracking" -e "sudo hashcat --help | head -20" &
                ;;
            "Web Scanner")
                xterm -title "Web Scanner" -e "sudo nikto -h localhost" &
                ;;
            "Metasploit")
                xterm -title "Metasploit" -e "sudo msfconsole -q" &
                ;;
            "Recon Tools")
                xterm -title "Recon-ng" -e "sudo recon-ng" &
                ;;
            "OSINT")
                xterm -title "SpiderFoot" -e "sudo spiderfoot -l 127.0.0.1:5001" &
                ;;
            "Forensics")
                xterm -title "Autopsy" -e "sudo autopsy" &
                ;;
            "Update Tools")
                xterm -title "Update Tools" -e "sudo apt-get update && sudo apt-get upgrade -y" &
                ;;
            "System Info")
                notify-send "System Info" "$(uptime && free -h && df -h /)" &
                ;;
            "Wordlists")
                xdg-open /usr/share/wordlists 2>/dev/null || \
                xterm -e "ls /usr/share/wordlists" &
                ;;
            "Tools Folder")
                xdg-open /opt/tools 2>/dev/null || \
                xterm -e "ls /opt/tools" &
                ;;
            "Documents")
                xdg-open /opt/docs 2>/dev/null || \
                xterm -e "ls /opt/docs" &
                ;;
            "Terminal")
                xterm &
                ;;
            "Exit"|"")
                break
                ;;
        esac
    done
}

# Start as background daemon
daemon_start() {
    log "Starting Kali Tray..."
    
    # Check if already running
    if [[ -f "$PID_FILE" ]]; then
        old_pid=$(cat "$PID_FILE")
        if kill -0 "$old_pid" 2>/dev/null; then
            echo "Tray already running (PID: $old_pid)"
            return 0
        fi
    fi
    
    # Start in background
    (
        check_deps
        show_menu
    ) &
    
    echo $! > "$PID_FILE"
    log "Tray started with PID: $(cat $PID_FILE)"
    notify-send "Kali Tray" "System tray started" 2>/dev/null
}

# Stop daemon
daemon_stop() {
    if [[ -f "$PID_FILE" ]]; then
        pid=$(cat "$PID_FILE")
        kill "$pid" 2>/dev/null
        rm -f "$PID_FILE"
        log "Tray stopped"
        notify-send "Kali Tray" "System tray stopped" 2>/dev/null
    fi
}

# Show status
daemon_status() {
    if [[ -f "$PID_FILE" ]]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Tray is running (PID: $pid)"
        else
            echo "Tray not running (stale PID file)"
        fi
    else
        echo "Tray not running"
    fi
}

# Handle arguments
case "${1:-start}" in
    start)
        daemon_start
        ;;
    stop)
        daemon_stop
        ;;
    restart)
        daemon_stop
        sleep 1
        daemon_start
        ;;
    status)
        daemon_status
        ;;
    menu)
        show_menu
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|menu}"
        exit 1
        ;;
esac
TRAYEOF

chmod +x "$TRAY_DIR/kali-tray.sh"

# ============================================
# CREATE DESKTOP AUTOSTART ENTRY
# ============================================

log_info "Creating autostart desktop entry..."

cat > "$DESKTOP_FILE" << 'DESKTOPEOF'
[Desktop Entry]
Type=Application
Name=Kali System Tray
Comment=Auto-start Kali security tools
Icon=kali-menu
Exec=/opt/kali-tray/kali-tray.sh start
Terminal=false
X-GNOME-Autostart-enabled=true
Hidden=false
DESKTOPEOF

# ============================================
# CREATE SYSTEMD SERVICE (OPTIONAL)
# ============================================

log_info "Creating systemd service..."

cat > "$SYSTEMD_SERVICE" << 'SYSTEMDEOF'
[Unit]
Description=Kali System Tray
After=graphical.target

[Service]
Type=simple
ExecStart=/opt/kali-tray/kali-tray.sh start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=graphical.target
SYSTEMDEOF

# ============================================
# CREATE CONVENIENCE SYMLINKS
# ============================================

log_info "Creating convenience links..."

ln -sf "$TRAY_DIR/kali-tray.sh" /usr/local/bin/kali-tray
ln -sf "$TRAY_DIR/kali-tray.sh" /usr/local/bin/kt

# ============================================
# CREATE TRAY ICON (FALLBACK)
# ============================================

log_info "Creating tray icon..."

mkdir -p /usr/share/icons/hicolor/48x48/apps

if [[ ! -f "$TRAY_ICON" ]]; then
    # Create simple icon
    cat > /tmp/kali-icon.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48">
  <rect width="48" height="48" fill="#367bf5"/>
  <text x="24" y="30" font-family="monospace" font-size="20" fill="white" text-anchor="middle">K</text>
</svg>
SVGEOF
    # Convert to png if possible, otherwise use as-is
    if command -v convert >/dev/null 2>&1; then
        convert /tmp/kali-icon.svg /usr/share/icons/hicolor/48x48/apps/kali-menu.png 2>/dev/null || true
    fi
fi

# ============================================
# ENABLE SERVICE
# ============================================

log_info "Enabling autostart..."

systemctl daemon-reload 2>/dev/null || true
systemctl enable kali-tray.service 2>/dev/null || true

# Make desktop entry executable
chmod +x "$DESKTOP_FILE"

# ============================================
# SUMMARY
# ============================================

echo ""
echo "=========================================="
log_success "SYSTEM TRAY INSTALLED!"
echo "=========================================="
echo ""
echo "Installation completed:"
echo "  - Tray app: $TRAY_DIR/kali-tray.sh"
echo "  - Autostart: $DESKTOP_FILE"
echo "  - Service: $SYSTEMD_SERVICE"
echo "  - Commands: kali-tray, kt"
echo ""
echo "Commands:"
echo "  kali-tray start    # Start tray"
echo "  kali-tray stop     # Stop tray"
echo "  kali-tray restart  # Restart tray"
echo "  kali-tray status  # Show status"
echo "  kali-tray menu    # Show menu"
echo ""
echo "The tray will auto-start on next login."
echo ""

# Start now if requested
if [[ "${1:-}" == "--start-now" ]] || [[ "${2:-}" == "--start-now" ]]; then
    log_info "Starting tray now..."
    "$TRAY_DIR/kali-tray.sh" start
fi