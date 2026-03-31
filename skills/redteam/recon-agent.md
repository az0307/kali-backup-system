# Reconnaissance Agent Skill

## Purpose
OSINT and reconnaissance automation for penetration testing.

## Tools
- theHarvester - Email gathering
- recon-ng - Reconnaissance framework
- spiderfoot - OSINT automation
- maltego - Link analysis
- assetfinder - Subdomain enumeration
- amass - Attack surface mapping

## Commands

### Email Harvest
```bash
theHarvester -d target.com -b all
```

### Subdomain Enum
```bash
assetfinder target.com
amass enum -d target.com
```

### Full Recon
```bash
spiderfoot -s target.com
```

## Usage
Use for:
- Email gathering
- Subdomain enumeration
- OSINT collection
- Attack surface mapping
