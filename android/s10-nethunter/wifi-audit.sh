#!/usr/bin/env bash
# wifi-audit.sh — Nexmon monitor-mode + handshake capture for the S10 internal chip.
#
#   AUTHORIZED / OWN-LAB ONLY. Capturing traffic you're not permitted to
#   assess is illegal. The internal Broadcom chip is 2.4GHz-only.
#
# usage:
#   ./wifi-audit.sh on                      # enable + verify monitor mode
#   ./wifi-audit.sh off                     # restore normal wifi
#   ./wifi-audit.sh scan                    # live AP/client survey
#   ./wifi-audit.sh capture <BSSID> <chan>  # targeted handshake capture
set -euo pipefail
IFACE="wlan0"

mon_on(){
  svc wifi disable; sleep 2
  ifconfig "$IFACE" up
  nexutil -s0x613 -i -v2
  # VERIFY — nexutil can report success while the chip stays managed
  # (the classic 18.38.18 vs 18.41.x firmware mismatch). Trust iwconfig, not $?.
  if iwconfig "$IFACE" 2>/dev/null | grep -q "Mode:Monitor"; then
    echo "[+] $IFACE is in MONITOR mode"
  else
    echo "[!] monitor mode NOT active — Nexmon/firmware mismatch (need bcm fw 18.38.18)"
    exit 1
  fi
}
mon_off(){ nexutil -m0; svc wifi enable; echo "[+] normal wifi restored"; }

case "${1:-}" in
  on)   mon_on ;;
  off)  mon_off ;;
  scan) mon_on; echo "[*] Ctrl-C to stop"; airodump-ng "$IFACE" ;;
  capture)
    BSSID="${2:?usage: $0 capture <BSSID> <channel>}"
    CH="${3:?need channel}"
    mon_on
    OUT="loot/wifi/$(date +%Y%m%d-%H%M%S)_${BSSID//:/}"
    mkdir -p "$(dirname "$OUT")"
    echo "[*] capturing ch $CH on $BSSID → $OUT"
    echo "    (in another pane, deauth a client to force the 4-way handshake)"
    airodump-ng -c "$CH" --bssid "$BSSID" -w "$OUT" "$IFACE" ;;
  *) echo "usage: $0 {on|off|scan|capture <BSSID> <channel>}"; exit 1 ;;
esac
