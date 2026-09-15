#!/usr/bin/env bash
# opsec.sh — per-session identity hygiene for AUTHORIZED engagements.
# Randomizes the wlan0 MAC + hostname, then checks egress IP and DNS for leaks.
# Run as root inside NetHunter.  Legitimate testing / own-lab use only.
#
#   ./opsec.sh mac     # new random MAC on wlan0
#   ./opsec.sh host    # new random hostname
#   ./opsec.sh check   # show egress IP + DNS resolvers (leak check)
#   ./opsec.sh all     # all of the above (default)
set -euo pipefail
IFACE="${IFACE:-wlan0}"

rand_mac(){
  # locally-administered, unicast — first octet 02 so it reads as a real NIC
  printf '02:%02x:%02x:%02x:%02x:%02x\n' \
    $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
}

spoof_mac(){
  ip link show "$IFACE" >/dev/null 2>&1 || { echo "[!] $IFACE not found — no interface to spoof"; exit 1; }
  local MAC; MAC="$(rand_mac)"
  ip link set "$IFACE" down 2>/dev/null || ifconfig "$IFACE" down 2>/dev/null || true
  if ip link set "$IFACE" address "$MAC" 2>/dev/null; then :; \
    elif command -v macchanger >/dev/null; then macchanger -m "$MAC" "$IFACE" >/dev/null; fi
  ip link set "$IFACE" up 2>/dev/null || ifconfig "$IFACE" up 2>/dev/null || true
  # VERIFY — as with wifi-audit.sh's monitor-mode check, don't trust that the
  # commands above ran; confirm the interface actually reports the new MAC.
  local NOW; NOW="$(ip -o link show "$IFACE" 2>/dev/null | grep -oE 'link/ether [0-9a-f:]+' | awk '{print $2}')"
  if [[ "${NOW,,}" == "$MAC" ]]; then
    echo "[+] $IFACE MAC → $MAC (confirmed)"
  else
    echo "[!] MAC change did NOT take effect — $IFACE is still ${NOW:-unknown}."
    echo "    install macchanger, or set the address manually."
    exit 1
  fi
  echo "    (NetHunter app → MAC Changer does this in the GUI too)"
}

rand_host(){
  local H="wsvc-$(tr -dc 'a-z0-9' </dev/urandom | head -c6)"   # bland, blends in
  hostname "$H" 2>/dev/null || echo "$H" > /proc/sys/kernel/hostname 2>/dev/null || true
  echo "[+] hostname → $H"
}

leak_check(){
  echo "[*] egress IP  : $(curl -s --max-time 8 https://ifconfig.me || echo '?? (no route)')"
  echo "[*] DNS resolvers:"
  grep -E '^nameserver' /etc/resolv.conf 2>/dev/null | sed 's/^/    /' || echo "    (none listed)"
  echo "[!] confirm that egress IP is your VPN / redirector — NOT your real line."
}

case "${1:-all}" in
  mac)   spoof_mac ;;
  host)  rand_host ;;
  check) leak_check ;;
  all)   spoof_mac; rand_host; leak_check ;;
  *) echo "usage: $0 {mac|host|check|all}"; exit 1 ;;
esac
