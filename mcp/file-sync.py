#!/usr/bin/env python3
"""
File Sync MCP Server
Sync files between laptop and desktop
"""

import os
import subprocess
from typing import List, Optional

class FileSync:
    def __init__(self, remote_host="192.168.1.200", remote_user="root"):
        self.remote = f"{remote_user}@{remote_host}"
    
    def sync_to_remote(self, local_path: str, remote_path: str) -> str:
        cmd = ["rsync", "-avz", local_path, f"{self.remote}:{remote_path}"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def sync_from_remote(self, remote_path: str, local_path: str) -> str:
        cmd = ["rsync", "-avz", f"{self.remote}:{remote_path}", local_path]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def sync_dir(self, local_dir: str, remote_dir: str) -> str:
        cmd = ["rsync", "-avz", "--delete", 
               f"{local_dir}/", f"{self.remote}:{remote_dir}/"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def list_remote(self, remote_path: str) -> List[str]:
        cmd = ["ssh", self.remote, "ls", remote_path]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout.split("\n")

if __name__ == "__main__":
    sync = FileSync()
    print(sync.list_remote("/opt/tools"))
