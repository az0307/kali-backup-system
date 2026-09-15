#!/usr/bin/env bash
# install.sh — drop the whole toolkit into ~/bin and make it runnable.
# Run this from the folder that contains the other scripts.
#
# usage:  bash install.sh
set -euo pipefail

DEST="$HOME/bin"
mkdir -p "$DEST"

KIT=(recon.sh setup-dotfiles.sh wifi-audit.sh nh-backup.sh newengagement.sh \
     opsec.sh vault.sh chezmoi-setup.sh tailscale-link.sh webterm.sh \
     panic.sh nh-menu.sh ai-setup.sh theme-all.sh ai-suggest.sh killswitch.sh)
# note: pc-setup.sh runs on the PC, not the phone — it is intentionally not installed here

for f in "${KIT[@]}"; do
  if [[ -f "$f" ]]; then
    install -m 0755 "$f" "$DEST/$f"      # copy + chmod 0755 in one step
    echo "[+] installed $f → $DEST/$f"
  else
    echo "[!] $f not found in $(pwd) — skipped"
  fi
done

# --- make sure ~/bin is on PATH (idempotent across zsh + bash) ---
if ! printf '%s' "$PATH" | tr ':' '\n' | grep -qx "$DEST"; then
  ADDED=""
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [[ -f "$rc" ]] || continue
    grep -q 'HOME/bin' "$rc" || echo 'export PATH="$HOME/bin:$PATH"' >> "$rc"
    ADDED=1
  done
  if [[ -n "$ADDED" ]]; then
    echo "[*] added ~/bin to PATH — reload with:  exec \$SHELL"
  else
    echo "[!] no ~/.zshrc or ~/.bashrc yet — run setup-dotfiles.sh first, or add manually:"
    echo "    export PATH=\"\$HOME/bin:\$PATH\""
  fi
fi

# --- stand up the Arsenal dashboard + Gemini CLI (folded-in cockpit setup) ---
echo "[*] setting up the Arsenal command dashboard…"
if ! command -v arsenal >/dev/null; then
  apt-get install -y -qq pipx fzf tmux 2>/dev/null || true
  pipx install arsenal-cli 2>/dev/null || python3 -m pip install --user arsenal-cli 2>/dev/null || \
    echo "[!] arsenal-cli install skipped — install manually with: pipx install arsenal-cli"
fi
if [[ -f "nethunter-arsenal.md" ]]; then
  mkdir -p "$HOME/.arsenal"; cp nethunter-arsenal.md "$HOME/.arsenal/"
  echo "[+] Arsenal cheatsheet → ~/.arsenal/nethunter-arsenal.md"
fi
command -v gemini >/dev/null || apt-get install -y -qq gemini-cli 2>/dev/null || \
  echo "[*] gemini-cli not installed (needs a Kali repo + paid API key since 18 Jun 2026)"

echo "[+] done. Cockpit ready:"
echo "    nh-menu.sh            # matrix TUI launcher"
echo "    arsenal               # command dashboard / playbook"
echo "    newengagement.sh test # scaffold an engagement"
