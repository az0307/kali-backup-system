#!/usr/bin/env bash
# nh-backup.sh — snapshot the Kali chroot to SD/USB with automatic rotation.
#
# Run from an ANDROID root shell (not inside the chroot) — it needs to read
# /data/local/nhsystem. Pull the resulting archive off-device to your PC too.
#
# usage:  su -c 'bash nh-backup.sh'
set -euo pipefail

SRC="/data/local/nhsystem"     # where NetHunter stores the rootfs
ROOTFS="kali-arm64"            # <-- change if you named your chroot differently
DEST="/sdcard/nh-backups"
KEEP=3                        # how many snapshots to retain

command -v tar >/dev/null || { echo "[!] tar not found"; exit 1; }
[[ -d "$SRC/$ROOTFS" ]] || { echo "[!] $SRC/$ROOTFS not found — fix ROOTFS="; exit 1; }

mkdir -p "$DEST"
STAMP="$(date +%Y%m%d-%H%M%S)"
FILE="$DEST/kali-$STAMP.tar.gz"

echo "[*] backing up $SRC/$ROOTFS → $FILE"
tar -C "$SRC" -czf "$FILE" "$ROOTFS"
echo "[+] $(du -h "$FILE" | cut -f1) written"

# rotation — keep the newest $KEEP, prune the rest
ls -1t "$DEST"/kali-*.tar.gz 2>/dev/null | tail -n +$((KEEP+1)) | while read -r old; do
  echo "[*] pruning old snapshot: $old"
  rm -f "$old"
done

echo "[+] done. Copy $DEST off-device to your PC for real safety."
echo "    restore later with:  tar -C $SRC -xzf <snapshot>.tar.gz"
