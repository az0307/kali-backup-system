# 📡 Samsung Galaxy S10 — Ultimate Kali NetHunter Field Rig

> Turn an S10 into a pocket pentest platform: full Kali chroot, deauth-capable
> internal Wi‑Fi (with the right kernel), HID/BadUSB, and OTG external adapters.

⚠️ **Authorized use only.** Rooting voids your warranty and trips Knox
**permanently** (Secure Folder, Samsung Pay, Health stop working). Back up first.

---

## 0. Know your device

| S10 variant | Model | SoC | NetHunter status |
|-------------|-------|-----|------------------|
| S10 (beyond1lte) | G973F | Exynos 9820 | ✅ Community builds |
| S10+ (beyond2lte) | G975F | Exynos 9820 | ✅ Community builds |
| S10e (beyond0lte) | G970F | Exynos 9820 | ✅ Community builds |
| S10 (Snapdragon) | G973U/W | SD855 | ⚠️ Bootloader locked on US/carrier — usually **not** unlockable |

> **Critical:** Only the **Exynos (F)** models unlock cleanly. Confirm in
> *Settings → About phone → Model number* before you start. If it's a US/carrier
> Snapdragon, stop — use it as a Termux-only client (see guide 2 patterns) instead.

---

## 1. Prerequisites

- [ ] Exynos S10 (G97xF), charged >70%
- [ ] USB‑C data cable + a computer (the HP Mini G9 works — Heimdall runs on Linux)
- [ ] **Full backup** — photos, 2FA seeds, everything (data is wiped)
- [ ] Samsung USB drivers (Windows) or `heimdall` (Linux)
- [ ] Downloads staged: Magisk, TWRP for `beyond1lte`, NetHunter for your kernel

```bash
# On the HP Mini G9 (Linux) — install the flashing tool
sudo apt update && sudo apt install -y heimdall-flash adb fastboot
heimdall version   # confirm it runs
```

---

## 2. Unlock the bootloader (OEM unlock)

1. Insert a SIM, connect Wi‑Fi, sign in — let it sit **7 days** (Samsung's OEM‑unlock
   cooldown; skipping it hides the toggle).
2. *Settings → About phone → Software information* → tap **Build number** 7×.
3. *Settings → Developer options* → enable **OEM unlocking** and **USB debugging**.
4. Power off → hold **Vol‑Down + Bixby + USB plug-in** to enter Download Mode →
   long‑press **Vol‑Up** to unlock. **This wipes the device.**

---

## 3. Root with Magisk

```bash
# 1. Pull the stock AP_*.tar.md5 from your firmware (SamFirm/Frija), extract:
#    boot.img (or the whole AP archive)
# 2. Copy AP archive to the phone, patch it in the Magisk app → "Install → Select and Patch a File"
# 3. Pull the patched file back to the HP Mini:
adb pull /sdcard/Download/magisk_patched-*.tar ./
# 4. Reboot to Download Mode, flash the patched AP in the AP slot:
heimdall flash --AP magisk_patched-XXXXX.tar --no-reboot
# 5. Reboot → open Magisk → confirm root. (First boot after root = another wipe.)
```

Enable **Zygisk** in Magisk and add **DenyList** for your banking/2FA apps so they
keep working. (Better: keep those on the Oppo — guide 2.)

---

## 4. Custom recovery (TWRP) + NetHunter kernel

NetHunter needs a **patched kernel** for monitor mode / packet injection on the
internal `bcmdhd` Wi‑Fi chip. Use the NetHunter build matched to your OS version.

```bash
# Flash TWRP for beyond1lte in Download Mode:
heimdall flash --RECOVERY twrp-3.x-beyond1lte.img --no-reboot
# Boot straight to recovery (Vol-Up + Bixby + power) so stock doesn't restore it.
```

In TWRP → **Install** → flash in order:
1. `nethunter-generic-arm64-kalifs-full.zip` (or `-minimal` if space is tight)
2. The **NetHunter kernel** zip for your exact firmware build
3. Reboot System.

---

## 5. First boot — NetHunter app + store

1. Install/open the **NetHunter** app → grant **superuser** when Magisk prompts.
2. NetHunter → **Kali Chroot Manager** → *Install Kali chroot* (full).
3. Add the **NetHunter Store** (F‑Droid fork) → install **NetHunter‑KeX**,
   **NetHunter Terminal**, **Termux**.
4. NetHunter → **Kali Services** → start `sshd`.

```bash
# Verify the chroot from NetHunter Terminal:
sudo su
cat /etc/os-release          # -> Kali GNU/Linux
nmap --version
iwconfig                     # look for wlan0/wlan1
```

---

## 6. Wireless capabilities

### Internal Wi‑Fi (bcmdhd)
Monitor mode + limited injection **only** with the NetHunter kernel. Test it:

```bash
# In NetHunter chroot
airmon-ng start wlan0
airodump-ng wlan0mon        # if you see APs, monitor mode works
```

### External adapter over OTG (the reliable path)
The internal chip is flaky; a USB‑OTG adapter with an injection chipset is the
pro move. Known-good chipsets (match the repo's `hardware-platforms.md`):

| Adapter | Chipset | Notes |
|---------|---------|-------|
| Alfa AWUS036NHA | AR9271 | Rock-solid, driver in-kernel |
| Alfa AWUS036ACH | RTL8812AU | Dual-band, needs `rtl8812au` DKMS |
| TP‑Link TL‑WN722N **v1** | AR9271 | v2/v3 do **not** inject |

```bash
# Plug adapter via USB-C OTG, then:
iwconfig                     # new wlanN appears
airmon-ng start wlan1
```

---

## 7. HID / BadUSB attacks

NetHunter app → **HID Attacks** (DuckHunter for Rubber Ducky scripts) and
**BadUSB MITM**. USB‑C to USB‑A cable required to target a host.

- **DuckHunter HID** — paste a Ducky payload, preview, execute against a plugged‑in PC.
- **BadUSB MITM** — phone becomes a USB Ethernet gadget to sniff/redirect host traffic.

Keep payloads in `~/loot/hid/`; sync them from the HP Mini (§9).

---

## 8. Field toolkit (chroot)

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y nmap masscan nikto sqlmap hydra aircrack-ng \
                    wifite bettercap responder tcpdump proxychains4 \
                    metasploit-framework seclists

# Route MSF/others through the HP Mini for compute-heavy jobs if needed:
#   ssh -R ... to the Mini, run heavy cracking there (hashcat on real GPU/CPU)
```

Wire in this repo's tooling from NetHunter Terminal:
```bash
git clone https://github.com/az0307/kali-backup-system ~/KaliShare
bash ~/KaliShare/scripts/menu.sh          # the MENU launcher works in the chroot
```

---

## 9. Fleet integration (talks to the HP Mini G9)

```bash
# Static IP for the S10 (see fleet README): 192.168.50.20

# a) SSH key to the Mini so scans can offload results
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
ssh-copy-id aries@192.168.50.10

# b) Stream a scan straight to the brain for AI triage
nmap -sV 10.0.0.0/24 -oX - | ssh aries@192.168.50.10 \
     'cat > ~/loot/$(date +%F)-s10-nmap.xml'

# c) Syncthing: share ~/loot and pull wordlists from the Mini
pkg install syncthing   # (Termux) or apt install syncthing (chroot)

# d) Tailscale for remote reach when off-LAN
curl -fsSL https://tailscale.com/install.sh | sh && tailscale up
```

Send captures to **HexStrike** running on the Mini (see `../02_TOOLS/hexstrike-integration.md`).

---

## 10. KeX desktop (full GUI when docked)

NetHunter‑KeX gives you a real Kali desktop over VNC — plug the S10 into a
USB‑C hub with HDMI + keyboard/mouse and you have a portable workstation.

```bash
# In NetHunter Terminal
kex --passwd        # set VNC password once
kex &               # start server
kex --stop          # tear down after use
```

---

## 11. OPSEC & recovery

- Keep a **stock firmware .tar** on the HP Mini to Heimdall-restore if a flash bricks.
- Disable NetHunter services (`sshd`, KeX) when not testing.
- Wipe loot before crossing any trust boundary — see `../05_TIPS/stealth-clean-exit.md`.
- Airplane-mode + external-adapter-only keeps the internal radios quiet in the field.

## Quick checklist

- [ ] Confirmed Exynos G97xF · 7‑day OEM cooldown passed
- [ ] Bootloader unlocked · Magisk root · DenyList set
- [ ] TWRP + NetHunter kernel + full chroot
- [ ] Internal monitor mode tested **and** OTG adapter working
- [ ] HID/BadUSB verified against a lab host
- [ ] SSH key + Syncthing + Tailscale to HP Mini G9
- [ ] Stock firmware backup stored on the Mini
