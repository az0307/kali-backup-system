# Network Monitoring Bible

## Monitoring Tools

### Open Source
- **Zeek** - Network monitoring
  - `zeek -i eth0` - Start monitoring
  - Logs in `/opt/zeek/logs/`
  - `zeek-cut` - Parse logs

- **Snort** - IDS/IPS
  - Rules in `/etc/snort/rules/`
  - `snort -i eth0 -c /etc/snort/snort.conf`

- **Suricata** - IDS/IPS
  - `suricata -i eth0 -c suricata.yaml`
  - EVE.json for JSON output

- **Argus** - Flow monitoring
- **Ntopng** - Network traffic
- **Prtg** - Multi-tool monitoring

### Commercial
- **SolarWinds** - Infrastructure
- **PRTG** - Network monitoring
- **Nagios** - Infrastructure
- **Zabbix** - Open-source monitoring

## Packet Capture

### Tools
- **Tcpdump** - CLI capture
  - `tcpdump -i eth0 -w capture.pcap`
  - `tcpdump -r capture.pcap`

- **Wireshark** - GUI analysis
- **Tshark** - CLI Wireshark
- **Dumpcap** - Capture only

### BPF Filters
- `tcpdump -i eth0 port 80`
- `tcpdump -i eth0 host 10.10.10.10`
- `tcpdump -i eth0 tcp and port 443`

## NetFlow/sFlow

### NetFlow
- **Nfdump** - NetFlow collection
  - `nfdump -r /var/cache/nfdump/`
  - `nfreplay` - Replay traffic

- **SiLK** - Flow collection
- **fprobe** - NetFlow exporter

### sFlow
- **sflowtool** - sFlow decoder

## Traffic Analysis

### Bandwidth
- **vnstat** - Bandwidth monitoring
- **Iperf** - Throughput testing
- **Speedtest** - Internet speed

### Protocols
- **Zeek** - Protocol parsing
- **Wireshark** - Deep inspection
- **NetworkMiner** - Quick analysis

### Performance
- **Smokeping** - Latency
- **Cacti** - Graphing
- **Grafana** - Visualization

## Security Monitoring

### IDS
- **Snort Rules**
  ```
  alert tcp any any -> any any (msg:"SQL Injection"; content:"union select"; sid:100001;)
  ```

- **Suricata Rules**
  - Enable rules in config
  - Custom rules in `rules/`

### SIEM Integration
- Send logs to SIEM
- Correlate events
- Alert on anomalies

## Network Discovery

### Discovery Tools
- **Nmap** - Port scanning
- **Masscan** - Fast scan
- **Angry IP Scanner** - GUI scanner
- **Netdiscover** - ARP discovery

### Topology
- **OpenNMS** - Discovery
- **Zabbix** - Auto-discovery

## Centralized Monitoring

### Collection
- **Elastic Beats**
  - Filebeat - Log files
  - Packetbeat - Network
  - Metricbeat - Metrics

- **Prometheus** - Metrics
- **Grafana** - Visualization

### Dashboards
- Network overview
- Top talkers
- Protocol distribution
- Alert summary

## Tools
- Zeek
- Suricata
- Snort
- Wireshark
- Tcpdump
- Ntopng
- PRTG
- Nagios

## References
- Zeek Documentation
- Suricata Rules
- Network Monitoring Guide