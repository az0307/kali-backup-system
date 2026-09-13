#!/usr/bin/env bash
# killswitch.sh — VPN kill-switch: VERIFY the tunnel holds, safely TEST that
# traffic stops if it drops, and optionally LOCK egress to the tunnel with
# firewall rules so a dropped VPN can never fall back to your real line.
#
#   AUTHORIZED / personal-device use. This protects YOUR egress identity on YOUR
#   device. `lock` inserts firewall rules that can cut your network — read the
#   notes and keep a way back (see `unlock`).
#
#   killswitch.sh baseline           # record the tunnel's egress IP (run with VPN UP)
#   killswitch.sh verify             # is my egress still the tunnel IP? (no changes)
#   killswitch.sh test               # controlled drop → prove traffic STOPS → restore
#   killswitch.sh lock   <tun> <ep>  # firewall: allow ONLY <tun> + VPN endpoint <ep>
#   killswitch.sh unlock             # remove the firewall rules
set -euo pipefail

STATE="$HOME/.config/killswitch"
mkdir -p "$STATE"
BASE="$STATE/tunnel_ip"
IPCHK="https://ifconfig.me"
TIMEOUT=6

egress(){ curl -s --max-time "$TIMEOUT" "$IPCHK" 2>/dev/null || echo ""; }

# detect an active tunnel interface + how it's managed
detect_tun(){
  if command -v tailscale >/dev/null && tailscale status >/dev/null 2>&1; then
    echo "tailscale"; return
  fi
  if command -v wg >/dev/null && wg show interfaces 2>/dev/null | grep -q .; then
    wg show interfaces | awk '{print $1; exit}'; return
  fi
  # any tun/wg interface that's up
  ip -o link show up 2>/dev/null | awk -F': ' '$2 ~ /^(tun|wg)/{print $2; exit}'
}

tun_down(){ # $1 = tun name / "tailscale"
  case "$1" in
    tailscale) tailscale down ;;
    wg*|tun*)  wg-quick down "$1" 2>/dev/null || ip link set "$1" down ;;
    *) return 1 ;;
  esac
}
tun_up(){
  case "$1" in
    tailscale) tailscale up ;;
    wg*|tun*)  wg-quick up "$1" 2>/dev/null || ip link set "$1" up ;;
  esac
}

baseline(){
  local ip; ip="$(egress)"
  [[ -z "$ip" ]] && { echo "[!] no egress — is the VPN up and online?"; exit 1; }
  echo "$ip" > "$BASE"
  echo "[+] recorded tunnel egress IP: $ip"
  echo "    (make sure this is your VPN/redirector IP, NOT your real ISP address)"
}

verify(){
  [[ -f "$BASE" ]] || { echo "[!] run 'killswitch.sh baseline' first (with VPN up)"; exit 1; }
  local want now; want="$(cat "$BASE")"; now="$(egress)"
  echo "[*] expected (tunnel): $want"
  echo "[*] current egress   : ${now:-<none>}"
  if [[ -z "$now" ]]; then
    echo "[+] HELD — no egress at all (fully blocked). Safe."
  elif [[ "$now" == "$want" ]]; then
    echo "[+] OK — still routing through the tunnel."
  else
    echo "[!!] LEAK — egress changed to $now. You are NOT on the tunnel. STOP."
    exit 2
  fi
}

test_drop(){
  local t; t="$(detect_tun || true)"
  [[ -z "$t" ]] && { echo "[!] no active tunnel detected — bring your VPN up first"; exit 1; }
  local before; before="$(egress)"
  echo "[*] tunnel: $t   egress now: ${before:-<none>}"
  echo "[*] dropping the tunnel to test the kill-switch…"
  tun_down "$t" || { echo "[!] couldn't drop $t"; exit 1; }
  sleep 2
  local leaked; leaked="$(egress)"
  echo "[*] egress WITH TUNNEL DOWN: ${leaked:-<none>}"
  echo "[*] restoring the tunnel…"
  tun_up "$t"; sleep 3
  echo
  if [[ -z "$leaked" ]]; then
    echo "[+] PASS — traffic STOPPED when the tunnel dropped. Kill-switch holds."
  else
    echo "[!!] FAIL — device reached the internet as $leaked with the tunnel DOWN."
    echo "     That is your real line leaking. Enable a kill-switch:"
    echo "       - Android: Settings → Network → VPN → Always-on + Block w/o VPN, OR"
    echo "       - killswitch.sh lock <tun> <vpn_endpoint_ip>"
    exit 2
  fi
}

lock(){ # $1 = tun iface, $2 = VPN endpoint IP (so the handshake can get out)
  local TUN="${1:?usage: killswitch.sh lock <tun-iface> <vpn-endpoint-ip>}"
  local EP="${2:?need the VPN server/endpoint IP so the tunnel can connect}"
  command -v iptables >/dev/null || { echo "[!] iptables not found"; exit 1; }
  echo "[*] locking egress to $TUN (+ endpoint $EP). Loopback + tunnel only."
  iptables -F OUTPUT
  iptables -A OUTPUT -o lo -j ACCEPT
  iptables -A OUTPUT -o "$TUN" -j ACCEPT
  iptables -A OUTPUT -d "$EP" -j ACCEPT           # allow the VPN handshake itself
  iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  iptables -P OUTPUT DROP
  echo "[+] LOCKED. If the tunnel drops, traffic is dropped — no fallback."
  echo "[!] to restore normal networking:  killswitch.sh unlock"
}

unlock(){
  command -v iptables >/dev/null || { echo "[!] iptables not found"; exit 1; }
  iptables -P OUTPUT ACCEPT
  iptables -F OUTPUT
  echo "[+] firewall rules cleared — normal networking restored."
}

case "${1:-}" in
  baseline) baseline ;;
  verify)   verify ;;
  test)     test_drop ;;
  lock)     shift; lock "$@" ;;
  unlock)   unlock ;;
  *) echo "usage: $0 {baseline|verify|test|lock <tun> <endpoint>|unlock}"; exit 1 ;;
esac
