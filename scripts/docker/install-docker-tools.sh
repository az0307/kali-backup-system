#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/docker-tools"

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed"
        exit 1
    fi
    echo "[OK] Docker is available"
}

create_directories() {
    mkdir -p "$TOOLS_DIR"/{scripts,config,logs}
    echo "[OK] Created directory structure"
}

install_docker_compose() {
    echo "Installing Docker Compose v2..."
    
    # Check if docker compose plugin exists
    if docker compose version &> /dev/null; then
        echo "[OK] Docker Compose plugin already installed"
        return 0
    fi
    
    # Check if standalone docker-compose exists
    if command -v docker-compose &> /dev/null; then
        echo "[OK] Docker Compose standalone already installed"
        return 0
    fi
    
    # Install Docker Compose v2
    DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
    mkdir -p "$DOCKER_CONFIG/cli-plugins"
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            COMPOSE_ARCH="x86_64"
            ;;
        aarch64|arm64)
            COMPOSE_ARCH="aarch64"
            ;;
        *)
            echo "[ERROR] Unsupported architecture: $ARCH"
            return 1
            ;;
    esac
    
    # Download Docker Compose v2
    echo "Downloading Docker Compose v2..."
    curl -SL "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-${COMPOSE_ARCH}" \
        -o "$DOCKER_CONFIG/cli-plugins/docker-compose"
    chmod +x "$DOCKER_CONFIG/cli-plugins/docker-compose"
    
    echo "[OK] Docker Compose v2 installed"
}

initialize_docker_swarm() {
    echo "Setting up Docker Swarm..."
    
    if docker info &> /dev/null | grep -q "Swarm: active"; then
        echo "[OK] Docker Swarm already initialized"
        return 0
    fi
    
    echo "Initialize Docker Swarm? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        docker swarm init --advertise-addr 127.0.0.1
        echo "[OK] Docker Swarm initialized"
    else
        echo "[SKIP] Docker Swarm initialization skipped"
    fi
}

create_helper_scripts() {
    # Container management
    cat > "$TOOLS_DIR/scripts/docker-clean.sh" << 'EOF'
#!/bin/bash

echo "Cleaning up Docker resources..."

echo "Removing stopped containers..."
docker container prune -f

echo "Removing unused networks..."
docker network prune -f

echo "Removing build cache..."
docker builder prune -f

echo "Removing dangling images..."
docker image prune -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Full cleanup complete!"
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-clean.sh"

    # Container health check
    cat > "$TOOLS_DIR/scripts/docker-health.sh" << 'EOF'
#!/bin/bash

echo "=== Docker Container Health ==="
echo ""

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | while read -r line; do
    echo "$line"
done

echo ""
echo "=== Container Resource Usage ==="
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-health.sh"

    # Log viewer
    cat > "$TOOLS_DIR/scripts/docker-logs.sh" << 'EOF'
#!/bin/bash

CONTAINER=${1:-}
LINES=${2:-50}

if [ -z "$CONTAINER" ]; then
    echo "Usage: $0 <container-name> [lines]"
    echo ""
    echo "Running containers:"
    docker ps --format "{{.Names}}"
    exit 1
fi

echo "Showing last $LINES lines of logs for: $CONTAINER"
docker logs --tail "$LINES" -f "$CONTAINER"
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-logs.sh"

    # Network inspection
    cat > "$TOOLS_DIR/scripts/docker-net.sh" << 'EOF'
#!/bin/bash

echo "=== Docker Networks ==="
docker network ls

echo ""
echo "=== Network Details ==="
for net in $(docker network ls --format "{{.Name}}" | grep -v "bridge\|host\|none"); do
    echo "--- $net ---"
    docker network inspect "$net" --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}' 2>/dev/null || echo "(no containers)"
done
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-net.sh"

    # Image management
    cat > "$TOOLS_DIR/scripts/docker-images.sh" << 'EOF'
#!/bin/bash

echo "=== Docker Images ==="
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"

echo ""
echo "=== Unused Images ==="
unused=$(docker images -f "dangling=true" -q)
if [ -n "$unused" ]; then
    docker images -f "dangling=true"
    echo ""
    echo "Remove these? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        docker image prune -f
    fi
else
    echo "No dangling images found"
fi
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-images.sh"

    # Quick shell access
    cat > "$TOOLS_DIR/scripts/docker-shell.sh" << 'EOF'
#!/bin/bash

CONTAINER=${1:-}
SHELL=${2:-/bin/sh}

if [ -z "$CONTAINER" ]; then
    echo "Usage: $0 <container-name> [shell]"
    echo ""
    echo "Running containers:"
    docker ps --format "{{.Names}}"
    exit 1
fi

echo "Connecting to $CONTAINER..."
docker exec -it "$CONTAINER" "$SHELL"
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-shell.sh"

    # Backup volumes
    cat > "$TOOLS_DIR/scripts/docker-volume-backup.sh" << 'EOF'
#!/bin/bash

VOLUME=${1:-}
BACKUP_DIR=${2:-./backups}

if [ -z "$VOLUME" ]; then
    echo "Usage: $0 <volume-name> [backup-dir]"
    echo ""
    echo "Available volumes:"
    docker volume ls
    exit 1
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${VOLUME}-${TIMESTAMP}.tar.gz"

echo "Backing up volume: $VOLUME"
docker run --rm \
    -v "$VOLUME":/volume \
    -v "$BACKUP_DIR":/backup \
    alpine tar czf "/backup/$BACKUP_FILE" -C /volume .

echo "Backup saved to: $BACKUP_FILE"
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-volume-backup.sh"

    # Restore volumes
    cat > "$TOOLS_DIR/scripts/docker-volume-restore.sh" << 'EOF'
#!/bin/bash

VOLUME=${1:-}
BACKUP_FILE=${2:-}

if [ -z "$VOLUME" ] || [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <volume-name> <backup-file.tar.gz>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Restoring volume: $VOLUME from $BACKUP_FILE"
docker run --rm \
    -v "$VOLUME":/volume \
    -v "$(dirname "$BACKUP_FILE"):/backup:ro" \
    alpine tar xzf "/backup/$(basename "$BACKUP_FILE")" -C /volume

echo "Restore complete!"
EOF
    chmod +x "$TOOLS_DIR/scripts/docker-volume-restore.sh"

    echo "[OK] Created helper scripts"
}

create_daemon_config() {
    cat > "$TOOLS_DIR/config/daemon.json" << 'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "default-address-pools": [
    {
      "base": "172.17.0.0/12",
      "size": 24
    }
  ],
  "dns": ["8.8.8.8", "8.8.4.4"],
  "metrics-addr": "127.0.0.1:9323",
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
EOF
    echo "[OK] Created daemon config"
}

create_compose_examples() {
    mkdir -p "$TOOLS_DIR/examples"
    
    # Basic web app
    cat > "$TOOLS_DIR/examples/basic-web.yml" << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  default:
    name: basic-web-network
EOF

    # Multi-tier app
    cat > "$TOOLS_DIR/examples/multi-tier.yml" << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    depends_on:
      api:
        condition: service_healthy
    networks:
      - frontend
      - backend

  api:
    image: node:alpine
    working_dir: /app
    command: node server.js
    environment:
      - DATABASE_URL=postgres://db:5432/app
    depends_on:
      db:
        condition: service_healthy
    networks:
      - backend
    healthcheck:
      test: ["CMD", "node", "check.js"]
      interval: 30s
      timeout: 10s
      retries: 3

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=app
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db-data:

networks:
  frontend:
  backend:
EOF

    echo "[OK] Created compose examples"
}

create_aliases() {
    cat > "$TOOLS_DIR/docker-aliases.sh" << 'EOF'
#!/bin/bash

# Docker Helper Aliases
# Source this file: source docker-aliases.sh

alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dclean='docker system prune -af'
alias dprune='docker container prune -f && docker image prune -f && docker volume prune -f'

# Docker Compose shortcuts
alias dcop='docker-compose up -d'
alias dcstop='docker-compose stop'
alias dcrestart='docker-compose restart'
alias dclog='docker-compose logs -f'
alias dcps='docker-compose ps'

# Container management
alias dsh='docker exec -it'
alias dbash='docker exec -it'

# Utility
alias dstat='docker stats'
alias dinspect='docker inspect'
alias dtop='docker top'
alias dnet='docker network ls'

# Swarm
alias dswarm-init='docker swarm init'
alias dswarm-leave='docker swarm leave --force'
alias dsvc='docker service'
alias dstack='docker stack'

echo "Docker aliases loaded!"
EOF
    echo "[OK] Created aliases file"
}

install_docker_tools() {
    echo "Installing Docker tools..."
    check_docker
    create_directories
    install_docker_compose
    initialize_docker_swarm
    create_helper_scripts
    create_daemon_config
    create_compose_examples
    create_aliases
    
    echo ""
    echo "========================================="
    echo "Docker Tools installation complete!"
    echo "========================================="
    echo ""
    echo "Helper scripts available in:"
    echo "  $TOOLS_DIR/scripts/"
    echo ""
    echo "To load Docker aliases:"
    echo "  source $TOOLS_DIR/docker-aliases.sh"
    echo ""
    echo "Useful commands:"
    echo "  $TOOLS_DIR/scripts/docker-health.sh"
    echo "  $TOOLS_DIR/scripts/docker-clean.sh"
    echo "  $TOOLS_DIR/scripts/docker-logs.sh <container>"
    echo "========================================="
}

main() {
    echo "=== Docker Tools Installation Script ==="
    install_docker_tools
}

main "$@"
