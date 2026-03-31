# AGENTS.md - KaliShare Coding Guidelines

> AI agents operating in this repository should follow these guidelines.

## Project Overview

**KaliShare** - Home lab penetration testing toolkit with Kali Linux, WiFi pentesting, Windows password reset, AI tools integration, and automated workflows. Contains bash scripts, batch files, chain workflows, skills, and agents.

---

## Build / Test Commands

### Running Scripts
```bash
# Make script executable
chmod +x script.sh

# Run with sudo (most pentest tools require root)
sudo ./script.sh

# Run from USB mount point
sudo mount /dev/sdb1 /mnt
cd /mnt && sudo ./QUICK-START.sh
```

### Testing Scripts
```bash
# ShellCheck linting (install: sudo apt-get install shellcheck)
shellcheck scripts/*.sh

# Run specific check
shellcheck -s bash -x scripts/menu.sh

# Test script syntax without execution
bash -n script.sh
```

### Quick Commands (via go CLI)
```bash
sudo ./cli/go status        # Check systems
sudo ./cli/go wifi-menu    # WiFi tools
sudo ./cli/go pentest <ip> # Run pentest
sudo ./cli/go win-reset    # Reset Windows password
```

---

## Code Style Guidelines

### Shell Scripts (.sh)
- **Shebang:** Always use `#!/bin/bash` (not `/bin/sh`)
- **Exit on error:** Start scripts with `set -euo pipefail`
- **Indentation:** 2 spaces, no tabs
- **Line length:** Max 80 characters
- **Quotes:** Use double quotes for variables, single for literals

### Bash Best Practices
```bash
#!/bin/bash
# ✅ Correct
set -euo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/logs/$(basename "$0").log"

# ❌ Avoid
set -x  # Don't leave debug on
cd ..   # Always use absolute paths
rm -rf $VAR  # Quote variables
```

### Batch Files (.bat/.cmd)
- Use `.bat` for Windows compatibility
- Enable delayed expansion when needed: `setlocal enabledelayedexpansion`
- Always check for admin: `net session >nul 2>&1`

### Error Handling
```bash
# Trap errors
trap 'echo "Error on line $LINENO"' ERR

# Check root
if [[ $EUID -ne 0 ]]; then
   echo "Run as root" >&2
   exit 1
fi

# Validate inputs
if [[ -z "$1" ]]; then
   echo "Usage: $0 <target>" >&2
   exit 1
fi
```

---

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Scripts | kebab-case | `auto-connect-ethernet.sh` |
| Functions | camelCase | `checkRoot()` |
| Variables | UPPER_SNAKE or camelCase | `TARGET_IP`, `logFile` |
| Constants | UPPER_SNAKE | `MAX_RETRIES=3` |
| Chain files | kebab-case | `full-recon.md` |
| Skill files | kebab-case | `expert-pentester.md` |

---

## Imports / Dependencies

### External Tool Dependencies
Document at top of script with `# Dependencies:` comment:
```bash
# Dependencies: airmon-ng, airodump-ng, aircrack-ng, nmap, masscan
```

### Path Handling
```bash
# ✅ Use relative to script location
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ✅ Check tool exists before use
command -v nmap >/dev/null 2>&1 || { echo "nmap required" >&2; exit 1; }
```

---

## Project Structure

```
KaliShare/
├── cli/                 # go command and subcommands
│   ├── go              # Main CLI (26 commands)
│   ├── kali-ctl        # Kali control
│   ├── net-scan        # Network scanning
│   └── wifi-mon        # WiFi monitor
├── scripts/            # 70+ shell scripts
│   ├── skeleton-key/  # Password reset tools
│   └── *.sh           # Individual tools
├── chains/            # 9 workflow chains
│   ├── full-recon.md
│   ├── wifi-audit.md
│   └── boot-takeover.md
├── skills/            # Pentest skills (29 files)
│   ├── expert-pentester.md
│   ├── redteam/
│   └── system/
├── docs/              # Organized docs (6 folders)
│   ├── 01_GETTING_STARTED/
│   ├── 02_TOOLS/
│   └── ...
└── agents/            # AI agents
```

---

## Chain Workflow Format

Each chain should have:
```markdown
# Chain Name

**Trigger:** `go <command>`  
**Purpose:** Brief description

## Steps
1. Step one description
2. Step two description

## Tools Used
- tool1
- tool2

## Output
- output-file.txt
```

---

## Git Workflow

### Commits
- Use conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`
- Commit often with meaningful messages
- Push to GitHub regularly

### Current Status
- 3 commits on master branch
- Ready to push to remote (needs GitHub token)

---

## Security Considerations

- **Never commit secrets** - Use Bitwarden for API keys
- **Validate all inputs** - Never trust user input
- **Check root** - Most pentest tools require root
- **Log actions** - Write to log files for audit trail
- **Safe defaults** - Fail closed, not open

---

## Useful Commands

```bash
# Find scripts
find . -name "*.sh" -type f

# Search in scripts
grep -r "nmap" scripts/

# Count lines
wc -l scripts/*.sh

# Check USB mount
lsblk
sudo mount /dev/sdb1 /mnt
```

---

*Last Updated: 2026-03-27*
