# NetHunter S10 Toolkit (beyond1lte)

Companion scripts for the interactive buildout guide:
https://claude.ai/code/artifact/89149a49-a871-4234-b99a-94bd3f669319

**Authorized testing & education only.** Everything here is for devices and
networks you own or have written permission to assess.

> The full interactive guide (guide.html, ~90KB) is distributed as a download /
> the artifact link above rather than committed here, to keep this tree reviewable.

## Order of operations

1. `fix-chroot.sh`     — run FIRST if apt/systemd errors (machine-id / dpkg). Kernel 4.19 vs systemd.
2. `setup-dotfiles.sh` — zsh + tmux + aliases (incl. mon/unmon).
3. `install.sh`        — installs every phone-side script into ~/bin + Arsenal + gemini-cli.
4. everything else via the menu: `nh-menu.sh`, or Arsenal: `arsenal`.

`pc-setup.sh` runs on your PC, not the phone. `make-widgets.sh` + `termux-colors.properties`
run in Termux, not the chroot.

## Files

| Script | Runs in | What it does |
|--------|---------|--------------|
| fix-chroot.sh        | chroot | Repair systemd/machine-id dpkg breakage (run first) |
| setup-dotfiles.sh    | chroot | zsh + tmux + oh-my-zsh + aliases |
| install.sh           | chroot | Install all scripts to ~/bin + Arsenal + gemini-cli |
| recon.sh             | chroot | Web recon: subfinder → httpx → nuclei |
| wifi-audit.sh        | chroot | Nexmon monitor mode + handshake capture (2.4GHz) |
| nh-backup.sh         | android root | Snapshot the chroot to SD with rotation |
| newengagement.sh     | chroot | Scaffold engagement folder + SCOPE.md + report |
| opsec.sh             | chroot | Randomize MAC + hostname + egress leak check |
| vault.sh             | chroot | age-encrypted loot vault (init/lock/unlock) |
| killswitch.sh        | chroot | Verify/test/enforce VPN kill-switch |
| panic.sh             | chroot | Lost-device data wipe (irreversible, confirm-gated) |
| chezmoi-setup.sh     | chroot | Migrate dotfiles to chezmoi + age |
| tailscale-link.sh    | chroot | Join tailnet + SSH (userspace mode) |
| webterm.sh           | chroot | ttyd browser terminal on the tailnet |
| pc-setup.sh          | PC (Linux) | adb + Tailscale + SSH key to pair |
| ai-setup.sh          | chroot | Ollama + small model; pointers to Cactus/Needle + Hermes |
| ai-suggest.sh        | chroot | Local model → suggest next command |
| arsenal-setup.sh     | chroot | Arsenal dashboard + gemini-cli + cheatsheet |
| nethunter-arsenal.md | —      | Arsenal cheatsheet / playbook |
| nh-menu.sh           | chroot | Matrix-themed whiptail TUI launcher |
| theme-all.sh         | chroot | Matrix theme: zsh/tmux/LS_COLORS/cmatrix |
| termux-colors.properties | Termux | Matrix palette for the Termux app |
| make-widgets.sh      | Termux | Termux:Widget home-screen launchers |
| docs/hp-mini-bridge.md | —    | HP Pro/Elite Mini bridge research (16GB/500GB offload) |

## Quick start (in the chroot)

```bash
bash fix-chroot.sh                 # only if apt is broken
apt update && apt -y full-upgrade
bash setup-dotfiles.sh && exec zsh
bash install.sh                    # stands up the whole cockpit
nh-menu.sh                         # or: arsenal
```
