#!/usr/bin/env bash
# newengagement.sh — scaffold a clean, auditable engagement workspace.
# Creates a loot/recon/evidence/notes tree, a SCOPE.md guard, and a Markdown
# report template. One folder per engagement keeps work separated and auditable.
#
# usage:  ./newengagement.sh acme-external
set -euo pipefail

NAME="${1:-}"
[[ -z "$NAME" ]] && { echo "usage: $0 <engagement-name>"; exit 1; }

ROOT="engagements/${NAME}_$(date +%Y%m%d)"
[[ -e "$ROOT" ]] && { echo "[!] $ROOT already exists — pick another name"; exit 1; }
mkdir -p "$ROOT"/{recon,loot,evidence,notes,exploits,reports}

# --- scope guard: fill this in BEFORE you touch anything ---
cat > "$ROOT/SCOPE.md" <<EOF
# Scope — $NAME

Authorized by      :
Date authorized    :
Engagement window  :
In-scope (hosts/domains/CIDRs) :
Out-of-scope       :
Rules of engagement:
Emergency contact  :

> If a target isn't listed in-scope above, it is out of scope. No exceptions.
EOF

# --- report template ---
cat > "$ROOT/reports/report.md" <<'EOF'
# <Engagement> — Findings Report

## Executive summary

## Scope & methodology

## Findings

### [CRITICAL | HIGH | MEDIUM | LOW] <title>
- **Affected:**
- **Description:**
- **Impact:**
- **Evidence:** (see ../evidence/)
- **Remediation:**

## Appendix — tooling & timeline
EOF

echo "Authorized targets only. Everything here stays inside SCOPE.md." \
  > "$ROOT/notes/README.txt"

echo "[+] scaffolded $ROOT"
find "$ROOT" -maxdepth 2 -mindepth 1 | sort
echo
echo "[*] next: fill in $ROOT/SCOPE.md before you start."
