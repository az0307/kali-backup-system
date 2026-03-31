#!/bin/bash
# ====================================================================
# banner.sh - Pretty console banners for Skeleton Key USB
# ====================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

banner_skeleton_key() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}           ${GREEN}SKELETON KEY USB v2.0${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}        ${YELLOW}Windows Password Recovery${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

banner_auto_mode() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}           ${WHITE}AUTO PASSWORD RESET MODE${NC}                   ${GREEN}║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

banner_menu() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${WHITE}RECOVERY MENU${NC}                           ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

banner_warning() {
    echo ""
    echo -e "${YELLOW}⚠️  WARNING ⚠️${NC}"
    echo -e "${YELLOW}============${NC}"
    echo -e "${RED}This will modify Windows password${NC}"
    echo ""
    echo -e "Partition: ${CYAN}$1${NC}"
    echo -e "User:      ${CYAN}$2${NC}"
    echo ""
    echo -e "Type ${GREEN}YES${NC} in capitals to confirm:"
    echo ""
}

banner_success() {
    echo ""
    echo -e "${GREEN}✅ SUCCESS${NC}"
    echo "=============="
    echo -e "$1"
    echo ""
}

banner_error() {
    echo ""
    echo -e "${RED}❌ ERROR${NC}"
    echo "=========="
    echo -e "$1"
    echo ""
}

banner_info() {
    echo ""
    echo -e "${BLUE}ℹ️  INFO${NC}"
    echo "========"
    echo -e "$1"
    echo ""
}

print_line() {
    echo "───────────────────────────────────────────────────────────"
}
