#!/usr/bin/env bash
# nh-menu.sh — Matrix-themed TUI launcher for the toolkit.
# Needs: apt install whiptail cmatrix   (cmatrix powers the rain screensaver)
set -euo pipefail

# green-on-black whiptail palette (the "matrix" look)
export NEWT_COLORS='
root=green,black
window=green,black
border=green,black
title=green,black
textbox=green,black
listbox=green,black
actlistbox=black,green
button=black,green
actbutton=black,green
entry=green,black
'

pick(){
  whiptail --title "☰ NETHUNTER // S10 — beyond1lte" \
    --menu "\n  wake up, operator.\n" 22 62 11 \
    recon   "web recon chain  (subfinder→httpx→nuclei)" \
    wifi    "monitor mode + handshake capture" \
    ai      "AI suggest next command (local model)" \
    opsec   "randomize identity + leak check" \
    vault   "lock the loot vault" \
    engage  "scaffold a new engagement" \
    backup  "snapshot the chroot" \
    web     "start the web terminal (tailnet)" \
    rain    "matrix rain screensaver" \
    panic   "PANIC WIPE (destruct)" \
    quit    "exit" 3>&1 1>&2 2>&3
}

while true; do
  case "$(pick || echo quit)" in
    recon)  read -rp "domain: " d; recon.sh "$d"; read -rp "[enter]" _ ;;
    wifi)   wifi-audit.sh scan ;;
    ai)     read -rp "context: " c; ai-suggest.sh "$c"; read -rp "[enter]" _ ;;
    opsec)  opsec.sh all; read -rp "[enter]" _ ;;
    vault)  vault.sh lock ./loot; read -rp "[enter]" _ ;;
    engage) read -rp "name: " n; newengagement.sh "$n"; read -rp "[enter]" _ ;;
    backup) su -c 'bash ~/bin/nh-backup.sh'; read -rp "[enter]" _ ;;
    web)    read -rsp "web pass: " p; echo; WT_PASS="$p" webterm.sh; read -rp "[enter]" _ ;;
    rain)   command -v cmatrix >/dev/null && cmatrix -ab -C green || echo "apt install cmatrix" ;;
    panic)  panic.sh ;;
    quit)   clear; exit 0 ;;
  esac
done
