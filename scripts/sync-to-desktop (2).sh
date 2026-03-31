#!/bin/bash
# ====================================================================
# Sync Tools to Desktop
# Sync all tools and scripts from laptop to desktop
# ====================================================================

DESKTOP="192.168.1.200"
USER="root"

echo "=== Syncing Tools to Desktop ==="

echo "[1/4] Syncing tools..."
rsync -avz /opt/tools/ $USER@$DESKTOP:/opt/tools/

echo "[2/4] Syncing scripts..."
rsync -avz ~/scripts/ $USER@$DESKTOP:/root/scripts/

echo "[3/4] Syncing configs..."
rsync -avz ~/.bashrc $USER@$DESKTOP:/root/
rsync -avz ~/.ssh/ $USER@$DESKTOP:/root/.ssh/

echo "[4/4] Syncing skills..."
rsync -avz ~/.config/opencode/skills/ $USER@$DESKTOP:/root/.config/opencode/skills/

echo ""
echo "=== Sync Complete ==="
