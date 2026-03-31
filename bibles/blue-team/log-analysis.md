# Log Analysis Bible

## Log Types

### System Logs
- **Windows**: Event Viewer
  - Security (4624, 4625, 4672)
  - System (7045 new service)
  - Application
- **Linux**: /var/log/
  - auth.log - Authentication
  - syslog - System messages
  - kern.log - Kernel
  - dmesg - Boot messages

### Application Logs
- **Web Servers**
  - Apache: access.log, error.log
  - Nginx: access.log, error.log
  - IIS: W3C Extended Logs

- **Databases**
  - MySQL: error.log, slow.log
  - PostgreSQL: postgresql.log
  - MongoDB: mongod.log

- **Applications**
  - Application-specific logs
  - Custom logging
  - Debug logs

### Network Logs
- **Firewalls**
  - Blocked connections
  - Allowed connections
  - NAT translations

- **IDS/IPS**
  - Alert logs
  - Signature triggers
  - Packet captures

- **DNS**
  - Query logs
  - Zone transfers
  - Failures

## Log Collection

### Agents
- **Osquery** - Query-based collection
  - `SELECT * FROM processes`
  - Schedule queries
  
- **Filebeat** - Log shipping
  - Forward to Elasticsearch
  - Parse with grok
  
- **Winlogbeat** - Windows events
  - Forward to SIEM
  - Filter specific channels

### Centralization
- **ELK Stack** - Elasticsearch, Logstash, Kibana
- **Splunk** - Enterprise search
- **Graylog** - Open-source
- **Wazuh** - Security-focused

## Analysis Techniques

### Pattern Recognition
- Regular expressions
- Log patterns
- Anomaly detection

### Correlation
- Time-based correlation
- Event linking
- Attack chain reconstruction

### Searching
- Full-text search
- Field-based queries
- Boolean operators

## Key Log Events

### Windows Security
| Event ID | Description |
|----------|-------------|
| 4624 | Successful logon |
| 4625 | Failed logon |
| 4634 | Logoff |
| 4672 | Special privileges assigned |
| 4720 | User account created |
| 4726 | User account deleted |
| 7045 | New service installed |

### Linux Auth
- Failed sudo attempts
- SSH connections (accept/fail)
- Sudo commands executed
- User creation/deletion

### Web Server
- 200/300 - Success
- 400 - Client error
- 500 - Server error
- SQL injection attempts
- Directory traversal

## Tools

### Analysis
- **Splunk** - Enterprise SIEM
- **Kibana** - ELK visualization
- **Graylog** - Open-source
- **LNav** - CLI log viewer
- **lnav** - Log file navigator
- **grep/sed/awk** - Text processing

### Parsing
- **Grok** - Pattern-based parsing
- **Syslog-ng** - Log server
- **Rsyslog** - Log processor

## Log Analysis for Security

### Detection
- Brute force attempts
- Privilege escalation
- Lateral movement
- Data exfiltration

### Investigation
- Timeline building
- Root cause analysis
- Scope determination

## Tools
- Splunk
- ELK Stack
- Graylog
- Wazuh
- LNav
- Syslog-ng
- Rsyslog

## References
- Splunk Search Reference
- MITRE ATT&CK Logging
- Windows Event Log IDs