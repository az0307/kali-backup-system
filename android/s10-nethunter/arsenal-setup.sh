#!/usr/bin/env bash
# arsenal-setup.sh — install the Arsenal command dashboard + Gemini CLI and wire
# in the NetHunter cheatsheet as your personal playbook. Run inside the chroot.
set -euo pipefail

# --- Arsenal (TUI command launcher / cheatsheet dashboard) ---
if ! command -v arsenal >/dev/null; then
  echo "[*] installing arsenal-cli…"
  apt-get install -y -qq pipx fzf tmux 2>/dev/null || true
  pipx install arsenal-cli || python3 -m pip install --user arsenal-cli
fi

# drop the custom cheatsheet where Arsenal looks for it
DEST="$HOME/.arsenal"
mkdir -p "$DEST"
if [[ -f "nethunter-arsenal.md" ]]; then
  cp nethunter-arsenal.md "$DEST/"
  echo "[+] installed cheatsheet → $DEST/nethunter-arsenal.md"
else
  echo "[!] nethunter-arsenal.md not found in $(pwd) — copy it into $DEST manually"
fi

# --- Gemini CLI (Kali package since 2025.3) ---
if ! command -v gemini >/dev/null; then
  echo "[*] installing gemini-cli…"
  apt-get install -y -qq gemini-cli || echo "[!] gemini-cli not in your repos — update apt or add Kali repo"
fi

cat <<'EON'

[+] done.
    arsenal                 # launch the command dashboard (Ctrl-T = fzf, -t = tmux send)
    arsenal -t              # send picked command into another tmux pane
    gemini -p "…"           # AI assist in the terminal

[!] Gemini CLI: free Google-account access ended 18 Jun 2026.
    Set a paid API key first:  export GEMINI_API_KEY=<your-key>
    (or configure Vertex AI). Without it, gemini-cli won't authenticate.
EON
