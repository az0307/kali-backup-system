# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> A repo-specific `AGENTS.md` already exists with coding guidelines — read it too. This file summarizes structure and workflow; where they overlap, `AGENTS.md` is authoritative on shell conventions.

## Project Overview

**kali-backup-system** (a.k.a. KaliShare) is a large **home-lab penetration-testing toolkit** for Kali Linux: a staged installer, WiFi pentesting helpers, Windows password-reset utilities, AI-tool integrations (Claude, OpenCode, Gemini, HexStrike), reference "bibles", agent definitions, and automated multi-step "chain" workflows. It is designed to run from a mounted USB / shared folder on a Kali VM or host.

The repo is **bash/batch scripts + Markdown knowledge bases + JSON/config**, ~900+ files. There is no compiled application. Many files have `(2)` duplicates — historical copies; prefer the non-`(2)` version as canonical.

> Authorized security testing and education only. All offensive tooling here assumes you have written permission for the target.

## Directory Map

```
scripts/         Staged installers + operational scripts (setup-stage1..5, start-kali.sh, monitor-mode.sh, ...)
scripts-desktop/ Desktop-variant scripts
cli/ tui/        Command-line and terminal-UI front ends (MENU, QUICK-START.sh)
agents/          Red-team / dev / monitor / orchestrator agent definitions (Markdown)
chains/          Multi-step automated workflow definitions
skills/          Skill definitions
bibles/          Knowledge bases — blue-team/ (forensics, IR, SIEM, malware, log/network) and red-team refs
claude/ gemini/ opencode/ tars/ gems/   AI-tool integrations & configs
mcp/             MCP server configs/integration
config/          Dotfiles and tool configuration
android/         Mobile helpers (kalishare-mobile.py, setup-mobile.sh)
wifi-passwords/  WiFi utilities/resources
desktop/ references/ docs/   Docs, references, desktop assets
simple-cdd/      Custom Debian/Kali build definitions
QUICK-START.sh, aliases.sh, autorun.inf/.ico   USB bootstrap
```

## Install / Usage (from README)

```bash
# From the USB / shared-folder mount:
cd /mnt/sf_KaliShare/scripts && chmod +x *.sh

sudo ./start-kali.sh              # safe VM startup with checks
# Staged install (run in order; login root/toor):
sudo ./setup-stage1-core.sh       # core tools
sudo ./setup-stage2-ai.sh         # AI tools (Claude, OpenCode, Gemini, HexStrike)
sudo ./setup-stage3-resources.sh  # wordlists & resources
sudo ./setup-stage4-network.sh    # remote access
sudo ./setup-stage5-productivity.sh   # optional
sudo ./monitor-mode.sh            # activate WiFi adapter monitor mode
```

## Development / Validation

Most tools require root. There is no build; validate scripts before running:

```bash
bash -n script.sh                 # syntax check (no execution)
shellcheck scripts/*.sh           # lint (apt-get install shellcheck)
shellcheck -s bash -x scripts/menu.sh
```

## Conventions

- **Follow `AGENTS.md`** for shell style, testing, and PR guidance — it is the primary coding guideline for this repo.
- Prefer editing the canonical file, not its `(2)` duplicate; avoid creating new `(2)` copies.
- Keep the staged-installer ordering intact (stage1 → stage5); scripts assume earlier stages ran.
- Never commit secrets, captured credentials, WiFi handshakes, or engagement data. Note `wifi-passwords/` is for lab material only.
- New agents/chains/skills go in their respective top-level directory following the Markdown format already used there.

## Related Repos

- `KaliShare` — public stub/landing repo for this toolkit.
- `specter` — leaner production-hardened Kali overlay (shell + AI wrappers).
- `april-redteam-2026` — red-team MCP server stack + playbook index.
