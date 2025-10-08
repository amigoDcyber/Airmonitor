#!/bin/bash
# airmonitor - enhanced interactive monitor mode switcher

# Enhanced color palette
RED='\033[0;31m'
BRED='\033[1;31m'        # Bright Red
GREEN='\033[0;32m'
BGREEN='\033[1;32m'      # Bright Green
YELLOW='\033[0;33m'
BYELLOW='\033[1;33m'     # Bright Yellow
BLUE='\033[0;34m'
BBLUE='\033[1;34m'       # Bright Blue
PURPLE='\033[0;35m'
BPURPLE='\033[1;35m'     # Bright Purple
CYAN='\033[0;36m'
BCYAN='\033[1;36m'       # Bright Cyan
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'             # No Color

# Config file for preferences
CONFIG_FILE="$HOME/.amigo_monitor_config"

# Bloody style ASCII banner
show_banner() {
    echo -e "${BRED}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║      ▄▄▄       ███▄ ▄███▓ ██▓  ▄████  ▒█████            ║
    ║     ▒████▄    ▓██▒▀█▀ ██▒▓██▒ ██▒ ▀█▒▒██▒  ██▒          ║
    ║     ▒██  ▀█▄  ▓██    ▓██░▒██▒▒██░▄▄▄░▒██░  ██▒          ║
    ║     ░██▄▄▄▄██ ▒██    ▒██ ░██░░▓█  ██▓▒██   ██░          ║
    ║      ▓█   ▓██▒▒██▒   ░██▒░██░░▒▓███▀▒░ ████▓▒░          ║
    ║      ▒▒   ▓▒█░░ ▒░   ░  ░░▓   ░▒   ▒ ░ ▒░▒░▒░           ║
    ║       ▒   ▒▒ ░░  ░      ░ ▒ ░  ░   ░   ░ ▒ ▒░           ║
    ║       ░   ▒   ░      ░    ▒ ░░ ░   ░ ░ ░ ░ ▒            ║
    ║           ░  ░       ░    ░        ░     ░ ░            ║
    ║                                                          ║
    ║       ▄████▄▓██   ██▓ ▄▄▄▄   ▓█████  ██▀███            ║
    ║      ▒██▀ ▀█ ▒██  ██▒▓█████▄ ▓█   ▀ ▓██ ▒ ██▒          ║
    ║      ▒▓█    ▄ ▒██ ██░▒██▒ ▄██▒███   ▓██ ░▄█ ▒          ║
    ║      ▒▓▓▄ ▄██▒░ ▐██▓░▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄            ║
    ║      ▒ ▓███▀ ░░ ██▒▓░░▓█  ▀█▓░▒████▒░██▓ ▒██▒          ║
    ║      ░ ░▒ ▒  ░ ██▒▒▒ ░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░          ║
    ║        ░  ▒ ▓██ ░▒░ ▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░          ║
    ║      ░     ▒ ▒ ░░  ░  ░    ░    ░     ░░   ░           ║
    ║      ░ ░   ░ ░     ░  ░         ░  ░   ░               ║
    ║      ░     ░ ░            ░                            ║
    ║                                                          ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${WHITE}           Wireless Monitor Mode Switcher v2.0${NC}"
    echo -e "${GRAY}               Developer: ${BGREEN}amigoDcyber${NC}"
    echo -e "${GRAY}               GitHub: ${BCYAN}https://github.com/amigoDcyber${NC}"
    echo -e "${GRAY}               Tools: ${BCYAN}https://github.com/amigoDcyber/Airmonitor${NC}"
    echo -e "${BRED}           ═══════════════════════════════════════${NC}"
    echo
}

# Enhanced print functions with bloody style
print_status() { echo -e "${BGREEN}[${WHITE}+${BGREEN}]${NC} ${WHITE}$1${NC}"; }
print_info() { echo -e "${BCYAN}[${WHITE}*${BCYAN}]${NC} ${CYAN}$1${NC}"; }
print_error() { echo -e "${BRED}[${WHITE}-${BRED}]${NC} ${RED}$1${NC}"; }
print_warning() { echo -e "${BYELLOW}[${WHITE}!${BYELLOW}]${NC} ${YELLOW}$1${NC}"; }
print_question() { echo -e "${BPURPLE}[${WHITE}?${BPURPLE}]${NC} ${PURPLE}$1${NC}"; }

# Load saved preferences
load_preferences() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE" 2>/dev/null
    fi
}

# Save preferences
save_preferences() {
    cat > "$CONFIG_FILE" << EOF
# AMIGO CYBER Monitor Config
PREFERRED_INTERFACE="$1"
LAST_MODE="$2"
LAST_USED=$(date +%s)
EOF
}

# Interface recovery mode function
interface_recovery_mode() {
    print_info "Starting interface recovery for ${BGREEN}$INTERFACE${NC}..."
    
    # Bring interface down
    ip link set "$INTERFACE" down 2>/dev/null
    sleep 2
    
    # Try to set to managed mode first
    iw "$INTERFACE" set type managed 2>/dev/null
    
    # Try to reload the module if possible
    local driver=$(ethtool -i "$INTERFACE" 2>/dev/null | grep 'driver:' | awk '{print $2}')
    if [[ -n "$driver" ]]; then
        print_info "Reloading driver module: ${BYELLOW}$driver${NC}"
        modprobe -r "$driver" 2>/dev/null
        sleep 3
        modprobe "$driver" 2>/dev/null
        sleep 2
    fi
    
    # Bring interface back up
    ip link set "$INTERFACE" up 2>/dev/null
    
    # Restart NetworkManager to ensure clean state
    print_info "Restarting network services..."
    systemctl restart NetworkManager 2>/dev/null || service NetworkManager restart 2>/dev/null
    
    print_status "Interface recovery completed for ${BGREEN}$INTERFACE${NC}"
    echo -e "${GRAY}   The interface should now be in a clean state${NC}"
    sleep 2
}

# Show the bloody banner
show_banner

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   print_error "Please run as root!"
   echo -e "${GRAY}   Usage: sudo $0${NC}"
   exit 1
fi

# Load preferences
load_preferences

# Auto-detect wireless interface
get_wireless_interface() {
    local interfaces=($(iw dev | awk '$1=="Interface"{print $2}'))
    
    if [[ ${#interfaces[@]} -eq 0 ]]; then
        print_error "No wireless interface found!"
        echo -e "${GRAY}   Make sure your wireless adapter is connected${NC}" >&2
        return 1
    elif [[ ${#interfaces[@]} -eq 1 ]]; then
        local interface="${interfaces[0]}"
        # Always ask even for single interface
        print_info "Found wireless interface: ${BGREEN}$interface${NC}" >&2
        if [[ -n "$PREFERRED_INTERFACE" && "$PREFERRED_INTERFACE" == "$interface" ]]; then
            print_question "Use your preferred interface ${BGREEN}$interface${NC}?" >&2
        else
            print_question "Use this interface?" >&2
        fi
        read -p "$(echo -e "${BPURPLE}   Choice${NC} ${WHITE}[${BGREEN}Y${WHITE}/${RED}n${WHITE}]${NC}: ")" choice >&2
        case "$choice" in
            n|N ) 
                print_error "Interface selection cancelled" >&2
                return 1
                ;;
            * ) 
                echo "$interface"
                return 0
                ;;
        esac
    else
        print_info "Multiple wireless interfaces detected:" >&2
        echo >&2
        # Highlight preferred interface if it exists
        for i in "${!interfaces[@]}"; do
            if [[ -n "$PREFERRED_INTERFACE" && "${interfaces[i]}" == "$PREFERRED_INTERFACE" ]]; then
                echo -e "${WHITE}    $((i+1)).${NC} ${BGREEN}${interfaces[i]}${NC} ${BYELLOW}(preferred)${NC}" >&2
            else
                echo -e "${WHITE}    $((i+1)).${NC} ${BGREEN}${interfaces[i]}${NC}" >&2
            fi
        done
        echo >&2
        print_question "Select interface number:" >&2
        read -p "$(echo -e "${BPURPLE}   Choice${NC} ${WHITE}[${BPURPLE}1-${#interfaces[@]}${WHITE}]${NC}: ")" choice >&2
        if [[ "$choice" =~ ^[1-${#interfaces[@]}]$ ]]; then
            echo "${interfaces[$((choice-1))]}"
            return 0
        else
            print_error "Invalid selection!" >&2
            return 1
        fi
    fi
}

# Check if interface is connected to a network
check_network_connection() {
    local interface="$1"
    
    # Check using multiple methods
    # Method 1: iwconfig ESSID check
    local essid=$(iwconfig "$interface" 2>/dev/null | grep 'ESSID:' | cut -d'"' -f2)
    if [[ -n "$essid" && "$essid" != "off/any" ]]; then
        return 0  # Connected
    fi
    
    # Method 2: Check if we have an IP address
    if ip addr show "$interface" 2>/dev/null | grep -q 'inet '; then
        return 0  # Connected
    fi
    
    # Method 3: nmcli check
    if command -v nmcli >/dev/null 2>&1; then
        if nmcli -t -f DEVICE,STATE dev 2>/dev/null | grep "^$interface:connected" >/dev/null; then
            return 0  # Connected
        fi
    fi
    
    return 1  # Not connected
}

# Get current SSID
get_current_ssid() {
    local interface="$1"
    local ssid=""
    
    # Try multiple methods to get SSID
    # Method 1: iwconfig
    ssid=$(iwconfig "$interface" 2>/dev/null | grep 'ESSID:' | sed 's/.*ESSID:"\([^"]*\)".*/\1/')
    
    # Method 2: nmcli if iwconfig failed
    if [[ -z "$ssid" || "$ssid" == "off/any" ]]; then
        ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d: -f2)
    fi
    
    # Method 3: iw if others failed
    if [[ -z "$ssid" ]]; then
        ssid=$(iw dev "$interface" link 2>/dev/null | grep 'SSID:' | awk '{print $2}')
    fi
    
    # Return the SSID or "Unknown" if not found
    if [[ -n "$ssid" && "$ssid" != "off/any" ]]; then
        echo "$ssid"
    else
        echo "Unknown Network"
    fi
}

# Kill interfering processes
kill_interfering_processes() {
    print_info "Scanning for interfering processes..."
    
    # Kill NetworkManager for this interface
    if pgrep NetworkManager >/dev/null; then
        print_warning "Stopping NetworkManager..."
        systemctl stop NetworkManager 2>/dev/null || service NetworkManager stop 2>/dev/null
        RESTART_NM=true
    fi
    
    # Kill wpa_supplicant
    if pgrep -f "wpa_supplicant.*$INTERFACE" >/dev/null; then
        print_warning "Terminating wpa_supplicant..."
        pkill -f "wpa_supplicant.*$INTERFACE" 2>/dev/null
    fi
    
    # Kill dhclient
    if pgrep -f "dhclient.*$INTERFACE" >/dev/null; then
        print_warning "Terminating dhclient..."
        pkill -f "dhclient.*$INTERFACE" 2>/dev/null
    fi
    
    echo -e "${GRAY}   Waiting for processes to terminate...${NC}"
    sleep 2
}

# Restore NetworkManager if it was stopped
restore_network_manager() {
    if [[ "$RESTART_NM" == "true" ]]; then
        print_info "Restarting NetworkManager..."
        systemctl start NetworkManager 2>/dev/null || service NetworkManager start 2>/dev/null
        echo -e "${GRAY}   Network services restored${NC}"
    fi
}

# Set interface to monitor mode
set_monitor_mode() {
    print_info "Switching ${BGREEN}$INTERFACE${CYAN} to monitor mode..."
    
    if ! ip link set "$INTERFACE" down 2>/dev/null; then
        print_error "Failed to bring interface down"
        return 1
    fi
    
    if ! iw "$INTERFACE" set type monitor 2>/dev/null; then
        print_error "Failed to set monitor mode (driver may not support it)"
        ip link set "$INTERFACE" up 2>/dev/null
        return 1
    fi
    
    if ! ip link set "$INTERFACE" up 2>/dev/null; then
        print_error "Failed to bring interface up"
        return 1
    fi
    
    print_status "${BGREEN}$INTERFACE${WHITE} is now in ${BRED}MONITOR${WHITE} mode"
    echo -e "${GRAY}   Ready for packet capture and analysis${NC}"
    save_preferences "$INTERFACE" "monitor"
    return 0
}

# Set interface to managed mode
set_managed_mode() {
    print_info "Switching ${BGREEN}$INTERFACE${CYAN} to managed mode..."
    
    if ! ip link set "$INTERFACE" down 2>/dev/null; then
        print_error "Failed to bring interface down"
        return 1
    fi
    
    if ! iw "$INTERFACE" set type managed 2>/dev/null; then
        print_error "Failed to set managed mode"
        return 1
    fi
    
    if ! ip link set "$INTERFACE" up 2>/dev/null; then
        print_error "Failed to bring interface up"
        return 1
    fi
    
    print_status "${BGREEN}$INTERFACE${WHITE} is now in ${BGREEN}MANAGED${WHITE} mode"
    echo -e "${GRAY}   Normal wireless connectivity restored${NC}"
    restore_network_manager
    save_preferences "$INTERFACE" "managed"
    return 0
}

# Quick mode toggle menu
quick_mode_toggle() {
    while true; do
        echo -e "${BCYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${BCYAN}║${NC} ${WHITE}Quick Mode Toggle${NC}                         ${BCYAN}║${NC}"
        echo -e "${BCYAN}╚══════════════════════════════════════════════╝${NC}"
        
        # Get current mode
        local current_mode=$(iw dev "$INTERFACE" info 2>/dev/null | grep -i type | awk '{print $2}')
        print_info "Current mode: ${BYELLOW}${current_mode^^}${NC}"
        echo
        
        echo -e "${WHITE}   Press ${BRED}[m]${WHITE} → Switch to Monitor Mode${NC}"
        echo -e "${WHITE}   Press ${BGREEN}[n]${WHITE} → Switch to Managed Mode${NC}"
        echo -e "${WHITE}   Press ${BYELLOW}[q]${WHITE} → Quit${NC}"
        echo
        
        read -n 1 -s -p "$(echo -e "${BPURPLE}   Your choice: ${NC}")" key
        echo
        case "$key" in
            m|M)
                if [[ "$current_mode" == "monitor" ]]; then
                    print_warning "Already in monitor mode!"
                    sleep 1
                    continue
                fi
                
                if check_network_connection "$INTERFACE"; then
                    local ssid=$(get_current_ssid "$INTERFACE")
                    print_warning "You are connected to Wi-Fi SSID '${BGREEN}$ssid${BYELLOW}'"
                    print_warning "Switching to monitor mode will disconnect you"
                    read -p "$(echo -e "${BPURPLE}   Continue?${NC} ${WHITE}[${RED}y${WHITE}/${BGREEN}N${WHITE}]${NC}: ")" confirm
                    case "$confirm" in
                        y|Y)
                            kill_interfering_processes
                            if set_monitor_mode; then
                                print_status "Quick toggle: Monitor mode activated"
                                echo
                            fi
                            ;;
                        *)
                            print_info "Monitor mode switch cancelled"
                            echo
                            ;;
                    esac
                else
                    kill_interfering_processes
                    if set_monitor_mode; then
                        print_status "Quick toggle: Monitor mode activated"
                        echo
                    fi
                fi
                ;;
            n|N)
                if [[ "$current_mode" == "managed" ]]; then
                    print_warning "Already in managed mode!"
                    sleep 1
                    continue
                fi
                
                if set_managed_mode; then
                    print_status "Quick toggle: Managed mode activated"
                    echo
                fi
                ;;
            q|Q)
                print_info "Exiting quick mode..."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Use m/n/q"
                sleep 1
                ;;
        esac
    done
}

# Cleanup function
cleanup() {
    echo
    echo -e "${BRED}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BRED}║${NC} ${WHITE}Cleaning up and restoring interface...${NC}     ${BRED}║${NC}"
    echo -e "${BRED}╚══════════════════════════════════════════════╝${NC}"
    set_managed_mode
    echo -e "${BGREEN}   Thanks for using AMIGO CYBER! Stay safe out there.${NC}"
    exit 0
}

# Trap signals
trap cleanup SIGINT SIGTERM

# Get wireless interface
INTERFACE=$(get_wireless_interface)

# Check if interface selection was successful
if [[ $? -ne 0 || -z "$INTERFACE" ]]; then
    print_error "No interface selected!"
    exit 1
fi

print_status "Target interface: ${BGREEN}$INTERFACE${NC}"

# Check if interface exists
if ! ip link show "$INTERFACE" &>/dev/null; then
    print_error "Interface $INTERFACE not found!"
    echo -e "${GRAY}   Run 'ip link' to see available interfaces${NC}"
    exit 1
fi

# Check current mode
CURRENT_MODE=$(iw dev "$INTERFACE" info 2>/dev/null | grep -i type | awk '{print $2}')

if [[ -z "$CURRENT_MODE" ]]; then
    print_error "Could not determine current interface mode"
    exit 1
fi

print_info "Current mode: ${BYELLOW}${CURRENT_MODE^^}${NC}"
echo

# Main menu
echo -e "${BCYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BCYAN}║${NC} ${WHITE}Choose Operation Mode${NC}                      ${BCYAN}║${NC}"
echo -e "${BCYAN}╚══════════════════════════════════════════════╝${NC}"
echo -e "${WHITE}   [${BRED}1${WHITE}] Standard Mode (guided setup)${NC}"
echo -e "${WHITE}   [${BGREEN}2${WHITE}] Quick Toggle Mode (m/n keys)${NC}"
echo -e "${WHITE}   [${BYELLOW}3${WHITE}] Recovery Mode (fix interface issues)${NC}"
echo -e "${WHITE}   [${BBLUE}4${WHITE}] Exit${NC}"
echo

read -p "$(echo -e "${BPURPLE}   Choice${NC} ${WHITE}[${BPURPLE}1-4${WHITE}]${NC}: ")" mode_choice

case "$mode_choice" in
    2)
        quick_mode_toggle
        # This never returns, it loops forever or exits
        ;;
    3)
        interface_recovery_mode
        # After recovery, show menu again
        exec "$0"
        ;;
    4)
        print_info "Exiting..."
        exit 0
        ;;
    1|*)
        # Standard mode continues below
        ;;
esac

# Handle current state (Standard Mode)
if [[ "$CURRENT_MODE" == "monitor" ]]; then
    print_question "Interface is already in monitor mode. Switch back to managed mode?"
    read -p "$(echo -e "${BPURPLE}   Choice${NC} ${WHITE}[${BGREEN}y${WHITE}/${RED}N${WHITE}]${NC}: ")" choice
    case "$choice" in
        y|Y ) 
            echo
            if set_managed_mode; then
                print_status "Successfully switched to managed mode"
                exit 0
            else
                print_error "Failed to switch to managed mode"
                exit 1
            fi
            ;;
        * ) 
            print_info "Keeping ${BGREEN}$INTERFACE${CYAN} in monitor mode${NC}"
            print_warning "Press ${BRED}Ctrl+C${BYELLOW} to exit and restore interface${NC}"
            echo
            ;;
    esac
else
    # Check if connected to network before switching
    if check_network_connection "$INTERFACE"; then
        ssid=$(get_current_ssid "$INTERFACE")
        print_warning "You are connected to Wi-Fi SSID '${BGREEN}$ssid${BYELLOW}'"
        print_warning "Switching to monitor mode will disconnect you"
        read -p "$(echo -e "${BPURPLE}   Continue?${NC} ${WHITE}[${RED}y${WHITE}/${BGREEN}N${WHITE}]${NC}: ")" choice
        case "$choice" in
            y|Y)
                # Continue with monitor mode setup
                ;;
            *)
                print_info "Monitor mode switch cancelled"
                exit 0
                ;;
        esac
    fi
    
    # Kill interfering processes before switching to monitor mode
    kill_interfering_processes
    
    if set_monitor_mode; then
        print_status "Successfully switched to monitor mode"
    else
        print_error "Failed to switch to monitor mode"
        restore_network_manager
        exit 1
    fi
fi

# Keep script running if in monitor mode
if [[ "$CURRENT_MODE" == "monitor" ]] || iw dev "$INTERFACE" info 2>/dev/null | grep -q "type monitor"; then
    echo -e "${BCYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BCYAN}║${NC} ${WHITE}Monitor mode active - Press ${BRED}Ctrl+C${WHITE} to exit${NC}    ${BCYAN}║${NC}"
    echo -e "${BCYAN}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${GRAY}   Interface ready for wireless analysis${NC}"
    echo
    while true; do
        sleep 1
    done
fi
