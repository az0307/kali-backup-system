# 🧠 HP Mini G9 — Ultimate AI Brain + Command Center

> The always-on hub. Local LLMs, the MCP server mesh, the SSH/loot/wordlist hub,
> and your general daily Linux workstation. The S10 and Oppo both lean on this box.
>
> Applies to the **HP Pro/Elite Mini 600/800 G9** family (Intel 12th/13th‑gen,
> DDR5, NVMe). Tune model sizes to your actual RAM.

---

## 0. Recommended spec targets

| Component | Minimum | Sweet spot | Why |
|-----------|---------|-----------|-----|
| CPU | i5‑12500T | i7‑13700T | more cores = faster CPU inference |
| RAM | 16 GB | **32–64 GB** | 32 GB runs 8B–14B models comfortably |
| Storage | 512 GB NVMe | 1–2 TB NVMe | models + wordlists + loot are big |
| GPU | iGPU (Arc/UHD) | eGPU or none | most local models here run CPU/iGPU |
| Network | 1 GbE | 2.5 GbE + Wi‑Fi 6E | it's the hub — wire it in |

> No discrete NVIDIA GPU in most Mini G9s. Plan around **CPU/iGPU inference**
> (Ollama, llama.cpp, GGUF quantized models). A 7–8B Q4 model is very usable;
> 13–14B works with 32 GB+; skip 70B unless you add an eGPU.

---

## 1. OS strategy — pick one

| Option | Setup | Best when |
|--------|-------|-----------|
| **A. Ubuntu host + Kali in Docker/VM** ✅ recommended | Stable daily OS, Kali when needed | AI brain that occasionally does security work |
| **B. Kali bare metal** | Kali as daily driver | You live in Kali and want tools native |
| **C. Dual-boot Ubuntu / Kali** | GRUB picks at boot | Clean separation, more admin |

This guide assumes **Option A** (Ubuntu 24.04 LTS host). The provisioning script
`scripts/setup-hp-mini-g9.sh` automates most of what follows.

```bash
# BIOS first: F10 at boot →
#   - Enable virtualization (VT-x/VT-d) for VMs/Docker
#   - Secure Boot: off if you'll flash custom kernels / DKMS drivers
#   - Set the fan/power profile to "Performance" for sustained inference
```

---

## 2. Base system

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y build-essential git curl wget htop btop tmux \
     python3 python3-pip python3-venv pipx ca-certificates gnupg lsb-release \
     openssh-server ufw fail2ban unattended-upgrades

# Static identity on the fleet
sudo hostnamectl set-hostname hp-mini-g9
# Set 192.168.50.10/24 via Netplan or nmcli (see fleet README)
```

---

## 3. The AI stack (the "brain")

### 3a. Ollama — local model runtime
```bash
curl -fsSL https://ollama.com/install.sh | sh
sudo systemctl enable --now ollama

# Pull a practical spread (adjust to RAM):
ollama pull llama3.1:8b          # general workhorse
ollama pull qwen2.5-coder:7b     # coding
ollama pull mistral-nemo         # 12B, strong reasoning (needs ~24GB)
ollama pull nomic-embed-text     # embeddings for RAG

# Expose to the fleet (S10/Oppo hit it over Tailscale):
echo 'OLLAMA_HOST=0.0.0.0:11434' | sudo tee /etc/systemd/system/ollama.service.d/host.conf >/dev/null
sudo systemctl daemon-reload && sudo systemctl restart ollama
```

### 3b. Open WebUI — the chat front-end (bookmarked from the Oppo)
```bash
# Docker (see §4 for Docker install)
docker run -d --name open-webui --restart always \
  -p 3000:8080 \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
# → http://192.168.50.10:3000
```

### 3c. Coding agents (this org's stack)
```bash
# Node LTS (for Claude Code / OpenCode)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

npm install -g @anthropic-ai/claude-code   # Claude Code CLI
# OpenCode + Gemini CLI per this repo's docs/02_TOOLS + docs/01_GETTING_STARTED
```

Cross-reference the existing repo docs so you don't reinvent them:
- `../02_TOOLS/AI_TOOLS_GUIDE.md` · `../06_REFERENCE/AI_IN_KALI.md`
- `../06_REFERENCE/AI-MODELS-PARROT-KALI.md` (model sizing on Kali/Parrot)

---

## 4. Docker + the MCP mesh

```bash
# Docker Engine
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"   # re-login after
```

This repo already ships MCP configs (`../../mcp/`). The Mini is where they *run*:

```bash
# Point your MCP clients at the local Ollama + repo MCP servers
ls ../../mcp/                     # server configs live here
# Wire n8n / AutoBoros / MCP bridge here so the phones call one endpoint.
```

Related org repos to co-locate on this box (they assume a hub like this):
`meta-automation-hub`, `n8n-nodes-mcp`, `desktopcommandermcp`, `compose`.

---

## 5. Security tooling (when it wears the Kali hat)

```bash
# Option A: Kali in Docker for on-demand tools
docker run -it --rm --name kali \
  -v ~/loot:/loot kalilinux/kali-rolling \
  bash -c "apt update && apt install -y kali-linux-headless && bash"

# HexStrike as the fleet's AI-red-team endpoint (S10 sends captures here)
# → see ../02_TOOLS/hexstrike-integration.md
# hashcat cracking runs HERE (real CPU cores), not on the phone:
sudo apt install -y hashcat
hashcat -m 22000 capture.hc22000 /usr/share/wordlists/rockyou.txt
```

Host the **wordlists** here and let the S10 pull them:
```bash
sudo apt install -y seclists
sudo mkdir -p /srv/wordlists && sudo cp -r /usr/share/wordlists/* /srv/wordlists/
# Shared over SSH/Syncthing to the field rig.
```

---

## 6. Hub services (what makes it the center)

```bash
# SSH hub (keys only)
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Syncthing — loot / notes / wordlists across the fleet
sudo apt install -y syncthing
systemctl --user enable --now syncthing   # GUI at http://127.0.0.1:8384

# Tailscale — mesh VPN so phones reach the brain anywhere
curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up

# Firewall — open only what the fleet needs
sudo ufw default deny incoming
sudo ufw allow 22/tcp             # SSH
sudo ufw allow from 192.168.50.0/24 to any port 11434 proto tcp   # Ollama (LAN only)
sudo ufw allow from 192.168.50.0/24 to any port 3000  proto tcp   # Open WebUI
sudo ufw allow 22000              # Syncthing
sudo ufw enable
```

---

## 7. General / daily workstation

- Desktop apps: browser, VS Code, Obsidian, LibreOffice, Bitwarden.
- `unattended-upgrades` + `fail2ban` keep an always-on box safe.
- **Backups**: `restic` or Timeshift → external NVMe; `/srv`, `~/loot`, and
  `~/.ollama` are the crown jewels.
- Power: set the BIOS + `tlp`/`power-profiles-daemon` to run flat-out — it's a
  desktop mini, not a laptop; you want sustained clocks for inference.

```bash
sudo apt install -y restic timeshift
```

---

## 8. Provisioning script

Run the automated setup and skip most of §2–§6:

```bash
bash scripts/setup-hp-mini-g9.sh          # full run
bash scripts/setup-hp-mini-g9.sh --help   # see stages
bash scripts/setup-hp-mini-g9.sh --ai-only # just the LLM stack
```

## Quick checklist

- [ ] BIOS: VT-x/VT-d on, performance power profile
- [ ] Ubuntu 24.04 host, hostname `hp-mini-g9`, static `192.168.50.10`
- [ ] Ollama serving on `0.0.0.0:11434` + models pulled
- [ ] Open WebUI on `:3000` (bookmarked from the Oppo)
- [ ] Claude Code / OpenCode / Gemini installed
- [ ] Docker + MCP mesh + HexStrike endpoint up
- [ ] SSH (keys only) · Syncthing · Tailscale · UFW locked to the fleet subnet
- [ ] Wordlists in `/srv/wordlists`, loot in `~/loot`, backups running
