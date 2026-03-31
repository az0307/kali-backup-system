#!/bin/bash
# Install SSH Server on Kali for Remote Access
# Run as root in Kali

echo "=========================================="
echo "Installing SSH Server for Remote Access"
echo "=========================================="

# Install OpenSSH server
echo "[1/4] Installing OpenSSH..."
sudo apt update
sudo apt install -y openssh-server

# Configure SSH
echo "[2/4] Configuring SSH..."
sudo cat > /etc/ssh/sshd_config.d/kali.conf << 'EOF'
# Allow root login (for Termux access)
PermitRootLogin yes

# Change default port (optional - for security)
Port 22

# Allow password authentication
PasswordAuthentication yes

# Disable empty passwords
PermitEmptyPasswords no
EOF

# Generate SSH keys if not exist
echo "[3/4] Generating SSH keys..."
sudo ssh-keygen -A

# Start SSH service
echo "[4/4] Starting SSH service..."
sudo service ssh start

# Enable on boot
sudo systemctl enable ssh

echo ""
echo "=========================================="
echo "SSH Server Installed!"
echo "=========================================="
echo ""
echo "To find your IP address:"
echo "  ip addr show"
echo ""
echo "From Termux, connect with:"
echo "  ssh root@YOUR_KALI_IP"
echo ""
echo "Default port: 22"
echo ""
echo "To get IP address:"
echo "  hostname -I"
