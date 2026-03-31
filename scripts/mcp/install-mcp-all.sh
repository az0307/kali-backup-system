#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
MAIN_LOG="${LOG_DIR}/install-mcp-all.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

mkdir -p "$LOG_DIR"

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$MAIN_LOG"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$MAIN_LOG"
}

error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$MAIN_LOG"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a "$MAIN_LOG"
}

info() {
    echo -e "${CYAN}[i]${NC} $1" | tee -a "$MAIN_LOG"
}

header() {
    echo
    echo -e "${MAGENTA}==============================================${NC}"
    echo -e "${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}==============================================${NC}"
    echo
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

run_script() {
    local script_name="$1"
    local script_path="$SCRIPT_DIR/$script_name"
    
    if [ ! -f "$script_path" ]; then
        error "Script not found: $script_path"
        return 1
    fi
    
    if [ ! -x "$script_path" ]; then
        chmod +x "$script_path"
    fi
    
    log "Running $script_name..."
    
    if "$script_path" 2>&1 | tee -a "$MAIN_LOG"; then
        success "$script_name completed successfully"
        return 0
    else
        error "$script_name failed"
        return 1
    fi
}

run_in_background() {
    local script_name="$1"
    local script_path="$SCRIPT_DIR/$script_name"
    local log_file="${LOG_DIR}/${script_name%.sh}.log"
    
    if [ ! -f "$script_path" ]; then
        error "Script not found: $script_path"
        return 1
    fi
    
    if [ ! -x "$script_path" ]; then
        chmod +x "$script_path"
    fi
    
    log "Starting $script_name in background..."
    nohup "$script_path" > "$log_file" 2>&1 &
    local pid=$!
    echo $pid > "${LOG_DIR}/${script_name%.sh}.pid"
    
    success "$script_name started (PID: $pid)"
    return 0
}

install_kali() {
    header "Installing MCP-Kali-Server"
    run_script "install-mcp-kali.sh"
}

install_security_hub() {
    header "Installing MCP Security Hub"
    run_script "install-mcp-security-hub.sh"
}

install_metasploit() {
    header "Installing MetasploitMCP"
    run_script "install-mcp-metasploit.sh"
}

install_redteam() {
    header "Installing Red Team MCPs"
    run_script "install-mcp-redteam.sh"
}

install_bluteam() {
    header "Installing Blue Team MCPs"
    run_script "install-mcp-bluteam.sh"
}

install_re() {
    header "Installing Reverse Engineering MCPs"
    run_script "install-mcp-re.sh"
}

install_mobile() {
    header "Installing Mobile Security MCPs"
    run_script "install-mcp-mobile.sh"
}

show_main_summary() {
    echo
    echo -e "${MAGENTA}==============================================${NC}"
    echo -e "${MAGENTA}  All MCP Servers Installation Complete!${NC}"
    echo -e "${MAGENTA}==============================================${NC}"
    echo
    echo "All installation logs: $LOG_DIR"
    echo "Main log: $MAIN_LOG"
    echo
    echo -e "${GREEN}Installed MCP Servers:${NC}"
    echo "  1. MCP-Kali-Server (Wh0am123/MCP-Kali-Server)"
    echo "  2. MCP Security Hub (FuzzingLabs/mcp-security-hub) - 38+ tools!"
    echo "  3. MetasploitMCP (GH05TCREW/MetasploitMCP)"
    echo "  4. Red Team MCPs"
    echo "     - sec-sliver-c2-mcp"
    echo "     - sec-havoc-c2-mcp"
    echo "     - shodan-mcp"
    echo "     - masscan-mcp"
    echo "  5. Blue Team MCPs"
    echo "     - Sentinel-MCP"
    echo "     - Splunk-MCP"
    echo "     - Elastic-MCP"
    echo "     - VirusTotal-MCP"
    echo "     - CrowdStrike-Falcon-MCP"
    echo "     - Wazuh-MCP"
    echo "     - TheHive-MCP"
    echo "  6. Reverse Engineering MCPs"
    echo "     - GhidraMCP (lauriewired/ghidramcp)"
    echo "     - ida-mcp-rs"
    echo "  7. Mobile Security MCPs"
    echo "     - android-mcp-server"
    echo "     - apktool-mcp-server"
    echo
    echo -e "${YELLOW}Configuration:${NC}"
    echo "  OpenCode config: $HOME/.config/opencode/mcp-servers.json"
    echo
    echo -e "${CYAN}Usage:${NC}"
    echo "  Each MCP can be started individually from:"
    echo "    $SCRIPT_DIR/<script-name>.sh"
    echo
    echo "  Or all at once (already done):"
    echo "    $SCRIPT_DIR/install-mcp-all.sh"
    echo
}

show_help() {
    cat << EOF
MCP Server Installation Master Script

Usage: $0 [OPTIONS]

OPTIONS:
    --all           Install all MCP servers (default)
    --kali          Install MCP-Kali-Server only
    --security-hub Install MCP Security Hub only
    --metasploit   Install MetasploitMCP only
    --redteam      Install Red Team MCPs only
    --bluteam      Install Blue Team MCPs only
    --re           Install Reverse Engineering MCPs only
    --mobile       Install Mobile Security MCPs only
    --parallel     Install all in parallel (faster)
    --sequential   Install all sequentially (safer)
    --help         Show this help message

EXAMPLES:
    $0 --all                    Install everything
    $0 --redteam --bluteam      Install red and blue team MCPs
    $0 --parallel               Install all in parallel

EOF
}

main() {
    log "Starting MCP servers installation..."
    
    check_root
    
    local install_all=true
    local parallel=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)
                install_all=true
                ;;
            --kali)
                install_all=false
                install_kali
                ;;
            --security-hub)
                install_all=false
                install_security_hub
                ;;
            --metasploit)
                install_all=false
                install_metasploit
                ;;
            --redteam)
                install_all=false
                install_redteam
                ;;
            --bluteam)
                install_all=false
                install_bluteam
                ;;
            --re)
                install_all=false
                install_re
                ;;
            --mobile)
                install_all=false
                install_mobile
                ;;
            --parallel)
                parallel=true
                ;;
            --sequential)
                parallel=false
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
    
    if [ "$install_all" = true ]; then
        if [ "$parallel" = true ]; then
            header "Installing All MCP Servers (Parallel)"
            run_in_background "install-mcp-kali.sh"
            run_in_background "install-mcp-security-hub.sh"
            run_in_background "install-mcp-metasploit.sh"
            run_in_background "install-mcp-redteam.sh"
            run_in_background "install-mcp-bluteam.sh"
            run_in_background "install-mcp-re.sh"
            run_in_background "install-mcp-mobile.sh"
            
            info "Waiting for all installations to complete..."
            sleep 5
            
            for pid_file in "$LOG_DIR"/*.pid; do
                if [ -f "$pid_file" ]; then
                    pid=$(cat "$pid_file")
                    if ps -p "$pid" > /dev/null 2>&1; then
                        wait "$pid" || true
                    fi
                fi
            done
            
            success "All MCP servers installed in parallel"
        else
            header "Installing All MCP Servers (Sequential)"
            install_kali
            install_security_hub
            install_metasploit
            install_redteam
            install_bluteam
            install_re
            install_mobile
        fi
    fi
    
    show_main_summary
    
    success "All MCP servers installation completed!"
}

main "$@"
