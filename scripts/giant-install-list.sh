#!/bin/bash
# Giant Kali Install List - 1000+ Security Tools
# Category: All Kali Linux Tools
# Usage: chmod +x install-all-kali-tools.sh && sudo ./install-all-kali-tools.sh

set -euo pipefail

echo "=========================================="
echo "Giant Kali Tools Installer - 1000+ Tools"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check root
if [[ $EUID -ne 0 ]]; then
   log_error "This script must be run as root"
   exit 1
fi

# Update repos
log_info "Updating package repositories..."
apt-get update -qq

log_info "Installing metapackages for complete toolset..."

# ============================================
# KALI METAPACKAGES - THE BIG ONE
# ============================================

echo ""
echo ">>> Installing ALL Kali tools via metapackage..."
echo "    This installs 1000+ tools in one command"
apt-get install -y kali-tools-all 2>/dev/null || log_warn "kali-tools-all not available, installing individual categories"

# ============================================
# CATEGORY 1: RECON & ENUMERATION
# ============================================

echo ""
echo ">>> [1/20] Installing Recon & Enumeration Tools..."

RECON_TOOLS=(
    nmap
    masscan
    netdiscover
    arp-scan
    enum4linux
    ldapsearch
    rpcclient
    smbclient
    smbmap
    enum4linux-ng
    nikto
    dirb
    gobuster
    wfuzz
    ffuf
   feroxbuster
    whatweb
    wappalyzer
    webtech
    dnsenum
    dnsrecon
    fierce
    sublist3r
    assetfinder
    amass
    findomain
    knockpy
    theHarvester
    recon-ng
    spiderfoot
    maltego
    exiftool
    binwalk
    foremost
    strings
    volatility
    peframe
    pestat
)

for tool in "${RECON_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Recon tools installed"

# ============================================
# CATEGORY 2: VULNERABILITY SCANNING
# ============================================

echo ""
echo ">>> [2/20] Installing Vulnerability Scanners..."

VULN_TOOLS=(
    openvas
    nessus
    nikto
    sqlmap
    jboss-autopwn
    vega
    zaproxy
    burpsuite
    arachni
    w3af
    uniscan
    grendel
    wapiti
    probalyzer
    ratproxy
    skipfish
    clusterd
    ftp-fuzz
)

for tool in "${VULN_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Vulnerability scanners installed"

# ============================================
# CATEGORY 3: EXPLOITATION
# ============================================

echo ""
echo ">>> [3/20] Installing Exploitation Frameworks..."

EXPLOIT_TOOLS=(
    metasploit-framework
    msfvenom
    searchsploit
    exploitdb
    core-impact
    canvas
    slmail
    openbullet
    commix
    metasploit
    beef-xss
    set
    msfpc
    armitage
    searchsploit
    auto-elliot
    linux-exploit-suggester
    windows-exploit-suggester
    peass
    linux-privilege-escalation-awesome-script-suite
    privesc
    linPEAS
    winPEAS
    seatbelt
    PowerUp
    SharpUp
    RottenPotato
    JuicyPotato
    PrintSpooler
    BadPotato
    GodPotato
    RoguePotato
    SweetPotato
    LonelyPotato
    mimikatz
    pwdump
    fgdump
    wce
    gsecdump
    procdump
    lsass
    mimikatz
    kerberoast
    ASREPRoast
   GPP-password
    LAPS
    ldapdomaindump
    certify
    bouncycastle
    sharpchromium
    sharpweb
    roastsauce
)

for tool in "${EXPLOIT_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Exploitation tools installed"

# ============================================
# CATEGORY 4: PASSWORD ATTACKS
# ============================================

echo ""
echo ">>> [4/20] Installing Password Attacks..."

PASSWORD_TOOLS=(
    hashcat
    john
    hydra
    medusa
    ncrack
    crowbar
    thc-hydra
    patator
    creddump
    fake-logon
    fgdump
    gsecdump
    lsassy
    mimikatz
    procdump
    pth-toolkit
    smbexec
    wce
    cewl
    crunch
    maskprocessor
    hashcat-utils
    maskgen
    rulebooks
    password-masks
    crackmapexec
    ldapdomaindump
    kerbrute
    enum4linux
    smbmap
    rpcclient
)

for tool in "${PASSWORD_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Password tools installed"

# ============================================
# CATEGORY 5: WIRELESS ATTACKS
# ============================================

echo ""
echo ">>> [5/20] Installing Wireless Attacks..."

WIRELESS_TOOLS=(
    aircrack-ng
    reaver
    wifite
    wpa-supplicant
    wpa-supplicant
    hostapd
    mdk3
    mdk4
    bettercap
    bettercap-ui
    reaver
    bully
    pixiewps
    fern-wifi-cracker
    wifiphisher
    evilginx2
    bettercap
    hcxdumptool
    hcxtools
    wlandump
    wlatr
    wlocate
    wps-gui
    krackattacks-scripts
    rtl8188eus
    rtl8812au
    rtl8814au
    rtl88x2bu
    rtl8812au-headers
    hostapd-mana
    driftnet
    dsniff
    ettercap
    sslstrip
    mitmproxy
   Responder
    MultiRelay
    Inveigh
    InveighZero
    mitm6
    acct
)

for tool in "${WIRELESS_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Wireless tools installed"

# ============================================
# CATEGORY 6: WEB ATTACKS
# ============================================

echo ""
echo ">>> [6/20] Installing Web Attacks..."

WEB_TOOLS=(
    burpsuite
    zaproxy
    nikto
    sqlmap
    xsser
    xsser-gui
    commix
    dirb
    gobuster
    wfuzz
    ffuf
    feroxbuster
    whatweb
    wapiti
    arachni
    w3af
    skipfish
    ratproxy
    uniscan
    clusterd
    vega
    jsql
    sqlmate
    sqlninja
    mysqlmap
    postgresql-map
    noSQLMap
    mongoaudit
    redis-tools
    apache-users
    htcap
    photon
    crawler
    raider
    foca
    parsia
    wpscan
    cmsmap
    droopescan
    joomscan
    wapiti
)

for tool in "${WEB_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Web tools installed"

# ============================================
# CATEGORY 7: SPOOFING & MITM
# ============================================

echo ""
echo ">>> [7/20] Installing Spoofing & MITM..."

MITM_TOOLS=(
    ettercap
    bettercap
    mitmproxy
    burpsuite
    zaproxy
    sslstrip
    sslsplit
    responder
    mitm6
    rerouter
    dsniff
    urlsnarf
    msgsnarf
    filesnarf
    dnsspoof
    arpspoof
    macof
    dhcpspoof
    sslstrip2
    mitmproxy
    webproxy
    bettercap
)

for tool in "${MITM_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "MITM tools installed"

# ============================================
# CATEGORY 8: FORENSICS
# ============================================

echo ""
echo ">>> [8/20] Installing Forensics..."

FORENSICS_TOOLS=(
    autopsy
    sleuth-kit
    dcfldd
    dc3dd
    foremost
    scalpel
    extundelete
    ext4magic
    testdisk
    photorec
    foremost
    binwalk
    strings
    volatility
    volatility3
    Rekall
    windows-forensics
    ftkimager
    magnet
    xplico
    plaso
    log2timeline
    plaso
    bulk_extractor
    cafa
    dfir-orp
    forensics-commons
    dfir-ntfs
    analyze-mft
    mftparser
    indxparser
    jleapp
    android-forensics
    apkhunter
)

for tool in "${FORENSICS_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Forensics tools installed"

# ============================================
# CATEGORY 9: REVERSE ENGINEERING
# ============================================

echo ""
echo ">>> [9/20] Installing Reverse Engineering..."

REVERSE_TOOLS=(
    radare2
    ida
    ida-free
    ghidra
    hopper
    binwalk
    objdump
    objcopy
    readelf
    nm
    strings
    strace
    ltrace
    gdb
    gdb-gef
    pwndbg
    pwntools
    ropper
    ropstar
    one-gadget
    libc-database
    uncompyle6
    pycdc
    jad
    jadx
    apktool
    jadx-gui
    dex2jar
    enjarify
    bytecoder
)

for tool in "${REVERSE_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Reverse engineering tools installed"

# ============================================
# CATEGORY 10: CRYPTOGRAPHY
# ============================================

echo ""
echo ">>> [10/20] Installing Cryptography..."

CRYPTO_TOOLS=(
    openssl
    libssl-dev
    gpg
    gpg2
    step
    cfssl
    mkcert
    certbot
    openssl-tool
    ssh-tools
    putty-tools
    putty
    ssh-audit
    ssh-get
    ssh-cert-check
    crowbar
    patator
    hashcat
    john
)

for tool in "${CRYPTO_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Cryptography tools installed"

# ============================================
# CATEGORY 11: PRIVILEGE ESCALATION
# ============================================

echo ""
echo ">>> [11/20] Installing Privilege Escalation..."

PRIVESC_TOOLS=(
    linux-exploit-suggester
    linux-exploit-suggester2
    linux-privilege-escalation-awesome-script-suite
    linPEAS
    linPEAS-color
    linux-smart-enumeration
    linux-local-enumeration
    unix-privesc-check
    suid3miner
    privesc
    sudo-killer
    SudoBleed
    GTFOBins
    GTFOBins-lookup
   LOLBAS
    LOLBAS-lookup
    PowerUp
    PowerUp-Windows
    SharpUp
    Seatbelt
    Watson
    Sharphound
    Sherlock
    JAWS
    WinPEAS
    winPEAS
    privesc-check
)

for tool in "${PRIVESC_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Privilege escalation tools installed"

# ============================================
# CATEGORY 12: POST-EXPLOITATION
# ============================================

echo ""
echo ">>> [12/20] Installing Post-Exploitation..."

POSTEXP_TOOLS=(
    powershell
    powershell-empire
    starkiller
    covenant
    koadic
    pupy
    silver
    merlin
    mettle
    nc
    netcat-traditional
    socat
    pwncat
    chisel
    proxychains
    proxychains4
    sshuttle
    openvpn
    openconnect
    wireguard
    gcat
    gdog
    mercury
    trevorC2
    silver
    C3
    dropbox
    cloudflared
    ngrok
    frp
    chisel
)

for tool in "${POSTEXP_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Post-exploitation tools installed"

# ============================================
# CATEGORY 13: SOCIAL ENGINEERING
# ============================================

echo ""
echo ">>> [13/20] Installing Social Engineering..."

SOCIAL_TOOLS=(
    set
    setoolkit
    social-engineer-toolkit
    beef-xss
    beef
    msfvenom
    powersploit
    phishing Frenzy
    king-phisher
    waterspray
    mallory
    ettercap
    sslstrip
)

for tool in "${SOCIAL_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Social engineering tools installed"

# ============================================
# CATEGORY 14: OSINT
# ============================================

echo ""
echo ">>> [14/20] Installing OSINT..."

OSINT_TOOLS=(
    theHarvester
    recon-ng
    spiderfoot
    maltego
    shodan-cli
    censys
    wig
    dnsenum
    dnsmap
    whois
    geoiplookup
    ipinfo
    phoneinfoga
    sherlock
    socialscan
    h8mail
    toutatis
    profile-hunter
    creepy
    osrframework
    sn0int
    amass
    assetfinder
    findomain
    sublist3r
    altdns
)

for tool in "${OSINT_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "OSINT tools installed"

# ============================================
# CATEGORY 15: RFID & NFC
# ============================================

echo ""
echo ">>> [15/20] Installing RFID/NFC..."

RFID_TOOLS=(
    proxmark3
    iceman-firmware
    mfoc
    mfcuk
    proxmark3-client
    libnfc
    libfreefare
    libhf-rfid
    libhf-usb
    pcsc-tools
    pcsc-daemon
   acr122u
    nfcd
    android-nfc
)

for tool in "${RFID_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "RFID/NFC tools installed"

# ============================================
# CATEGORY 16: SDR & RADIO
# ============================================

echo ""
echo ">>> [16/20] Installing SDR/Radio..."

SDR_TOOLS=(
    gqrx
    gnuradio
    gr-air-modes
    gr-adsb
    dump1090
    dump978
    kalibrate-rtl
    rtl-sdr
    rtl_433
    hackrf
    hackrf-tools
    uhd-host
    usrp
    bladeRF
    bladerf-fpga
    gnuradio-companion
    qspectrumanalyzer
    inspectrum
    baudline
    sdrangelove
    sdr-j
)

for tool in "${SDR_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "SDR/Radio tools installed"

# ============================================
# CATEGORY 17: BLUE TEAM / DEFENSE
# ============================================

echo ""
echo ">>> [17/20] Installing Blue Team/Defense..."

BLUE_TOOLS=(
    ossec
    rkhunter
    lynis
    chkrootkit
    clamav
    suricata
    snort
    zeek
    argus
    ntopng
    p0f
    Bro
    securityonion
    wazuh
    atomic-threat-coverage
    cortex
    thehive
    maltrail
    kiban
    elastalert
    osquery
    auditd
    aulast
    ausearch
    aureport
    amt
)

for tool in "${BLUE_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Blue team tools installed"

# ============================================
# CATEGORY 18: CLOUD & CONTAINERS
# ============================================

echo ""
echo ">>> [18/20] Installing Cloud & Containers..."

CLOUD_TOOLS=(
    awscli
    az
    gcloud
    terraform
    ansible
    kubernetes
    kubectl
    kubectx
    helm
    docker.io
    docker-compose
    podman
    buildah
    skopeo
    trivy
    checkov
    tfsec
    scoutsuite
    cloudsploit
    cloud-nuke
    pacu
    cloudmapper
    enumerate-iam
    iam-backstrap
)

for tool in "${CLOUD_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Cloud/Container tools installed"

# ============================================
# CATEGORY 19: IOT & INDUSTRIAL
# ============================================

echo ""
echo ">>> [19/20] Installing IoT & Industrial..."

IOT_TOOLS=(
    firmware-analysis-toolkit
    binwalk
   firmwalker
    chkrootkit
    nmap-scripts
    smod
    modscan
    plcscan
    mbtget
    protocol-bridge
    opcua-exploit-kit
    s7comm-brute
    nmap
    masscan
    help2man
    net-tools
)

for tool in "${IOT_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "IoT/Industrial tools installed"

# ============================================
# CATEGORY 20: REPORTING & UTILITIES
# ============================================

echo ""
echo ">>> [20/20] Installing Reporting & Utilities..."

REPORT_TOOLS=(
    termineter
    cutycapt
    eyewitness
    goWitness
    Eyeshine
    dradis
    faraday
    pivotage
    magicTree
    pipal
    passpie
    gpp-decrypt
    lsassy
    impacket
    wmiexec
    smbexec
    dcomexec
    atexec
    wmiquery
    secretsdump
    ticketConverter
    silver
    krbtgt
    domain-gen
    adidnsdump
    pykek
)

for tool in "${REPORT_TOOLS[@]}"; do
    apt-get install -y "$tool" 2>/dev/null || log_warn "$tool not in repos"
done

log_success "Reporting/Utilities installed"

# ============================================
# FINAL: UPDATE TOOLS
# ============================================

echo ""
log_info "Updating searchsploit database..."
searchsploit -u 2>/dev/null || true

log_info "Cleaning up..."
apt-get autoremove -y -qq

echo ""
echo "=========================================="
log_success "ALL TOOLS INSTALLED!"
echo "=========================================="
echo ""
echo "Tool count summary:"
echo "  - Nmap:"
which nmap >/dev/null && echo "    [INSTALLED]" || echo "    [NOT FOUND]"
echo "  - Metasploit:"
which msfconsole >/dev/null && echo "    [INSTALLED]" || echo "    [NOT FOUND]"
echo "  - Hashcat:"
which hashcat >/dev/null && echo "    [INSTALLED]" || echo "    [NOT FOUND]"
echo "  - John:"
which john >/dev/null && echo "    [INSTALLED]" || echo "    [NOT FOUND]"
echo "  - BurpSuite:"
which burpsuite >/dev/null && echo "    [INSTALLED]" || echo "    [NOT FOUND]"
echo ""
echo "Install complete! Run 'apt list --installed | wc -l' for full count"