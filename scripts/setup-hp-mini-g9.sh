#!/bin/bash
# ====================================================================
# HP MINI G9 — AI BRAIN + COMMAND CENTER PROVISIONING
# Local LLMs (Ollama/Open WebUI), coding agents, Docker/MCP mesh,
# and fleet hub services (SSH/Syncthing/Tailscale/UFW).
# Target: Ubuntu 24.04 LTS host. See docs/07_DEVICE_SETUPS/HP_MINI_G9_AI.md
# ====================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[*]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
info() { echo -e "${CYAN}[i]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1" >&2; exit 1; }

# --- Config (override via env) ---------------------------------------
FLEET_SUBNET="${FLEET_SUBNET:-192.168.50.0/24}"
HOSTNAME_SET="${HOSTNAME_SET:-hp-mini-g9}"
OLLAMA_MODELS="${OLLAMA_MODELS:-llama3.1:8b qwen2.5-coder:7b nomic-embed-text}"

usage() {
  cat <<USAGE
HP Mini G9 provisioning

Usage: $0 [stage]
  (no args)     Run every stage
  --base        System packages + hostname only
  --ai-only     Ollama + models + Open WebUI + coding agents
  --hub-only    SSH / Syncthing / Tailscale / UFW
  --docker      Docker engine only
  --help        This help

Env overrides: FLEET_SUBNET, HOSTNAME_SET, OLLAMA_MODELS
USAGE
}

require_root() {
  [ "$(id -u)" -eq 0 ] || error "Run with sudo (needs apt / systemctl)."
}

stage_base() {
  log "Base system: update + core packages"
  apt update && apt full-upgrade -y
  apt install -y build-essential git curl wget htop btop tmux \
    python3 python3-pip python3-venv pipx ca-certificates gnupg lsb-release \
    openssh-server ufw fail2ban unattended-upgrades restic
  log "Setting hostname -> ${HOSTNAME_SET}"
  hostnamectl set-hostname "${HOSTNAME_SET}"
  info "Set a static IP (e.g. 192.168.50.10) via netplan/nmcli — not automated here."
}

stage_docker() {
  if command -v docker >/dev/null 2>&1; then
    info "Docker already present — skipping."
  else
    log "Installing Docker Engine"
    curl -fsSL https://get.docker.com | sh
    [ -n "${SUDO_USER:-}" ] && usermod -aG docker "${SUDO_USER}" \
      && warn "Added ${SUDO_USER} to docker group — log out/in to take effect."
  fi
}

stage_ai() {
  log "Installing Ollama"
  if ! command -v ollama >/dev/null 2>&1; then
    curl -fsSL https://ollama.com/install.sh | sh
  fi
  log "Exposing Ollama on 0.0.0.0:11434 for the fleet"
  mkdir -p /etc/systemd/system/ollama.service.d
  printf '[Service]\nEnvironment="OLLAMA_HOST=0.0.0.0:11434"\n' \
    > /etc/systemd/system/ollama.service.d/host.conf
  systemctl daemon-reload
  systemctl enable --now ollama || warn "Enable ollama manually if service missing."

  log "Pulling models: ${OLLAMA_MODELS}"
  for m in ${OLLAMA_MODELS}; do
    info "  -> ${m}"
    ollama pull "${m}" || warn "Failed to pull ${m} (RAM/network?) — continuing."
  done

  log "Node LTS + Claude Code (coding agents)"
  if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt install -y nodejs
  fi
  npm install -g @anthropic-ai/claude-code \
    || warn "Claude Code install failed — install manually later."

  if command -v docker >/dev/null 2>&1; then
    log "Starting Open WebUI on :3000"
    docker rm -f open-webui >/dev/null 2>&1 || true
    docker run -d --name open-webui --restart always \
      -p 3000:8080 \
      -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
      --add-host=host.docker.internal:host-gateway \
      -v open-webui:/app/backend/data \
      ghcr.io/open-webui/open-webui:main \
      || warn "Open WebUI container failed to start."
  else
    warn "Docker missing — skipping Open WebUI (run --docker first)."
  fi
}

stage_hub() {
  log "Hardening SSH (keys only)"
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  systemctl restart ssh || systemctl restart sshd || warn "Restart sshd manually."

  log "Installing Syncthing"
  apt install -y syncthing
  info "Enable per-user: systemctl --user enable --now syncthing (GUI :8384)"

  log "Installing Tailscale"
  if ! command -v tailscale >/dev/null 2>&1; then
    curl -fsSL https://tailscale.com/install.sh | sh
  fi
  info "Join the mesh with: sudo tailscale up"

  log "Firewall: allow only fleet services"
  ufw --force default deny incoming
  ufw allow 22/tcp
  ufw allow from "${FLEET_SUBNET}" to any port 11434 proto tcp
  ufw allow from "${FLEET_SUBNET}" to any port 3000 proto tcp
  ufw allow 22000
  ufw --force enable

  log "Staging wordlists in /srv/wordlists"
  apt install -y seclists || warn "seclists not available in this repo set."
  mkdir -p /srv/wordlists
  if [ -d /usr/share/wordlists ]; then
    cp -rn /usr/share/wordlists/* /srv/wordlists/ 2>/dev/null || true
  fi
}

main() {
  case "${1:-all}" in
    --help|-h) usage; exit 0 ;;
    --base)    require_root; stage_base ;;
    --docker)  require_root; stage_docker ;;
    --ai-only) require_root; stage_ai ;;
    --hub-only) require_root; stage_hub ;;
    all|"")
      require_root
      stage_base
      stage_docker
      stage_ai
      stage_hub
      ;;
    *) usage; error "Unknown option: $1" ;;
  esac
  log "Done. Review docs/07_DEVICE_SETUPS/HP_MINI_G9_AI.md for manual steps."
}

main "${1:-all}"
