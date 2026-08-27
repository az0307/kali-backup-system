# 07 · Device Setups — The Three-Device Fleet

> **Ultimate setup for a coordinated personal fleet.**
> One field rig, one daily driver, one AI brain — wired together so each does the
> job it is best at and hands off to the others.

⚠️ **Authorized use only.** Every offensive capability described here assumes you
own the target or hold **written permission** to test it. See `../../legal.md`.

---

## The Fleet at a Glance

| # | Device | Role | Codename | Ultimate-setup guide |
|---|--------|------|----------|----------------------|
| 1 | **Samsung Galaxy S10** | 📡 Field pentest rig — Kali NetHunter | `beyond1lte` | [`S10_KALI_NETHUNTER.md`](S10_KALI_NETHUNTER.md) |
| 2 | **Oppo phone** | 📱 Daily driver — comms, 2FA, light field client | ColorOS | [`OPPO_DAILY_DRIVER.md`](OPPO_DAILY_DRIVER.md) |
| 3 | **HP Mini G9** | 🧠 AI brain + command center — local LLMs, MCP mesh, SSH hub | `hp-mini-g9` | [`HP_MINI_G9_AI.md`](HP_MINI_G9_AI.md) |

## How they work together

```
                 ┌─────────────────────────────┐
                 │   HP MINI G9  (the brain)    │
                 │  Ollama / Open WebUI / MCP   │
                 │  Claude Code · OpenCode      │
                 │  SSH hub · Syncthing server  │
                 └───────┬───────────────┬──────┘
              SSH / API  │               │  Syncthing / SSH
                 ┌───────▼──────┐  ┌─────▼─────────┐
                 │  S10         │  │  OPPO         │
                 │  NetHunter   │  │  daily driver │
                 │  field ops   │  │  2FA · comms  │
                 └──────────────┘  └───────────────┘
```

- **S10** runs scans/captures in the field, streams results to the HP Mini for
  AI triage (HexStrike / local LLM), and pulls wordlists from the Mini over SSH.
- **Oppo** is the *clean* device: banking, 2FA, messaging, and a read-only
  dashboard of fleet status. It never touches offensive payloads.
- **HP Mini G9** is always-on: hosts local models, the MCP server mesh, wordlists,
  loot storage, and Syncthing so the other two stay in sync.

## Recommended build order

1. **HP Mini G9 first** — it becomes the hub the phones talk to. → guide 3
2. **Oppo second** — quick, non-root; gives you a trusted control surface. → guide 2
3. **S10 last** — most involved (unlock → root → NetHunter). → guide 1

## Shared conventions

| Thing | Value |
|-------|-------|
| Fleet subnet (example) | `192.168.50.0/24` |
| HP Mini G9 static IP | `192.168.50.10` |
| S10 static IP | `192.168.50.20` |
| Oppo static IP | `192.168.50.30` |
| Sync tool | Syncthing (loot, notes, wordlists) |
| Secrets | Bitwarden / `pass` — **never** commit keys (see repo `.gitignore`) |
| Remote access | Tailscale mesh VPN across all three |

Each guide is self-contained; start with the one for the device in your hand.
