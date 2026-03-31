# Mount ISO and Copy to USB

Write-Host "Mounting Kali ISO..." -ForegroundColor Cyan
$iso = Mount-DiskImage -ImagePath "F:\kali.iso" -PassThru
$driveLetter = ($iso | Get-Volume).DriveLetter

Write-Host "ISO mounted as drive: $driveLetter" -ForegroundColor Green

Write-Host "Copying files to USB..." -ForegroundColor Cyan
Copy-Item -Path "${driveLetter}:\*." -Destination "F:\" -Recurse -Force

Write-Host "Unmounting ISO..." -ForegroundColor Cyan
Dismount-DiskImage -ImagePath "F:\kali.iso"

Write-Host "Done! USB is bootable." -ForegroundColor Green
