#!/usr/bin/env bash
# chezmoi-setup.sh — migrate your NetHunter dotfiles into chezmoi, so any rebuild
# is one command and secrets are age-encrypted. Run INSIDE the Kali chroot.
set -euo pipefail

# 1) install chezmoi + age
if ! command -v chezmoi >/dev/null; then
  echo "[*] installing chezmoi…"
  sh -c "$(curl -fsSL https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
fi
export PATH="$HOME/.local/bin:$PATH"
command -v age >/dev/null || { echo "[*] installing age…"; apt-get install -y -qq age; }

# 2) init and adopt existing configs
chezmoi init 2>/dev/null || true
for f in "$HOME/.zshrc" "$HOME/.tmux.conf"; do
  [[ -f "$f" ]] && chezmoi add "$f" && echo "[+] tracked $f"
done

# 3) wire age encryption for secrets (recommended)
CM="$HOME/.config/chezmoi"
if [[ ! -f "$CM/key.txt" ]]; then
  mkdir -p "$CM"
  age-keygen -o "$CM/key.txt" 2>/dev/null
  chmod 600 "$CM/key.txt"
  RECIP="$(grep 'public key' "$CM/key.txt" | awk '{print $NF}')"
  cat >> "$CM/chezmoi.toml" <<EOF
encryption = "age"
[age]
    identity = "$CM/key.txt"
    recipient = "$RECIP"
EOF
  echo "[+] age encryption configured"
  echo "    add a secret with:  chezmoi add --encrypt <file>"
fi

cat <<'EON'

[+] done. Everyday commands:
    chezmoi add <file>        # start tracking a dotfile
    chezmoi cd                # enter the source repo → git init && push to a PRIVATE remote
    chezmoi apply             # on a fresh chroot, after: chezmoi init <your-repo-url>
[!] BACK UP ~/.config/chezmoi/key.txt OFF-DEVICE — it decrypts your secrets.
EON
