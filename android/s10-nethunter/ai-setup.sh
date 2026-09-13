#!/usr/bin/env bash
# ai-setup.sh — on-device / local AI for the S10 (Exynos 9820, 8GB RAM).
# Sets up Ollama + a small tool-capable model as a local backend, and points you
# at the tiny options (Cactus / Needle 2) and the Hermes agent harness.
# Run inside the Kali chroot.
set -euo pipefail

# --- Ollama: simplest local model runtime in the chroot ---
if ! command -v ollama >/dev/null; then
  echo "[*] installing Ollama…"
  curl -fsSL https://ollama.com/install.sh | sh
fi
ollama serve >/tmp/ollama.log 2>&1 &
sleep 3
# a small model that supports tool calling — fits an 8GB device
echo "[*] pulling a small tool-capable model (this is the big download)…"
ollama pull qwen2.5:1.5b || ollama pull llama3.2:1b || true
echo "[+] test it:  ollama run qwen2.5:1.5b 'hello'"

cat <<'EON'

[+] Local backend ready (Ollama on http://localhost:11434).

NEXT — pick your layer:

  • Cactus + Needle 2  (truly tiny, on-device tool calling)
      - Needle 2 = a 45M-param agentic model, ~14MB, runs in ~28MB RAM.
      - Cactus = the ARM-optimized inference engine (Exynos/Snapdragon kernels).
      - Repos:  github.com/cactus-compute/cactus  ·  github.com/cactus-compute/needle
      - Best for: fast, offline, structured tool-calls with almost no RAM cost.

  • Hermes Agent  ("the agent that grows with you")
      - An agent harness that wraps a local model with tools (files, shell, web)
        and improves via memory + learned skills.
      - Point it at your Ollama endpoint above.  Needs >=64k context — use a
        model/quant that supports it; the S10 will be slow but functional.
      - Repo:  github.com/NousResearch/hermes-agent

[!] On-device AI keeps prompts OFF the network — good for OPSEC, but the S10 is
    the slow end of the range. Use tiny models; offload heavy jobs to a PC.
EON
