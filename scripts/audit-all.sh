# Comprehensive Audit Script
# Usage: ./audit-all.sh [quick|full|tools|network|security]

set -euo pipefail

MODE=${1:-full}
LOG_DIR="$HOME/kalishare-audit"
mkdir -p "$LOG_DIR"

log() { echo "[$(date +%H:%M:%S)] $*"; }

echo "=== KaliShare Complete Audit ==="
echo "Mode: $MODE | Log: $LOG_DIR"

case $MODE in
    quick)
        log "Quick audit..."
        echo "=== System ===" > "$LOG_DIR/quick-audit.txt"
        echo "User: $(whoami)" >> "$LOG_DIR/quick-audit.txt"
        echo "Uptime: $(uptime)" >> "$LOG_DIR/quick-audit.txt"
        echo "IP: $(hostname -I 2>/dev/null || ip addr show | grep inet | head -1)" >> "$LOG_DIR/quick-audit.txt"
        
        echo "=== Critical Tools ===" >> "$LOG_DIR/quick-audit.txt"
        for tool in nmap msfconsole hashcat aircrack-ng sqlmap nikto; do
            if command -v $tool &>/dev/null; then
                echo "$tool: $(command -v $tool)" >> "$LOG_DIR/quick-audit.txt"
            else
                echo "$tool: MISSING" >> "$LOG_DIR/quick-audit.txt"
            fi
        done
        
        cat "$LOG_DIR/quick-audit.txt"
        ;;

    tools)
        log "Checking all pentest tools..."
        echo "=== Tool Availability ===" > "$LOG_DIR/tools-audit.txt"
        
        declare -a TOOLS=(
            "nmap" "masscan" "rustscan" "netcat" "nc"
            "msfconsole" "msfvenom" "msfdb"
            "hashcat" "john" "hashid"
            "aircrack-ng" "airmon-ng" "airodump-ng" "aireplay-ng" "wifite"
            "sqlmap" "nikto" "gobuster" "dirb" "wpscan"
            "burpsuite" "zaproxy"
            "searchsploit" "msfpc"
            "hydra" "medusa" "crackmapexec" "responder"
            "impacket" "mimikatz" "powerup" "winpeas" "linpeas"
            "metasploit" "covenant" "empire" "sliver"
            "nikto" "wpscan" "droopescan"
            "sublist3r" "amass" "theHarvester" "recon-ng"
            "whatweb" "wappalyzer" "builtwith"
            "curl" "wget" "httpx" "gau"
        )
        
        INSTALLED=0
        MISSING=0
        for tool in "${TOOLS[@]}"; do
            if command -v $tool &>/dev/null; then
                echo "✓ $tool" | tee -a "$LOG_DIR/tools-audit.txt"
                ((INSTALLED++))
            else
                echo "✗ $tool" | tee -a "$LOG_DIR/tools-audit.txt"
                ((MISSING++))
            fi
        done
        
        echo "" | tee -a "$LOG_DIR/tools-audit.txt"
        echo "Installed: $INSTALLED | Missing: $MISSING" | tee -a "$LOG_DIR/tools-audit.txt"
        
        log "Tool audit complete"
        ;;

    network)
        log "Network configuration audit..."
        echo "=== Network Audit ===" > "$LOG_DIR/network-audit.txt"
        
        echo "--- Interfaces ---" >> "$LOG_DIR/network-audit.txt"
        ip addr >> "$LOG_DIR/network-audit.txt" 2>&1 || ifconfig >> "$LOG_DIR/network-audit.txt" 2>&1
        
        echo "--- Routes ---" >> "$LOG_DIR/network-audit.txt"
        ip route >> "$LOG_DIR/network-audit.txt" 2>&1 || route -n >> "$LOG_DIR/network-audit.txt" 2>&1
        
        echo "--- DNS ---" >> "$LOG_DIR/network-audit.txt"
        cat /etc/resolv.conf >> "$LOG_DIR/network-audit.txt" 2>&1
        
        echo "--- WiFi Interfaces ---" >> "$LOG_DIR/network-audit.txt"
        iw dev 2>/dev/null || echo "iw not available" >> "$LOG_DIR/network-audit.txt"
        ip link show | grep -E "wlan|wlp" >> "$LOG_DIR/network-audit.txt" 2>&1
        
        echo "--- Active Connections ---" >> "$LOG_DIR/network-audit.txt"
        netstat -tuln 2>/dev/null | head -20 >> "$LOG_DIR/network-audit.txt" || ss -tuln | head -20 >> "$LOG_DIR/network-audit.txt"
        
        cat "$LOG_DIR/network-audit.txt"
        ;;

    security)
        log "Security configuration audit..."
        echo "=== Security Audit ===" > "$LOG_DIR/security-audit.txt"
        
        echo "--- Sudoers ---" >> "$LOG_DIR/security-audit.txt"
        sudo -l 2>/dev/null >> "$LOG_DIR/security-audit.txt" || echo "Not sudoer or not root" >> "$LOG_DIR/security-audit.txt"
        
        echo "--- SUID Binaries ---" >> "$LOG_DIR/security-audit.txt"
        find / -perm -4000 -type f 2>/dev/null | head -30 >> "$LOG_DIR/security-audit.txt"
        
        echo "--- Listening Services ---" >> "$LOG_DIR/security-audit.txt"
        ss -tulnp 2>/dev/null | grep LISTEN >> "$LOG_DIR/security-audit.txt" || netstat -tulnp 2>/dev/null | grep LISTEN >> "$LOG_DIR/security-audit.txt"
        
        echo "--- Firewall ---" >> "$LOG_DIR/security-audit.txt"
        iptables -L 2>/dev/null | head -20 >> "$LOG_DIR/security-audit.txt" || ufw status 2>/dev/null >> "$LOG_DIR/security-audit.txt"
        
        echo "--- Open Ports ---" >> "$LOG_DIR/security-audit.txt"
        nmap -sT -p- localhost 2>/dev/null | tail -10 >> "$LOG_DIR/security-audit.txt" || echo "nmap not available" >> "$LOG_DIR/security-audit.txt"
        
        cat "$LOG_DIR/security-audit.txt"
        ;;

    full|*)
        log "Running full system audit..."
        
        # System info
        echo "=== System ===" > "$LOG_DIR/full-audit.txt"
        uname -a >> "$LOG_DIR/full-audit.txt"
        cat /etc/os-release | head -5 >> "$LOG_DIR/full-audit.txt"
        
        # Hardware
        echo -e "\n=== Hardware ===" >> "$LOG_DIR/full-audit.txt"
        lspci | grep -i "network\|wireless\|vga" >> "$LOG_DIR/full-audit.txt" 2>&1
        lsusb | head -10 >> "$LOG_DIR/full-audit.txt" 2>&1
        
        # Disk
        echo -e "\n=== Disk ===" >> "$LOG_DIR/full-audit.txt"
        df -h >> "$LOG_DIR/full-audit.txt"
        
        # Memory
        echo -e "\n=== Memory ===" >> "$LOG_DIR/full-audit.txt"
        free -h >> "$LOG_DIR/full-audit.txt"
        
        # Tool check (abbreviated)
        echo -e "\n=== Key Tools ===" >> "$LOG_DIR/full-audit.txt"
        for tool in nmap msfconsole hashcat aircrack-ng sqlmap; do
            echo -n "$tool: " >> "$LOG_DIR/full-audit.txt"
            command -v $tool &>/dev/null && echo "OK" >> "$LOG_DIR/full-audit.txt" || echo "MISSING" >> "$LOG_DIR/full-audit.txt"
        done
        
        # Network
        echo -e "\n=== Network ===" >> "$LOG_DIR/full-audit.txt"
        ip addr | grep inet | head -5 >> "$LOG_DIR/full-audit.txt" 2>&1
        
        echo -e "\n=== WiFi ===" >> "$LOG_DIR/full-audit.txt"
        iw dev 2>/dev/null | grep -A5 "Interface" >> "$LOG_DIR/full-audit.txt" || echo "WiFi not available" >> "$LOG_DIR/full-audit.txt"
        
        # Git status
        echo -e "\n=== Git Status ===" >> "$LOG_DIR/full-audit.txt"
        git status --short 2>/dev/null | head -10 >> "$LOG_DIR/full-audit.txt"
        
        cat "$LOG_DIR/full-audit.txt"
        ;;
esac

log "Audit complete: $LOG_DIR"
echo "Results saved to: $LOG_DIR"