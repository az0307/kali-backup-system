#!/usr/bin/env bash
# theme-all.sh — apply a cohesive Matrix (green-on-black) theme to the CHROOT:
# zsh prompt, LS_COLORS, tmux, and cmatrix. (Termux's own colors live in a
# separate file — see termux-colors.properties in this toolkit.)
# Run inside the Kali chroot.
set -euo pipefail

apt-get install -y -qq cmatrix zsh tmux 2>/dev/null || true

# --- green LS_COLORS + a matrix zsh prompt (idempotent marker block) ---
MARK="# >>> matrix-theme >>>"
if ! grep -q "$MARK" "$HOME/.zshrc" 2>/dev/null; then
cat >> "$HOME/.zshrc" <<'EOF'
# >>> matrix-theme >>>
export LS_COLORS='di=1;32:ln=1;32:ex=1;32:fi=0;32'
# minimal green prompt: user@host:path $  in phosphor green
autoload -Uz colors && colors
PROMPT='%F{green}%n@%m%f:%F{green}%~%f %F{green}%#%f '
alias ls='ls --color=auto'
alias grep='grep --color=auto'
# type 'rain' anytime for the screensaver
alias rain='cmatrix -ab -C green'
# <<< matrix-theme <<<
EOF
echo "[+] zsh matrix prompt + green LS_COLORS applied"
fi

# --- tmux green status (back up existing) ---
[[ -f "$HOME/.tmux.conf" ]] && cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak.$(date +%s)"
grep -q 'matrix-tmux' "$HOME/.tmux.conf" 2>/dev/null || cat >> "$HOME/.tmux.conf" <<'EOF'
# matrix-tmux
set -g status-style 'bg=#000600 fg=#00ff41'
set -g pane-active-border-style 'fg=#00ff41'
set -g pane-border-style 'fg=#0c5223'
EOF

echo "[+] done. Reload:  exec zsh  &&  tmux source ~/.tmux.conf"
echo "[*] for the Termux app itself, copy termux-colors.properties → ~/.termux/colors.properties"
echo "    (in Termux, not the chroot) then run:  termux-reload-settings"
