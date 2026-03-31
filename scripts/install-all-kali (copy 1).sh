#!/bin/bash
# Install all in Kali VM

# Run super-install
chmod +x /media/sf_KaliShare/scripts/super-install.sh
sudo bash /media/sf_KaliShare/scripts/super-install.sh

# Install Zenox
npm install -g zenox

# Copy skills
mkdir -p ~/.config/opencode/skills
cp -r /media/sf_KaliShare/skills/* ~/.config/opencode/skills/
cp -r /media/sf_KaliShare/gems/* ~/.config/opencode/skills/

# Install TARS
npm install -g @agent-tars/cli

# Start TARS
agent-tars web &
