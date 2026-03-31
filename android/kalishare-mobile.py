#!/usr/bin/env python3
"""
KaliShare Android Connector
Run this on Android (via Pydroid or Termux) to connect to KaliShare USB
"""

import os
import sys
import socket
import paramiko
import threading
import time
from datetime import datetime

# Try to import android modules, fallback to CLI if not available
try:
    import android
    ANDROID_MODE = True
except ImportError:
    ANDROID_MODE = False
    print("Running in CLI mode (install 'pydroid3' on Android for GUI)")

# Basic color codes for terminal
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
RED = '\033[0;31m'
BLUE = '\033[0;34m'
CYAN = '\033[0;36m'
NC = '\033[0m'

class KaliShareMobile:
    def __init__(self):
        self.ssh_client = None
        self.connected = False
        self.host = "192.168.1.100"
        self.port = 22
        self.username = "root"
        self.password = "toor"
        
    def log(self, msg, level="info"):
        timestamp = datetime.now().strftime("%H:%M:%S")
        if level == "error":
            print(f"{RED}[X] {msg}{NC}")
        elif level == "success":
            print(f"{GREEN}[✓] {msg}{NC}")
        elif level == "warning":
            print(f"{YELLOW}[!] {msg}{NC}")
        else:
            print(f"{BLUE}[*] {msg}{NC}")
            
    def connect(self, host=None, port=None, username=None, password=None):
        """Connect to KaliShare via SSH"""
        if host: self.host = host
        if port: self.port = port
        if username: self.username = username
        if password: self.password = password
        
        self.log(f"Connecting to {self.host}:{self.port}...")
        
        try:
            self.ssh_client = paramiko.SSHClient()
            self.ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            
            self.ssh_client.connect(
                hostname=self.host,
                port=int(self.port),
                username=self.username,
                password=self.password,
                timeout=10,
                allow_agent=False,
                look_for_keys=False
            )
            
            self.connected = True
            self.log("Connected successfully!", "success")
            return True
            
        except Exception as e:
            self.log(f"Connection failed: {str(e)}", "error")
            return False
            
    def disconnect(self):
        """Disconnect from SSH"""
        if self.ssh_client:
            self.ssh_client.close()
            self.connected = False
            self.log("Disconnected")
            
    def execute(self, command):
        """Execute command via SSH"""
        if not self.connected:
            self.log("Not connected!", "error")
            return None
            
        try:
            stdin, stdout, stderr = self.ssh_client.exec_command(command)
            output = stdout.read().decode()
            error = stderr.read().decode()
            
            return output if output else error
            
        except Exception as e:
            self.log(f"Error executing command: {str(e)}", "error")
            return None
            
    def quick_scan(self):
        """Quick network scan"""
        self.log("Running quick network scan...")
        result = self.execute("nmap -sn 192.168.1.0/24")
        print(result)
        
    def wifi_scan(self):
        """WiFi scan"""
        self.log("Starting WiFi scan...")
        result = self.execute("airodump-ng wlan0mon")
        print(result)
        
    def tool_widget(self):
        """Launch tool widget"""
        self.log("Launching tool widget...")
        self.execute("bash /root/KaliShare/scripts/tool-widget.sh")
        
    def status(self):
        """Get system status"""
        self.log("Getting system status...")
        result = self.execute("echo '=== System ===' && uname -a && echo '=== Network ===' && ip addr && echo '=== Memory ===' && free -h")
        print(result)
        
    def run_tools(self, tool_name):
        """Run common tools"""
        tools = {
            "nmap": "nmap -sV -sC {target}",
            "nikto": "nikto -h {target}",
            "sqlmap": "sqlmap -u '{target}' --batch",
            "hydra": "hydra -L /usr/share/wordlists/usernames.txt -P /usr/share/wordlists/rockyou.txt {target} ssh",
            "msf": "msfconsole -q",
            "aircrack": "aircrack-ng {handshake}",
            "wifite": "wifite",
            " gobuster": "gobuster dir -u {target} -w /usr/share/wordlists/dirb/big.txt",
        }
        
        if tool_name in tools:
            self.log(f"Running {tool_name}...")
            print(self.execute(tools[tool_name]))
            
    def interactive_shell(self):
        """Interactive shell"""
        if not self.connected:
            self.log("Connect first!", "error")
            return
            
        self.log("Entering interactive shell. Type 'exit' to quit.")
        
        while True:
            try:
                cmd = input(f"{GREEN}KaliShare${NC} $ ")
                if cmd.lower() in ["exit", "quit", "q"]:
                    break
                if cmd.strip():
                    result = self.execute(cmd)
                    if result:
                        print(result)
            except KeyboardInterrupt:
                break
            except Exception as e:
                self.log(f"Error: {str(e)}", "error")
                
    def auto_connect_menu(self):
        """Auto-discover and connect"""
        self.log("Scanning network for KaliShare...")
        
        # Try common subnets
        for subnet in ["192.168.1", "192.168.0", "10.0.0", "172.16.0"]:
            for last_octet in range(1, 255):
                ip = f"{subnet}.{last_octet}"
                try:
                    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                    sock.settimeout(0.5)
                    result = sock.connect_ex((ip, 22))
                    sock.close()
                    
                    if result == 0:
                        self.log(f"Found SSH on {ip}", "success")
                        # Try to connect
                        if self.connect(host=ip):
                            self.log(f"Connected to KaliShare at {ip}!", "success")
                            return True
                except:
                    pass
                    
        self.log("No KaliShare found on network", "warning")
        return False


def main():
    print(f"""
{CYAN}╔══════════════════════════════════════════════════════╗
║          KALI SHARE MOBILE CONNECTOR v1.0                ║
╚══════════════════════════════════════════════════════╝{NC}
""")
    
    app = KaliShareMobile()
    
    # Try auto-discover first
    print(f"\n{YELLOW}Searching for KaliShare on network...{NC}")
    
    # Or manual connect
    print(f"\n{BLUE}Manual Connection:{NC}")
    host = input(f"Host IP [{app.host}]: ").strip() or app.host
    port = input(f"Port [{app.port}]: ").strip() or app.port
    username = input(f"Username [{app.username}]: ").strip() or app.username
    password = input(f"Password [{app.password}]: ").strip() or app.password
    
    if app.connect(host, port, username, password):
        while True:
            print(f"""
{CYAN}╔══════════════════════════════╗
║         MAIN MENU                ║
╠══════════════════════════════╣
║ 1. Interactive Shell          ║
║ 2. Quick Network Scan        ║
║ 3. WiFi Scan                  ║
║ 4. System Status             ║
║ 5. Launch Tool Widget        ║
║ 6. Run Common Tool            ║
║ 7. Re-scan Network            ║
║ 0. Disconnect & Exit         ║
╚══════════════════════════════╝{NC}
""")
            choice = input("Select: ").strip()
            
            if choice == "1":
                app.interactive_shell()
            elif choice == "2":
                app.quick_scan()
            elif choice == "3":
                app.wifi_scan()
            elif choice == "4":
                app.status()
            elif choice == "5":
                app.tool_widget()
            elif choice == "6":
                tool = input("Tool (nmap/nikto/sqlmap/hydra/msf/aircrack/wifite/gobuster): ").strip()
                target = input("Target (or press Enter): ").strip()
                if target:
                    app.run_tools(tool.replace("{target}", target).replace("{handshake}", target))
                else:
                    app.run_tools(tool)
            elif choice == "7":
                app.auto_connect_menu()
            elif choice == "0":
                app.disconnect()
                break
            else:
                print("Invalid choice")
    else:
        print(f"\n{YELLOW}Connection failed. Try auto-scan option next time.{NC}")
        print("Or check that SSH is enabled on KaliShare:")
        print("  systemctl start ssh")


if __name__ == "__main__":
    # Try to install paramiko if not available
    try:
        import paramiko
    except ImportError:
        print("Installing paramiko...")
        os.system("pip3 install paramiko")
        
    main()