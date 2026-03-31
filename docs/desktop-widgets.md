# 🖥️ Kali Desktop Widgets & Customization

## Make Kali Look & Feel Pro

---

## Quick Widget Install

```bash
# Install desktop widgets
sudo apt install -y \
    conky \
    screenfetch \
    neofetch \
    htop \
    btop \
    gotop \
    gtop \
    sysmon \
    resources
```

---

## System Monitors

### Conky (Desktop Overlay)
```bash
sudo apt install -y conky

# Create config
nano ~/.conkyrc
```

### Simple Config:
```bash
conky.config = {
    own_window = true,
    own_window_type = 'desktop',
    background = false,
    update_interval = 1,
    font = 'DejaVu Sans Mono:size=10',
};

conky.text = [[
${color green}SYSTEM ${hr 2}
Host: $alignr$nodename
Kernel: $alignr$kernel
Uptime: $alignr$uptime
CPU: $alignr${cpu}%
RAM: $alignr${memperc}%
Disk: $alignr${fs_used /}/${fs_size /}

${color green}NETWORK ${hr 2}
Down: $alignr${downspeed wlan0}
Up: $alignr${upspeed wlan0}
]]
```

### Start on Boot
```bash
# Add to startup applications
# Menu → Settings → Session and Startup → Application Autostart
# Add: conky
```

---

## Status Bar (Polybar/Latte)

### Install Polybar
```bash
sudo apt install -y polybar
```

### Or Use Latte Dock
```bash
sudo apt install -y latte-dock
```

---

## Desktop Widgets

### GNOME Extensions (If using GNOME)
```bash
# Enable desktop icons
gnome-extensions install desktop-icons@linuxonly.github.com

# System monitor
gnome-extensions install system-monitor@gnome-shell-extensions.gcampax.github.com
```

### KDE Plasma (If using KDE)
- Already has widgets!
- Right-click desktop → Add Widgets

---

## Quick Status Scripts

### CPU/RAM Display
```bash
# Add to panel or run in terminal
watch -n 1 'echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk "{print \$2}")% | RAM: $(free -h | grep Mem | awk "{print \$3}")"'
```

### Network Monitor
```bash
# Watch network
watch -n 1 'echo "Down: $(cat /sys/class/net/wlan0/statistics/rx_bytes) | Up: $(cat /sys/class/net/wlan0/statistics/tx_bytes)"'
```

---

## Desktop Backgrounds

### Hacker Wallpapers
```bash
# Install Kali wallpapers
sudo apt install -y kali-wallpapers-*

# Or download
wget -O ~/Pictures/wallpaper.jpg \
    https://images.unsplash.com/photo-1550751827-4bd374c3f58b
```

---

## Useful Desktop Icons

### Shortcuts to Add
- `/mnt/sf_KaliShare/scripts/menu.sh` - Main menu
- `/opt/pentest-tools/` - Tools folder
- `/usr/share/wordlists/` - Wordlists
- `/usr/share/seclists/` - SecLists

---

## Minimalist Setup (Recommended for VM)

### For Low Resource
```bash
# Don't use heavy widgets!
# Just use:
neofetch       # In terminal
htop           # Process monitor  
btop           # Beautiful system monitor
```

### Start with Terminal
```bash
# Add to ~/.bashrc
neofetch
echo ""
echo "Type 'menu' for options"
echo ""

alias menu='sudo bash /mnt/sf_KaliShare/scripts/menu.sh'
```

---

## Quick Commands Summary

| Command | What It Does |
|---------|-------------|
| `neofetch` | System info + ASCII logo |
| `screenfetch` | Similar to neofetch |
| `htop` | Process monitor |
| `btop` | Modern htop (beautiful!) |
| `conky` | Desktop overlay |
| `ranger` | File manager in terminal |
| `tty-clock` | Clock in terminal |

---

## Resources for Customization

### Themes
- Kali themes: `sudo apt install kali-themes`
- Numix theme
- Flat Remix
- Papirus

### Icons
- Papirus: `sudo apt install papirus-icon-theme`
- Numix: `sudo apt install numix-icon-theme`

### Fonts
- Fira Code (programming)
- JetBrains Mono
- Source Code Pro

---

## Recommended Setup

For your VM (lightweight):

1. **Don't use desktop widgets** - Waste RAM
2. **Use terminal tools instead:**
   - `btop` for monitoring
   - `neofetch` at startup
   - `tmux` for multiple terminals
3. **Add to .bashrc:**
```bash
# ~/.bashrc additions
alias sys='btop'
alias menu='sudo bash /mnt/sf_KaliShare/scripts/menu.sh'
neofetch
```

---

## 🎯 Best for VM

| Tool | RAM | Use |
|------|-----|-----|
| btop | Low | System monitor |
| neofetch | Low | System info |
| tmux | Low | Terminal mux |
| htop | Low | Processes |

**Don't use:** Conky, polybar, heavy widgets - will slow VM down!
