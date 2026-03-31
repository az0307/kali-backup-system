#!/bin/bash
# System Information Script

echo "╔══════════════════════════════════════════════════════╗"
echo "║            SYSTEM INFORMATION                       ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

echo "=== HOSTNAME & USER ==="
hostname
echo "User: $(whoami)"
echo "UID: $(id -u)"
echo ""

echo "=== OPERATING SYSTEM ==="
cat /etc/os-release | grep -E "NAME|VERSION|PRETTY"
echo ""

echo "=== KERNEL ==="
uname -a
echo ""

echo "=== CPU INFO ==="
lscpu | grep -E "Model name|CPU\(s\)|Thread|Core|Socket"
echo ""

echo "=== MEMORY ==="
free -h
echo ""

echo "=== DISK SPACE ==="
df -h | grep -E "^/dev|Filesystem"
echo ""

echo "=== NETWORK INTERFACES ==="
ip addr show
echo ""

echo "=== ROUTING ==="
ip route show
echo ""

echo "=== DNS SERVERS ==="
cat /etc/resolv.conf 2>/dev/null | grep nameserver
echo ""

echo "=== USB DEVICES ==="
lsusb
echo ""

echo "=== PCI DEVICES ==="
lspci | grep -iE "network|wireless|ethernet|vg|display"
echo ""

echo "=== RUNNING SERVICES ==="
systemctl list-units --type=service --state=running | head -20
echo ""

echo "=== OPEN PORTS ==="
ss -tulpn | grep LISTEN
echo ""

echo "=== MOUNTED FILESYSTEMS ==="
mount | grep -E "^/dev"
echo ""

echo "=== ENVIRONMENT VARIABLES (Key) ==="
env | grep -iE "PATH|HOME|USER|SSH|FTP|HTTP|PROXY" | head -10
