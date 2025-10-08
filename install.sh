#!/bin/bash
# install.sh - AMIGO CYBER Global Installer
# Developer: amigo-d-cyber
# GitHub: https://github.com/amigo-d-cyber

# Enhanced color palette
RED='\033[0;31m'
BRED='\033[1;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;32m'
YELLOW='\033[0;33m'
BYELLOW='\033[1;33m'
BLUE='\033[0;34m'
BBLUE='\033[1;34m'
PURPLE='\033[0;35m'
BPURPLE='\033[1;35m'
CYAN='\033[0;36m'
BCYAN='\033[1;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# Installation paths
INSTALL_DIR="/usr/local/bin"
MAN_DIR="/usr/local/share/man/man1"
SCRIPT_NAME="airmonitor"
MAIN_SCRIPT="airmonitor.sh"

# Print functions
print_status() { echo -e "${BGREEN}[${WHITE}+${BGREEN}]${NC} ${WHITE}$1${NC}"; }
print_info() { echo -e "${BCYAN}[${WHITE}*${BCYAN}]${NC} ${CYAN}$1${NC}"; }
print_error() { echo -e "${BRED}[${WHITE}-${BRED}]${NC} ${RED}$1${NC}"; }
print_warning() { echo -e "${BYELLOW}[${WHITE}!${BYELLOW}]${NC} ${YELLOW}$1${NC}"; }
print_question() { echo -e "${BPURPLE}[${WHITE}?${BPURPLE}]${NC} ${PURPLE}$1${NC}"; }

# Bloody installer banner
show_banner() {
    echo -e "${BRED}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║    █████╗ ███╗   ███╗██╗ ██████╗  ██████╗                ║
    ║   ██╔══██╗████╗ ████║██║██╔════╝ ██╔═══██╗               ║
    ║   ███████║██╔████╔██║██║██║  ███╗██║   ██║               ║
    ║   ██╔══██║██║╚██╔╝██║██║██║   ██║██║   ██║               ║
    ║   ██║  ██║██║ ╚═╝ ██║██║╚██████╔╝╚██████╔╝               ║
    ║   ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝ ╚═════╝  ╚═════╝                ║
    ║                                                           ║
    ║    ██████╗██╗   ██╗██████╗ ███████╗██████╗                ║
    ║   ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗               ║
    ║   ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝               ║
    ║   ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗               ║
    ║   ╚██████╗   ██║   ██████╔╝███████╗██║  ██║               ║
    ║    ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝               ║
    ║                                                           ║
    ║               GLOBAL INSTALLER v1.0                      ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${WHITE}                    System-Wide Installation${NC}"
    echo -e "${GRAY}                   Developer: ${BGREEN}amigoDcyber${NC}"
    echo -e "${BRED}           ═══════════════════════════════════════${NC}"
    echo
}

# Check for root privileges
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This installer must be run as root!"
        echo -e "${GRAY}   Usage: sudo ./install.sh${NC}"
        exit 1
    fi
}

# Detect Linux distribution
detect_distro() {
    print_info "Detecting Linux distribution..."
    
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DISTRO_ID="$ID"
        DISTRO_LIKE="$ID_LIKE"
        print_status "Detected: ${BGREEN}$PRETTY_NAME${NC}"
    else
        print_error "Cannot detect distribution!"
        exit 1
    fi
    
    # Determine package manager
    case "$DISTRO_ID" in
        arch|manjaro|endeavouros|artix)
            PKG_MANAGER="pacman"
            PKG_INSTALL="pacman -S --noconfirm"
            PKG_UPDATE="pacman -Sy"
            ;;
        ubuntu|debian|kali|parrot|linuxmint)
            PKG_MANAGER="apt"
            PKG_INSTALL="apt install -y"
            PKG_UPDATE="apt update"
            ;;
        fedora|rhel|centos)
            PKG_MANAGER="dnf"
            PKG_INSTALL="dnf install -y"
            PKG_UPDATE="dnf check-update"
            ;;
        opensuse|sles)
            PKG_MANAGER="zypper"
            PKG_INSTALL="zypper install -y"
            PKG_UPDATE="zypper refresh"
            ;;
        *)
            # Check ID_LIKE for derivatives
            case "$DISTRO_LIKE" in
                *arch*)
                    PKG_MANAGER="pacman"
                    PKG_INSTALL="pacman -S --noconfirm"
                    PKG_UPDATE="pacman -Sy"
                    ;;
                *debian*|*ubuntu*)
                    PKG_MANAGER="apt"
                    PKG_INSTALL="apt install -y"
                    PKG_UPDATE="apt update"
                    ;;
                *rhel*|*fedora*)
                    PKG_MANAGER="dnf"
                    PKG_INSTALL="dnf install -y"
                    PKG_UPDATE="dnf check-update"
                    ;;
                *)
                    print_warning "Unknown distribution, attempting to detect package manager..."
                    if command -v pacman >/dev/null 2>&1; then
                        PKG_MANAGER="pacman"
                        PKG_INSTALL="pacman -S --noconfirm"
                        PKG_UPDATE="pacman -Sy"
                    elif command -v apt >/dev/null 2>&1; then
                        PKG_MANAGER="apt"
                        PKG_INSTALL="apt install -y"
                        PKG_UPDATE="apt update"
                    elif command -v dnf >/dev/null 2>&1; then
                        PKG_MANAGER="dnf"
                        PKG_INSTALL="dnf install -y"
                        PKG_UPDATE="dnf check-update"
                    elif command -v yum >/dev/null 2>&1; then
                        PKG_MANAGER="yum"
                        PKG_INSTALL="yum install -y"
                        PKG_UPDATE="yum check-update"
                    else
                        print_error "No supported package manager found!"
                        print_info "Please install dependencies manually: iw, wireless-tools, iproute2, systemd"
                        exit 1
                    fi
                    ;;
            esac
            ;;
    esac
    
    print_info "Using package manager: ${BGREEN}$PKG_MANAGER${NC}"
}

# Check and install dependencies
install_dependencies() {
    print_info "Checking system dependencies..."
    
    local missing_packages=()
    
    # Define package names for different distros
    declare -A packages
    case "$PKG_MANAGER" in
        pacman)
            packages[iw]="iw"
            packages[iwconfig]="wireless_tools"
            packages[ip]="iproute2"
            packages[systemctl]="systemd"
            packages[nmcli]="networkmanager"
            ;;
        apt)
            packages[iw]="iw"
            packages[iwconfig]="wireless-tools"
            packages[ip]="iproute2"
            packages[systemctl]="systemd"
            packages[nmcli]="network-manager"
            ;;
        dnf|yum)
            packages[iw]="iw"
            packages[iwconfig]="wireless-tools"
            packages[ip]="iproute"
            packages[systemctl]="systemd"
            packages[nmcli]="NetworkManager"
            ;;
        zypper)
            packages[iw]="iw"
            packages[iwconfig]="wireless-tools"
            packages[ip]="iproute2"
            packages[systemctl]="systemd"
            packages[nmcli]="NetworkManager"
            ;;
    esac
    
    # Check for each required command
    for cmd in iw iwconfig ip systemctl; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            print_warning "Missing required dependency: ${BRED}$cmd${NC}"
            missing_packages+=(${packages[$cmd]})
        else
            print_status "Found: ${BGREEN}$cmd${NC}"
        fi
    done
    
    # Check for optional NetworkManager
    if ! command -v nmcli >/dev/null 2>&1; then
        print_warning "Optional dependency missing: ${BYELLOW}nmcli${NC} (NetworkManager)"
        read -p "$(echo -e "${BPURPLE}   Install NetworkManager?${NC} ${WHITE}[${BGREEN}y${WHITE}/${RED}N${WHITE}]${NC}: ")" install_nm
        case "$install_nm" in
            y|Y)
                missing_packages+=(${packages[nmcli]})
                ;;
        esac
    else
        print_status "Found: ${BGREEN}nmcli${NC}"
    fi
    
    # Install missing packages
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        print_info "Installing missing dependencies..."
        echo -e "${GRAY}   Packages: ${missing_packages[*]}${NC}"
        
        print_info "Updating package database..."
        if ! eval "$PKG_UPDATE" >/dev/null 2>&1; then
            print_warning "Package update failed, continuing anyway..."
        fi
        
        print_info "Installing packages..."
        if eval "$PKG_INSTALL ${missing_packages[*]}" >/dev/null 2>&1; then
            print_status "Dependencies installed successfully!"
        else
            print_error "Failed to install some dependencies!"
            print_warning "You may need to install manually: ${missing_packages[*]}"
            read -p "$(echo -e "${BPURPLE}   Continue anyway?${NC} ${WHITE}[${RED}y${WHITE}/${BGREEN}N${WHITE}]${NC}: ")" continue_install
            case "$continue_install" in
                y|Y)
                    print_info "Continuing installation..."
                    ;;
                *)
                    print_error "Installation aborted."
                    exit 1
                    ;;
            esac
        fi
    else
        print_status "All dependencies are already installed!"
    fi
}

# Install the main script
install_airmonitor() {
    print_info "Installing AMIGO CYBER airmonitor..."
    
    # Check if main script exists
    if [[ ! -f "$MAIN_SCRIPT" ]]; then
        print_error "Main script '$MAIN_SCRIPT' not found!"
        print_info "Make sure you run this installer from the same directory as $MAIN_SCRIPT"
        exit 1
    fi
    
    # Create directories if they don't exist
    print_info "Creating installation directories..."
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$MAN_DIR"
    
    # Backup existing installation
    if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_warning "Existing installation found, creating backup..."
        cp "$INSTALL_DIR/$SCRIPT_NAME" "$INSTALL_DIR/${SCRIPT_NAME}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Copy main script
    print_info "Copying airmonitor script..."
    cp "$MAIN_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    # Create man page
    create_man_page
    
    print_status "Installation completed successfully!"
}

# Create man page documentation
create_man_page() {
    print_info "Creating man page documentation..."
    
    cat > "$MAN_DIR/airmonitor.1" << 'EOF'
.TH AIRMONITOR 1 "$(date +"%B %Y")" "AMIGO CYBER v2.0" "User Commands"
.SH NAME
airmonitor \- Wireless interface monitor mode switcher
.SH SYNOPSIS
.B airmonitor
.SH DESCRIPTION
AMIGO CYBER airmonitor is an enhanced interactive tool for switching wireless network interfaces between monitor and managed modes. It provides intelligent interface detection, network connection awareness, and quick toggle functionality for wireless security testing and network analysis.
.SH FEATURES
.TP
.B Smart Interface Detection
Automatically detects available wireless interfaces with preference memory
.TP
.B Network Connection Awareness  
Shows current SSID and warns before disconnecting from networks
.TP
.B Quick Toggle Mode
Lightning-fast switching using single keystrokes (m/n/q)
.TP
.B Process Management
Automatically handles NetworkManager and interfering processes
.TP
.B Interface Recovery
Deep cleanup mode for fixing interfaces corrupted by other tools
.TP
.B Preference Memory
Remembers your preferred interface and settings between runs
.SH OPTIONS
The tool provides an interactive menu with the following modes:
.TP
.B Standard Mode
Guided setup with step-by-step interface configuration
.TP
.B Quick Toggle Mode
Fast switching using single key commands:
.RS
.TP
.B m
Switch to monitor mode
.TP
.B n  
Switch to managed mode
.TP
.B q
Quit the application
.RE
.TP
.B Recovery Mode
Fix interfaces corrupted by tools like Fluxion, WEF, or Linset
.SH REQUIREMENTS
.TP
Root privileges required for wireless interface manipulation
.TP
Required packages: iw, wireless-tools, iproute2, systemd
.TP
Optional: NetworkManager for enhanced network detection
.SH FILES
.TP
.I ~/.amigo_monitor_config
User preferences and interface settings
.SH EXAMPLES
.TP
.B sudo airmonitor
Start the interactive interface switcher
.SH AUTHOR
Written by amigo-d-cyber
.SH REPORTING BUGS
Report bugs to: https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-
.SH COPYRIGHT
This is free software; see the source for copying conditions.
.SH SEE ALSO
.BR iw (8),
.BR iwconfig (8),
.BR ip (8)
EOF
    
    # Compress man page
    if command -v gzip >/dev/null 2>&1; then
        gzip -f "$MAN_DIR/airmonitor.1"
        print_status "Man page created: ${BGREEN}man airmonitor${NC}"
    else
        print_warning "gzip not found, man page not compressed"
    fi
}

# Test installation
test_installation() {
    print_info "Testing installation..."
    
    if [[ -x "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_status "Executable installed correctly"
    else
        print_error "Installation verification failed!"
        exit 1
    fi
    
    # Test if command is in PATH
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        print_status "Global command available: ${BGREEN}sudo $SCRIPT_NAME${NC}"
    else
        print_warning "Command may not be in PATH, try: ${BGREEN}sudo $INSTALL_DIR/$SCRIPT_NAME${NC}"
    fi
}

# Main installation function
main() {
    show_banner
    
    print_question "Install AMIGO CYBER airmonitor globally?"
    read -p "$(echo -e "${BPURPLE}   Continue?${NC} ${WHITE}[${BGREEN}Y${WHITE}/${RED}n${WHITE}]${NC}: ")" confirm
    
    case "$confirm" in
        n|N)
            print_info "Installation cancelled by user"
            exit 0
            ;;
    esac
    
    check_root
    detect_distro
    install_dependencies
    install_airmonitor
    test_installation
    
    echo
    echo -e "${BGREEN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${BGREEN}║${NC} ${WHITE}INSTALLATION COMPLETED SUCCESSFULLY!${NC}             ${BGREEN}║${NC}"
    echo -e "${BGREEN}╚════════════════════════════════════════════════════╝${NC}"
    echo -e "${WHITE}   Usage: ${BGREEN}sudo airmonitor${NC}"
    echo -e "${WHITE}   Documentation: ${BCYAN}man airmonitor${NC}"
    echo -e "${WHITE}   Uninstall: ${BRED}sudo ./uninstall.sh${NC}"
    echo
    echo -e "${GRAY}   Stay bloody, stay sharp! - amigo-d-cyber${NC}"
    echo
}

# Run main function
main "$@"
