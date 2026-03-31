# Monitor Agent Configuration

## Agent: monitor-agent
## Platform: Both (Laptop + Desktop)
## Purpose: Health monitoring and alerts

### Functions
- Network connectivity checks
- Service monitoring
- Log aggregation
- Alert on failures

### Checks
```bash
# Connectivity
ping -c 1 192.168.1.100
ping -c 1 192.168.1.200
ping -c 1 8.8.8.8

# Service checks
systemctl status ssh
systemctl status apache2

# Disk usage
df -h
```

### Alerts
- Email on failure
- Log to /var/log/monitor.log
- Push notification
