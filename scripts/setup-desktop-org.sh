#!/bin/bash
# ====================================================================
# KALISHARE DESKTOP ORGANIZER
# Quick launcher with icons, categories, and one-click access
# ====================================================================

set -euo pipefail

KALI_SHARE="/root/KaliShare"
DESKTOP_DIR="/root/Desktop"
APPS_DIR="${KALI_SHARE}/desktop-apps"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[*]${NC} $1"; }

mkdir -p "$APPS_DIR" "$DESKTOP_DIR/KaliShare"

create_launcher() {
    local name="$1"
    local script="$2"
    local icon="$3"
    local category="$4"
    
    cat > "${APPS_DIR}/${name}.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Comment=KaliShare - $category
Exec=bash ${KALI_SHARE}/scripts/$script
Icon=$icon
Terminal=true
Categories=Network;Security;
EOF
    
    chmod +x "${APPS_DIR}/${name}.desktop"
    cp "${APPS_DIR}/${name}.desktop" "$DESKTOP_DIR/KaliShare/"
    
    log "Created: $name"
}

setup_desktop() {
    log "Setting up KaliShare Desktop..."
    
    mkdir -p "$DESKTOP_DIR/KaliShare"
    
    # Network Tools
    create_launcher "Network Scan" "tool-widget.sh" "network" "Scanning"
    create_launcher "Quick Nmap" "cli/go quick" "nmap" "Scanning"
    create_launcher "Full Scan" "cli/go full" "nmap" "Scanning"
    create_launcher "Auto Recon" "cli/go auto" "recon" "Scanning"
    
    # WiFi Tools
    create_launcher "WiFi Menu" "cli/go wifi-menu" "wifi" "WiFi"
    create_launcher "WiFi Sweep" "area-sweeper.sh" "wifi" "WiFi"
    create_launcher "Wifite" "wifite" "wifi" "WiFi"
    create_launcher "Aircrack" "aircrack-ng" "wifi" "WiFi"
    
    # Web Tools
    create_launcher "Web Test" "cli/go web" "web" "Web"
    create_launcher "Nikto" "nikto" "web" "Web"
    create_launcher "SQLMap" "sqlmap" "web" "Web"
    
    # Password Tools
    create_launcher "Hashcat" "hashcat" "password" "Password"
    create_launcher "Hydra" "hydra" "password" "Password"
    create_launcher "Crack Wifi" "cli/go crack" "password" "Password"
    
    # Exploitation
    create_launcher "Metasploit" "msfconsole" "exploit" "Exploit"
    create_launcher "Searchsploit" "searchsploit" "exploit" "Exploit"
    create_launcher "Payload Gen" "payload-generator.sh" "exploit" "Exploit"
    
    # AI Tools
    create_launcher "OpenCode" "opencode" "ai" "AI"
    create_launcher "Ollama" "ollama serve" "ai" "AI"
    create_launcher "HexStrike" "hexstrike-install.sh" "ai" "AI"
    
    # Recovery
    create_launcher "Boot Menu" "cli/go boot-menu" "recovery" "Recovery"
    create_launcher "Win Reset" "cli/go win-reset" "recovery" "Recovery"
    
    # Utility
    create_launcher "Tool Widget" "tool-widget.sh" "tool" "Utility"
    create_launcher "Stealth Mode" "stealth-mode.sh" "tool" "Utility"
    create_launcher "Detection Tracker" "detection-tracker.sh" "tool" "Utility"
    create_launcher "Automation Hub" "automation-hub.sh" "tool" "Utility"
    
    log "Desktop launchers created in: $DESKTOP_DIR/KaliShare/"
}

create_kali_bashrc() {
    log "Creating enhanced Kali bashrc with auto-complete..."
    
    cat > /root/.bashrc_kalishare << 'EOF'
# ═══════════════════════════════════════════════════════════════
# KALISHARE ENHANCED BASHRC
# Auto-complete, predictive text, aliases
# ═══════════════════════════════════════════════════════════════

# Auto-complete for go command
_go_complete() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    local commands="pentest full quick web exploit grab drop stealth ai-pentest auto wifi wifi-menu wifyte fluxion wpa deauth crack boot-menu win-reset recovery recon recon-menu ai-install ai-pentest-tools opencode home-lab validate update report status widget essential aliases repos stealth detect payload sweep automate quick-help help"
    
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi
}

complete -F _go_complete go

# Auto-complete for nmap
_nmap_complete() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    local flags="-sn -sV -sT -sU -sC -O -p- -T4 -oA --script vuln --randomize-hosts"
    
    COMPREPLY=( $(compgen -W "${flags}" -- ${cur}) )
}
complete -F _nmap_complete nmap

# Predictive suggestions (show after command)
export KALI_PROMPT="KaliShare"
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# ═══════════════════════════════════════════════════════════════
# ALIASES
# ═══════════════════════════════════════════════════════════════

# Network
alias ns="nmap -sn"
alias nf="nmap -sV -p-"
alias nu="nmap -sU"
alias nc="netcat -nv"
alias mscan="masscan --rate=10000"

# WiFi
alias ws="airodump-ng wlan0mon"
alias wm-start="airmon-ng start wlan0"
alias wm-stop="airmon-ng stop wlan0mon"
alias wf="wifite"

# Web
alias nk="nikto -h"
alias sm="sqlmap -u --batch"
alias gb="gobuster dir -u"

# Password
alias hc="hashcat"
alias jn="john"
alias hyd="hydra"

# Exploit
alias msf="msfconsole -q"
alias ss="searchsploit"

# Quick
alias ll="ls -lah"
alias ..="cd .."
alias ~="cd ~"

# KaliShare
alias go="bash /root/KaliShare/cli/go"
alias ksg="/root/KaliShare/scripts/tool-widget.sh"

# ═══════════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════════

kshelp() {
    echo "═══════════════════════════════════════════════════════"
    echo "  KALISHARE QUICK COMMANDS"
    echo "═══════════════════════════════════════════════════════"
    echo "  go help         - Show all commands"
    echo "  go quick <ip>   - Quick scan"
    echo "  go wifi-menu   - WiFi tools"
    echo "  go widget      - Interactive menu"
    echo "  go essential   - Install tools"
    echo "  go stealth     - Stealth mode"
    echo "  go status      - System status"
    echo ""
    echo "  nk <target>    - Nikto scan"
    echo "  sm <url>       - SQLMap"
    echo "  wf             - Wifite"
    echo "  ws             - WiFi scan"
}

# Auto-suggest (Bash 4+)
bind '"\t": menu-complete'

# Color prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

EOF

    log "Enhanced bashrc created: /root/.bashrc_kalishare"
    echo "source /root/.bashrc_kalishare" >> /root/.bashrc
}

setup_predictive() {
    log "Setting up predictive text..."
    
    # Create command suggestions file
    cat > /etc/profile.d/kalishare-suggestions.sh << 'EOF'
#!/bin/bash
# Command suggestions for KaliShare

KALI_COMMANDS="
go pentest:Run full AI pentest
go quick:Quick network scan
go full:Full port scan
go web:Web application test
go wifi-menu:WiFi tools menu
go widget:Interactive tool launcher
go essential:Install essential tools
go stealth:Enable stealth mode
go detect:Detection tracker
go payload:Generate payloads
go sweep:Area sweeper
go automate:Automation hub
go home-lab:Setup home lab
go status:System status
go validate:Check installed tools
nmap -sn:Discover live hosts
nmap -sV:Version detection
nmap -sC:Default scripts
nmap -O:OS detection
nikto -h:Web vulnerability scan
sqlmap -u:SQL injection
airmon-ng start:Enable monitor mode
airodump-ng:Scan WiFi networks
reaver -i:Attack WPS
hashcat -m:Crack passwords
hydra -L:Brute force login
msfconsole:Metasploit
searchsploit:Find exploits
"

export KALI_COMMANDS
EOF

    chmod +x /etc/profile.d/kalishare-suggestions.sh
    log "Predictive system installed"
}

create_terminal_profiles() {
    log "Creating terminal profiles..."
    
    # Create kali-profile.sh for terminal enhancements
    cat > /usr/local/bin/kali-profile << 'EOF'
#!/bin/bash
# KaliShare Terminal Profile

# Load KaliShare environment
source /root/KaliShare/aliases.sh 2>/dev/null

# Set prompt with color
PS1='\[\033[01;32m\]┌─(\[\033[01;34m\]\u@\h\[\033[01;32m\])─(\[\033[00m\]\T\[\033[01;32m\])\[\033[00m\]\n\[\033[01;32m\]└─>\[\033[0m\] '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'

# KaliShare quick commands
alias ksg='/root/KaliShare/scripts/tool-widget.sh'
alias go='/root/KaliShare/cli/go'

echo -e "\033[1;32mKaliShare Terminal Loaded\033[0m"
echo "Type 'kshelp' for quick reference"
EOF

    chmod +x /usr/local/bin/kali-profile
    log "Terminal profile created"
}

setup_autocomplete() {
    log "Setting up auto-complete for all tools..."
    
    # Nmap completion
    mkdir -p /etc/bash_completion.d
    cat > /etc/bash_completion.d/nmap << 'EOF'
_nmap() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    case "${prev}" in
        -p|--port)
            COMPREPLY=( $(compgen -W "21 22 23 25 53 80 110 139 143 443 445 993 995 3306 3389 5432 8080 8443" -- ${cur}) )
            return 0
            ;;
        -o|--output)
            COMPREPLY=( $(compgen -f -- ${cur}) )
            return 0
            ;;
    esac
    
    COMPREPLY=( $(compgen -W "-iL -oA -oG -oN -oX -sn -sV -sT -sU -sC -O -p- -T1 -T2 -T3 -T4 -T5 --script vuln" -- ${cur}) )
}
complete -F _nmap nmap
EOF

    # Hydra completion
    cat > /etc/bash_completion.d/hydra << 'EOF'
_hydra() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    case "${prev}" in
        -s|--service)
            COMPREPLY=( $(compgen -W "ssh ftp smb http https mysql postgresql rdp vnc telnet" -- ${cur}) )
            return 0
            ;;
    esac
    
    COMPREPLY=( $(compgen -W "-L -P -l -p -t -V -f -o" -- ${cur}) )
}
complete -F _hydra hydra
EOF

    log "Auto-complete configured"
}

create_quick_launcher() {
    log "Creating quick launcher menu..."
    
    cat > /usr/local/bin/ks << 'EOF'
#!/bin/bash
# KaliShare Quick Launcher

case "$1" in
    scan) bash /root/KaliShare/cli/go quick "${@:2}" ;;
    wifi) bash /root/KaliShare/cli/go wifi-menu ;;
    web) bash /root/KaliShare/cli/go web "${@:2}" ;;
    pentest) bash /root/KaliShare/cli/go pentest "${@:2}" ;;
    widget) bash /root/KaliShare/scripts/tool-widget.sh ;;
    stealth) bash /root/KaliShare/scripts/stealth-mode.sh ;;
    sweep) bash /root/KaliShare/scripts/area-sweeper.sh ;;
    payload) bash /root/KaliShare/scripts/payload-generator.sh ;;
    help|--help|-h)
        echo "KaliShare Quick Launcher (ks)"
        echo "  ks scan <ip>     - Quick scan"
        echo "  ks wifi         - WiFi menu"
        echo "  ks web <url>    - Web test"
        echo "  ks pentest <ip>- Pentest"
        echo "  ks widget       - Tool widget"
        echo "  ks stealth      - Stealth mode"
        echo "  ks sweep        - Area sweeper"
        echo "  ks payload      - Gen payloads"
        ;;
    *) bash /root/KaliShare/cli/go "$@"
esac
EOF

    chmod +x /usr/local/bin/ks
    log "Quick launcher created: ks"
}

main() {
    log "Setting up KaliShare Desktop Organization..."
    
    setup_desktop
    create_kali_bashrc
    setup_predictive
    create_terminal_profiles
    setup_autocomplete
    create_quick_launcher
    
    log "Desktop organization complete!"
    log "Desktop icons: $DESKTOP_DIR/KaliShare/"
    log "Quick command: ks"
    log "Terminal: source /root/.bashrc_kalishare"
}

main "$@"