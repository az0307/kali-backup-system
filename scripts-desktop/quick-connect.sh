#!/bin/bash
set -euo pipefail

read -r -p "Wi-Fi network name: " ssid
if [[ -z "$ssid" ]]; then
  echo "Network name is required." >&2
  exit 1
fi
nmcli --ask device wifi connect "$ssid"
