#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/portainer"

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed"
        exit 1
    fi
    echo "[OK] Docker is available"
}

create_directories() {
    mkdir -p "$PROJECT_DIR/{data,agent-data,certs}"
    echo "[OK] Created directory structure"
}

create_env_file() {
    cat > "$PROJECT_DIR/.env" << 'EOF'
# Portainer Configuration
PORTAINER_VERSION=2.21.4
AGENT_VERSION=2.21.1

# Admin Credentials
ADMIN_PASSWORD=change_this_password_in_production

# SSL Configuration
SSL=true
HTTP_PORT=9000
HTTPS_PORT=9443
HTTP_BIND_PORT=9000
HTTPS_BIND_PORT=9443
EOF
    echo "[OK] Created .env file"
}

create_agent_compose() {
    cat > "$PROJECT_DIR/docker-compose.agent.yml" << 'EOF'
version: '3.8'

services:
  agent:
    image: portainer/agent:${AGENT_VERSION}
    container_name: portainer-agent
    restart: unless-stopped
    environment:
      AGENT_SECRET: change_this_secret_in_production
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      - ./agent-data:/data
    ports:
      - "9001:9001"
    networks:
      - portainer-agent-network
    mode: global

networks:
  portainer-agent-network:
    driver: bridge
EOF
    echo "[OK] Created agent docker-compose"
}

create_docker_compose() {
    cat > "$PROJECT_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  portainer:
    image: portainer/portainer-ce:${PORTAINER_VERSION}
    container_name: portainer
    restart: unless-stopped
    command: --http-enabled --http-bind-port=${HTTP_BIND_PORT} --https-bind-port=${HTTPS_BIND_PORT}
    ports:
      - "${HTTP_PORT}:9000"
      - "${HTTPS_PORT}:9443"
      - "9001:9001"
    environment:
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
    volumes:
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock
      - ./certs:/certs
    networks:
      - portainer-network
    depends_on:
      - agent

  agent:
    image: portainer/agent:${AGENT_VERSION}
    container_name: portainer-agent-edge
    restart: unless-stopped
    environment:
      AGENT_SECRET: change_this_secret_in_production
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      - ./agent-data:/data
    networks:
      - portainer-network
    deploy:
      mode: global

networks:
  portainer-network:
    driver: bridge
EOF
    echo "[OK] Created main docker-compose.yml"
}

create_startup_script() {
    cat > "$PROJECT_DIR/start-portainer.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Portainer..."
cd "$SCRIPT_DIR"
docker-compose up -d

echo ""
echo "========================================="
echo "Portainer started!"
echo "========================================="
echo "Web UI: https://localhost:9443"
echo "Agent:  localhost:9001"
echo ""
echo "Useful commands:"
echo "  cd $SCRIPT_DIR"
echo "  docker-compose logs -f"
echo "  docker-compose restart"
echo "  docker-compose down"
echo "========================================="
EOF
    chmod +x "$PROJECT_DIR/start-portainer.sh"
    echo "[OK] Created startup script"
}

create_management_scripts() {
    # Backup script
    cat > "$PROJECT_DIR/backup.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "Backing up Portainer data..."
cd "$SCRIPT_DIR"

# Stop Portainer
docker-compose stop

# Backup data directory
tar -czf "$BACKUP_DIR/portainer-data-$TIMESTAMP.tar.gz" data/

# Start Portainer
docker-compose start

echo "Backup complete: $BACKUP_DIR/portainer-data-$TIMESTAMP.tar.gz"
EOF
    chmod +x "$PROJECT_DIR/backup.sh"

    # Restore script
    cat > "$PROJECT_DIR/restore.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup-file.tar.gz>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Restoring Portainer from backup..."
cd "$SCRIPT_DIR"

# Stop Portainer
docker-compose stop

# Clear existing data
rm -rf data/*

# Restore backup
tar -xzf "$BACKUP_FILE" -C .

# Start Portainer
docker-compose start

echo "Restore complete!"
EOF
    chmod +x "$PROJECT_DIR/restore.sh"

    # Update script
    cat > "$PROJECT_DIR/update.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating Portainer..."
cd "$SCRIPT_DIR"

# Pull latest images
docker-compose pull

# Restart services
docker-compose up -d

echo "Update complete!"
EOF
    chmod +x "$PROJECT_DIR/update.sh"

    echo "[OK] Created management scripts"
}

install_portainer() {
    echo "Installing Portainer..."
    cd "$PROJECT_DIR"
    
    # Pull images
    docker-compose pull
    
    # Start services
    docker-compose up -d
    
    echo ""
    echo "========================================="
    echo "Portainer installation complete!"
    echo "========================================="
    echo "Access: https://localhost:9443"
    echo ""
    echo "IMPORTANT:"
    echo "1. Change ADMIN_PASSWORD in .env"
    echo "2. Change AGENT_SECRET in docker-compose.yml"
    echo "3. For remote hosts, use the agent compose file"
    echo ""
    echo "Useful commands:"
    echo "  cd $PROJECT_DIR"
    echo "  docker-compose logs -f"
    echo "  ./backup.sh"
    echo "  ./update.sh"
    echo "========================================="
}

main() {
    echo "=== Portainer Installation Script ==="
    check_docker
    create_directories
    create_env_file
    create_docker_compose
    create_agent_compose
    create_startup_script
    create_management_scripts
    install_portainer
}

main "$@"
