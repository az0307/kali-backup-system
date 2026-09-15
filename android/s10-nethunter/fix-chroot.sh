#!/usr/bin/env bash
# fix-chroot.sh — repair the classic NetHunter/Kali chroot dpkg breakage on
# Android, where systemd's postinst fails with:
#   cannot open '/etc/machine-id': Protocol driver not attached
#   dpkg: error processing package systemd  →  "N not fully installed or removed"
#
# Root cause: the S10's Android kernel (4.19) is older than the >=5.10 that
# modern systemd expects, so its postinst can't touch machine-id / udev in the
# chroot. You don't run systemd as init in a chroot, so we satisfy it and stop
# it aborting the whole dpkg run. Run this as root INSIDE the chroot, BEFORE
# install.sh / any big apt install.
set -uo pipefail   # not -e: we want to push through partial failures

echo "[*] 1/5 writing a valid /etc/machine-id…"
cat /proc/sys/kernel/random/uuid | tr -d '-' > /etc/machine-id
mkdir -p /var/lib/dbus
ln -sf /etc/machine-id /var/lib/dbus/machine-id
echo "    machine-id = $(cat /etc/machine-id)"

echo "[*] 2/5 neutering set -e in systemd/udev postinst (chroot-safe)…"
for p in systemd udev systemd-sysv libpam-systemd; do
  f="/var/lib/dpkg/info/${p}.postinst"
  [[ -f "$f" ]] && sed -i 's/^set -e/set +e/' "$f" && echo "    patched $p.postinst"
done

echo "[*] 3/5 dpkg --configure -a (finishing half-installed packages)…"
dpkg --configure -a || true

echo "[*] 4/5 apt -f install (fix broken deps)…"
apt-get -f install -y || true

echo "[*] 5/5 verifying dpkg state…"
if dpkg --audit 2>/dev/null | grep -q .; then
  echo "[!] some packages still need attention:"
  dpkg --audit
  echo "    re-run this script, or: apt -y --fix-broken install"
else
  echo "[+] dpkg is clean. You can now run: apt update && apt -y full-upgrade"
  echo "    then: bash install.sh"
fi

# NOTE: on kernel <5.10 this can recur after a future systemd upgrade.
# If it does, just run fix-chroot.sh again. To reduce the churn you *may*:
#   apt-mark hold systemd systemd-sysv udev
# but that can block unrelated upgrades on Kali rolling — prefer re-running this.
