# HP Mini — the bridge / companion PC (research)

The S10 rig offloads the heavy work (7B+ models, GPU cracking, BloodHound/Caido)
to a paired PC over Tailscale (see `pc-setup.sh`). An **HP Pro/Elite Mini** is a
strong fit: tiny, quiet, low-power, Ubuntu-certified, and cheap on the used market.

## HP Pro Mini 400 G9  (budget pick)
- **CPU:** Intel 12th/13th/14th Gen (Q670 chipset); review units run i5-14500T. "T" = low-power.
- **RAM:** DDR4-3200, **up to 64 GB** (2 SO-DIMM).
- **OS:** Win 11 / FreeDOS from factory; **Ubuntu-certified**; Linux Mint reported working.
- **Why:** cheapest capable mini; DDR4 keeps used prices low. Great as a redirector / model host.

## HP Elite Mini 800 G9  (performance pick)
- **CPU:** Intel 12th/13th/14th Gen up to **i9-14900**; review units i5-14500 / i9.
- **RAM:** **DDR5-5600, up to 64 GB.**
- **OS:** Win 11 / FreeDOS; **Ubuntu-certified**; modular, easy to service.
- **Why:** DDR5 + i7/i9 options run bigger local models and parallel cracking far better.

## Which to buy
| Use | Pick |
|-----|------|
| Redirector / VPN jump box / light model host | **Pro Mini 400 G9** (i5-T, 16–32 GB) |
| Local 7B–14B models, hashcat CPU, BloodHound, Caido | **Elite Mini 800 G9** (i7/i9, 32–64 GB DDR5) |

## Realistic notes
- Neither has a discrete GPU — hashcat is **CPU-only** here too. For serious cracking, add an
  eGPU or use a separate GPU box; the Mini is best as a redirector + model/orchestration host.
- Both are Ubuntu-certified; run Kali or Ubuntu + Docker for the offload tools.
- Pair it: `pc-setup.sh` installs adb + Tailscale + the SSH key; the S10 reaches it by tailnet name.

## Your config: 16 GB RAM + 500 GB SSD — what it unlocks

This is a solid "heavy half" for the rig. Realistic ceiling: **7B–14B local models, Docker
stacks, BloodHound, big wordlists + a few lab VMs.** NOT 70B models or GPU cracking (no dGPU).

Where each part of the build gets better once the Mini is paired over Tailscale:

| System part | On the S10 alone | Enhanced on the 16GB/500GB Mini |
|-------------|------------------|----------------------------------|
| **On-device AI** | tiny only: Needle 2, 1–2B, slow | **7B–8B comfortably, 14B (short ctx)**. Run Ollama here; point `ai-suggest.sh` at it via `AI_MODEL` + `OLLAMA_HOST=http://<mini-tailscale-ip>:11434`. This is what finally makes **Hermes Agent** (needs ≥64k ctx) usable. |
| **Password cracking** | none (no GPU, weak CPU) | **hashcat/john CPU cracking**, far faster; 500 GB holds rockyou + full SecLists + weakpass + rules. Capture on phone (`wifi-audit.sh`) → crack on Mini. |
| **Recon at scale** | fine for one target | run nuclei/katana across **big scopes** without draining the phone; trigger from the phone over SSH. |
| **AD / heavy tools** | can't realistically | **BloodHound CE + Neo4j, Certipy, Caido, Burp** — 16 GB is enough for moderate AD graphs + a browser. |
| **Home lab** | none | 500 GB SSD hosts **practice VMs** (Metasploitable, DVWA, a small AD lab) to train against safely. |
| **Backups & loot** | SD card only | Mini = **off-device backup target + encrypted loot archive** (age vault syncs here over the tailnet). |
| **Egress / OpSec** | phone VPN only | Mini as a **Tailscale exit node / redirector** — cleaner, controllable egress; phone routes through it. |

### Watch the two limits (be honest with the config)
- **16 GB is the gate for models:** 7–8B (Q4) leaves room for long context; 14B (Q4 ~9 GB) only with
  short context + nothing else open. No 30B/70B. Plenty for tool-calling + recon assist.
- **500 GB fills fast:** SecLists (~1 GB), a couple of VMs (20–40 GB each), loot archive, chroot
  backups. Budget it — keep VMs lean, prune old snapshots, put bulk wordlists on an external drive if needed.

### Concrete first steps once you have it
1. Install Ubuntu/Kali → `bash pc-setup.sh` (adb + Tailscale + SSH key; pair with the phone).
2. `curl -fsSL https://ollama.com/install.sh | sh` → `ollama pull qwen2.5:7b` (or `llama3.1:8b`).
3. On the phone: `AI_MODEL=qwen2.5:7b OLLAMA_HOST=http://<mini-ip>:11434 ai-suggest.sh "..."`.
4. Docker for the heavy tools: BloodHound CE, Caido; store wordlists + VMs on the 500 GB.

Sources: HP QuickSpecs (Pro 400 G9 / Elite 800 G9), Notebookcheck reviews, Ubuntu certification pages.
