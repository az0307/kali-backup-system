# AI & Pentesting Dashboard for Windows PowerShell
# Save as: ai-dashboard.ps1
# Run with: .\ai-dashboard.ps1

param(
    [switch]$Theme = "Cyberpunk"
)

# Colors
$colors = @{
    "Primary" = "Cyan"
    "Secondary" = "Green"
    "Accent" = "Yellow"
    "Error" = "Red"
    "Background" = "Black"
}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor $colors.Primary
    Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
    Write-Host "  ║      🤖 AI Tools & Pentesting Control Center                 ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
    Write-Host "  ╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor $colors.Primary
    Write-Host ""
}

function Get-SystemInfo {
    $cpu = (Get-CimInstance Win32_Processor).Name
    $ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    
    Write-Host "  System: $os" -ForegroundColor $colors.Secondary
    Write-Host "  CPU: $cpu" -ForegroundColor $colors.Secondary
    Write-Host "  RAM: $ram GB" -ForegroundColor $colors.Secondary
}

function Show-Menu {
    param([string]$Title = "AI Dashboard")
    
    Show-Banner
    Get-SystemInfo
    Write-Host ""
    
    Write-Host "  ╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor $colors.Primary
    Write-Host "  ║                        MAIN MENU                              ║" -ForegroundColor $colors.Primary
    Write-Host "  ╠═══════════════════════════════════════════════════════════════╣" -ForegroundColor $colors.Primary
    Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
    Write-Host "  ║  [1] 🤖 AI Tools                                             ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [2] 🖥️  Kali VM                                             ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [3] 📡 Wireless/Pentest                                    ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [4] 🔧 MCP Servers                                          ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [5] 📂 Quick Scripts                                        ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [6] ⚙️  Settings                                            ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [7] 📊 System Info                                          ║" -ForegroundColor $colors.Secondary
    Write-Host "  ║  [0] ❌ Exit                                                  ║" -ForegroundColor $colors.Error
    Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
    Write-Host "  ╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor $colors.Primary
    Write-Host ""
}

function Invoke-AIToolsMenu {
    do {
        Show-Banner
        Write-Host "  ╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor $colors.Primary
        Write-Host "  ║                      AI TOOLS                                ║" -ForegroundColor $colors.Primary
        Write-Host "  ╠═══════════════════════════════════════════════════════════════╣" -ForegroundColor $colors.Primary
        
        # Check tool status
        $opencode = Get-Command opencode -ErrorAction SilentlyContinue
        $claude = Get-Command claude -ErrorAction SilentlyContinue
        $gemini = Get-Command gemini -ErrorAction SilentlyContinue
        $tars = Get-Command agent-tars -ErrorAction SilentlyContinue
        
        Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
        Write-Host ("  ║  [1] OpenCode     {0,-45} ║" -f if($opencode){"✓ Installed"}else{"✗ Not Found"}) -ForegroundColor $(if($opencode){$colors.Secondary}else{$colors.Error})
        Write-Host ("  ║  [2] Claude Code  {0,-45} ║" -f if($claude){"✓ Installed"}else{"✗ Not Found"}) -ForegroundColor $(if($claude){$colors.Secondary}else{$colors.Error})
        Write-Host ("  ║  [3] Gemini CLI   {0,-45} ║" -f if($gemini){"✓ Installed"}else{"✗ Not Found"}) -ForegroundColor $(if($gemini){$colors.Secondary}else{$colors.Error})
        Write-Host ("  ║  [4] TARS         {0,-45} ║" -f if($tars){"✓ Installed"}else{"✗ Not Found"}) -ForegroundColor $(if($tars){$colors.Secondary}else{$colors.Error})
        Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
        Write-Host "  ║  [0] Back                                                        ║" -ForegroundColor $colors.Accent
        Write-Host "  ╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor $colors.Primary
        Write-Host ""
        
        $choice = Read-Host "  Select option"
        
        switch ($choice) {
            "1" { opencode }
            "2" { claude }
            "3" { gemini }
            "4" { agent-tars }
            "0" { return }
        }
    } while ($true)
}

function Invoke-KaliMenu {
    do {
        Show-Banner
        Write-Host "  ╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor $colors.Primary
        Write-Host "  ║                      KALI VM                                 ║" -ForegroundColor $colors.Primary
        Write-Host "  ╠═══════════════════════════════════════════════════════════════╣" -ForegroundColor $colors.Primary
        
        # Check VM status
        $vms = VBoxManage list vms 2>$null
        $running = VBoxManage list runningvms 2>$null
        
        Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
        Write-Host "  ║  [1] Start Kali VM                                           ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [2] Stop Kali VM                                             ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [3] SSH to Kali                                              ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [4] Show VM Status                                           ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [5] Take Snapshot                                            ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [0] Back                                                        ║" -ForegroundColor $colors.Accent
        Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
        Write-Host "  ╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor $colors.Primary
        Write-Host ""
        
        $choice = Read-Host "  Select option"
        
        switch ($choice) {
            "1" { 
                Write-Host "  Starting Kali VM..." -ForegroundColor $colors.Secondary
                VBoxManage startvm "Kali-Linux-Wireless" --type headless
                Write-Host "  VM started!" -ForegroundColor $colors.Secondary
                Start-Sleep -Seconds 2
            }
            "2" { 
                Write-Host "  Stopping Kali VM..." -ForegroundColor $colors.Secondary
                VBoxManage controlvm "Kali-Linux-Wireless" poweroff
                Write-Host "  VM stopped!" -ForegroundColor $colors.Secondary
                Start-Sleep -Seconds 2
            }
            "3" { 
                Write-Host "  Connecting to Kali via SSH..." -ForegroundColor $colors.Secondary
                ssh root@192.168.56.10
            }
            "4" {
                Write-Host "  VM Status:" -ForegroundColor $colors.Secondary
                VBoxManage showvminfo "Kali-Linux-Wireless" | Select-String -Pattern "State"
                Start-Sleep -Seconds 3
            }
            "5" {
                $snapshotName = Read-Host "  Enter snapshot name"
                VBoxManage snapshot "Kali-Linux-Wireless" take $snapshotName
                Write-Host "  Snapshot taken!" -ForegroundColor $colors.Secondary
                Start-Sleep -Seconds 2
            }
            "0" { return }
        }
    } while ($true)
}

function Invoke-MCPMenu {
    do {
        Show-Banner
        Write-Host "  ╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor $colors.Primary
        Write-Host "  ║                      MCP SERVERS                             ║" -ForegroundColor $colors.Primary
        Write-Host "  ╠═══════════════════════════════════════════════════════════════╣" -ForegroundColor $colors.Primary
        Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
        Write-Host "  ║  [1] Claude Code MCP List                                    ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [2] OpenCode MCP List                                       ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [3] Gemini CLI MCP List                                    ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [4] Add MCP Server                                         ║" -ForegroundColor $colors.Secondary
        Write-Host "  ║  [0] Back                                                        ║" -ForegroundColor $colors.Accent
        Write-Host "  ║                                                               ║" -ForegroundColor $colors.Primary
        Write-Host "  ╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor $colors.Primary
        Write-Host ""
        
        $choice = Read-Host "  Select option"
        
        switch ($choice) {
            "1" { 
                claude mcp list
                Write-Host ""
                Write-Host "  Press Enter to continue..." -ForegroundColor $colors.Accent
                Read-Host
            }
            "2" { 
                opencode mcp list
                Write-Host ""
                Write-Host "  Press Enter to continue..." -ForegroundColor $colors.Accent
                Read-Host
            }
            "3" { 
                gemini mcp list
                Write-Host ""
                Write-Host "  Press Enter to continue..." -ForegroundColor $colors.Accent
                Read-Host
            }
            "4" {
                Write-Host "  MCP Server Configurations Available:" -ForegroundColor $colors.Secondary
                Write-Host "  - filesystem"
                Write-Host "  - github"
                Write-Host "  - brave-search"
                Write-Host "  - memory"
                Write-Host "  - context7"
                Write-Host "  - notion"
                Write-Host "  - composio"
                $name = Read-Host "  Enter MCP server name to add"
                $server = Read-Host "  Enter server command (npx -y ...)"
                claude mcp add $name -- $server
            }
            "0" { return }
        }
    } while ($true)
}

# Main Loop
do {
    Show-Menu
    $choice = Read-Host "  Select option"
    
    switch ($choice) {
        "1" { Invoke-AIToolsMenu }
        "2" { Invoke-KaliMenu }
        "3" { 
            Write-Host "  Wireless/Pentest tools in Kali VM" -ForegroundColor $colors.Secondary
            Write-Host "  Use SSH to Kali: ssh root@192.168.56.10" -ForegroundColor $colors.Secondary
            Start-Sleep -Seconds 3
        }
        "4" { Invoke-MCPMenu }
        "5" { 
            Write-Host "  Quick Scripts:" -ForegroundColor $colors.Secondary
            Write-Host "  - ai-launcher.bat"
            Write-Host "  - enhance-kali.sh (run in Kali)"
            Start-Sleep -Seconds 3
        }
        "6" {
            Write-Host "  Settings:" -ForegroundColor $colors.Secondary
            Write-Host "  - Theme: $Theme"
            Start-Sleep -Seconds 2
        }
        "7" {
            Show-Banner
            Get-SystemInfo
            Write-Host ""
            Write-Host "  Press Enter to continue..." -ForegroundColor $colors.Accent
            Read-Host
        }
        "0" { 
            Write-Host "  Goodbye!" -ForegroundColor $colors.Secondary
            exit 
        }
    }
} while ($true)
