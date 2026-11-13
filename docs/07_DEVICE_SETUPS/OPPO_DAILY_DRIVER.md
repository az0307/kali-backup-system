# 📱 Oppo Phone — Ultimate Daily Driver (Clean, Hardened, Fleet-Aware)

> The **trusted** device. No root, no offensive payloads. It carries banking, 2FA,
> comms, and a read-only window into the fleet — so if the S10 gets seized or
> bricked in the field, your identity and access are untouched.

> **Why no root on the Oppo?** ColorOS bootloader unlocking is heavily restricted
> (Oppo killed the official unlock tool on most models), and rooting the daily
> driver breaks exactly the apps you need it for. Keep it stock and hard.

---

## 1. Clean-slate setup

1. Factory reset if it's been used loosely.
2. Sign in with a **dedicated Google account** for this device (not your main junk one).
3. Skip Oppo/HeyTap cloud sync of contacts unless you want them on HeyTap servers.
4. *Settings → About device → Version* → tap **Build number** 7× only if you need
   Developer options (for ADB pairing to the Mini); otherwise leave it off.

---

## 2. Harden ColorOS

| Setting | Where | Value |
|---------|-------|-------|
| Screen lock | Settings → Password & security | **6+ digit PIN or alphanumeric**, not pattern |
| Biometrics | same | Fingerprint on; face **off** (weaker) |
| Lock-screen notifications | Notifications | Hide sensitive content |
| App permissions | Privacy → Permission manager | Revoke mic/camera/location from all but essentials |
| "Personalized ads" / HeyTap | Privacy | **Off** |
| Auto-updates | Software update | On |
| Find My Device | Google + Find My Device | On |
| Unknown sources | keep **off** except when sideloading F‑Droid, then off again |

- Turn on **Google Play Protect** and run a scan.
- Set up a **Private Safe / App Lock** (ColorOS built-in) for finance apps.

---

## 3. The "trusted device" app stack

| Purpose | App | Notes |
|---------|-----|-------|
| 2FA (authenticator) | **Aegis** (F‑Droid) or Authy | Export-encrypted backup → HP Mini |
| Password manager | **Bitwarden** | Same vault as the fleet; unlock hub secrets |
| Messaging | **Signal** | Primary secure comms |
| VPN / mesh | **Tailscale** | Puts the Oppo on the fleet mesh, read-only usage |
| Files/sync | **Syncthing** | *Receive-only* folder of fleet dashboards/notes |
| Notes | **Obsidian** or Standard Notes | Vault synced via Syncthing |
| SSH client | **Termux** + `openssh`, or **JuiceSSH** | For status checks only |
| AI assistant | Claude / ChatGPT / Gemini app | General daily use |

```bash
# Optional: minimal Termux on the Oppo — a *client*, never a rig
pkg update && pkg install -y openssh mosh git
# Status-only SSH to the brain:
ssh aries@192.168.50.10 'uptime; tailscale status | head'
```

---

## 4. Fleet integration (read-only by design)

```
Oppo  ──Tailscale──►  HP Mini G9   (check dashboards, uptime, alerts)
Oppo  ──Syncthing──►  HP Mini G9   (RECEIVE-ONLY: notes, run summaries)
```

- Static IP: `192.168.50.30`.
- Syncthing: add the Mini as a device, share the `fleet-notes` folder as
  **Receive Only** so a compromised phone can't poison the hub.
- Keep a home-screen widget / bookmark to the **Open WebUI** URL on the Mini
  (`http://192.168.50.10:3000`) for AI chat against your local models on the go.

---

## 5. Backup & recovery

- **2FA seeds**: Aegis → encrypted export → Syncthing → HP Mini → offline backup.
  Losing these is worse than losing the phone.
- **Photos/docs**: Syncthing to the Mini (own your data) *and* Google Photos.
- **Bitwarden**: cloud vault means a lost phone is a non-event — just re-auth.
- Note IMEI + serial in your Bitwarden secure notes for theft reports.

---

## 6. Daily-driver + light-field role

The Oppo *can* help on authorized engagements without any root:

- **Wi‑Fi survey** — WiFiAnalyzer (F‑Droid) to eyeball channels/APs (passive, legal).
- **Hotspot** — share a clean uplink to the S10 field rig.
- **Camera/notes** — document the site, findings, and chain of custody.
- **Signal** — coordinate with the team.

It never runs scans or attacks — that stays on the S10.

## Quick checklist

- [ ] Stock ColorOS, dedicated Google account, strong PIN
- [ ] Permissions stripped · HeyTap ads off · Play Protect on
- [ ] Aegis/Bitwarden/Signal installed · 2FA backed up to the Mini
- [ ] Tailscale joined · Syncthing **receive-only** folder from the Mini
- [ ] Open WebUI bookmark for on-the-go AI
- [ ] No root, no payloads — this device stays clean
