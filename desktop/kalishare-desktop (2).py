#!/usr/bin/env python3
"""
KaliShare Desktop Companion
Windows app that connects to and controls the KaliShare USB
"""

import os
import sys
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
from pathlib import Path
import threading
import shutil

class KaliShareDesktop:
    def __init__(self, root):
        self.root = root
        self.root.title("KaliShare Desktop Companion v1.0")
        self.root.geometry("800x600")
        self.root.resizable(True, True)
        
        # Find USB drive
        self.usb_drive = self.find_usb_drive()
        self.kali_share_path = None
        
        if self.usb_drive:
            self.kali_share_path = Path(self.usb_drive) / "KaliShare"
        
        self.setup_ui()
        
    def find_usb_drive(self):
        """Find the KaliShare USB drive"""
        drive_letters = "DEFGHIJKLMNOPQRSTUVWXYZ"
        
        for letter in drive_letters:
            path = f"{letter}:\\"
            if os.path.exists(path):
                # Check for KaliShare folder or known marker
                if os.path.exists(os.path.join(path, "KaliShare")):
                    return letter
                if os.path.exists(os.path.join(path, "MENU.txt")):
                    return letter
                if os.path.exists(os.path.join(path, "scripts")):
                    return letter
        return None
        
    def setup_ui(self):
        """Setup the user interface"""
        
        # Title bar
        title_frame = tk.Frame(self.root, bg="#1a1a2e", height=60)
        title_frame.pack(fill="x")
        title_frame.pack_propagate(False)
        
        title_label = tk.Label(title_frame, text="KaliShare Desktop Companion",
                             font=("Consolas", 18, "bold"), bg="#1a1a2e", fg="#00ff88")
        title_label.pack(pady=15)
        
        # Main content
        main_frame = tk.Frame(self.root, bg="#16213e")
        main_frame.pack(fill="both", expand=True, padx=10, pady=10)
        
        # Status panel
        status_frame = tk.Frame(main_frame, bg="#16213e")
        status_frame.pack(fill="x", pady=5)
        
        self.status_label = tk.Label(status_frame, text="USB: Not Connected",
                                    font=("Consolas", 10), bg="#16213e", fg="#ff6b6b")
        self.status_label.pack(side="left")
        
        if self.usb_drive:
            self.status_label.config(text=f"USB: {self.usb_drive}:\\ Connected", fg="#00ff88")
        
        # Tabs
        self.notebook = ttk.Notebook(main_frame)
        self.notebook.pack(fill="both", expand=True)
        
        # Tab 1: Quick Launch
        self.create_quick_launch_tab()
        
        # Tab 2: Network Tools
        self.create_network_tab()
        
        # Tab 3: WiFi Tools
        self.create_wifi_tab()
        
        # Tab 4: Scripts
        self.create_scripts_tab()
        
        # Tab 5: Terminal Output
        self.create_terminal_tab()
        
        # Log panel
        log_frame = tk.LabelFrame(main_frame, text="Activity Log", bg="#16213e", fg="#00ff88")
        log_frame.pack(fill="x", pady=5)
        
        self.log_text = scrolledtext.ScrolledText(log_frame, height=8, bg="#0f0f23", fg="#00ff88",
                                                   font=("Consolas", 9))
        self.log_text.pack(fill="x", padx=5, pady=5)
        
    def create_quick_launch_tab(self):
        """Quick Launch tab"""
        frame = tk.Frame(self.notebook, bg="#16213e")
        self.notebook.add(frame, text="Quick Launch")
        
        # Buttons grid
        btn_frame = tk.Frame(frame, bg="#16213e")
        btn_frame.pack(pady=20)
        
        buttons = [
            ("Network Scan", "quick"),
            ("Full Port Scan", "full"),
            ("WiFi Menu", "wifi-menu"),
            ("Tool Widget", "widget"),
            ("Stealth Mode", "stealth"),
            ("Detection Tracker", "detect"),
            ("Area Sweeper", "sweep"),
            ("Payload Gen", "payload"),
            ("Boot Menu", "boot-menu"),
            ("System Status", "status"),
        ]
        
        row, col = 0, 0
        for text, cmd in buttons:
            btn = tk.Button(btn_frame, text=text, width=18, height=2,
                          bg="#1a1a2e", fg="#00ff88", font=("Consolas", 10),
                          command=lambda c=cmd: self.run_command(c))
            btn.grid(row=row, column=col, padx=5, pady=5)
            col += 1
            if col > 2:
                col = 0
                row += 1
                
    def create_network_tab(self):
        """Network Tools tab"""
        frame = tk.Frame(self.notebook, bg="#16213e")
        self.notebook.add(frame, text="Network")
        
        # Target input
        input_frame = tk.Frame(frame, bg="#16213e")
        input_frame.pack(fill="x", pady=10, padx=10)
        
        tk.Label(input_frame, text="Target IP/Range:", bg="#16213e", fg="#00ff88").pack(side="left")
        self.target_entry = tk.Entry(input_frame, width=25, bg="#0f0f23", fg="#00ff88")
        self.target_entry.pack(side="left", padx=10)
        self.target_entry.insert(0, "192.168.1.1")
        
        # Action buttons
        action_frame = tk.Frame(frame, bg="#16213e")
        action_frame.pack(pady=10)
        
        actions = [
            ("Quick Scan (nmap -sn)", "ns"),
            ("Port Scan (nmap -sV)", "nf"),
            ("Service Scan", "sv"),
            ("OS Detection", "os"),
            ("Vuln Scan", "vuln"),
            ("Full Recon", "full"),
        ]
        
        for text, cmd in actions:
            btn = tk.Button(action_frame, text=text, width=20, height=2,
                           bg="#1a1a2e", fg="#00ff88", font=("Consolas", 9),
                           command=lambda c=cmd: self.run_network_cmd(c))
            btn.pack(side="left", padx=5)
            
    def create_wifi_tab(self):
        """WiFi Tools tab"""
        frame = tk.Frame(self.notebook, bg="#16213e")
        self.notebook.add(frame, text="WiFi")
        
        btn_frame = tk.Frame(frame, bg="#16213e")
        btn_frame.pack(pady=20)
        
        wifi_actions = [
            ("Enable Monitor Mode", "mon-start"),
            ("Scan Networks", "wifi-scan"),
            ("Capture Handshake", "wpa"),
            ("Wifite", "wifite"),
            ("Fluxion", "fluxion"),
            ("Crack Handshake", "crack"),
            ("Deauth Attack", "deauth"),
        ]
        
        row, col = 0, 0
        for text, cmd in wifi_actions:
            btn = tk.Button(btn_frame, text=text, width=18, height=2,
                           bg="#1a1a2e", fg="#00ff88", font=("Consolas", 9),
                           command=lambda c=cmd: self.run_wifi_cmd(c))
            btn.grid(row=row, column=col, padx=5, pady=5)
            col += 1
            if col > 2:
                col = 0
                row += 1
                
    def create_scripts_tab(self):
        """Scripts management tab"""
        frame = tk.Frame(self.notebook, bg="#16213e")
        self.notebook.add(frame, text="Scripts")
        
        # Script list
        list_frame = tk.Frame(frame, bg="#16213e")
        list_frame.pack(fill="both", expand=True, padx=10, pady=10)
        
        tk.Label(list_frame, text="Available Scripts:", bg="#16213e", fg="#00ff88").pack(anchor="w")
        
        self.script_listbox = tk.Listbox(list_frame, bg="#0f0f23", fg="#00ff88",
                                         font=("Consolas", 9), height=15)
        self.script_listbox.pack(fill="both", expand=True)
        
        self.load_scripts()
        
        # Buttons
        btn_frame = tk.Frame(frame, bg="#16213e")
        btn_frame.pack(fill="x", padx=10, pady=5)
        
        tk.Button(btn_frame, text="Refresh", bg="#1a1a2e", fg="#00ff88",
                  command=self.load_scripts).pack(side="left", padx=5)
        tk.Button(btn_frame, text="Run Selected", bg="#1a1a2e", fg="#00ff88",
                  command=self.run_selected_script).pack(side="left", padx=5)
                  
    def create_terminal_tab(self):
        """Terminal output tab"""
        frame = tk.Frame(self.notebook, bg="#16213e")
        self.notebook.add(frame, text="Terminal")
        
        self.term_text = scrolledtext.ScrolledText(frame, bg="#0f0f23", fg="#00ff88",
                                                    font=("Consolas", 10))
        self.term_text.pack(fill="both", expand=True, padx=5, pady=5)
        
        btn_frame = tk.Frame(frame, bg="#16213e")
        btn_frame.pack(fill="x", padx=5, pady=5)
        
        tk.Button(btn_frame, text="Clear", bg="#1a1a2e", fg="#00ff88",
                  command=lambda: self.term_text.delete("1.0", "end")).pack(side="right")
                  
    def load_scripts(self):
        """Load available scripts"""
        self.script_listbox.delete(0, "end")
        
        scripts = [
            "tool-widget.sh - Interactive tool launcher",
            "essential-tools.sh - Install must-have tools",
            "stealth-mode.sh - OPSEC-safe operations",
            "detection-tracker.sh - Track security events",
            "area-sweeper.sh - Auto WiFi/network sweep",
            "payload-generator.sh - Generate shells/payloads",
            "automation-hub.sh - Workflow orchestration",
            "audit-test.sh - Test suite",
            "setup-desktop-org.sh - Desktop setup",
        ]
        
        for script in scripts:
            self.script_listbox.insert("end", script)
            
    def log(self, message):
        """Add message to log"""
        self.log_text.insert("end", f"> {message}\n")
        self.log_text.see("end")
        
    def run_command(self, cmd):
        """Run a go command"""
        if not self.usb_drive:
            messagebox.showerror("Error", "USB not connected!")
            return
            
        self.log(f"Running: go {cmd}")
        
        # Simulate - in real scenario this would run on the USB/Kali
        self.term_text.insert("end", f"\n[Running: go {cmd}]\n")
        self.term_text.see("end")
        
    def run_network_cmd(self, cmd):
        """Run network command"""
        target = self.target_entry.get()
        if not target:
            messagebox.showwarning("Warning", "Enter target IP!")
            return
            
        self.log(f"Running: nmap {cmd} on {target}")
        self.term_text.insert("end", f"\n[Running: nmap -{cmd} {target}]\n")
        
    def run_wifi_cmd(self, cmd):
        """Run WiFi command"""
        self.log(f"Running WiFi command: {cmd}")
        self.term_text.insert("end", f"\n[Running WiFi: {cmd}]\n")
        
    def run_selected_script(self):
        """Run selected script"""
        selection = self.script_listbox.curselection()
        if not selection:
            return
            
        script = self.script_listbox.get(selection[0]).split(" - ")[0]
        self.log(f"Running script: {script}")
        self.term_text.insert("end", f"\n[Running: {script}]\n")

def main():
    root = tk.Tk()
    
    # Set dark theme colors
    root.configure(bg="#16213e")
    
    app = KaliShareDesktop(root)
    root.mainloop()

if __name__ == "__main__":
    main()