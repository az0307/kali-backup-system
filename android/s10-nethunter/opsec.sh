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
  local MAC; MAC="$(rand_mac)"
  ip link set "$IFACE" down 2>/dev/null || ifconfig "$IFACE" down 2>/dev/null || true
  if ip link set "$IFACE" address "$MAC" 2>/dev/null; then :; \
    elif command -v macchanger >/dev/null; then macchanger -m "$MAC" "$IFACE" >/dev/null; fi
  ip link set "$IFACE" up 2>/dev/null || ifconfig "$IFACE" up 2>/dev/null || true
  echo "[+] $IFACE MAC → $MAC"
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
