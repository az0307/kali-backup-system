# Digital Forensics Bible

## Evidence Collection

### Order of Volatility
1. CPU registers, cache
2. Memory (RAM)
3. Network state
4. Running processes
5. Disk
6. Remote logs
7. Physical configuration
8. Media (paper)

### Types
- **Live Response** - Running system
- **Dead Box** - Powered off system
- **Network** - Capture traffic
- **Cloud** - Cloud取证
- **Mobile** - Phone/tablet forensics

## Acquisition

### Memory
- **FTK Imager** - Memory capture
- **WinPmem** - Windows memory dump
- **LiME** - Linux memory extractor
- **MacQuisition** - macOS memory

### Disk
- **Write Blockers** - Hardware/software
- **dd** - Raw image
- **FTK Imager** - Forensic imaging
- **Guymager** - Linux imaging
- **Tableau** - Hardware blocker

### Network
- **Tcpdump** - Packet capture
- **Wireshark** - Analysis
- **Moloch** - Large-scale capture
- **Zeek** - Network analysis

## Analysis Tools

### Windows
- **Autopsy** - Disk forensics
- **FTK** - Complete toolkit
- **EnCase** - Industry standard
- **X-Ways** - Low-level forensics
- **WinHex** - Hex editor

### Linux
- **The Sleuth Kit** - CLI forensics
- **Autopsy** - GUI for TSK
- **CAINE** - Live CD distro
- **DEFT** - Forensics distro

### Memory
- **Volatility** - Memory analysis
  - `vol -f mem.img pslist`
  - `vol -f mem.img malfind`
  - `vol -f mem.img netscan`

### Network
- **Wireshark** - Packet analysis
- **Zeek** - Protocol analysis
- **NetworkMiner** - PCAP analysis
- **Packetyzer** - Cisco analysis

## File System Forensics

### Windows
- **NTFS** - MFT, USN journal
- **Registry** - SAM, SECURITY, SOFTWARE
- **Prefetch** - Program execution
- **ShimCache** - Application cache
- **Amcache** - Program execution

### Linux
- **EXT4** - Inodes, journaling
- **Journal** - File system logs
- **Logs** - /var/log/*
- **History** - Bash history

### Mac
- **APFS** - Snapshot, encryption
- **Spotlight** - Index
- **Unified Logs** - System logging
- **FSEvents** - File events

## Timeline Analysis

### Methods
- **Super Timeline** - All events
- **MFT Timeline** - File times
- **Registry Timeline** - Key changes
- **Log Timeline** - System logs

### Tools
- **Plaso** - Log2Timeline
- **Timesketch** - Timeline analysis
- **MFTECmd** - MFT extraction

## Password Recovery

### Hash Cracking
- **Hashcat** - GPU cracking
- **John the Ripper** - Multi-format

### Memory
- **Mimikatz** - Windows creds
- **Mimipenguin** - Linux creds
- **LaZagne** - Multiple password recovery

### Encrypted Volumes
- **Veracrypt** - TrueCrypt successor
- **BitLocker** - Windows encryption
- **FileVault** - macOS encryption

## Mobile Forensics

### Android
- **ADB** - Android Debug Bridge
- **AFLogical** - Data extraction
- **Cellebrite** - Commercial tool
- **Magnet AXIOM** - Commercial

### iOS
- **iTunes Backup** - Encrypted backups
- ** Cellebrite** - iOS extraction
- **GrayKey** - iOS unlocking
- **IPSW** - Firmware analysis

## Cloud Forensics

### AWS
- **CloudTrail** - API logs
- **CloudWatch** - Monitoring
- **VPC Flow Logs** - Network
- **S3 Access Logs** - Bucket access

### Azure
- **Activity Log** - Azure activities
- **Audit Logs** - Resource changes
- **NSG Flow Logs** - Network

### GCP
- **Audit Logs** - Admin activity
- **VPC Flow Logs** - Network
- **Cloud Logging** - Application logs

## Reporting

### Evidence
- Chain of custody
- Hash verification
- Timeline documentation
- Screenshots

### Tools
- **Maltego** - Link analysis
- **Obsidian** - Note taking
- **CherryTree** - Forensics notes

## Tools List
- FTK Imager
- Autopsy
- EnCase
- Volatility
- The Sleuth Kit
- CAINE
- SIFT
- Wireshark
- Zeek
- X-Ways
- Magnet AXIOM
- Cellebrite
- UFED

## References
- SANS Digital Forensics
- NIST Computer Forensics
- DFIR Training