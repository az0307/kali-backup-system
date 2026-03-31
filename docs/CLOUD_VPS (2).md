# ☁️ Cloud & VPS Options for Your Home Lab

## Overview

Add cloud power to your setup for:
- **Reconnaissance** - Nmap scanning from cloud IP
- **C2 Servers** - Command & Control for red team ops
- **Storage** - Extra wordlists, payloads
- **Redundancy** - Backup if home connection fails

---

## 🥇 Recommended VPS Providers

### 1. DigitalOcean
```
Price: $4-24/month
Best for: General pentesting, good network
Signup: digitalocean.com
Referral: $200 credit for 60 days
```

### 2. Linode (Akamai)
```
Price: $5-30/month  
Best for: Reliable, fast
Signup: linode.com
Note: Now part of Akamai
```

### 3. Hetzner
```
Price: €3-30/month (~$3-33)
Best for: Cheapest EU servers
Location: Germany, Finland, US
```

### 4. Oracle Cloud (FREE!)
```
Price: FREE forever
Best for: ARM-based testing
VMs: 2x ARM + 4GB RAM + 200GB storage
Signup: cloud.oracle.com
```

### 5. AWS
```
Price: Pay as you go
Best for: Full cloud suite
Services: EC2, S3, Lambda, etc.
Note: Complex pricing
```

---

## 🎯 Use Cases

### Pentest Recon VPS ($5/mo)
```
- Nmap scans
- subdomain enumeration
- web reconnaissance
- screenshot tools
```

### C2 Server ($10/mo)
```
- Covenant C2
- Sliver
- Metasploit
- Redirectors
```

### Storage VPS ($3/mo)
```
- Wordlists
- Payloads
- PCAP storage
- Backups
```

### Always-On VPN ($5/mo)
```
- Connect from anywhere
- Hide real IP
- Exit node for tools
```

---

## 🚀 Quick Setup Scripts

### DigitalOcean
```bash
# Install doctl
winget install digitalocean.doctl

# Authenticate
doctl auth init

# Create droplet
doctl compute droplet create pentest-vm \
  --size s-1vcpu-1gb \
  --image ubuntu-22-04 \
  --region nyc1 \
  --ssh-keys <your-key>

# SSH in
doctl compute ssh pentest-vm
```

### Oracle Cloud (Free ARM)
```
1. Go to cloud.oracle.com
2. Sign up for free tier
3. Create VM (Always Free eligible)
4. Choose:
   - Image: Ubuntu 22.04
   - Shape: Ampere (ARM)
   - 4 cores, 24GB RAM, 200GB storage!
```

---

## 🔧 Quick VPS Commands

### Ubuntu Security Setup
```bash
# Update
apt update && apt upgrade -y

# Install tools
apt install -y curl wget git vim htop net-tools \
    nmap sqlmap gobuster nikto jq \
    python3 python3-pip python3-venv

# Install Docker
curl -fsSL https://get.docker.com | sh
usermod -aG docker $USER

# Firewall
ufw enable
ufw allow ssh
ufw allow 80
ufw allow 443
```

### Pentest VPS
```bash
# Install best tools
wget https://raw.githubusercontent.com/4ndersonLin/pentest-vps/main/install.sh
chmod +x install.sh
./install.sh
```

---

## 📋 Checklist

- [ ] Choose VPS provider
- [ ] Create account
- [ ] Deploy first VPS
- [ ] Secure harden it
- [ ] Install tools
- [ ] Add to home-lab launcher

---

## 💰 Cost Estimate

| Setup | Monthly | Yearly |
|-------|---------|--------|
| Minimal (1GB) | $4 | $48 |
| Pentest (2GB) | $8 | $96 |
| Standard (4GB) | $16 | $192 |
| Full Lab (8GB) | $32 | $384 |
| Oracle Free | $0 | $0 |

---

## 🔗 Quick Links

- DigitalOcean: https://digitalocean.com
- Linode: https://linode.com
- Hetzner: https://hetzner.com
- Oracle: https://cloud.oracle.com
- AWS: https://aws.amazon.com

---

*Last Updated: 2026-03-16*
