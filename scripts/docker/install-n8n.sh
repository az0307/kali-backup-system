#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/n8n"
ENV_FILE="$PROJECT_DIR/.env"

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
    mkdir -p "$PROJECT_DIR/{postgres-data,workflows,custom-nodes,webhooks,ssl}"
    echo "[OK] Created directory structure"
}

create_env_file() {
    cat > "$ENV_FILE" << 'EOF'
# n8n Configuration
N8N_HOST=n8n.kali.local
N8N_PORT=5678
N8N_PROTOCOL=https

# PostgreSQL Configuration
POSTGRES_DB=n8n
POSTGRES_USER=n8n_user
POSTGRES_PASSWORD=change_this_password_in_production

# Authentication
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=change_this_password_in_production

# Security
N8N_JWT_SECRET=change_this_jwt_secret_in_production
N8N_ENCRYPTION_KEY=change_this_encryption_key_in_production

# Webhooks
WEBHOOK_URL=https://n8n.kali.local
WEBHOOK_TECHNICAL_ERROR_RESPONSE_TYPE=plain

# Customizations
N8N_THEME_TYPE=dark
N8N_THEME_FORCE_DARK_MODE=true

# Execution
EXECUTIONS_MODE=queue
EXECUTIONS_TIMEOUT=300
EXECUTIONS_TIMEOUT_MAX=600

# Optional: Enable audit logging
N8N_AUDIT_ENABLED=true

# Proxy settings (if needed)
# HTTP_PROXY=
# HTTPS_PROXY=
# NO_PROXY=localhost,127.0.0.1

# Advanced
NODE_ENV=production
GENERIC_TIMEZONE=UTC
EOF
    echo "[OK] Created .env file - IMPORTANT: Change all passwords before running!"
}

create_docker_compose() {
    cat > "$PROJECT_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    container_name: n8n-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    networks:
      - n8n-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${N8N_HOST}
      - N8N_PORT=${N8N_PORT}
      - N8N_PROTOCOL=${N8N_PROTOCOL}
      - NODE_ENV=${NODE_ENV}
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
      
      # Database
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      
      # Authentication
      - N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE}
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      - N8N_JWT_SECRET=${N8N_JWT_SECRET}
      
      # Encryption
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      
      # Webhooks
      - WEBHOOK_URL=${WEBHOOK_URL}
      - WEBHOOK_TECHNICAL_ERROR_RESPONSE_TYPE=${WEBHOOK_TECHNICAL_ERROR_RESPONSE_TYPE}
      
      # Executions
      - EXECUTIONS_MODE=${EXECUTIONS_MODE}
      - EXECUTIONS_TIMEOUT=${EXECUTIONS_TIMEOUT}
      - EXECUTIONS_TIMEOUT_MAX=${EXECUTIONS_TIMEOUT_MAX}
      
      # Theme
      - N8N_THEME_TYPE=${N8N_THEME_TYPE}
      - N8N_THEME_FORCE_DARK_MODE=${N8N_THEME_FORCE_DARK_MODE}
    volumes:
      - ./workflows:/home/node/.n8n/workflows
      - ./custom-nodes:/home/node/.n8n/custom
      - ./webhooks:/home/node/.n8n/webhooks
    networks:
      - n8n-network
    depends_on:
      postgres:
        condition: service_healthy

  # nginx reverse proxy with SSL
  nginx:
    image: nginx:alpine
    container_name: n8n-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./ssl:/etc/nginx/ssl:ro
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - n8n-network
    depends_on:
      - n8n

networks:
  n8n-network:
    driver: bridge
EOF
    echo "[OK] Created docker-compose.yml"
}

create_nginx_config() {
    cat > "$PROJECT_DIR/nginx.conf" << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream n8n_backend {
        server n8n:5678;
    }

    server {
        listen 80;
        server_name n8n.kali.local;
        
        # Rate limiting zones
        limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
        limit_req_zone $binary_remote_addr zone=auth_limit:10m rate=5r/s;
        
        location / {
            proxy_pass http://n8n_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            # Security headers
            add_header X-Frame-Options "SAMEORIGIN" always;
            add_header X-Content-Type-Options "nosniff" always;
            add_header X-XSS-Protection "1; mode=block" always;
            add_header Referrer-Policy "no-referrer" always;
            
            # WebSocket support
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_buffering off;
        }
        
        location /webhook/ {
            limit_req zone=api_limit burst=20 nodelay;
            proxy_pass http://n8n_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
        
        location /api/ {
            limit_req zone=api_limit burst=10 nodelay;
            proxy_pass http://n8n_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
    
    # SSL server block (requires certificates)
    server {
        listen 443 ssl http2;
        server_name n8n.kali.local;
        
        # SSL configuration - REPLACE WITH YOUR CERTIFICATES
        ssl_certificate /etc/nginx/ssl/server.crt;
        ssl_certificate_key /etc/nginx/ssl/server.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
        
        # Rate limiting
        limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
        
        location / {
            proxy_pass http://n8n_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            add_header X-Frame-Options "SAMEORIGIN" always;
            add_header X-Content-Type-Options "nosniff" always;
            add_header X-XSS-Protection "1; mode=block" always;
            
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_buffering off;
        }
    }
}
EOF
    echo "[OK] Created nginx.conf"
}

create_example_workflows() {
    mkdir -p "$PROJECT_DIR/example-workflows"
    
    # Pentest recon workflow
    cat > "$PROJECT_DIR/example-workflows/pentest-recon.json" << 'EOF'
{
  "name": "Pentest Reconnaissance",
  "nodes": [
    {
      "parameters": {
        "url": "https://api.shodan.io",
        "method": "GET"
      },
      "name": "Shodan API",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 3,
      "position": [450, 300]
    },
    {
      "parameters": {
        "rule": {
          "error": true,
          "errorMessage": "Shodan API key not configured"
        }
      },
      "name": "Check Config",
      "type": "n8n-nodes-base.error",
      "typeVersion": 1,
      "position": [250, 300]
    }
  ],
  "connections": {
    "Check Config": {
      "main": [[{"node": "Shodan API", "type": "main", "index": 0}]]
    }
  },
  "active": false,
  "settings": {},
  "id": "pentest-recon"
}
EOF

    # Network scanner workflow
    cat > "$PROJECT_DIR/example-workflows/network-scan.json" << 'EOF'
{
  "name": "Network Scanner",
  "nodes": [
    {
      "parameters": {
        "command": "nmap -sn 192.168.1.0/24"
      },
      "name": "Execute Scan",
      "type": "n8n-nodes-base.executeCommand",
      "typeVersion": 1,
      "position": [450, 300]
    }
  ],
  "connections": {},
  "active": false,
  "settings": {},
  "id": "network-scan"
}
EOF

    # Log analysis workflow
    cat > "$PROJECT_DIR/example-workflows/log-analysis.json" << 'EOF'
{
  "name": "Log Analysis",
  "nodes": [
    {
      "parameters": {
        "batchSize": 100
      },
      "name": "Read Logs",
      "type": "n8n-nodes-base.readBinaryFiles",
      "typeVersion": 1,
      "position": [250, 300]
    }
  ],
  "connections": {},
  "active": false,
  "settings": {},
  "id": "log-analysis"
}
EOF
    echo "[OK] Created example workflows"
}

install_n8n() {
    echo "Installing n8n..."
    cd "$PROJECT_DIR"
    
    # Pull images
    docker-compose pull
    
    # Start services
    docker-compose up -d
    
    echo ""
    echo "========================================="
    echo "n8n installation complete!"
    echo "========================================="
    echo "Access: http://localhost:5678"
    echo ""
    echo "IMPORTANT:"
    echo "1. Edit .env and change all passwords"
    echo "2. Generate SSL certificates for HTTPS"
    echo "3. Import workflows from example-workflows/"
    echo ""
    echo "Useful commands:"
    echo "  cd $PROJECT_DIR"
    echo "  docker-compose logs -f n8n"
    echo "  docker-compose restart"
    echo "  docker-compose down"
    echo "========================================="
}

main() {
    echo "=== n8n Installation Script ==="
    check_docker
    create_directories
    create_env_file
    create_docker_compose
    create_nginx_config
    create_example_workflows
    install_n8n
}

main "$@"
