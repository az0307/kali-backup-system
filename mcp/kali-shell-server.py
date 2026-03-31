#!/usr/bin/env python3
"""
Kali Shell MCP Server
Execute commands on Kali Linux via SSH
"""

import asyncio
import json
import paramiko
from typing import Any

class KaliShellServer:
    def __init__(self, host="192.168.1.200", user="root"):
        self.host = host
        self.user = user
        self.client = None
    
    def connect(self):
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.client.connect(self.host, username=self.user)
    
    def execute(self, command: str) -> dict:
        if not self.client:
            self.connect()
        
        stdin, stdout, stderr = self.client.exec_command(command)
        return {
            "output": stdout.read().decode(),
            "error": stderr.read().decode(),
            "exit_code": stdout.channel.recv_exit_status()
        }
    
    def close(self):
        if self.client:
            self.client.close()

# Example usage
if __name__ == "__main__":
    server = KaliShellServer()
    result = server.execute("nmap -sn 192.168.1.0/24")
    print(json.dumps(result, indent=2))
