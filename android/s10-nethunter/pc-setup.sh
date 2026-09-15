#!/usr/bin/env bash
# pc-setup.sh — set up a Linux PC to work with the NetHunter phone.
# Installs adb/fastboot, Tailscale, age, and an SSH key to pair with the phone.
# Debian / Ubuntu / Kali. (Windows & macOS: see the guide's PC tab.)
set -euo pipefail

echo "[*] installing platform-tools + deps…"
sudo apt-get update -qq
sudo apt-get install -y -qq android-tools-adb android-tools-fastboot \
  openssh-client curl age

# --- Tailscale (secure mesh between PC and phone) ---
if ! command -v tailscale >/dev/null; then
  echo "[*] installing Tailscale…"
  curl -fsSL https://tailscale.com/install.sh | sh
fi
sudo tailscale up
echo "[+] Tailscale up. This PC on the tailnet:"
tailscale ip -4 || true

# --- SSH keypair to pair with the phone (clone-pair) ---
KEY="$HOME/.ssh/nh_ed25519"
[[ -f "$KEY" ]] || ssh-keygen -t ed25519 -N "" -f "$KEY" -C "pc->nethunter"
echo
echo "[+] PC public key — add this to the phone's ~/.ssh/authorized_keys:"
echo "----------------------------------------------------------------"
cat "$KEY.pub"
echo "----------------------------------------------------------------"
echo "[*] then connect:  ssh -i $KEY kali@<phone-tailscale-ip>"
echo "[+] verify the phone is visible:  tailscale status"
