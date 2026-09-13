#!/usr/bin/env bash
# recon.sh — passive→active web recon chain for ONE authorized target.
# subfinder → httpx → nuclei, with organized, timestamped output.
#
#   AUTHORIZED TARGETS ONLY. Run only against domains you own or have
#   written permission to assess. You are responsible for scope.
#
# usage:  ./recon.sh example.com
set -euo pipefail

DOMAIN="${1:-}"
if [[ -z "$DOMAIN" ]]; then
  echo "usage: $0 <domain>    e.g. $0 example.com"; exit 1
fi

# one folder per run, so nothing overwrites and every engagement is auditable
OUT="loot/${DOMAIN}/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"
echo "[*] recon → $OUT"

# 1) passive subdomain enumeration (no packets to the target yet)
echo "[*] subfinder — enumerating subdomains…"
subfinder -d "$DOMAIN" -all -silent | sort -u > "$OUT/subs.txt"
echo "    $(wc -l < "$OUT/subs.txt") subdomains found"

# 2) probe which resolve + answer HTTP/S; grab status, title, tech, server
echo "[*] httpx — finding live hosts…"
httpx -l "$OUT/subs.txt" -silent -follow-redirects \
      -status-code -title -tech-detect -web-server \
      -o "$OUT/alive.txt"
awk '{print $1}' "$OUT/alive.txt" | sort -u > "$OUT/urls.txt"
echo "    $(wc -l < "$OUT/urls.txt") live hosts"

# 3) nuclei — templated vuln/exposure scan against the LIVE list only
echo "[*] nuclei — scanning (this is the loud part)…"
nuclei -l "$OUT/urls.txt" \
       -severity low,medium,high,critical \
       -rl 50 -c 25 \
       -o "$OUT/nuclei.txt" || true

echo
echo "[+] done."
echo "    subdomains : $OUT/subs.txt"
echo "    live hosts : $OUT/alive.txt"
echo "    findings   : $OUT/nuclei.txt"
