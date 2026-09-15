#!/usr/bin/env bash
# tailscale-link.sh — join the NetHunter chroot to your tailnet + enable SSH so
# the PC (or a 3rd device) can reach the phone securely from anywhere.
#
# NOTE: the SIMPLE path for a device-level tailnet join is the Tailscale ANDROID
# app (NetHunter Store / F-Droid / Play). Use THIS script when you also want the
# Kali CHROOT and its services (ttyd, tools) reachable over the tailnet.
set -euo pipefail

if ! command -v tailscale >/dev/null; then
  echo "[*] installing Tailscale…"
  curl -fsSL https://tailscale.com/install.sh | sh
fi

# chroots usually have no TUN device → run tailscaled in userspace mode
if ! pgrep -x tailscaled >/dev/null; then
  echo "[*] starting tailscaled (userspace networking)…"
  tailscaled --tun=userspace-networking \
    --socks5-server=localhost:1055 \
    --state=/var/lib/tailscale/tailscaled.state >/tmp/tailscaled.log 2>&1 &
  sleep 3
fi

# --ssh lets tailnet peers SSH in via Tailscale's own auth
tailscale up --ssh --hostname nethunter-s10
echo "[+] joined tailnet. Phone on the tailnet:"
tailscale ip -4 || true

# also enable key-based openssh as a fallback (clone-pair with the PC key)
apt-get install -y -qq openssh-server
mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
echo "[*] paste the PC's public key (from pc-setup.sh) into ~/.ssh/authorized_keys"
echo "[+] then from the PC:  ssh kali@nethunter-s10   (or the tailscale IP)"
