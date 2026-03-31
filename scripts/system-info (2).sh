#!/bin/bash
# ====================================================================
# Kali Share - Neofetch System Info
# Custom info display for USB
# ====================================================================

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   KALI SHARE - SYSTEM INFO                      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# OS Info
OS=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p 2>/dev/null || echo "Unknown")

echo -e "${GREEN}OS:${NC}        $OS"
echo -e "${GREEN}Kernel:${NC}    $KERNEL"
echo -e "${GREEN}Uptime:${NC}    $UPTIME"
echo ""

# Hardware
if command -v lscpu &> /dev/null; then
    CPU=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
    echo -e "${GREEN}CPU:${NC}      $CPU"
fi

if command -v free &> /dev/null; then
    RAM=$(free -h | grep Mem | awk '{print $2}')
    echo -e "${GREEN}RAM:${NC}      $RAM"
fi
echo ""

# Network
echo -e "${GREEN}Network:${NC}"
echo -e "  IP: $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'N/A')"
echo -e "  Gateway: $(ip route | grep default | awk '{print $3}' | head -1)"
echo ""

# Disk Usage
echo -e "${GREEN}Storage:${NC}"
df -h / | tail -1 | awk '{print "  Root: " $3 " / " $2 " (" $5 ")"}'
echo ""

# Services
echo -e "${GREEN}Services:${NC}"
echo -e "  SSH: $(systemctl is-active ssh 2>/dev/null || echo 'inactive')"
echo -e "  Apache: $(systemctl is-active apache2 2>/dev/null || echo 'inactive')"
echo -e "  PostgreSQL: $(systemctl is-active postgresql 2>/dev/null || echo 'inactive')"
echo ""

# Quick Links
echo -e "${YELLOW}Quick Links:${NC}"
echo "  Menu: sudo ./MENU"
echo "  Scripts: ls scripts/"
echo "  Skills: ls skills/"
echo ""