#!/bin/bash
# Wordlists Downloader - All Major Password Lists
# Usage: chmod +x download-wordlists.sh && sudo ./download-wordlists.sh

set -euo pipefail

echo "=========================================="
echo "Security Wordlists Downloader"
echo "=========================================="

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

# Create directories
WORDLIST_DIR="/usr/share/wordlists"
mkdir -p "$WORDLIST_DIR"
cd "$WORDLIST_DIR"

log_info "Creating wordlist directories..."
mkdir -p {SecLists,RockYou,CrackStation,WeakPass,Passwords,Crunch,Custom}

# ============================================
# DOWNLOAD SECLISTS (RECOMMENDED)
# ============================================

log_info "Downloading SecLists (the big one)..."

if command -v git >/dev/null 2>&1; then
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git SecLists/ 2>/dev/null || \
    curl -sL https://github.com/danielmiessler/SecLists/archive/master.zip -o SecLists.zip && \
    unzip -q SecLists.zip && mv SecLists-master SecLists && rm SecLists.zip
else
    log_warn "git not installed, downloading as zip..."
    curl -sL https://github.com/danielmiessler/SecLists/archive/master.zip -o SecLists.zip
    unzip -q SecLists.zip
    mv SecLists-master SecLists
    rm SecLists.zip
fi

log_success "SecLists downloaded"

# ============================================
# DOWNLOAD ROCKYOU
# ============================================

log_info "Downloading RockYou2024..."

# Try multiple sources for rockyou
ROCKYOU_SOURCES=(
    "https://github.com/ohmybahos/ROCKYOU2024/archive/refs/heads/main.zip"
    "https://download.weakpass.com/rockyou.txt.gz"
    "https://wordlist.mapleinnovation.com/wordlists/rockyou.txt.gz"
)

for source in "${ROCKYOU_SOURCES[@]}"; do
    if curl -sI --max-time 30 "$source" | grep -q "200\|302"; then
        log_info "Trying: $source"
        if [[ "$source" == *.gz ]]; then
            curl -sL "$source" -o rockyou.txt.gz && gunzip -f rockyou.txt.gz
        else
            curl -sL "$source" -o rockyou2024.zip && unzip -q rockyou2024.zip -d RockYou && \
            mv RockYou/*/rockyou.txt RockYou/ 2>/dev/null || true && rm -rf rockyou2024.zip
        fi
        break
    fi
done

if [[ -f rockyou.txt ]]; then
    log_success "RockYou downloaded ($(du -h rockyou.txt | cut -f1))"
else
    log_warn "RockYou not available - will create empty placeholder"
    touch rockyou.txt
fi

# ============================================
# DOWNLOAD CRACKSTATION
# ============================================

log_info "Downloading CrackStation..."

CRACKSTATION_SOURCES=(
    "https://crackstation.net/downloads/crackstation-human-only.txt.gz"
    "https://download.weakpass.com/crackstation.txt.gz"
    "https://wordlist.mapleinnovation.com/wordlists/crackstation.txt.gz"
)

for source in "${CRACKSTATION_SOURCES[@]}"; do
    if curl -sI --max-time 30 "$source" | grep -q "200\|302"; then
        log_info "Trying: $source"
        curl -sL "$source" -o crackstation.txt.gz && gunzip -f crackstation.txt.gz && break
    fi
done

if [[ -f crackstation.txt ]]; then
    log_success "CrackStation downloaded ($(du -h crackstation.txt | cut -f1))"
else
    log_warn "CrackStation not available"
    touch crackstation.txt
fi

# ============================================
# DOWNLOAD WEAKPASS
# ============================================

log_info "Downloading WeakPass lists..."

WEAKPASS_URLS=(
    "https://download.weakpass.com/wordlists/2023/weakpass_3a.gz"
    "https://download.weakpass.com/wordlists/2022/weakpass_2e.gz"
    "https://download.weakpass.com/wordlists/weakpass_1.zip"
)

mkdir -p WeakPass
cd WeakPass

for url in "${WEAKPASS_URLS[@]}"; do
    filename=$(basename "$url")
    if curl -sI --max-time 30 "$url" | grep -q "200\|302"; then
        log_info "Downloading: $filename"
        curl -sL "$url" -o "$filename" 2>/dev/null
        if [[ "$filename" == *.gz ]]; then
            gunzip -f "$filename"
        elif [[ "$filename" == *.zip ]]; then
            unzip -q "$filename" && rm "$filename"
        fi
    fi
done

cd ..
log_success "WeakPass downloaded"

# ============================================
# DOWNLOAD CONFUSABLE & MISC
# ============================================

log_info "Downloading additional wordlists..."

# Top passwords
curl -sL "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt" -o "Passwords/top-10000.txt"

# Cracklib
apt-get install -y crack-must-pass 2>/dev/null || true

# Default passwords
curl -sL "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Default-Credentials/default-passwords.txt" -o "Passwords/default-passwords.txt"

# Leet speak
curl -sL "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Leaked-Databases/leet_alternatives.txt" -o "Passwords/leet.txt"

log_success "Additional wordlists downloaded"

# ============================================
# CREATE CUSTOM GENERATION SCRIPTS
# ============================================

log_info "Creating custom wordlist generators..."

# Crunch wrapper
cat > /usr/local/bin/generate-wordlist << 'EOF'
#!/bin/bash
# Custom wordlist generator using crunch
# Usage: generate-wordlist <min> <max> <charset> <output>

if ! command -v crunch >/dev/null 2>&1; then
    echo "crunch not installed. Install: apt-get install crunch"
    exit 1
fi

min=${1:-8}
max=${2:-12}
charset=${3:-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789}
output=${4:-wordlist.txt}

echo "Generating wordlist: $min-$max chars"
crunch "$min" "$max" "$charset" -o "$output"
echo "Saved to: $output"
echo "Size: $(du -h "$output" | cut -f1)"
EOF
chmod +x /usr/local/bin/generate-wordlist

# CeWL wrapper
cat > /usr/local/bin/cewl-extract << 'EOF'
#!/bin/bash
# Extract words from website for wordlist
# Usage: cewl-extract https://example.com -d 2 -m 5

if ! command -v cewl >/dev/null 2>&1; then
    echo "cewl not installed. Install: apt-get install cewl"
    exit 1
fi

cewl "$@"
echo "Wordlist generated"
EOF
chmod +x /usr/local/bin/cewl-extract

log_success "Custom generators created"

# ============================================
# STATISTICS
# ============================================

echo ""
echo "=========================================="
log_success "WORDLISTS DOWNLOAD COMPLETE!"
echo "=========================================="
echo ""
echo "Wordlist directory: $WORDLIST_DIR"
echo ""
echo "Contents:"
du -sh "$WORDLIST_DIR"/* 2>/dev/null | while read -r size dir; do
    echo "  $dir: $size"
done
echo ""
echo "Main files:"
for f in rockyou.txt crackstation.txt; do
    if [[ -f "$WORDLIST_DIR/$f" ]]; then
        lines=$(wc -l < "$WORDLIST_DIR/$f")
        echo "  $f: $(echo $lines | sed 's/../../\ /') lines"
    fi
done
echo ""
echo "Total size: $(du -sh "$WORDLIST_DIR" | cut -f1)"
echo ""
log_success "Ready for password cracking!"