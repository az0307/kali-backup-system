#!/usr/bin/env bash
# setup-dotfiles.sh — one-shot shell hardening for the NetHunter Kali chroot.
# Installs zsh + tmux + plugins, writes a sane ~/.tmux.conf, and appends an
# idempotent alias/plugin block to ~/.zshrc. Safe to re-run (backs up + guards).
#
# run INSIDE the Kali chroot:   bash setup-dotfiles.sh
set -euo pipefail

echo "[*] installing packages…"
apt-get update -qq
apt-get install -y -qq zsh git curl tmux ncdu htop

# --- oh-my-zsh (unattended; don't switch shell or launch zsh mid-script) ---
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZC="$HOME/.oh-my-zsh/custom"
[[ -d "$ZC/plugins/zsh-autosuggestions" ]] || \
  git clone -q https://github.com/zsh-users/zsh-autosuggestions "$ZC/plugins/zsh-autosuggestions"
[[ -d "$ZC/plugins/zsh-syntax-highlighting" ]] || \
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"

# --- tmux config (back up any existing one first) ---
[[ -f "$HOME/.tmux.conf" ]] && cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak.$(date +%s)"
cat > "$HOME/.tmux.conf" <<'EOF'
set -g mouse on              # touch-scroll + tap-to-select on a phone
set -g history-limit 50000
setw -g mode-keys vi
bind | split-window -h
bind - split-window -v
set -g status-style 'bg=#111a22 fg=#45d3a6'
EOF

# --- zshrc additions, wrapped in a marker block so re-runs don't duplicate ---
MARK="# >>> nethunter-dotfiles >>>"
if ! grep -q "$MARK" "$HOME/.zshrc" 2>/dev/null; then
cat >> "$HOME/.zshrc" <<'EOF'
# >>> nethunter-dotfiles >>>
plugins=(git sudo tmux zsh-autosuggestions zsh-syntax-highlighting)
alias ll='ls -lah --color=auto'
alias ports='ss -tulpn'
alias myip='curl -s ifconfig.me'
# Nexmon monitor-mode toggles (internal S10 chip, 2.4GHz)
alias mon='svc wifi disable && sleep 2 && ifconfig wlan0 up && nexutil -s0x613 -i -v2 && iwconfig wlan0'
alias unmon='nexutil -m0 && svc wifi enable'
export EDITOR=nano
# <<< nethunter-dotfiles <<<
EOF
fi

# --- make zsh the default shell ---
command -v zsh >/dev/null && chsh -s "$(command -v zsh)" || true
echo "[+] done. Start a new shell or run:  exec zsh"
