#!/bin/bash
# uninstall.sh - AMIGO CYBER Global Uninstaller
# Developer: amigoDcyber
# GitHub: https://github.com/amigoDcyber

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

# Print functions
print_status() { echo -e "${BGREEN}[${WHITE}+${BGREEN}]${NC} ${WHITE}$1${NC}"; }
print_info() { echo -e "${BCYAN}[${WHITE}*${BCYAN}]${NC} ${CYAN}$1${NC}"; }
print_error() { echo -e "${BRED}[${WHITE}-${BRED}]${NC} ${RED}$1${NC}"; }
print_warning() { echo -e "${BYELLOW}[${WHITE}!${BYELLOW}]${NC} ${YELLOW}$1${NC}"; }
print_question() { echo -e "${BPURPLE}[${WHITE}?${BPURPLE}]${NC} ${PURPLE}$1${NC}"; }

# Bloody uninstaller banner
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
    ║               GLOBAL UNINSTALLER v1.0                    ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${WHITE}                    System-Wide Removal${NC}"
    echo -e "${GRAY}                   Developer: ${BGREEN}amigoDcyber${NC}"
    echo -e "${BRED}           ═══════════════════════════════════════${NC}"
    echo
}

# Check for root privileges
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This uninstaller must be run as root!"
        echo -e "${GRAY}   Usage: sudo ./uninstall.sh${NC}"
        exit 1
    fi
}

# Check if airmonitor is installed
check_installation() {
    print_info "Checking for AMIGO CYBER airmonitor installation..."
    
    if [[ ! -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_error "AMIGO CYBER airmonitor is not installed globally!"
        echo -e "${GRAY}   No installation found in $INSTALL_DIR/$SCRIPT_NAME${NC}"
        exit 1
    fi
    
    print_status "Found installation: ${BGREEN}$INSTALL_DIR/$SCRIPT_NAME${NC}"
}

# Check if airmonitor is currently running
check_running_processes() {
    print_info "Checking for running airmonitor processes..."
    
    local airmonitor_pids=$(pgrep -f "airmonitor" 2>/dev/null)
    
    if [[ -n "$airmonitor_pids" ]]; then
        print_warning "Found running airmonitor processes!"
        echo -e "${GRAY}   PIDs: $airmonitor_pids${NC}"
        
        print_question "Kill running processes before uninstall?"
        read -p "$(echo -e "${BPURPLE}   Continue?${NC} ${WHITE}[${BGREEN}Y${WHITE}/${RED}n${WHITE}]${NC}: ")" kill_processes
        
        case "$kill_processes" in
            n|N)
                print_error "Cannot uninstall while airmonitor is running!"
                print_info "Please stop all airmonitor processes first"
                exit 1
                ;;
            *)
                print_info "Terminating airmonitor processes..."
                pkill -f "airmonitor" 2>/dev/null
                sleep 2
                
                # Force kill if still running
                if pgrep -f "airmonitor" >/dev/null 2>&1; then
                    print_warning "Force killing remaining processes..."
                    pkill -9 -f "airmonitor" 2>/dev/null
                fi
                
                print_status "All airmonitor processes terminated"
                ;;
        esac
    else
        print_status "No running airmonitor processes found"
    fi
}

# Remove installed files
remove_files() {
    print_info "Removing AMIGO CYBER airmonitor files..."
    
    local removed_files=0
    local failed_removals=0
    
    # Remove main executable
    if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        if rm -f "$INSTALL_DIR/$SCRIPT_NAME" 2>/dev/null; then
            print_status "Removed: ${BGREEN}$INSTALL_DIR/$SCRIPT_NAME${NC}"
            ((removed_files++))
        else
            print_error "Failed to remove: $INSTALL_DIR/$SCRIPT_NAME"
            ((failed_removals++))
        fi
    fi
    
    # Remove backup files
    local backup_files=$(find "$INSTALL_DIR" -name "${SCRIPT_NAME}.backup.*" 2>/dev/null)
    if [[ -n "$backup_files" ]]; then
        print_info "Removing backup files..."
        for backup in $backup_files; do
            if rm -f "$backup" 2>/dev/null; then
                print_status "Removed backup: ${BGREEN}$(basename "$backup")${NC}"
                ((removed_files++))
            else
                print_error "Failed to remove backup: $backup"
                ((failed_removals++))
            fi
        done
    fi
    
    # Remove man page
    if [[ -f "$MAN_DIR/airmonitor.1.gz" ]]; then
        if rm -f "$MAN_DIR/airmonitor.1.gz" 2>/dev/null; then
            print_status "Removed: ${BGREEN}$MAN_DIR/airmonitor.1.gz${NC}"
            ((removed_files++))
        else
            print_error "Failed to remove man page"
            ((failed_removals++))
        fi
    elif [[ -f "$MAN_DIR/airmonitor.1" ]]; then
        if rm -f "$MAN_DIR/airmonitor.1" 2>/dev/null; then
            print_status "Removed: ${BGREEN}$MAN_DIR/airmonitor.1${NC}"
            ((removed_files++))
        else
            print_error "Failed to remove man page"
            ((failed_removals++))
        fi
    fi
    
    # Update man database
    if command -v mandb >/dev/null 2>&1; then
        print_info "Updating man page database..."
        mandb -q 2>/dev/null || true
    fi
    
    # Summary
    if [[ $failed_removals -eq 0 ]]; then
        print_status "Successfully removed $removed_files files"
    else
        print_warning "Removed $removed_files files, failed to remove $failed_removals files"
    fi
}

# Handle user configuration
handle_user_config() {
    print_question "Remove user configuration files?"
    echo -e "${GRAY}   This will delete ~/.amigo_monitor_config for all users${NC}"
    read -p "$(echo -e "${BPURPLE}   Remove configs?${NC} ${WHITE}[${RED}y${WHITE}/${BGREEN}N${WHITE}]${NC}: ")" remove_config
    
    case "$remove_config" in
        y|Y)
            print_info "Scanning for user configuration files..."
            
            local config_files_found=0
            local config_files_removed=0
            
            # Check common user directories
            for home_dir in /home/* /root; do
                if [[ -d "$home_dir" ]]; then
                    local config_file="$home_dir/.amigo_monitor_config"
                    if [[ -f "$config_file" ]]; then
                        ((config_files_found++))
                        if rm -f "$config_file" 2>/dev/null; then
                            print_status "Removed config: ${BGREEN}$config_file${NC}"
                            ((config_files_removed++))
                        else
                            print_error "Failed to remove: $config_file"
                        fi
                    fi
                fi
            done
            
            if [[ $config_files_found -eq 0 ]]; then
                print_info "No user configuration files found"
            else
                print_status "Removed $config_files_removed of $config_files_found configuration files"
            fi
            ;;
        *)
            print_info "User configuration files preserved"
            echo -e "${GRAY}   Users can manually delete ~/.amigo_monitor_config if desired${NC}"
            ;;
    esac
}

# Verify complete removal
verify_removal() {
    print_info "Verifying complete removal..."
    
    local verification_failed=false
    
    # Check if main executable still exists
    if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_error "Main executable still exists: $INSTALL_DIR/$SCRIPT_NAME"
        verification_failed=true
    fi
    
    # Check if command is still available
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        print_error "Command still available in PATH: $SCRIPT_NAME"
        verification_failed=true
    fi
    
    # Check for leftover man page
    if [[ -f "$MAN_DIR/airmonitor.1" ]] || [[ -f "$MAN_DIR/airmonitor.1.gz" ]]; then
        print_error "Man page still exists"
        verification_failed=true
    fi
    
    if [[ "$verification_failed" == false ]]; then
        print_status "Verification successful - airmonitor completely removed!"
    else
        print_warning "Verification found some remaining files"
        print_info "Manual cleanup may be required"
    fi
}

# Main uninstallation function
main() {
    show_banner
    
    print_warning "This will completely remove AMIGO CYBER airmonitor from your system!"
    print_question "Are you sure you want to uninstall?"
    read -p "$(echo -e "${BPURPLE}   Continue?${NC} ${WHITE}[${RED}y${WHITE}/${BGREEN}N${WHITE}]${NC}: ")" confirm
    
    case "$confirm" in
        y|Y)
            ;;
        *)
            print_info "Uninstallation cancelled by user"
            exit 0
            ;;
    esac
    
    check_root
    check_installation
    check_running_processes
    remove_files
    handle_user_config
    verify_removal
    
    echo
    echo -e "${BRED}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${BRED}║${NC} ${WHITE}UNINSTALLATION COMPLETED!${NC}                      ${BRED}║${NC}"
    echo -e "${BRED}╚════════════════════════════════════════════════════╝${NC}"
    echo -e "${WHITE}   AMIGO CYBER airmonitor has been removed${NC}"
    echo -e "${WHITE}   Thanks for using our tools!${NC}"
    echo
    echo -e "${GRAY}   Stay bloody, stay sharp! - amigoDcyber${NC}"
    echo -e "${GRAY}   GitHub: https://github.com/amigoDcyber/Airmonitor${NC}"
    echo
}

# Run main function
main "$@"
