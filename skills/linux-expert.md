---
name: linux-expert
description: >
  Linux system administration and troubleshooting expert. Use for: package management, system configuration, 
  service management, user management, disk management, networking config, shell scripting, cron jobs,
  permissions, systemd, boot issues, performance tuning, security hardening.
compatibility:
  tools: [bash, systemctl, apt, yum, dnf, snap, yum, chmod, chown, ls, cd, pwd, grep, awk, sed]
  os: [linux, debian, ubuntu, kali, fedora, centos, arch]
---

# Linux Expert

## Quick Commands

### Packages
```bash
apt update && apt upgrade -y          # Debian/Ubuntu/Kali
yum update -y                         # CentOS/RHEL
snap install package                 # Snap
pip3 install package                 # Python
```

### Services
```bash
systemctl start service
systemctl enable service
systemctl status service
journalctl -u service -n 50
```

### Files
```bash
find / -name "file" 2>/dev/null
grep -r "pattern" /path/
ls -lah /path/
chmod +x file
chown user:group file
```

### Networking
```bash
ip addr
ip route
netstat -tulpn
ss -tulpn
/etc/network/interfaces
```

### Process
```bash
ps aux | grep process
top
htop
kill -9 pid
pkill name
```

### Logs
```bash
/var/log/syslog
/var/log/auth.log
journalctl -xe
dmesg
```

---

## Solve Issues

Tell me what issue you're having and I'll help solve it!
