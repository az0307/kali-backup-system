#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed"
        echo "Install Docker first: https://docs.docker.com/get-docker/"
        exit 1
    fi
    echo "[OK] Docker is installed: $(docker --version)"
    echo "[OK] Docker daemon: $(docker info --format '{{.ServerVersion}}')"
}

install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        
        case "$(uname -s)" in
            Linux*)
                curl -fsSL https://get.docker.com | sh
                sudo usermod -aG docker "$USER"
                sudo systemctl enable docker
                sudo systemctl start docker
                ;;
            *)
                echo "[ERROR] Please install Docker manually for your OS"
                exit 1
                ;;
        esac
    fi
}

print_banner() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║           Docker Installation Scripts for Kali           ║
║                    Version 1.0.0                         ║
╚═══════════════════════════════════════════════════════════╝
EOF
}

install_component() {
    local script=$1
    local name=$2
    
    echo ""
    echo "========================================="
    echo "Installing: $name"
    echo "========================================="
    echo ""
    
    if [ -f "$SCRIPT_DIR/$script" ]; then
        chmod +x "$SCRIPT_DIR/$script"
        bash "$SCRIPT_DIR/$script"
    else
        echo "[ERROR] Script not found: $script"
        return 1
    fi
}

print_summary() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║              Installation Complete!                        ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    echo "Installed Components:"
    echo "  ✓ Docker Engine"
    echo "  ✓ Docker Tools (helpers, aliases)"
    echo "  ✓ n8n Automation Platform"
    echo "  ✓ Portainer Management"
    echo "  ✓ Security Stack (Wazuh, TheHive, Cortex, Shuffle)"
    echo ""
    echo "Quick Start:"
    echo "  cd $SCRIPT_DIR"
    echo ""
    echo "  # Start services"
    echo "  cd n8n && docker-compose up -d"
    echo "  cd ../portainer && docker-compose up -d"
    echo "  cd ../security-stack && docker-compose up -d"
    echo ""
    echo "  # Health checks"
    echo "  ./docker-tools/scripts/docker-health.sh"
    echo ""
    echo "Services:"
    echo "  n8n:           http://localhost:5678"
    echo "  Portainer:     https://localhost:9443"
    echo "  Wazuh:         http://localhost:5601"
    echo "  TheHive:       http://localhost:9000"
    echo "  Cortex:        http://localhost:9001"
    echo "  Shuffle:       http://localhost:3000"
    echo ""
    echo "========================================="
}

main() {
    print_banner
    check_docker
    
    echo ""
    echo "Select installation option:"
    echo "  1) Install ALL Docker components"
    echo "  2) Install n8n only"
    echo "  3) Install Portainer only"
    echo "  4) Install Security Stack only"
    echo "  5) Install Docker Tools only"
    echo "  6) Exit"
    echo ""
    echo -n "Enter choice [1-6]: "
    read -r choice
    
    case $choice in
        1)
            echo ""
            echo "Installing ALL components..."
            install_component "install-docker-tools.sh" "Docker Tools"
            install_component "install-n8n.sh" "n8n Automation"
            install_component "install-portainer.sh" "Portainer"
            install_component "install-security-stack.sh" "Security Stack"
            print_summary
            ;;
        2)
            install_component "install-n8n.sh" "n8n Automation"
            ;;
        3)
            install_component "install-portainer.sh" "Portainer"
            ;;
        4)
            install_component "install-security-stack.sh" "Security Stack"
            ;;
        5)
            install_component "install-docker-tools.sh" "Docker Tools"
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "[ERROR] Invalid choice"
            exit 1
            ;;
    esac
}

main "$@"
