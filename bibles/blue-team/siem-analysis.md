# SIEM Analysis Bible

## SIEM Platforms

### Open Source
- **Wazuh** - Full SIEM (log analysis, IDS, vulnerability)
  - `apt install wazuh-manager`
  - Web UI: https://localhost
  - Agents for endpoint collection

- **OSSEC** - Host-based IDS
  - `apt install ossec-hids`
  - File integrity monitoring
  - Rootkit detection

- **Security Onion** - Network + host monitoring
  - `setup` - Initial configuration
  - Includes Zeek, Suricata, OSSEC

- **HELK** - ELK + Hunting
  - Docker-based
  - Jupyter notebooks for analysis

### Commercial
- **Splunk** - Enterprise SIEM
- **Elastic Security** - ELK-based
- **Microsoft Sentinel** - Cloud SIEM
- **IBM QRadar** - Enterprise SIEM
- **AlienVault OSSIM** - Open-source

## Log Sources

### Windows Events
- **Security** - Logon, privilege use, object access
- **System** - Service, driver issues
- **Application** - App-specific events
- **PowerShell** - Script execution
- **Sysmon** - Detailed process, network

### Linux Logs
- `/var/log/auth.log` - Authentication
- `/var/log/syslog` - System messages
- `/var/log/apache2/` - Web server
- `/var/log/nginx/` - Nginx logs
- Audit logs (`/var/log/audit/`)

### Network Devices
- **Firewall** - Blocked/allowed traffic
- **IDS/IPS** - Alert logs
- **DNS** - Query logs
- **DHCP** - Leases, assignments

### Cloud
- AWS CloudTrail
- Azure Activity Log
- GCP Audit Logs

## Correlation Rules

### Detection Examples
- Brute force: Multiple failed logins → account lock
- Lateral movement: Unusual service/port
- Data exfiltration: Large outbound data
- Privilege escalation: New admin group membership
- Malware: Suspicious process + network

### Writing Rules
- SPL (Splunk) - `index=* | stats count by src_ip`
- KQL (Elastic) - `process_name:evil.exe`
- Sigma rules - Portable detection rules
- Custom scripts for complex logic

## Investigation

### Workflow
1. Alert triggered
2. Review alert details
3. Search related logs
4. Identify scope (who, what, when)
5. Determine root cause
6. Contain/eradicate
7. Document findings

### Timeline Analysis
- Build timeline of events
- Identify entry point
- Track attacker actions
- Determine dwell time
- Scope the impact

### Threat Hunting
- Proactive searches
- MITRE ATT&CK mapping
- Anomaly detection
- IOC scanning

## Dashboards

### Key Dashboards
- Executive summary
- Top alerts by severity
- Attack timeline
- Geographic map of attacks
- Asset inventory
- Compliance status

### Custom Dashboards
- Splunk dashboards
- Kibana visualizations
- Grafana integrations

## Integrations

### SOAR
- Shuffle
- TheHive
- Cortex
- Splunk SOAR

### Threat Intel
- MISP
- OTX AlienVault
- Hybrid Analysis
- VirusTotal

## Alert Tuning

### Reduce False Positives
- Baseline normal behavior
- Tune rules to environment
- Add exceptions
- Update detection logic

## Tools
- Splunk
- Wazuh
- Elastic Security
- Microsoft Sentinel
- Security Onion
- TheHive
- MISP

## References
- Splunk Docs
- MITRE ATT&CK
- Elastic Security Docs