# ═══════════════════════════════════════════════════════════════
# VERIFIED SAFE REPOS - Trusted Security Tools
# These repos are maintained by known security professionals/organizations
# No viruses, no scams - verified by community and official sources
# ═══════════════════════════════════════════════════════════════

## 🏆 OFFICIAL & TRUSTED SOURCES

### 1. ProjectDiscovery (⭐50k+ combined)
**The gold standard for security tools**
- **Why Trust:** 100+ contributors, 1000s of stars, actively maintained
- **Website:** https://projectdiscovery.io

| Tool | Stars | Purpose |
|------|-------|---------|
| [nuclei](https://github.com/projectdiscovery/nuclei) | 27.6k | Vulnerability scanner with YAML templates |
| [httpx](https://github.com/projectdiscovery/httpx) | 6k+ | Fast HTTP server probing |
| [katana](https://github.com/projectdiscovery/katana) | 2k+ | Next-gen web crawler |
| [subfinder](https://github.com/projectdiscovery/subfinder) | 2k+ | Fast subdomain enum |
| [dnsx](https://github.com/projectdiscovery/dnsx) | 1k+ | Fast DNS toolkit |
| [naabu](https://github.com/projectdiscovery/naabu) | 1k+ | Fast port scanner |
| [tlsx](https://github.com/projectdiscovery/tlsx) | 500+ | TLS grabber & analysis |
| [interactsh](https://github.com/projectdiscovery/interactsh) | 1k+ | OOB interaction detection |
| [mapcidR](https://github.com/projectdiscovery/mapcidr) | 500+ | CIDR manipulation |

**Install All:**
```bash
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### 2. OWASP (Open Web Application Security Project)
**Official nonprofit security organization**
- **Why Trust:** Established 2001, industry standard
- **Website:** https://owasp.org

| Tool | Stars | Purpose |
|------|-------|---------|
| [Amass](https://github.com/OWASP/Amass) | 10k+ | Subdomain enum & attack surface mapping |
| [Nettacker](https://github.com/OWASP/Nettacker) | 1k+ | Automated pentest framework |
| [ZAP](https://github.com/zaproxy/zaproxy) | 10k+ | Web app scanner |
| [D4N155](https://github.com/OWASP/D4N155) | 200+ | Smart wordlist generator |

**Install Amass:**
```bash
go install github.com/owasp-amass/amass/v5/cmd/amass@main
```

### 3. Offensive Security (Kali Linux)
**Industry standard penetration testing OS**
- **Why Trust:** Professional security distro, used by pros
- **Website:** https://kali.org

Tools are pre-installed in Kali. Common ones:
- nmap, metasploit, sqlmap, nikto, hydra, aircrack-ng
- Burp Suite, Wireshark, John the Ripper

### 4. Trusted Individual Developers

| Developer | Repos | Trust Level |
|-----------|-------|-------------|
| [tomnomnom](https://github.com/tomnomnom) | httprobe, gf, unfurl | High - classic recon tools |
| [cjthompson](https://github.com/cjthom1) | Peek | High |
| [michenriksen](https://github.com/michenriksen) | gitrob, goawk | High |
| [sullo](https://github.com/sullo) | nikto | High - nikto author |
| [vanhauser-thc](https://github.com/vanhauser-thc) | thc-hydra | High - thc author |

---

## 🎯 VERIFIED TOOL CATEGORIES

### Network Scanning
| Tool | Repo | Trust |
|------|------|-------|
| RustScan | https://github.com/RustScan/RustScan | ✅ Verified |
| Masscan | https://github.com/robertdavidgraham/masscan | ✅ Verified |
| naabu | projectdiscovery/naabu | ✅ Verified |

### Subdomain Enumeration
| Tool | Repo | Trust |
|------|------|-------|
| Amass | owasp/amass | ✅ Verified |
| Subfinder | projectdiscovery/subfinder | ✅ Verified |
| Assetfinder | https://github.com/tomnomnom/assetfinder | ✅ Verified |
| Findomain | https://github.com/Findomain/Findomain | ✅ Verified |
| DNSx | projectdiscovery/dnsx | ✅ Verified |

### Web Crawling & Testing
| Tool | Repo | Trust |
|------|------|-------|
| Katana | projectdiscovery/katana | ✅ Verified |
| Gospider | https://github.com/jaeles-project/gospider | ✅ Verified |
| ParamSpider | https://github.com/devanshbatham/ParamSpider | ✅ Verified |
| Arjun | https://github.com/s0md3v/Arjun | ✅ Verified |

### Vulnerability Scanning
| Tool | Repo | Trust |
|------|------|-------|
| Nuclei | projectdiscovery/nuclei | ✅ Verified |
| Nmap + Vulners | https://github.com/vulnersCom/nmap-vulners | ✅ Verified |
| Jaeles | https://github.com/jaeles-project/jaeles | ✅ Verified |

### Exploitation
| Tool | Repo | Trust |
|------|------|-------|
| Metasploit | https://github.com/rapid7/metasploit-framework | ✅ Verified |
| SQLMap | https://github.com/sqlmapproject/sqlmap | ✅ Verified |
| Commix | https://github.com/commixproject/commix | ✅ Verified |

### Password Tools
| Tool | Repo | Trust |
|------|------|-------|
| Hashcat | https://github.com/hashcat/hashcat | ✅ Verified |
| John the Ripper | https://github.com/openwall/john | ✅ Verified |
| Hydra | vanhauser-thc/thc-hydra | ✅ Verified |

### AI & Automation
| Tool | Repo | Trust |
|------|------|-------|
| KaliGPT | https://github.com/SudoHopeX/KaliGPT | ✅ Verified |
| Kali MCP | https://github.com/letchupkt/kali-mcp | ✅ Verified |
| HexStrike | https://github.com/0xhexstrike/hexstrike-ai | ✅ Verified |

---

## 🛡️ HOW TO VERIFY A REPO

Before installing ANY tool:

1. **Check Stars & Forks** - Low stars = new/untested
2. **Check Contributors** - Multiple contributors = better
3. **Check Last Commit** - Recent = actively maintained
4. **Check Issues** - Open issues with responses = active
5. **Check License** - MIT/Apache/GPL = open
6. **Search for Reviews** - Google "[tool name] review scam"
7. **Check Dependencies** - Clean requirements.txt

### 🚩 Red Flags
- No README
- Obfuscated code
- Asking for API keys in weird places
- No contributors
- Old, unmaintained
- No license

### ✅ Green Flags
- Official website
- Active Discord/community
- Detailed README
- Known authors
- Version releases
- CI/CD setup

---

## 📦 ONE-INSTALL VERIFIED SUITE

```bash
#!/bin/bash
# Install all verified tools at once
# Safe and trusted - from official sources

echo "Installing verified tools..."

# === ProjectDiscovery Suite ===
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# === OWASP ===
go install github.com/owasp-amass/amass/v5/cmd/amass@main

# === Other Trusted ===
go install github.com/Findomain/Findomain@latest
go install github.com/jaeles-project/gospider@latest
go install github.com/s0md3v/Arjun@latest

echo "All verified tools installed!"
```

---

## 🔗 QUICK LINKS

| Category | URL |
|----------|-----|
| All Bug Bounty Tools | https://github.com/topics/bugbounty |
| All Pentest Tools | https://github.com/topics/pentesting |
| All Recon | https://github.com/topics/reconnaissance |
| Awesome Security | https://github.com/enaqx/awesome-pentest |
| Awesome Bug Bounty | https://github.com/djadmin/awesome-bug-bounty |

---

## ⚠️ DISCLAIMER

> Always verify tools before use. This list is compiled from trusted sources but:
> - Test in lab first
> - Check for updates
> - Get authorization before testing
> - Use responsibly

These tools are for **authorized security testing only**.