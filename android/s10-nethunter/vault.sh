#!/usr/bin/env bash
# vault.sh — age-encrypted loot vault. Keep captures/creds encrypted at rest so
# a lost or seized phone can't leak client data.  AUTHORIZED USE ONLY.
#
#   ./vault.sh init            # create an age keypair (run once)
#   ./vault.sh lock <dir>      # encrypt a folder → <dir>.tar.age, shred plaintext
#   ./vault.sh unlock <file>   # decrypt <file>.tar.age back to a folder
set -euo pipefail

VDIR="$HOME/.config/vault"
KEY="$VDIR/key.txt"
PUB_FILE="$VDIR/recipient.txt"

command -v age >/dev/null || { echo "[!] install age:  apt install age"; exit 1; }

init(){
  mkdir -p "$VDIR"; chmod 700 "$VDIR"
  [[ -f "$KEY" ]] && { echo "[!] key already exists at $KEY"; exit 1; }
  age-keygen -o "$KEY" 2>/dev/null
  chmod 600 "$KEY"
  grep 'public key' "$KEY" | awk '{print $NF}' > "$PUB_FILE"
  echo "[+] keypair created. PUBLIC key (safe to share / back up):"
  cat "$PUB_FILE"
  echo "[!] BACK UP $KEY OFF-DEVICE — lose it and the vault is unrecoverable."
}

lock(){
  local DIR="${1:?usage: vault.sh lock <dir>}"
  [[ -d "$DIR" ]] || { echo "[!] $DIR is not a directory"; exit 1; }
  [[ -f "$PUB_FILE" ]] || { echo "[!] run 'vault.sh init' first"; exit 1; }
  local PUB OUT PARENT BASE
  PUB="$(cat "$PUB_FILE")"
  DIR="${DIR%/}"
  OUT="${DIR}.tar.age"
  # tar relative to the parent, storing only the basename as the member name.
  # (tar -cf - "$DIR" with an absolute $DIR would strip the leading '/' and
  # bake the whole absolute path into the archive — see unlock below.)
  PARENT="$(cd "$(dirname "$DIR")" && pwd)"; BASE="$(basename "$DIR")"
  tar -C "$PARENT" -cf - "$BASE" | age -r "$PUB" -o "$OUT"
  echo "[+] encrypted → $OUT"
  # overwrite file contents where possible, then remove the plaintext tree
  find "$DIR" -type f -exec shred -u {} + 2>/dev/null || true
  rm -rf "$DIR"
  echo "[+] plaintext $DIR shredded"
}

unlock(){
  local FILE="${1:?usage: vault.sh unlock <file.tar.age>}"
  [[ -f "$FILE" ]] || { echo "[!] $FILE not found"; exit 1; }
  # extract next to the archive, not into whatever the caller's cwd happens to
  # be — matches lock's basename-only archive layout and what we report below.
  local DEST_PARENT; DEST_PARENT="$(cd "$(dirname "$FILE")" && pwd)"
  age -d -i "$KEY" "$FILE" | tar -C "$DEST_PARENT" -xf -
  echo "[+] decrypted → ${FILE%.tar.age}/"
}

case "${1:-}" in
  init)   init ;;
  lock)   shift; lock "$@" ;;
  unlock) shift; unlock "$@" ;;
  *) echo "usage: $0 {init | lock <dir> | unlock <file.tar.age>}"; exit 1 ;;
esac
