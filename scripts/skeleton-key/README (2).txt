SKELETON KEY USB v2.0
======================

Windows Password Recovery USB

USAGE:
======

Level 1 - Auto Reset (No Questions):
    sudo ./auto-reset.sh
    
    - Auto-detects Windows partition
    - Auto-detects admin user
    - Resets password to BLANK
    - Auto-reboots

Level 2 - Interactive Menu:
    sudo ./start.sh
    
    - Shows menu
    - Choose reset option
    - Manual selection if multiple Windows

Level 3 - Manual:
    cd scripts-skeleton-key/
    # Use individual scripts as needed

OPTIONS:
========
[1] Auto Reset Password (Recommended)
    - Zero interaction required
    - Best for most cases

[2] Set New Password
    - Set a specific new password

[3] Promote to Admin
    - Make user administrator

[4] Unlock Account
    - Unlock disabled/locked account

[5] Show Partitions
    - List all Windows partitions

[6] Kali Live Desktop
    - Start graphical desktop

SAFETY FEATURES:
=================
✓ Always backs up SAM before changes
✓ Requires typed 'YES' to confirm
✓ Only targets internal drives (sda)
✓ Automatic rollback on failure
✓ Verification after reset

TROUBLESHOOTING:
================
"No Windows found":
    - Boot to Windows first
    - Disable Fast Boot in Windows
    - Disable Secure Boot in BIOS

"SAM not found":
    - Wrong partition selected
    - Windows may be BitLocker encrypted

"Permission denied":
    - Run with sudo

"mnt/logs/ errors":
    - Check /mnt/logs/errors.log

FILES:
======
auto-reset.sh    - Auto mode
start.sh         - Menu mode
error-handler.sh - Error handling
mount-utils.sh    - Mount functions
detect-windows.sh - Auto-detection
reset-password.sh - Reset logic
verify-reset.sh  - Verification
banner.sh        - Console banners

LEGAL:
======
For authorized use only. Only use on systems you own
or have explicit permission to access.
