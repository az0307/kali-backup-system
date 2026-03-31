#!/bin/bash
# STAGE 5: Productivity, Utils & Fun
# Run as root: sudo ./scripts/setup-stage5-productivity.sh

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     STAGE 5: Productivity & CLI Utils           ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "[1/6] Installing CLI enhancements..."
sudo apt update
sudo apt install -y \
    bat         `# Better cat with syntax highlighting` \
    exa         `# Modern ls replacement` \
    lsd         `# ls with icons` \
    ripgrep     `# Fast grep` \
    jq          `# JSON processor` \
    shellcheck  `# Bash linting` \
    httpie      `# Curl alternative` \
    tldr        `# Simplified man pages` \
    fzf         `# Fuzzy finder` \
    htop        `# Process viewer` \
    btop        `# Modern htop` \
    ncdu        `# Disk analyzer`

echo "[2/6] Installing useful utils..."
sudo apt install -y \
    curl \
    wget \
    vim \
    git \
    tmux \
    tree \
    unzip \
    zip \
    tar \
    gzip

echo "[3/6] Installing fun tools..."
sudo apt install -y \
    cowsay \
    fortune \
    boxes \
    lolcat \
    figlet \
    neofetch \
    cmatrix \
    hollywood  `# Hollywood hacker screen`

echo "[4/6] Installing system tools..."
sudo apt install -y \
    net-tools \
    iproute2 \
    dnsutils \
    traceroute \
    mtr \
    nmap \
    tcpdump \
    strace \
    ltrace

echo "[5/6] Installing development tools..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    git-lfs

echo "[6/6] Configuring tmux..."
# Install TPM
mkdir -p ~/.tmux/plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || true

# Copy tmux config
cat > ~/.tmux.conf << 'EOF'
# Set prefix to Ctrl-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse
set -g mouse on

# Start window numbering at 1
set -g base-index 1

# Better colors
set -g default-terminal "screen-256color"

# Status bar
set -g status-bg black
set -g status-fg green
EOF

echo ""
echo "✅ Stage 5 Complete!"
echo ""
echo "🚀 New commands:"
echo "  bat file           # Better cat"
echo "  exa -la           # Better ls"
echo "  rg pattern        # Fast grep"
echo "  jq .              # JSON parse"
echo "  tldr command      # Simple help"
echo "  fzf               # Fuzzy finder"
echo "  neofetch          # System info"
echo "  hollywood         # Hacker screen"
