#!/usr/bin/env bash
# webterm.sh — expose a browser terminal so a 3rd device can reach the phone
# over the web. Private to YOUR TAILNET by default (not the public internet).
#
#   AUTHORIZED / personal use. A web shell is a remote-code path — keep auth on,
#   keep it tailnet-only unless you fully understand the exposure.
set -euo pipefail

PORT="${PORT:-7681}"
WT_USER="${WT_USER:-op}"
WT_PASS="${WT_PASS:-}"

[[ -z "$WT_PASS" ]] && { echo "[!] set a password:  WT_PASS='strong-pass' $0"; exit 1; }
command -v ttyd >/dev/null || { echo "[*] installing ttyd…"; apt-get install -y -qq ttyd; }

# ttyd = a terminal over http, with basic auth
pkill -x ttyd 2>/dev/null || true
ttyd -p "$PORT" -c "$WT_USER:$WT_PASS" -t fontSize=15 -t 'theme={"background":"#000600"}' \
  zsh >/tmp/ttyd.log 2>&1 &
echo "[+] ttyd running on :$PORT  (user=$WT_USER)"

# expose to the TAILNET only — reachable by any device signed into your tailnet
if command -v tailscale >/dev/null; then
  tailscale serve --bg "http://localhost:$PORT" 2>/dev/null || \
    tailscale serve https / "http://localhost:$PORT" 2>/dev/null || true
  echo "[+] served on your tailnet:"
  tailscale serve status 2>/dev/null || true
  echo "[*] open that https URL on any device signed into your tailnet."
  echo "[!] PUBLIC exposure would use 'tailscale funnel' — only with auth, at your own risk."
else
  echo "[*] no tailscale — reachable at http://<phone-ip>:$PORT on the LAN only."
fi
