#!/bin/bash
# ====================================================================
# KALI SHARE MOBILE SETUP SCRIPT
# Run this in Termux on Android to setup connection to KaliShare
# ====================================================================

echo -e "\033[1;32m╔══════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║         KALI SHARE MOBILE SETUP v1.0                ║\033[0m"
echo -e "\033[1;32m╚══════════════════════════════════════════════════════╝\033[0m"
echo ""

echo "This script sets up your Android (Termux) to connect to KaliShare USB"
echo ""

# Update and install Python
echo -e "\033[1;33m[*]\033[0m Updating Termux and installing Python..."
pkg update -y
pkg upgrade -y
pkg install -y python python3-pip

# Install required packages
echo -e "\033[1;33m[*]\033[0m Installing required packages..."
pip install --upgrade pip
pip install paramiko cryptography

# Download the connector script
echo -e "\033[1;33m[*]\033[0m Downloading KaliShare Mobile Connector..."
mkdir -p ~/KaliShare
cd ~/KaliShare

# Create the connector script
cat > kalishare-connect.py << 'ENDPYTHON'
#!/usr/bin/env python3
import os, sys, socket, time

HOST = "192.168.1.100"
PORT = 22
USER = "root"
PASS = "toor"

def log(msg):
    print(f"[*] {msg}")

def send_cmd(sock, cmd):
    sock.send((cmd + "\n").encode())
    time.sleep(0.5)
    response = b""
    while True:
        data = sock.recv(4096)
        if not data:
            break
        response += data
        if b"$ " in data or b"# " in data:
            break
    return response.decode()

def connect():
    log(f"Connecting to {HOST}:{PORT}...")
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(10)
        sock.connect((HOST, PORT))
        
        # Read initial prompt
        sock.recv(2048)
        
        # Login
        sock.send((USER + "\n").encode())
        time.sleep(0.3)
        sock.recv(1024)
        
        sock.send((PASS + "\n").encode())
        time.sleep(0.3)
        resp = sock.recv(1024)
        
        if "Permission denied" in resp.decode():
            log("Wrong password!")
            return None
            
        log("Connected!")
        return sock
    except Exception as e:
        log(f"Failed: {e}")
        return None

def main():
    print("""
    ╔═══════════════════════════════════╗
    ║   KALI SHARE CONNECTOR (Simple)  ║
    ╚═══════════════════════════════════╝
    """)
    
    host = input(f"Host IP [{HOST}]: ").strip() or HOST
    user = input(f"Username [{USER}]: ").strip() or USER
    password = input(f"Password [{PASS}]: ").strip() or PASS
    
    global HOST, USER, PASS
    HOST, USER, PASS = host, user, password
    
    sock = connect()
    if not sock:
        return
        
    log("Type commands or 'exit' to quit")
    
    while True:
        cmd = input(f"{USER}@{HOST}$ ").strip()
        if cmd in ["exit", "quit", "q"]:
            break
        if cmd:
            print(send_cmd(sock, cmd))
            
    sock.close()
    log("Disconnected")

if __name__ == "__main__":
    main()
ENDPYTHON

chmod +x kalishare-connect.py

# Create launcher
cat > run-kalishare.sh << 'ENDSH'
#!/bin/bash
cd ~/KaliShare
python3 kalishare-connect.py
ENDSH

chmod +x run-kalishare.sh

echo ""
echo -e "\033[1;32m[✓] Setup complete!\033[0m"
echo ""
echo "To connect to KaliShare:"
echo "  1. Ensure KaliShare SSH is running: systemctl start ssh"
echo "  2. Get KaliShare IP: ip addr"
echo "  3. Run: cd ~/KaliShare && python3 kalishare-connect.py"
echo ""
echo "Or just run: bash ~/KaliShare/run-kalishare.sh"
echo ""

# Offer to run now
read -p "Run connector now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd ~/KaliShare
    python3 kalishare-connect.py
fi