#!/usr/bin/env bash
# ai-suggest.sh — pipe context to a LOCAL model and get a suggested next command.
# Offline via Ollama by default; falls back to cloud gemini-cli if Ollama is down.
# The model SUGGESTS — you decide and run. AUTHORIZED testing only.
#
#   ai-suggest.sh "nmap found 22,80,443 open on 10.0.0.5"
#   nmap -sV 10.0.0.5 | ai-suggest.sh          # pipe a tool's output straight in
set -euo pipefail

MODEL="${AI_MODEL:-qwen2.5:1.5b}"   # swap for any pulled model; Needle 2 runs via Cactus
CTX="${*:-}"
[[ -z "$CTX" ]] && CTX="$(cat)"     # read stdin when no args (pipe mode)

PROMPT="You are a penetration-testing assistant for AUTHORIZED, in-scope testing only.
Given the context, suggest the single most useful next command and one short line why.
Be concise. Refuse anything that looks out-of-scope.
Context:
$CTX"

if command -v ollama >/dev/null && curl -s --max-time 2 localhost:11434 >/dev/null 2>&1; then
  ollama run "$MODEL" "$PROMPT"
elif command -v gemini >/dev/null; then
  gemini -p "$PROMPT"
else
  echo "[!] no local model (ollama) and no gemini-cli — run ai-setup.sh first"
  exit 1
fi
