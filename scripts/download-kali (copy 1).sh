#!/bin/bash

################################################################################
#  📥 KALI ISO DOWNLOADER - Smart Retry with Progress Detection
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
KALI_VERSION="2024.4"
ISO_FILE="kali-linux-${KALI_VERSION}-live-amd64.iso"
OUTPUT_DIR="/c/Users/User/Downloads"
OUTPUT_PATH="$OUTPUT_DIR/$ISO_FILE"

# Download settings
MIN_SIZE_MB=3500  # Minimum valid size (~3.5GB)
MAX_RETRIES=5
BASE_TIMEOUT=300  # 5 minutes base
EXTRA_TIME_PER_GB=120  # 2 min per GB downloaded

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $*"; }

# Check disk space
check_space() {
    local available=$(df -B1 "$OUTPUT_DIR" | awk 'NR==2 {print $4}')
    local needed=5000000000
    
    if [ "$available" -lt "$needed" ]; then
        log_error "Need 5GB, have $((available/1000000000))GB"
        return 1
    fi
    log_success "Disk OK: $((available/1000000000))GB free"
    return 0
}

# Calculate dynamic timeout based on current progress
get_timeout() {
    local current_size=0
    local current_mb=0
    
    if [ -f "$OUTPUT_PATH" ]; then
        current_size=$(stat -c%s "$OUTPUT_PATH" 2>/dev/null || echo 0)
        current_mb=$((current_size / 1000000))
    fi
    
    local timeout=$BASE_TIMEOUT
    
    # Add extra time if partially downloaded
    if [ $current_mb -gt 0 ]; then
        local extra=$((current_mb * 3 / 1000))  # ~3 seconds per MB
        timeout=$((timeout + extra))
    fi
    
    echo $timeout
}

# Verify download
verify_iso() {
    if [ ! -f "$OUTPUT_PATH" ]; then
        return 1
    fi
    
    local size=$(stat -c%s "$OUTPUT_PATH" 2>/dev/null || echo 0)
    local size_mb=$((size / 1000000))
    
    if [ $size_mb -lt $MIN_SIZE_MB ]; then
        log_warn "File too small: ${size_mb}MB (need ${MIN_SIZE_MB}MB)"
        return 1
    fi
    
    log_success "ISO verified: $((size_mb / 1024))GB"
    return 0
}

# Download with smart retry
download_with_progress() {
    local url=$1
    local output=$2
    local attempt=1
    local last_size=0
    
    while [ $attempt -le $MAX_RETRIES ]; do
        log_info "Download attempt $attempt/$MAX_RETRIES"
        
        # Check current size for timeout calculation
        if [ -f "$output" ]; then
            last_size=$(stat -c%s "$output" 2>/dev/null || echo 0)
            log_info "Resuming from $((last_size / 1000000))MB..."
        fi
        
        # Calculate dynamic timeout
        local timeout=$(get_timeout)
        log_info "Timeout: ${timeout}s"
        
        # Download with curl
        if curl -L --retry 3 --retry-delay 5 \
            --continue-at - \
            -o "$output" \
            --progress-bar \
            --max-time $timeout \
            "$url" 2>&1; then
            
            # Verify
            if verify_iso; then
                return 0
            fi
        fi
        
        # Check progress
        if [ -f "$output" ]; then
            local new_size=$(stat -c%s "$output" 2>/dev/null || echo 0)
            if [ $new_size -gt $last_size ]; then
                log_warn "Progress made: $((last_size/1000000))MB -> $((new_size/1000000))MB"
                # Extend retries for partial progress
                MAX_RETRIES=$((MAX_RETRIES + 2))
            fi
        fi
        
        log_warn "Attempt $attempt failed"
        attempt=$((attempt + 1))
        
        if [ $attempt -le $MAX_RETRIES ]; then
            log_info "Waiting 10s before retry..."
            sleep 10
        fi
    done
    
    return 1
}

# Main
main() {
    log_info "════════════════════════════════════════════════════════════"
    log_info "  📥 KALI ISO DOWNLOADER - Smart Retry"
    log_info "════════════════════════════════════════════════════════════"
    
    check_space || exit 1
    
    # Check existing
    if verify_iso; then
        log_success "ISO already valid: $OUTPUT_PATH"
        exit 0
    fi
    
    # Try mirrors
    local mirrors=(
        "https://cdimage.kali.org/kali-${KALI_VERSION}/${ISO_FILE}"
        "https://kali.download/kali/${ISO_FILE}"
    )
    
    for mirror in "${mirrors[@]}"; do
        log_info "Trying: $mirror"
        
        if download_with_progress "$mirror" "$OUTPUT_PATH"; then
            log_success "Download complete!"
            exit 0
        fi
        
        log_warn "Mirror failed, trying next..."
    done
    
    log_error "All mirrors failed!"
    log_info "Manual: https://kali.org/get-kali/"
    exit 1
}

main "$@"
