# KaliShare Skills Catalog

## Overview
KaliShare contains 30+ skills organized by category. Skills are markdown files that provide specialized instructions for AI agents and tools.

## Category: Core Skills

### Expert Pentester
- **File:** `skills/expert-pentester.md`
- **Purpose:** Master pentest workflow and tools
- **Commands:** Full penetration testing methodology

### Linux Expert
- **File:** `skills/linux-expert.md`
- **Purpose:** Linux system administration
- **Commands:** File management, processes, networking

### Coding Expert
- **File:** `skills/coding-expert.md`
- **Purpose:** Script development and automation
- **Commands:** Python, Bash, Ruby development

## Category: Red Team

| Skill | File | Purpose |
|-------|------|---------|
| Network Scanner | `skills/redteam/network-scanner.md` | Network reconnaissance |
| WiFi Auditor | `skills/redteam/wifi-auditor.md` | Wireless pentesting |
| Recon Agent | `skills/redteam/recon-agent.md` | OSINT automation |
| Exploit Finder | `skills/redteam/exploit-finder.md` | Exploit discovery |
| Red Team Guide | `skills/redteam-guide.md` | Red team operations |

## Category: System

| Skill | File | Purpose |
|-------|------|---------|
| Backup Manager | `skills/system/backup-manager.md` | System backup |
| Hardening | `skills/system/hardening.md` | Security hardening |

## Category: Hybrid

| Skill | File | Purpose |
|-------|------|---------|
| SSH Manager | `skills/hybrid/ssh-manager.md` | SSH automation |
| Orchestrator | `skills/hybrid/orchestrator.md` | Workflow orchestration |

## Category: Specialized

| Skill | File | Purpose |
|-------|------|---------|
| File Creator | `skills/file-creator.md` | Document generation |
| Test Expert | `skills/test-expert.md` | Testing methodology |
| USB WiFi Fix | `skills/usb-wifi-fix.md` | WiFi driver issues |
| AI 2026 | `skills/ai-2026.md` | AI tool integration |
| Automation Learning | `skills/automation-learning.md` | Automation patterns |

## Category: Reference

| Skill | File | Purpose |
|-------|------|---------|
| Kali Expert | `skills/kali-expert.md` | Kali Linux mastery |
| VirtualBox Setup | `skills/virtualbox-setup.md` | VM configuration |
| Templates | `skills/templates.md` | Document templates |
| Packages | `skills/packages.md` | Tool packages |
| Commands | `skills/commands.md` | Command reference |
| Hardware | `skills/hardware.md` | Hardware guides |
| Deep Dive | `skills/deepdive-complete.md` | Comprehensive guide |
| Legal | `skills/legal.md` | Legal considerations |

## Category: AI Integration

| Skill | File | Purpose |
|-------|------|---------|
| Gemini RedTeam | `skills/gemini-redteam-gem.md` | Gemini CLI for pentest |
| Claude RedTeam | `skills/claude-redteam-agent.md` | Claude Code for pentest |
| Kali RedTeam Curator | `skills/kali-redteam-curator.md` | AI tool curation |
| Scripts Skill | `skills/scripts-skill.md` | Script management |

## Skill Usage

### With OpenCode
Skills are automatically loaded from `~/.config/opencode/skills/` when relevant.

### With Claude/Gemini
Use skill files as reference documents for context.

### Direct Execution
```bash
# Read skill
cat skills/expert-pentester.md

# Use as reference
source skills/scripts-skill.md
```

## Creating New Skills

Create skill files in `skills/` directory:
```markdown
# Skill Name

**Purpose:** What the skill does

## Commands
- command1 - description
- command2 - description

## Usage
Example usage scenarios
```

## Related Tools

- **CLI:** `cli/go` - Main command interface
- **Scripts:** `scripts/*.sh` - Automation scripts
- **Docs:** `docs/` - Detailed documentation
- **MCP:** `mcp/*.py` - Model Context Protocol servers