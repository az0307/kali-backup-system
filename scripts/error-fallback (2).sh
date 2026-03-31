#!/bin/bash
# error-fallback.sh - Universal error handler for all scripts
# Auto-include in all scripts

ERROR_LOG="$HOME/kalishare-errors.log"

log_error() {
    echo "[ERROR] $(date +%Y%m%d-%H%M%S) - $1" | tee -a "$ERROR_LOG"
}

check_deps() {
    local deps=("$@")
    local missing=()
    
    for tool in "${deps[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing+=("$tool")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        echo "Missing: ${missing[*]}"
        echo "Install with: apt install ${missing[*]}"
        return 1
    fi
    return 0
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "Requires root privileges"
        echo "Run with sudo"
        return 1
    fi
    return 0
}

check_internet() {
    if ! ping -c 1 -W 3 8.8.8.8 &> /dev/null; then
        if ! ping -c 1 -W 3 1.1.1.1 &> /dev/null; then
            log_error "No internet connection"
            return 1
        fi
    fi
    return 0
}

fallback_nmap() {
    local target=$1
    echo "[FALLBACK] Using alternative port scanners..."
    
    if command -v rustscan &> /dev/null; then
        rustscan -a "$target" --ulimit 5000 2>/dev/null
    elif command -v nmap &> /dev/null; then
        nmap -sV -p- "$target"
    elif command -v nc &> /dev/null; then
        for port in 22 80 443 445 3389 8080; do
            nc -zv -w 3 "$target" "$port" 2>&1 | grep succeeded
        done
    else
        echo "No port scanner available"
        return 1
    fi
}

fallback_web() {
    local target=$1
    echo "[FALLBACK] Using alternative web fuzzers..."
    
    if command -v dirb &> /dev/null; then
        dirb "http://$target" /usr/share/wordlists/dirb/common.txt
    elif command -v curl &> /dev/null; then
        echo "Checking common paths..."
        for path in /admin /login /backup /wp-admin /phpmyadmin; do
            curl -s -o /dev/null -w "%{http_code} $path\n" "http://$target$path"
        done
    else
        echo "No web scanner available"
        return 1
    fi
}

fallback_password() {
    local hashfile=$1
    echo "[FALLBACK] Using alternative password tools..."
    
    if command -v hashcat &> /dev/null; then
        hashcat -m 0 "$hashfile" /usr/share/wordlists/rockyou.txt
    elif command -v john &> /dev/null; then
        john --wordlist=/usr/share/wordlists/rockyou.txt "$hashfile"
    elif command -v unshadow &> /dev/null; then
        unshadow /etc/passwd /etc/shadow > combined.txt
        john combined.txt
    else
        echo "No password tool available"
        return 1
    fi
}

fallback_wifi() {
    echo "[FALLBACK] Using alternative WiFi tools..."
    
    if command -v wifite &> /dev/null; then
        wifite -i wlan0
    elif command -v airodump-ng &> /dev/null; then
        echo "Manual mode: airodump-ng wlan0"
    elif command -v nmcli &> /dev/null; then
        nmcli device wifi list
    else
        echo "No WiFi tool available"
        return 1
    fi
}

fallback_exploit() {
    local target=$1
    echo "[FALLBACK] Using alternative exploitation..."
    
    if command -v searchsploit &> /dev/null; then
        echo "Searchsploit available - search for vulnerabilities manually"
    elif command -v msfconsole &> /dev/null; then
        echo "Metasploit available"
    else
        echo "No exploitation framework"
        return 1
    fi
}

timeout_wrapper() {
    local secs=$1
    shift
    timeout "$secs" "$@" 2>/dev/null || {
        log_error "Command timed out after ${secs}s: $*"
        return 1
    }
}

retry_wrapper() {
    local attempts=${2:-3}
    local cmd=$1
    local i=1
    
    while [ $i -le $attempts ]; do
        if eval "$cmd"; then
            return 0
        fi
        echo "Attempt $i/$attempts failed, retrying..."
        sleep 2
        ((i++))
    done
    log_error "Failed after $attempts attempts: $cmd"
    return 1
}

export -f log_error check_deps check_root check_internet
export -f fallback_nmap fallback_web fallback_password fallback_wifi
export -f fallback_exploit timeout_wrapper retry_wrapper