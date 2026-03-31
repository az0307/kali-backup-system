#!/bin/bash
# privesc-win.ps1 - Windows privilege escalation checker
# Usage: ./privesc-win.ps1

echo "=== Windows Privilege Escalation Check ==="

echo "[1/6] User & privileges..."
whoami /all > privesc.txt

echo "[2/6] Running services..."
wmic service get name,startname,state >> privesc.txt

echo "[3/6] Scheduled tasks..."
schtasks /query /fo LIST /v >> privesc.txt

echo "[4/6] Network connections..."
netstat -ano >> privesc.txt

echo "[5/6] Installed software..."
wmic product get name,version >> privesc.txt

echo "[6/6] Registry auto-run..."
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> privesc.txt

echo "=== Done. Results in privesc.txt ==="