# System Hardening Skill

## Purpose
Secure and harden Kali Linux systems.

## Tools
- ufw - Uncomplicated firewall
- iptables - Packet filtering
- fail2ban - Intrusion prevention
- lynis - Security audit
- chkrootkit - Rootkit detection

## Commands

### Firewall Setup
```bash
ufw enable
ufw default deny incoming
ufw allow ssh
ufw allow 22/tcp
```

### Security Audit
```bash
lynis audit system
chkrootkit
```

## Hardening Steps
1. Enable UFW firewall
2. Configure fail2ban
3. Disable unnecessary services
4. Set up log monitoring
5. Enable auditd

## Usage
Use to:
- Harden Kali installation
- Set up firewall rules
- Detect rootkits
- Security auditing
