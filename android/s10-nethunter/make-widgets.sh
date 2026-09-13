#!/usr/bin/env bash
# make-widgets.sh — create Termux:Widget home-screen launchers for the toolkit.
#
# Run this in TERMUX (not the chroot). Install the "Termux:Widget" app (F-Droid),
# then long-press your home screen → Widgets → Termux:Widget to place shortcuts.
# Shortcuts call into the Kali chroot via the `nethunter` wrapper.
set -euo pipefail

SC="$HOME/.shortcuts"
mkdir -p "$SC"

mk(){  # $1 = shortcut name, $2 = command to run in the chroot
  cat > "$SC/$1" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
nethunter -c '$2'
EOF
  chmod +x "$SC/$1"
  echo "[+] widget: $1"
}

mk "Recon"    'read -p "domain: " d; recon.sh "$d"; read -p "[enter]" _'
mk "WiFi-Mon" 'wifi-audit.sh on; read -p "[enter]" _'
mk "OpSec"    'opsec.sh all; read -p "[enter]" _'
mk "Menu"     'nh-menu.sh'
mk "Rain"     'cmatrix -ab -C green'

echo
echo "[*] Add the Termux:Widget widget to your home screen to launch these."
echo "[!] If a shortcut fails, check your chroot wrapper name (nethunter / nh)"
echo "    and that the tools are on the chroot PATH (run install.sh in the chroot)."
