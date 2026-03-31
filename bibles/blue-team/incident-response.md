# Incident Response Bible

## Preparation

### IR Plan
- Define incident classifications
- Establish roles/responsibilities
- Document communication plan
- Define escalation path
- Practice scenarios

### Tools
- **Flare** - Incident response Linux distro
- **SIFT** - SANS Investigative Framework
- **CAINE** - Live CD for forensics

### Pre-Built Kits
- Evidence collection scripts
- Memory acquisition tools
- Network capture tools

## Detection & Analysis

### Signs of Compromise
- Unusual network traffic
- Unexpected processes
- Unknown accounts
- Log anomalies
- Performance issues
- User reports

### Triage
- Determine scope
- Assess severity
- Identify affected systems
- Preserve evidence
- Initial containment

### Analysis Tools
- **Volatility** - Memory forensics
- **Autopsy** - Disk forensics
- **Wireshark** - Network analysis
- **X-Ways** - Low-level forensics

## Containment

### Short-term
- Isolate affected systems
- Block malicious IPs/domains
- Disable compromised accounts
- Stop malicious processes

### Long-term
- Patch vulnerabilities
- Reset compromised credentials
- Rebuild affected systems
- Enhanced monitoring

## Eradication

### Steps
- Remove malware
- Close vulnerabilities
- Patch systems
- Change passwords
- Remove persistence mechanisms

### Verification
- Confirm threat removed
- Check for reinfection
- Validate system integrity

## Recovery

### Restoration
- Restore from clean backups
- Rebuild systems
- Rejoin to domain
- Resume services

### Monitoring
- Increased monitoring
- IOC scanning
- Log analysis
- User awareness

## Post-Incident

### Lessons Learned
- Timeline of events
- What worked/didn't
- Process improvements
- Training needs

### Documentation
- Incident report
- Evidence chain
- Chain of custody
- Recommendations

## Evidence Collection

### Memory
- **FTK Imager** - Memory capture
- **WinPmem** - Windows memory
- **LiME** - Linux memory
- **Magical Dump** - Mac memory

### Disk
- Write blocker (hardware/software)
- Image (dd, FTK, Guymager)
- Preserve timestamps
- Hash everything

### Network
- **Tcpdump** - Packet capture
- **Wireshark** - Packet analysis
- **Zeek** - Network monitoring

### Chain of Custody
- Document every transfer
- Use evidence bags
- Maintain logs
- Secure storage

## Key Tools
- FTK Imager
- Volatility
- Autopsy
- EnCase
- CAINE
- SIFT
- GRR
- Velociraptor

## Frameworks
- NIST SP 800-61
- SANS IR Process
- MITRE ATT&CK
- CIS Controls

## References
- SANS IR Training
- NIST Computer Security Incident Handling Guide
- DFIR Training