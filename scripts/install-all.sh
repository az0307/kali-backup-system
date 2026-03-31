#!/bin/bash
# MASTER INSTALL - Runs ALL stages
# Run: sudo bash install-all.sh

export DEBIAN_FRONTEND=noninteractive

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     KALI RED TEAM INSTALLER                 ║"
echo "╚══════════════════════════════════════════════════════════╝"

KALI_SHARE=""
if [ -d "/media/sf_KaliShare" ]; then
    KALI_SHARE="/media/sf_KaliShare"
elif [ -d "/mnt/sf_KaliShare" ]; then
    KALI_SHARE="/mnt/sf_KaliShare"
else
    echo "KaliShare not found!"
    exit 1
fi

cd "$KALI_SHARE/scripts"

echo "Installing Stage 1: Core Tools..."
bash setup-stage1-core.sh || true

echo "Installing Stage 2: AI Tools..."
bash setup-stage2-ai.sh || true

echo "Installing Stage 3: Resources..."
bash setup-stage3-resources.sh || true

echo "Installing Stage 4: Network..."
bash setup-stage4-network.sh || true

echo "Installing Stage 5: Productivity..."
bash setup-stage5-productivity.sh || true

# Copy skills
mkdir -p ~/.config/opencode/skills
cp -r "$KALI_SHARE/skills"/* ~/.config/opencode/skills/ 2>/dev/null || true
cp -r "$KALI_SHARE/gems"/* ~/.config/opencode/skills/ 2>/dev/null || true

echo ""
echo "✅ DONE!"
echo ""
echo "Use: gemini --prompt 'help'"
