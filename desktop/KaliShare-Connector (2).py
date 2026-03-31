#!/usr/bin/env python3
"""
KaliShare Connector - Windows Desktop App
Connects to and controls KaliShare USB bootable system remotely
"""

import os
import sys
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext, filedialog
from pathlib import Path
import threading
import socket
import paramiko
from datetime import datetime
import json

class KaliShareConnector:
    def __init__(self, root):
        self.root = root
        self.root.title("KaliShare Connector v1.0")
        self.root.geometry("1000x700")
        self.root.resizable(True, True)
        
        # Connection settings
        self.host = tk.StringVar(value="192.168.1.100")
        self.port = tk.StringVar(value="22")
        self.username = tk.StringVar(value="root")
        self.password = tk.StringVar(value="toor")
        
        # SSH client
        self.ssh_client = None
        self.connected = False
        
        # Config
        self.config_file = os.path.expanduser("~/.kalishare_connector.json")
        self.load_config()
        
        # Colors
        self.bg_color = "#0d1117"
        self.fg_color = "#00ff88"
        self.accent_color = "#1f6feb"
        self.error_color = "#f85149"
        
        self.setup_ui()
        
    def load_config(self):
        """Load saved connection settings"""
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r') as f:
                    config = json.load(f)
                    self.host.set(config.get('host', '192.168.1.100'))
                    self.port.set(config.get('port', '22'))
                    self.username.set(config.get('username', 'root'))
                    self.password.set(config.get('password', 'toor'))
            except:
                pass
                
    def save_config(self):
        """Save connection settings"""
        config = {
            'host': self.host.get(),
            'port': self.port.get(),
            'username': self.username.get(),
            'password': self.password.get()
        }
        with open(self.config_file, 'w') as f:
            json.dump(config, f)
            
    def setup_ui(self):
        """Setup the user interface"""
        self.root.configure(bg=self.bg_color)
        
        # Menu bar
        self.create_menu()
        
        # Main container
        main_container = tk.Frame(self.root, bg=self.bg_color)
        main_container.pack(fill="both", expand=True)
        
        # Left panel - Connection
        self.create_connection_panel(main_container)
        
        # Right panel - Terminal & Controls
        self.create_terminal_panel(main_container)
        
        # Bottom - Status bar
        self.create_status_bar()
        
    def create_menu(self):
        """Create menu bar"""
        menubar = tk.Menu(self.root, bg=self.bg_color, fg=self.fg_color)
        self.root.config(menu=menubar)
        
        file_menu = tk.Menu(menubar, bg=self.bg_color, fg=self.fg_color)
        menubar.add_cascade(label="File", menu=file_menu)
        file_menu.add_command(label="Save Connection", command=self.save_config)
        file_menu.add_command(label="Load Connection", command=self.load_connection)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.root.quit)
        
        tools_menu = tk.Menu(menubar, bg=self.bg_color, fg=self.fg_color)
        menubar.add_cascade(label="Tools", menu=tools_menu)
        tools_menu.add_command(label="Quick Nmap", command=lambda: self.run_command("nmap -sn"))
        tools_menu.add_command(label="WiFi Scan", command=lambda: self.run_command("airodump-ng wlan0mon"))
        tools_menu.add_command(label="Tool Widget", command=lambda: self.run_command("bash /root/KaliShare/scripts/tool-widget.sh"))
        
        help_menu = tk.Menu(menubar, bg=self.bg_color, fg=self.fg_color)
        menubar.add_cascade(label="Help", menu=help_menu)
        help_menu.add_command(label="Quick Commands", command=self.show_help)
        
    def create_connection_panel(self, parent):
        """Create connection panel"""
        conn_frame = tk.LabelFrame(parent, text="🔌 Connection", 
                                   bg=self.bg_color, fg=self.fg_color,
                                   font=("Consolas", 11, "bold"))
        conn_frame.pack(side="left", fill="y", padx=5, pady=5)
        
        # Host
        tk.Label(conn_frame, text="Host IP:", bg=self.bg_color, fg=self.fg_color).pack(pady=2)
        tk.Entry(conn_frame, textvariable=self.host, bg="#161b22", fg=self.fg_color, width=20).pack(pady=2)
        
        # Port
        tk.Label(conn_frame, text="SSH Port:", bg=self.bg_color, fg=self.fg_color).pack(pady=2)
        tk.Entry(conn_frame, textvariable=self.port, bg="#161b22", fg=self.fg_color, width=20).pack(pady=2)
        
        # Username
        tk.Label(conn_frame, text="Username:", bg=self.bg_color, fg=self.fg_color).pack(pady=2)
        tk.Entry(conn_frame, textvariable=self.username, bg="#161b22", fg=self.fg_color, width=20).pack(pady=2)
        
        # Password
        tk.Label(conn_frame, text="Password:", bg=self.bg_color, fg=self.fg_color).pack(pady=2)
        tk.Entry(conn_frame, textvariable=self.password, show="*", bg="#161b22", fg=self.fg_color, width=20).pack(pady=2)
        
        # Connect button
        self.connect_btn = tk.Button(conn_frame, text="🔗 Connect", 
                                     command=self.connect,
                                     bg=self.accent_color, fg="white",
                                     font=("Consolas", 10, "bold"), width=18)
        self.connect_btn.pack(pady=10)
        
        # Disconnect button
        tk.Button(conn_frame, text="❌ Disconnect", 
                  command=self.disconnect,
                  bg="#f85149", fg="white",
                  font=("Consolas", 10), width=18).pack(pady=2)
        
        # Separator
        tk.Frame(conn_frame, height=2, bg=self.fg_color).pack(fill="x", pady=10)
        
        # Quick Actions
        tk.Label(conn_frame, text="⚡ Quick Actions", bg=self.bg_color, fg=self.fg_color, 
                 font=("Consolas", 10, "bold")).pack(pady=5)
        
        quick_actions = [
            ("📡 Scan Network", "nmap -sn 192.168.1.0/24"),
            ("🔍 Port Scan", "nmap -sV -p- {host}"),
            ("📶 WiFi Menu", "bash /root/KaliShare/cli/go wifi-menu"),
            ("🛠️ Tool Widget", "bash /root/KaliShare/scripts/tool-widget.sh"),
            ("🎯 Pentest", "bash /root/KaliShare/cli/go pentest {host}"),
            ("🛡️ Stealth", "bash /root/KaliShare/scripts/stealth-mode.sh"),
            ("📊 Status", "bash /root/KaliShare/cli/go status"),
            ("📁 File Browser", "ls -la /root/KaliShare"),
            ("💻 System Info", "uname -a && free -h"),
            ("🌐 Internet Test", "ping -c 3 8.8.8.8"),
        ]
        
        for label, cmd in quick_actions:
            btn = tk.Button(conn_frame, text=label, 
                           command=lambda c=cmd: self.run_command(c),
                           bg="#21262d", fg=self.fg_color,
                           font=("Consolas", 9), width=20)
            btn.pack(pady=1, padx=5)
            
    def create_terminal_panel(self, parent):
        """Create terminal panel"""
        term_frame = tk.Frame(parent, bg=self.bg_color)
        term_frame.pack(side="left", fill="both", expand=True, padx=5, pady=5)
        
        # Terminal title
        tk.Label(term_frame, text="💻 Terminal", bg=self.bg_color, fg=self.fg_color,
                font=("Consolas", 11, "bold")).pack(anchor="w")
        
        # Terminal output
        self.terminal = scrolledtext.ScrolledText(term_frame, 
                                                 bg="#0d1117", fg=self.fg_color,
                                                 font=("Consolas", 11),
                                                 height=25, width=60)
        self.terminal.pack(fill="both", expand=True)
        self.terminal.tag_config("error", foreground=self.error_color)
        self.terminal.tag_config("success", foreground=self.fg_color)
        self.terminal.tag_config("info", foreground="#58a6ff")
        
        # Command input
        input_frame = tk.Frame(term_frame, bg=self.bg_color)
        input_frame.pack(fill="x", pady=5)
        
        tk.Label(input_frame, text=">", bg=self.bg_color, fg=self.fg_color).pack(side="left")
        
        self.cmd_entry = tk.Entry(input_frame, bg="#161b22", fg=self.fg_color,
                                   font=("Consolas", 11))
        self.cmd_entry.pack(side="left", fill="x", expand=True)
        self.cmd_entry.bind("<Return>", lambda e: self.run_command(self.cmd_entry.get()))
        
        # Action buttons
        btn_frame = tk.Frame(term_frame, bg=self.bg_color)
        btn_frame.pack(fill="x", pady=5)
        
        tk.Button(btn_frame, text="Clear", command=self.clear_terminal,
                 bg="#21262d", fg=self.fg_color).pack(side="left", padx=2)
        tk.Button(btn_frame, text="Send Command", command=lambda: self.run_command(self.cmd_entry.get()),
                 bg=self.accent_color, fg="white").pack(side="left", padx=2)
        tk.Button(btn_frame, text="Run Script", command=self.run_script,
                 bg="#238636", fg="white").pack(side="left", padx=2)
        tk.Button(btn_frame, text="Transfer File", command=self.transfer_file,
                 bg="#8957e5", fg="white").pack(side="left", padx=2)
                 
    def create_status_bar(self):
        """Create status bar"""
        status_frame = tk.Frame(self.root, bg="#161b22", height=30)
        status_frame.pack(fill="x", side="bottom")
        
        self.status_label = tk.Label(status_frame, text="Not Connected",
                                     bg="#161b22", fg=self.error_color,
                                     font=("Consolas", 10))
        self.status_label.pack(side="left", padx=10)
        
        self.info_label = tk.Label(status_frame, text="KaliShare Connector v1.0",
                                   bg="#161b22", fg="#8b949e",
                                   font=("Consolas", 9))
        self.info_label.pack(side="right", padx=10)
        
    def connect(self):
        """Connect via SSH"""
        try:
            self.output("Connecting to {}:{}...".format(self.host.get(), self.port.get()), "info")
            
            self.ssh_client = paramiko.SSHClient()
            self.ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            
            self.ssh_client.connect(
                hostname=self.host.get(),
                port=int(self.port.get()),
                username=self.username.get(),
                password=self.password.get(),
                timeout=10
            )
            
            self.connected = True
            self.output("✓ Connected successfully!", "success")
            self.status_label.config(text=f"Connected: {self.username.get()}@{self.host.get()}", fg=self.fg_color)
            self.connect_btn.config(text="✓ Connected", bg="#238636")
            self.save_config()
            
            # Get system info
            self.run_command("echo '=== System Info ===' && uname -a")
            
        except Exception as e:
            self.output(f"✗ Connection failed: {str(e)}", "error")
            messagebox.showerror("Connection Error", str(e))
            
    def disconnect(self):
        """Disconnect from SSH"""
        if self.ssh_client:
            self.ssh_client.close()
            self.ssh_client = None
        self.connected = False
        self.output("Disconnected", "info")
        self.status_label.config(text="Not Connected", fg=self.error_color)
        self.connect_btn.config(text="🔗 Connect", bg=self.accent_color)
        
    def run_command(self, command):
        """Run command via SSH"""
        if not self.connected:
            self.output("Not connected! Connect first.", "error")
            return
            
        # Replace {host} placeholder
        command = command.replace("{host}", self.host.get())
        
        self.output(f"$ {command}", "info")
        
        try:
            stdin, stdout, stderr = self.ssh_client.exec_command(command)
            
            # Get output
            output = stdout.read().decode()
            error = stderr.read().decode()
            
            if output:
                self.output(output, "success")
            if error:
                self.output(error, "error")
                
            if not output and not error:
                self.output("Command executed (no output)", "info")
                
        except Exception as e:
            self.output(f"Error: {str(e)}", "error")
            
    def output(self, text, tag="success"):
        """Add output to terminal"""
        self.terminal.insert("end", text + "\n", tag)
        self.terminal.see("end")
        
    def clear_terminal(self):
        """Clear terminal"""
        self.terminal.delete("1.0", "end")
        
    def run_script(self):
        """Run a script file"""
        filename = filedialog.askopenfilename(filetypes=[("Scripts", "*.sh"), ("All", "*.*")])
        if filename:
            with open(filename, 'r') as f:
                for line in f:
                    if line.strip() and not line.startswith('#'):
                        self.run_command(line.strip())
                        time.sleep(0.5)
                        
    def transfer_file(self):
        """Transfer file to remote system"""
        if not self.connected:
            self.output("Not connected!", "error")
            return
            
        filename = filedialog.askopenfilename()
        if filename:
            filename = Path(filename).name
            self.output(f"Use SFTP to transfer: scp {filename} {self.username.get()}@{self.host.get()}:/tmp/", "info")
            messagebox.showinfo("File Transfer", 
                               f"Use this command in Windows terminal:\n\n"
                               f"scp \"{filename}\" {self.username.get()}@{self.host.get()}:/tmp/")
                               
    def load_connection(self):
        """Load connection from file"""
        filename = filedialog.askopenfilename(filetypes=[("JSON", "*.json")])
        if filename:
            with open(filename, 'r') as f:
                config = json.load(f)
                self.host.set(config.get('host', ''))
                self.port.set(config.get('port', '22'))
                self.username.set(config.get('username', ''))
                self.password.set(config.get('password', ''))
                
    def show_help(self):
        """Show help"""
        help_text = """
╔═══════════════════════════════════════════╗
║       KALISHARE CONNECTOR HELP            ║
╚═══════════════════════════════════════════╝

CONNECTION:
• Enter Kali IP address (check with 'ip addr')
• Default SSH port: 22
• Default credentials: root/toor (Kali Live)

QUICK COMMANDS:
• {host} - Current target IP
• nmap -sn - Network discovery
• airodump-ng - WiFi scanning
• msfconsole - Metasploit

FILE TRANSFER:
• scp file root@192.168.1.x:/tmp/

SSH CONNECT FROM WINDOWS CMD:
• ssh root@192.168.1.x

TROUBLESHOOTING:
1. Check Kali IP: 'ip addr' in Kali terminal
2. Start SSH: 'systemctl start ssh'
3. Firewall: 'ufw allow ssh'
"""
        self.output(help_text, "info")

def main():
    # Try to install paramiko if not present
    try:
        import paramiko
    except ImportError:
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "paramiko"])
        except:
            pass
    
    root = tk.Tk()
    app = KaliShareConnector(root)
    root.mainloop()

if __name__ == "__main__":
    main()