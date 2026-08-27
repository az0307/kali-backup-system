#!/bin/bash
# ====================================================================
# S10 KALI NETHUNTER — FIELD RIG PROVISIONING
# Runs INSIDE the NetHunter Kali chroot (NetHunter Terminal → sudo su).
# Installs the field toolkit and wires the S10 to the HP Mini G9 hub.
# See docs/07_DEVICE_SETUPS/S10_KALI_NETHUNTER.md
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
HUB_HOST="${HUB_HOST:-192.168.50.10}"     # HP Mini G9 (the brain)
HUB_USER="${HUB_USER:-aries}"
REPO_DIR="${REPO_DIR:-$HOME/KaliShare}"
REPO_URL="${REPO_URL:-https://github.com/az0307/kali-backup-system}"

usage() {
  cat <<USAGE
S10 NetHunter field-rig provisioning (run in the Kali chroot)

Usage: $0 [stage]
  (no args)     Run every stage
  --tools       Field toolkit (apt) only
  --repo        Clone/refresh this KaliShare repo only
  --hub         SSH key + Tailscale to the HP Mini G9 only
  --check       Verify chroot + wireless capability, then exit
  --help        This help

Env overrides: HUB_HOST, HUB_USER, REPO_DIR, REPO_URL
USAGE
}

require_chroot() {
  if ! grep -qi kali /etc/os-release 2>/dev/null; then
    error "Not in the Kali chroot. Open NetHunter Terminal and 'sudo su' first."
  fi
  [ "$(id -u)" -eq 0 ] || error "Run as root inside the chroot (sudo su)."
}

stage_check() {
  log "Chroot OK: $(grep -oP '(?<=^PRETTY_NAME=").*(?=")' /etc/os-release 2>/dev/null || echo Kali)"
  info "Wireless interfaces:"
  iwconfig 2>/dev/null | grep -E '^[a-z]' || warn "No wireless ifaces visible yet."
  info "Plug an OTG adapter (AR9271/RTL8812AU) for reliable injection."
}

stage_tools() {
  log "Updating chroot + installing field toolkit"
  apt update && apt full-upgrade -y
  apt install -y nmap masscan nikto sqlmap hydra aircrack-ng wifite \
                 bettercap responder tcpdump proxychains4 openssh-client \
                 metasploit-framework seclists git curl \
    || warn "Some packages unavailable in this chroot flavour — continuing."
  mkdir -p "$HOME/loot" "$HOME/loot/hid"
  log "Loot dir ready at $HOME/loot"
}

stage_repo() {
  if [ -d "$REPO_DIR/.git" ]; then
    log "Refreshing repo at $REPO_DIR"
    git -C "$REPO_DIR" pull --ff-only || warn "Pull failed — leaving existing clone."
  else
    log "Cloning $REPO_URL -> $REPO_DIR"
    git clone --depth 1 "$REPO_URL" "$REPO_DIR" || warn "Clone failed (offline?)."
  fi
  info "Launch the toolkit menu with: bash $REPO_DIR/scripts/menu.sh"
}

stage_hub() {
  log "Setting up offload to the HP Mini G9 (${HUB_USER}@${HUB_HOST})"
  if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" || warn "keygen failed."
  fi
  info "Push the key with:  ssh-copy-id ${HUB_USER}@${HUB_HOST}"
  info "Stream a scan to the brain:"
  echo "    nmap -sV <target> -oX - | ssh ${HUB_USER}@${HUB_HOST} 'cat > ~/loot/\$(date +%F)-s10-nmap.xml'"

  if ! command -v tailscale >/dev/null 2>&1; then
    log "Installing Tailscale (for off-LAN reach)"
    curl -fsSL https://tailscale.com/install.sh | sh || warn "Tailscale install failed."
  fi
  info "Join the mesh with:  tailscale up"
}

main() {
  case "${1:-all}" in
    --help|-h) usage; exit 0 ;;
    --check)   require_chroot; stage_check ;;
    --tools)   require_chroot; stage_tools ;;
    --repo)    require_chroot; stage_repo ;;
    --hub)     require_chroot; stage_hub ;;
    all|"")
      require_chroot
      stage_check
      stage_tools
      stage_repo
      stage_hub
      ;;
    *) usage; error "Unknown option: $1" ;;
  esac
  log "Done. Full guide: docs/07_DEVICE_SETUPS/S10_KALI_NETHUNTER.md"
}

main "${1:-all}"
