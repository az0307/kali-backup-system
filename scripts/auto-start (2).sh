#!/bin/bash
# AUTO STARTUP - Runs scripts automatically on Kali boot
# Put in ~/.bashrc or use as desktop shortcut

echo "╔══════════════════════════════════════════════════════════╗"
echo "║       🐉 KALI RED TEAM AUTO START               ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check if we're in Kali
if [ ! -d "/media/sf_KaliShare" ] && [ ! -d "/mnt/sf_KaliShare" ]; then
    echo "⚠️  KaliShare not found! Mount it first."
    exit 1
fi

# Find KaliShare
KALI_SHARE=""
if [ -d "/media/sf_KaliShare" ]; then
    KALI_SHARE="/media/sf_KaliShare"
elif [ -d "/mnt/sf_KaliShare" ]; then
    KALI_SHARE="/mnt/sf_KaliShare"
fi

echo "Found KaliShare at: $KALI_SHARE"
echo ""

# Menu
echo "Choose:"
echo "  1. Install ALL tools (super-install)"
echo "  2. Install AI only (quick-ai-install)"
echo "  3. Activate WiFi (monitor-mode)"
echo "  4. Start Gemini CLI"
echo "  5. Just show status"
echo ""
read -p "Choice (1-5): " choice

case $choice in
    1)
        echo "Running super-install..."
        sudo bash "$KALI_SHARE/scripts/super-install.sh"
        ;;
    2)
        echo "Running AI install..."
        sudo bash "$KALI_SHARE/scripts/quick-ai-install.sh"
        ;;
    3)
        echo "Activating WiFi..."
        sudo bash "$KALI_SHARE/scripts/monitor-mode.sh"
        ;;
    4)
        gemini --prompt "hello"
        ;;
    5)
        echo "=== System Status ==="
        echo "RAM: $(free -h | grep Mem)"
        echo "Disk: $(df -h / | tail -1)"
        which gemini && echo "✅ Gemini installed" || echo "❌ Gemini not installed"
        which opencode && echo "✅ OpenCode installed" || echo "❌ OpenCode not installed"
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
