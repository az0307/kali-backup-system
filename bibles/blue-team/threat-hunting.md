# Threat Hunting Bible

## Hunting Methodology

### Intel-Based
- Use threat intelligence
- MITRE ATT&CK framework
- Recent campaigns
- IOCs from incidents

### Anomaly-Based
- Baseline normal behavior
- Detect deviations
- Statistical analysis
- ML-based detection

### Hypothesis-Driven
- "What if attacker did X?"
- Design searches for tactics
- Test hypotheses with data

### Automation
- Scheduled searches
- Real-time alerts
- SOAR integration

## Hunting Locations

### Endpoint
- **Processes** - Running processes
  - `Get-Process` (PowerShell)
  - Sysinternals tools
  - Volatility `pslist`

- **Persistence** - Startup locations
  - Registry Run keys
  - Scheduled tasks
  - Services

- **Network** - Connections
  - Active connections
  - DNS queries
  - HTTP traffic

- **Files** - File system
  - New/modified files
  - Suspicious locations
  - Temp directories

### Network
- **Zeek** - Network monitoring
- **Suricata** - IDS/IPS
- **Wireshark** - Packet analysis
- **Network taps** - Full packets

### Cloud
- **AWS CloudTrail** - API calls
- **Azure Monitor** - Logs
- **GCP Audit Logs** - Activity

## MITRE ATT&CK Mapping

### Initial Access
- Phishing links
- Exploitable services
- Valid accounts

### Execution
- User execution
- Script interpreters
- Native API

### Persistence
- Registry Run keys
- Scheduled tasks
- Services
- Bash profiles

### Privilege Escalation
- Valid accounts
- Exploitation
- Sudo/sudo

### Defense Evasion
- Disabling security
- File deletion
- Encrypted payloads

### Lateral Movement
- SMB/Windows Admin
- Remote services
- Exploitation of services

### Collection
- Screen capture
- Keylogging
- Email collection

### Exfiltration
- Exfiltration over C2
- Data compression
- Encrypted channels

## Hunting Tools

### SIEM Queries
- Splunk
- Elastic
- Microsoft Sentinel
- Splunk

### Custom Scripts
- PowerShell
- Python
- Bash

### Frameworks
- **HELK** - Hunting ELK
- **Mythic** - C2 framework
- **Atomic Red Team** - Atomic tests

## IOCs

### Types
- IP addresses
- Domains
- File hashes
- File paths
- Registry keys
- Email addresses
- URLs

### Sources
- Threat feeds
- MISP
- AlienVault OTX
- VirusTotal
- Hybrid Analysis

## Documentation

### Hunting Reports
- Hypothesis
- Data sources
- Findings
- Recommendations

### Metrics
- Hunts performed
- IOCs found
- Time to detect
- Coverage

## Tools
- Splunk
- Elastic
- Microsoft Sentinel
- Zeek
- Suricata
- Volatility
- PowerShell
- Python

## References
- MITRE ATT&CK
- sqrrl/Threat-Hunting
- Chris Long (Detection Lab)