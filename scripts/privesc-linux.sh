#!/bin/bash
# privesc-linux.sh - Linux privilege escalation checker
# Usage: ./privesc-linux.sh

echo "=== Linux Privilege Escalation Check ==="

echo "[1/8] System info..."
uname -a > privesc.txt
echo "=== System ===" >> privesc.txt
cat /etc/*release >> privesc.txt

echo "[2/8] User info..."
echo "=== Users ===" >> privesc.txt
id >> privesc.txt
whoami >> privesc.txt

echo "[3/8] Sudo permissions..."
echo "=== Sudo ===" >> privesc.txt
sudo -l 2>/dev/null >> privesc.txt

echo "[4/8] Running processes..."
echo "=== Processes ===" >> privesc.txt
ps aux >> privesc.txt

echo "[5/8] Network connections..."
echo "=== Network ===" >> privesc.txt
netstat -tunp 2>/dev/null >> privesc.txt

echo "[6/8] SUID binaries..."
echo "=== SUID ===" >> privesc.txt
find / -perm -4000 2>/dev/null >> privesc.txt

echo "[7/8] Cron jobs..."
echo "=== Cron ===" >> privesc.txt
ls -la /etc/cron* 2>/dev/null >> privesc.txt

echo "[8/8] Writable files..."
echo "=== Writable ===" >> privesc.txt
find / -writable -type f 2>/dev/null | head -50 >> privesc.txt

echo "=== Done. Results in privesc.txt ==="
wc -l privesc.txt