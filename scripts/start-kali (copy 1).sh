#!/bin/bash
# Kali VM Startup with Safety Checks
# Run on Windows with VirtualBox installed

VM_NAME="Kali-Linux-Wireless"
VBOX="C:/Program Files/Oracle/VirtualBox/VBoxManage.exe"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║         KALI VM STARTUP - Safety Check                 ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check VirtualBox exists
echo "[1/5] Checking VirtualBox..."
if [ ! -f "$VBOX" ]; then
    echo "❌ VirtualBox not found at: $VBOX"
    echo "   Install VirtualBox from: https://www.virtualbox.org/"
    exit 1
fi
echo "✅ VirtualBox found"

# Check VM exists
echo "[2/5] Checking VM..."
$VBOX list vms | grep -q "$VM_NAME"
if [ $? -ne 0 ]; then
    echo "❌ VM '$VM_NAME' not found!"
    echo "   Available VMs:"
    $VBOX list vms
    exit 1
fi
echo "✅ VM '$VM_NAME' found"

# Check VM settings
echo "[3/5] Checking VM settings..."
RAM=$($VBOX showvminfo "$VM_NAME" --details 2>/dev/null | grep "Memory size:" | awk '{print $3}')
CPUS=$($VBOX showvminfo "$VM_NAME" --details 2>/dev/null | grep "Number of CPUs:" | awk '{print $4}')

echo "   CPUs: $CPUS"
echo "   RAM: ${RAM}MB"

# Safety checks
if [ "$CPUS" -gt 2 ]; then
    echo "⚠️  WARNING: Using $CPUS CPUs (recommend 2)"
fi

if [ "$RAM" -gt 6144 ]; then
    echo "⚠️  WARNING: Using ${RAM}MB RAM (recommend 4-6GB max)"
fi

if [ "$CPUS" -gt 2 ] || [ "$RAM" -gt 6144 ]; then
    echo ""
    echo "To fix, run:"
    echo "  VBoxManage modifyvm \"$VM_NAME\" --cpus 2"
    echo "  VBoxManage modifyvm \"$VM_NAME\" --memory 4096"
fi

# Check host resources
echo ""
echo "[4/5] Checking host system..."

if [ "$(uname)" = "Darwin" ]; then
    # macOS
    FREE_RAM=$(vm_stat | grep "Pages free:" | awk '{print $3}' | tr -d '.')
    FREE_RAM_MB=$((FREE_RAM * 4096 / 1024 / 1024))
elif [ "$(uname)" = "Linux" ]; then
    # Linux (Git Bash on Windows might not have this)
    FREE_RAM_MB=$(free -m 2>/dev/null | grep Mem | awk '{print $7}' || echo "unknown")
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows - use PowerShell
    FREE_RAM_MB=$(powershell -Command "(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024" 2>/dev/null || echo "unknown")
fi

echo "   Free RAM: ${FREE_RAM_MB}MB"

if [ "$FREE_RAM_MB" != "unknown" ] && [ "$FREE_RAM_MB" -lt 4000 ]; then
    echo "⚠️  WARNING: Low RAM on host! Consider closing apps."
fi

# Check USB for wireless adapter
echo ""
echo "[5/5] USB devices (for wireless adapter)..."
echo "   After starting VM, check USB device is connected:"
echo "   Devices → USB → TP-Link TL-WN721N"
echo ""

# Ask user to proceed
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Ready to start VM!                                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Starting '$VM_NAME'..."
echo ""

# Start VM
"$VBOX" startvm "$VM_NAME"

echo ""
echo "✅ VM Started!"
echo ""
echo "NEXT STEPS:"
echo "1. Login: root / toor"
echo "2. Connect USB WiFi adapter to VM (Devices → USB)"
echo "3. Run: sudo airmon-ng start wlan0"
echo ""
echo "To stop: VBoxManage controlvm \"$VM_NAME\" poweroff"
