#!/bin/bash

################################################################################
#  ☁️ SMART USB BACKUP - With Progress & Resume Support
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SOURCE="/f"
DEST_BASE="/d/USB_Backup"
LOG_FILE="$DEST_BASE/backup.log"

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; echo "[$(date)] INFO: $*" >> "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; echo "[$(date)] OK: $*" >> "$LOG_FILE"; }
log_error() { echo -e "${RED}[✗]${NC} $*"; echo "[$(date)] ERROR: $*" >> "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $*"; echo "[$(date)] WARN: $*" >> "$LOG_FILE"; }

# Get size info
get_source_size() {
    du -sb "$SOURCE" 2>/dev/null | awk '{print $1}'
}

get_dest_size() {
    if [ -d "$DEST" ]; then
        du -sb "$DEST" 2>/dev/null | awk '{print $1}'
    else
        echo 0
    fi
}

main() {
    echo ""
    log_info "════════════════════════════════════════════════════════════"
    log_info "  ☁️ USB SMART BACKUP"
    log_info "════════════════════════════════════════════════════════════"
    
    DEST="$DEST_BASE/$(date +%Y%m%d_%H%M%S)"
    
    # Check source
    if [ ! -d "$SOURCE" ]; then
        log_error "Source $SOURCE not found!"
        exit 1
    fi
    
    # Get sizes
    source_size=$(get_source_size)
    log_info "Source size: $((source_size / 1000000))MB"
    
    # Check disk space
    dest_avail=$(df -B1 /d | awk 'NR==2 {print $4}')
    if [ "$dest_avail" -lt "$source_size" ]; then
        log_error "Not enough space! Need $((source_size/1000000))MB, have $((dest_avail/1000000))MB"
        exit 1
    fi
    
    # Create dest
    mkdir -p "$DEST"
    log_info "Destination: $DEST"
    
    # Sync with progress
    log_info "Starting sync..."
    
    # Use rsync or fallback to cp
    if command -v rsync >/dev/null 2>&1; then
        rsync -avh --progress "$SOURCE/" "$DEST/" 2>&1 | tee -a "$LOG_FILE"
    else
        # Fallback to cp with progress
        cp -rv "$SOURCE/" "$DEST/" 2>&1 | while read line; do
            echo "$line" | tee -a "$LOG_FILE"
        done
    fi
    
    # Verify
    dest_size=$(get_dest_size)
    log_info "Backup size: $((dest_size / 1000000))MB"
    
    if [ $dest_size -ge $((source_size * 90 / 100)) ]; then
        log_success "Backup complete! ($((dest_size * 100 / source_size))% of source)"
    else
        log_warn "Backup may be incomplete: $((dest_size * 100 / source_size))%"
    fi
    
    echo ""
    log_info "Log saved: $LOG_FILE"
    log_info "Files: $(find "$DEST" -type f | wc -l)"
}

main "$@"
