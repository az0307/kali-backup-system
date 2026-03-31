#!/usr/bin/env python3
"""
Kali Backup System TUI
A Textual-based Terminal User Interface for Kali Linux management
"""
import os
import sys
import subprocess
from pathlib import Path
from textual.app import App, ComposeResult
from textual.containers import Container, VerticalScroll, Horizontal
from textual.widgets import Header, Footer, Button, Static, ListView, ListItem, Label
from textual.screen import Screen
from textual import work

SCRIPT_DIR = Path(__file__).parent.parent / "scripts"
USB_PATH = Path("/media/usb")  # Adjust for Kali

class MenuScreen(Screen):
    """Main menu screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Kali Backup System[/b]", classes="title"),
            ListView(
                ListItem(Label("1. MCP Servers")),
                ListItem(Label("2. Docker Tools")),
                ListItem(Label("3. AI Tools")),
                ListItem(Label("4. Browser Automation")),
                ListItem(Label("5. Wordlists")),
                ListItem(Label("6. Red Team Tools")),
                ListItem(Label("7. Blue Team Tools")),
                ListItem(Label("8. Install All Tools")),
                ListItem(Label("9. Backup to USB")),
                ListItem(Label("10. Exit")),
                id="menu-list"
            ),
            classes="menu-container"
        )
    
    def on_list_view_selected(self, event: ListView.Selected) -> None:
        index = event.list_view.index
        if index == 0:
            self.app.push_screen(MCPScreen())
        elif index == 1:
            self.app.push_screen(DockerScreen())
        elif index == 2:
            self.app.push_screen(AIScreen())
        elif index == 3:
            self.app.push_screen(AutomationScreen())
        elif index == 4:
            self.app.push_screen(WordlistScreen())
        elif index == 5:
            self.app.push_screen(RedTeamScreen())
        elif index == 6:
            self.app.push_screen(BlueTeamScreen())
        elif index == 7:
            self.app.push_screen(InstallAllScreen())
        elif index == 8:
            self.app.push_screen(BackupScreen())
        elif index == 9:
            self.app.exit()

class MCPScreen(Screen):
    """MCP Servers installation screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]MCP Servers[/b]", classes="title"),
            ListView(
                ListItem(Label("1. MCP-Kali-Server")),
                ListItem(Label("2. MCP-Security-Hub")),
                ListItem(Label("3. Metasploit MCP")),
                ListItem(Label("4. Red Team MCPs")),
                ListItem(Label("5. Blue Team MCPs")),
                ListItem(Label("6. Reverse Engineering MCPs")),
                ListItem(Label("7. Install All MCPs")),
                ListItem(Label("← Back")),
            ),
            id="mcp-list"
        )
    
    def on_list_view_selected(self, event: ListView.Selected) -> None:
        index = event.list_view.index
        if index == 6:
            self.app.push_screen(InstallMCPAllScreen())
        elif index == 7:
            self.app.pop_screen()

class DockerScreen(Screen):
    """Docker tools screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Docker Tools[/b]", classes="title"),
            ListView(
                ListItem(Label("1. Install n8n (Automation)")),
                ListItem(Label("2. Install Portainer")),
                ListItem(Label("3. Install Security Stack")),
                ListItem(Label("4. Install Docker Tools")),
                ListItem(Label("5. Install All Docker")),
                ListItem(Label("← Back")),
            ),
            id="docker-list"
        )

class AIScreen(Screen):
    """AI tools screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]AI Tools[/b]", classes="title"),
            ListView(
                ListItem(Label("1. Install Ollama")),
                ListItem(Label("2. Install OpenWork")),
                ListItem(Label("3. Install HuggingFace")),
                ListItem(Label("4. Install All AI")),
                ListItem(Label("← Back")),
            ),
            id="ai-list"
        )

class AutomationScreen(Screen):
    """Browser automation screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Browser Automation[/b]", classes="title"),
            ListView(
                ListItem(Label("1. Install Puppeteer")),
                ListItem(Label("2. Install Playwright")),
                ListItem(Label("3. Install browser-use")),
                ListItem(Label("4. Install All Automation")),
                ListItem(Label("← Back")),
            ),
            id="automation-list"
        )

class WordlistScreen(Screen):
    """Wordlists screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Wordlists[/b]", classes="title"),
            ListView(
                ListItem(Label("1. Download SecLists")),
                ListItem(Label("2. Download CrackStation")),
                ListItem(Label("3. Download RockYou")),
                ListItem(Label("4. Download WeakPass")),
                ListItem(Label("5. Download All Wordlists")),
                ListItem(Label("← Back")),
            ),
            id="wordlist-list"
        )

class RedTeamScreen(Screen):
    """Red Team tools screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Red Team Tools[/b]", classes="title"),
            ListView(
                ListItem(Label("1. Network Attacks")),
                ListItem(Label("2. Web Application")),
                ListItem(Label("3. Exploitation")),
                ListItem(Label("4. Password Cracking")),
                ListItem(Label("5. Social Engineering")),
                ListItem(Label("← Back")),
            ),
            id="redteam-list"
        )

class BlueTeamScreen(Screen):
    """Blue Team tools screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Blue Team Tools[/b]", classes="title"),
            ListView(
                ListItem(Label("1. Forensics")),
                ListItem(Label("2. Malware Analysis")),
                ListItem(Label("3. Log Analysis")),
                ListItem(Label("4. Network Monitoring")),
                ListItem(Label("← Back")),
            ),
            id="blueteam-list"
        )

class InstallAllScreen(Screen):
    """Install all tools screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Install All Tools[/b]", classes="title"),
            Label("This will install all MCP, Docker, AI, and Automation tools."),
            Label(""),
            Button("Install All", variant="primary", id="install-all"),
            Button("Cancel", variant="error", id="cancel"),
        )

class BackupScreen(Screen):
    """Backup to USB screen"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Backup to USB[/b]", classes="title"),
            Label("Select backup destination:"),
            ListView(
                ListItem(Label("1. USB Drive (F:/)")),
                ListItem(Label("2. USB Drive (G:/)")),
                ListItem(Label("3. Custom Path")),
                ListItem(Label("← Back")),
            ),
        )

class InstallMCPAllScreen(Screen):
    """Install all MCPs"""
    
    def compose(self) -> ComposeResult:
        yield Container(
            Label("[b]Installing All MCP Servers...[/b]", classes="title"),
            Static("", id="output"),
        )
    
    def on_mount(self) -> None:
        self.run_install()
    
    def run_install(self):
        mcp_dir = SCRIPT_DIR / "mcp"
        if mcp_dir.exists():
            output = self.query_one("#output")
            output.update("MCP installation scripts ready in:\n" + str(mcp_dir))

class KaliTUIApp(App):
    """Main TUI Application"""
    
    CSS = """
    Screen {
        background: $surface;
    }
    .title {
        text-align: center;
        width: 100%;
        height: 3;
        content-align: center middle;
        text-style: bold;
        color: $accent;
    }
    .menu-container {
        height: 100%;
        align: center middle;
    }
    ListView {
        width: 60;
        height: 20;
    }
    """
    
    def on_mount(self) -> None:
        self.push_screen(MenuScreen())
    
    def get_default_screen(self) -> MenuScreen:
        return MenuScreen()

if __name__ == "__main__":
    app = KaliTUIApp()
    app.run()