#!/bin/bash
# ====================================================================
# error-handler.sh - Centralized error handling for Skeleton Key USB
# ====================================================================

ERROR_LOG="/mnt/logs/errors.log"
PARTITION_BACKUP="/mnt/backup"

init_logging() {
    mkdir -p "$(dirname "$ERROR_LOG")" 2>/dev/null || true
    mkdir -p "$PARTITION_BACKUP" 2>/dev/null || true
}

log() {
    local msg="[$(date +%H:%M:%S)] $*"
    echo "$msg"
    echo "$msg" >> "$ERROR_LOG" 2>/dev/null || true
}

error() {
    local msg="[ERROR] $*"
    echo "$msg" | tee -a "$ERROR_LOG" 2>/dev/null || true
}

warn() {
    local msg="[WARNING] $*"
    echo "$msg" | tee -a "$ERROR_LOG" 2>/dev/null || true
}

error_exit() {
    local msg="$1"
    local code="${2:-1}"
    error "$msg"
    echo ""
    echo "Check log: $ERROR_LOG"
    echo "Press Enter to exit..."
    read
    exit "$code"
}

require_root() {
    if [ "$EUID" -ne 0 ]; then
        error_exit "Must run as root (use sudo)"
    fi
}

require_chntpw() {
    if ! command -v chntpw &> /dev/null; then
        warn "chntpw not found, attempting install..."
        if command -v apt-get &> /dev/null; then
            apt-get update -qq && apt-get install -y -qq chntpw 2>/dev/null
        fi
        if ! command -v chntpw &> /dev/null; then
            error_exit "Cannot install chntw. Install manually: sudo apt install chntpw"
        fi
    fi
    log "chntpw verified"
}

require_ntfs3g() {
    if ! command -v ntfs-3g &> /dev/null; then
        warn "ntfs-3g not found, attempting install..."
        if command -v apt-get &> /dev/null; then
            apt-get update -qq && apt-get install -y -qq ntfs-3g 2>/dev/null
        fi
        if ! command -v ntfs-3g &> /dev/null; then
            error_exit "Cannot install ntfs-3g. Install manually: sudo apt install ntfs-3g"
        fi
    fi
    log "ntfs-3g verified"
}

cleanup_on_exit() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        error "Script exited with code: $exit_code"
    fi
    return $exit_code
}

trap 'cleanup_on_exit' EXIT
trap 'error_exit "Interrupted at line $LINENO" INT TERM' INT TERM

init_logging
