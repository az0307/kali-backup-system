@echo off
REM AI Tools & VM Quick Launcher for Windows
REM Save as: ai-launcher.bat

setlocal enabledelayedexpansion

:menu
cls
color 0A
echo.
echo  ========================================================================
echo  ^|           ^)  AI Tools ^& Pentesting Launcher                      ^|
echo  ========================================================================
echo.
echo  [1] OpenCode           - AI Coding Assistant
echo  [2] Claude Code        - Anthropic AI
echo  [3] Gemini CLI         - Google AI
echo  [4] TARS              - Agent TARS
echo.
echo  ----------------------------------------------------------------
echo  [5] Start Kali VM      - VirtualBox
echo  [6] Kali Status        - Check VM
echo  [7] SSH to Kali        - Connect via SSH
echo.
echo  ----------------------------------------------------------------
echo  [8] MCP Status         - Check MCP servers
echo  [9] Skills List        - Show available skills
echo  [0] Exit
echo.
echo  ========================================================================
set /p choice="Select option: "

if "%choice%"=="1" goto opencode
if "%choice%"=="2" goto claude
if "%choice%"=="3" goto gemini
if "%choice%"=="4" goto tars
if "%choice%"=="5" goto start-kali
if "%choice%"=="6" goto kali-status
if "%choice%"=="7" goto ssh-kali
if "%choice%"=="8" goto mcp-status
if "%choice%"=="9" goto skills-list
if "%choice%"=="0" goto end

echo Invalid option
timeout /t 2 >nul
goto menu

:opencode
echo.
echo Starting OpenCode...
call opencode
goto menu

:claude
echo.
echo Starting Claude Code...
call claude
goto menu

:gemini
echo.
echo Starting Gemini CLI...
call gemini
goto menu

:tars
echo.
echo Starting TARS...
call agent-tars
goto menu

:start-kali
echo.
echo Starting Kali Linux VM...
VBoxManage startvm "Kali-Linux-Wireless" --type headless
echo VM started! Wait 30 seconds for boot...
timeout /t 30 >nul
echo Done
timeout /t 2 >nul
goto menu

:kali-status
echo.
echo Checking Kali VM status...
VBoxManage list vms
echo.
echo Running VMs:
VBoxManage list runningvms
timeout /t 5 >nul
goto menu

:ssh-kali
echo.
echo Connecting to Kali via SSH...
echo Default: root@192.168.56.10
echo.
ssh root@192.168.56.10
goto menu

:mcp-status
echo.
echo ========================================
echo MCP Server Status
echo ========================================
echo.
echo [Claude Code]
claude mcp list 2>nul || echo   Not available
echo.
echo [OpenCode]
opencode mcp list 2>nul || echo   Not available
echo.
echo [Gemini CLI]
gemini mcp list 2>nul || echo   Not available
echo.
pause
goto menu

:skills-list
echo.
echo ========================================
echo Available Skills
echo ========================================
echo.
opencode debug skill 2>nul || echo Skills not loaded
echo.
pause
goto menu

:end
cls
echo.
echo Goodbye!
echo.
exit /b 0
