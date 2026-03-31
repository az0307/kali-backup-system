#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/security-stack"

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed"
        exit 1
    fi
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo "[ERROR] Docker Compose is not installed"
        exit 1
    fi
    echo "[OK] Docker and Docker Compose are available"
}

create_directories() {
    mkdir -p "$PROJECT_DIR"/{wazuh/{data,config},thehive/{data,conf},cortex/data,shuffle/data,certs,logs}
    echo "[OK] Created directory structure"
}

create_env_file() {
    cat > "$PROJECT_DIR/.env" << 'EOF'
# Security Stack Configuration
# ================================

# Wazuh
WAZUH_VERSION=4.9.1
ELASTIC_VERSION=8.11.4
WAZUH_INDEXER_PASSWORD=change_this_password_in_production
WAZUH_DASHBOARD_PASSWORD=change_this_password_in_production
WAZUH_API_PASSWORD=change_this_password_in_production

# TheHive
THEHIVE_VERSION=5.3.1
THEHIVE_SECRET_KEY=change_this_secret_key_in_production
THEHIVE_ADMIN_PASSWORD=change_this_password_in_production
CORTEX_URL=http://cortex:9001

# Cortex
CORTEX_VERSION=3.1.0
CORTEX_ADMIN_API_KEY=change_this_api_key_in_production
CORTEX_DB_PASSWORD=change_this_password_in_production

# Shuffle
SHUFFLE_VERSION=latest
SHUFFLE_ADMIN_PASSWORD=change_this_password_in_production

# Network
NETWORK_MODE=bridge
WAZUH_PORT=5601
THEHIVE_PORT=9000
CORTEX_PORT=9001
SHUFFLE_PORT=3000
EOF
    echo "[OK] Created .env file"
}

create_docker_compose() {
    cat > "$PROJECT_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  # ============================
  # Wazuh SIEM
  # ============================
  wazuh-indexer:
    image: wazuh/wazuh-indexer:${WAZUH_VERSION}
    container_name: wazuh-indexer
    restart: unless-stopped
    environment:
      - cluster.name=wazuh-cluster
      - node.name=wazuh-indexer
      - discovery.type=single-node
      - ELASTIC_PASSWORD=${WAZUH_INDEXER_PASSWORD}
      - "OPENSEARCH_JAVA_OPTS=-Xms1g -Xmx1g"
    volumes:
      - wazuh-indexer-data:/usr/share/wazuh-indexer/data
      - wazuh-indexer-config:/usr/share/wazuh-indexer/config
    ports:
      - "9200:9200"
      - "9600:9600"
    networks:
      - security-network
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536

  wazuh-manager:
    image: wazuh/wazuh-manager:${WAZUH_VERSION}
    container_name: wazuh-manager
    restart: unless-stopped
    environment:
      - INDEXER_URL=https://wazuh-indexer:9200
      - WAZUH_API_PASSWORD=${WAZUH_API_PASSWORD}
      - ELASTIC_PASSWORD=${WAZUH_INDEXER_PASSWORD}
    volumes:
      - wazuh-manager-data:/var/lib/wazuh-server
      - wazuh-manager-rules:/var/ossec/etc/rules
      - wazuh-manager-conf:/var/ossec/etc
    ports:
      - "1514:1514/udp"
      - "1515:1515"
      - "514:514/udp"
    networks:
      - security-network

  wazuh-dashboard:
    image: wazuh/wazuh-dashboard:${WAZUH_VERSION}
    container_name: wazuh-dashboard
    restart: unless-stopped
    environment:
      - WAZUH_API_URL=https://wazuh-manager
      - WAZUH_USERNAME=admin
      - WAZUH_PASSWORD=${WAZUH_DASHBOARD_PASSWORD}
      - ELASTIC_PASSWORD=${WAZUH_INDEXER_PASSWORD}
      - OPENSEARCH_SSL_VERIFICATIONMODE=certificate
    volumes:
      - wazuh-dashboard-data:/usr/share/wazuh-dashboard/data
    ports:
      - "${WAZUH_PORT}:5601"
    networks:
      - security-network
    depends_on:
      - wazuh-indexer
      - wazuh-manager

  # ============================
  # TheHive (Incident Response)
  # ============================
  thehive:
    image: thehiveproject/thehive:${THEHIVE_VERSION}
    container_name: thehive
    restart: unless-stopped
    environment:
      - SECRET_KEY=${THEHIVE_SECRET_KEY}
      - THEHIVE_ADMIN_PASSWORD=${THEHIVE_ADMIN_PASSWORD}
      - CORTEX_URL=${CORTEX_URL}
      - THEHIVE_PORT=9000
    volumes:
      - thehive-data:/var/lib/thehive
      - thehive-conf:/etc/thehive
      - ./thehive/application.conf:/etc/thehive/application.conf:ro
    ports:
      - "${THEHIVE_PORT}:9000"
    networks:
      - security-network
    depends_on:
      - cortex

  # ============================
  # Cortex (Threat Intelligence)
  # ============================
  cortex:
    image: thehiveproject/cortex:${CORTEX_VERSION}
    container_name: cortex
    restart: unless-stopped
    environment:
      - CORTEX_ADMIN_API_KEY=${CORTEX_ADMIN_API_KEY}
      - CORTEX_PORT=9001
    volumes:
      - cortex-data:/var/lib/cortex
      - cortex-conf:/etc/cortex
    ports:
      - "${CORTEX_PORT}:9001"
    networks:
      - security-network

  # ============================
  # Shuffle (SOAR)
  # ============================
  shuffle:
    image: shuffler/shuffle-shared:${SHUFFLE_VERSION}
    container_name: shuffle
    restart: unless-stopped
    environment:
      - ADMIN_PASSWORD=${SHUFFLE_ADMIN_PASSWORD}
      - SHUFFLE_SHUFFLER_DB_HOST=postgres
      - SHUFFLE_SHUFFLER_DB=shuffle
      - SHUFFLE_SHUFFLER_DB_USER=shuffle
      - SHUFFLE_SHUFFLER_DB_PASSWORD=shuffle_db_password
      - SHUFFLE_DOCKER_NETWORK=security-network
    volumes:
      - shuffle-data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "${SHUFFLE_PORT}:3000"
    networks:
      - security-network
    depends_on:
      - postgres

  postgres:
    image: postgres:15-alpine
    container_name: shuffle-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=shuffle
      - POSTGRES_USER=shuffle
      - POSTGRES_PASSWORD=shuffle_db_password
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - security-network

volumes:
  wazuh-indexer-data:
  wazuh-indexer-config:
  wazuh-manager-data:
  wazuh-manager-rules:
  wazuh-manager-conf:
  wazuh-dashboard-data:
  thehive-data:
  thehive-conf:
  cortex-data:
  cortex-conf:
  shuffle-data:
  postgres-data:

networks:
  security-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
EOF
    echo "[OK] Created docker-compose.yml"
}

create_thehive_config() {
    cat > "$PROJECT_DIR/thehive/application.conf" << 'EOF'
# TheHive Configuration
include "application.conf"

play.http.router = prod.Routes
play.server.http.port = 9000

db {
  default {
    driver = org.postgresql.Driver
    url = "jdbc:postgresql://postgres:5432/thehive"
    username = "thehive"
    password = "thehive_db_password"
    maxConnections = 20
    minThreads = 1
  }
}

search {
  default {
    backend = elasticsearch
    host = "wazuh-indexer"
    port = 9200
    index = "thehive"
  }
}

cortex {
  {
    url = "http://cortex:9001"
  }
}

secret {
  key = "${THEHIVE_SECRET_KEY}"
}

auth {
  method = password
}
EOF
    echo "[OK] Created TheHive config"
}

create_startup_script() {
    cat > "$PROJECT_DIR/start-security-stack.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Security Stack..."
cd "$SCRIPT_DIR"

# Check if docker-compose plugin is available
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

$DOCKER_COMPOSE up -d

echo ""
echo "========================================="
echo "Security Stack Started!"
echo "========================================="
echo "Wazuh Dashboard:    http://localhost:5601"
echo "TheHive:            http://localhost:9000"
echo "Cortex:             http://localhost:9001"
echo "Shuffle SOAR:       http://localhost:3000"
echo ""
echo "IMPORTANT: Change all passwords in .env"
echo ""
echo "Useful commands:"
echo "  cd $SCRIPT_DIR"
echo "  docker-compose logs -f [service]"
echo "  docker-compose restart [service]"
echo "  docker-compose stop"
echo "========================================="
EOF
    chmod +x "$PROJECT_DIR/start-security-stack.sh"
    echo "[OK] Created startup script"
}

create_management_scripts() {
    # Health check script
    cat > "$PROJECT_DIR/health-check.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Checking Security Stack health..."
echo ""

check_service() {
    local service=$1
    local url=$2
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200\|301\|302"; then
        echo "[OK] $service is running"
    else
        echo "[WARN] $service may not be ready"
    fi
}

check_service "Wazuh Dashboard" "http://localhost:5601"
check_service "TheHive" "http://localhost:9000"
check_service "Cortex" "http://localhost:9001"
check_service "Shuffle" "http://localhost:3000"

echo ""
echo "Checking Docker containers..."
cd "$SCRIPT_DIR"
docker-compose ps
EOF
    chmod +x "$PROJECT_DIR/health-check.sh"

    # Stop script
    cat > "$PROJECT_DIR/stop-security-stack.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping Security Stack..."
cd "$SCRIPT_DIR"
docker-compose down

echo "Security Stack stopped!"
EOF
    chmod +x "$PROJECT_DIR/stop-security-stack.sh"

    # Update script
    cat > "$PROJECT_DIR/update-security-stack.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating Security Stack..."
cd "$SCRIPT_DIR"

# Pull latest images
docker-compose pull

# Restart services
docker-compose up -d

echo "Update complete!"
EOF
    chmod +x "$PROJECT_DIR/update-security-stack.sh"

    echo "[OK] Created management scripts"
}

install_security_stack() {
    echo "Installing Security Stack..."
    cd "$PROJECT_DIR"
    
    # Pull images
    docker-compose pull
    
    # Start services
    docker-compose up -d
    
    echo ""
    echo "========================================="
    echo "Security Stack installation complete!"
    echo "========================================="
    echo "Wazuh Dashboard: http://localhost:5601"
    echo "TheHive:         http://localhost:9000"
    echo "Cortex:          http://localhost:9001"
    echo "Shuffle:         http://localhost:3000"
    echo ""
    echo "IMPORTANT:"
    echo "1. Change all passwords in .env"
    echo "2. Configure TheHive with admin user"
    echo "3. Add Cortex analyzers in TheHive"
    echo ""
    echo "Useful commands:"
    echo "  cd $PROJECT_DIR"
    echo "  ./health-check.sh"
    echo "  ./update-security-stack.sh"
    echo "========================================="
}

main() {
    echo "=== Security Stack Installation Script ==="
    check_docker
    create_directories
    create_env_file
    create_docker_compose
    create_thehive_config
    create_startup_script
    create_management_scripts
    install_security_stack
}

main "$@"
