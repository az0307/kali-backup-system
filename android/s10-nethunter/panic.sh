#!/usr/bin/env bash
# panic.sh — LOST / STOLEN-DEVICE DATA PROTECTION.
#
# Irreversibly wipes sensitive engagement data + keys from THIS device so a lost
# or stolen phone can't leak a client's data. It destroys YOUR OWN data on YOUR
# OWN device — the mobile equivalent of a remote wipe.
#
#   >>> IRREVERSIBLE. NO UNDO. Requires typing WIPE to confirm. <<<
#
# Legitimate use: protecting client / engagement data on a lost or stolen device.
# Do NOT use this to destroy data you are legally required to preserve.
set -euo pipefail

TARGETS=(
  "$HOME/.config/vault"            # age loot-vault private key
  "$HOME/.config/chezmoi/key.txt"  # dotfiles secret key
  "$HOME/.ssh"                     # ssh private keys
  "$HOME/engagements"              # scaffolded engagement data
  "$HOME/loot"                     # loose loot
  "$HOME/.zsh_history"
  "$HOME/.bash_history"
)

echo "This will PERMANENTLY DESTROY, on THIS device:"
printf '   - %s\n' "${TARGETS[@]}"
echo
read -r -p 'Type EXACTLY  WIPE  to proceed (anything else aborts): ' ans
[[ "$ans" == "WIPE" ]] || { echo "[*] aborted — nothing was changed."; exit 1; }

for t in "${TARGETS[@]}"; do
  [[ -e "$t" ]] || continue
  if [[ -d "$t" ]]; then
    find "$t" -type f -exec shred -u {} + 2>/dev/null || true
    rm -rf "$t"
  else
    shred -u "$t" 2>/dev/null || rm -f "$t"
  fi
  echo "[+] wiped $t"
done

# drop off the tailnet so the node can't be reached after
command -v tailscale >/dev/null && tailscale logout 2>/dev/null || true

echo "[+] sensitive data destroyed."
echo "[*] for a full clean, follow with an Android factory reset from recovery."
