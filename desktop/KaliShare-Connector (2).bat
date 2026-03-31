@echo off
REM ====================================================================
REM KALI SHARE CONNECTOR LAUNCHER
REM Launch the KaliShare Connector desktop app
REM ====================================================================

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║        KaliShare Connector v1.0                       ║
echo ╚══════════════════════════════════════════════════════╝
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found!
    echo Please install Python 3.8+ from python.org
    echo.
    pause
    exit /b 1
)

REM Check if paramiko is installed
python -c "import paramiko" >nul 2>&1
if errorlevel 1 (
    echo Installing required packages...
    pip install paramiko
)

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"

REM Check if the Python script exists
if not exist "%SCRIPT_DIR%KaliShare-Connector.py" (
    echo ERROR: KaliShare-Connector.py not found!
    echo Make sure this batch file is in the same folder as the Python script
    pause
    exit /b 1
)

REM Run the connector
echo Starting KaliShare Connector...
echo.
python "%SCRIPT_DIR%KaliShare-Connector.py"

pause