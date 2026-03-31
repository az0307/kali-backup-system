#!/usr/bin/env python3
"""
Nmap MCP Server
Automated network scanning
"""

import subprocess
import json
from typing import List, Optional

class NmapServer:
    def __init__(self):
        self.defaults = ["-sV", "-T4"]
    
    def quick_scan(self, target: str) -> str:
        cmd = ["nmap", "-sn", target]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def full_scan(self, target: str) -> str:
        cmd = ["nmap"] + self.defaults + ["-p-", target]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def scan_with_scripts(self, target: str, script: str = "default") -> str:
        cmd = ["nmap", "--script", script, "-sV", target]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def parse_results(self, output: str) -> dict:
        hosts = []
        for line in output.split("\n"):
            if "Nmap scan report for" in line:
                hosts.append(line.replace("Nmap scan report for ", ""))
        return {"hosts": hosts}

if __name__ == "__main__":
    server = NmapServer()
    print(server.quick_scan("192.168.1.0/24"))
