# 🩸 AMIGO CYBER - Airmonitor

<div align="center">

```
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
```

**Advanced Wireless Monitor Mode Switcher for Linux**

[![License](https://img.shields.io/badge/license-MIT-red.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-blue.svg)](https://www.linux.org/)
[![Bash](https://img.shields.io/badge/bash-5.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Overview

**AMIGO CYBER Airmonitor** is a professional-grade wireless interface management tool designed for penetration testers, security researchers, and network administrators. It provides an intuitive interface for switching wireless adapters between monitor and managed modes with intelligent interface detection, network awareness, and advanced recovery capabilities.

### 🎯 Key Highlights

- **🔄 Smart Interface Management** - Automatic wireless adapter detection with preference memory
- **🌐 Network-Aware Operations** - Detects active connections before mode switching
- **⚡ Quick Toggle Mode** - Lightning-fast switching with single keystrokes (m/n/q)
- **🛡️ Interface Recovery** - Nuclear cleanup for corrupted adapters (fixes Fluxion/WEF/Linset aftermath)
- **🎨 Professional UI** - Bloody-style ASCII art with color-coded status indicators
- **💾 Persistent Configuration** - Remembers your preferences between sessions
- **📦 Universal Compatibility** - Works across all major Linux distributions

---

## ✨ Features

### Core Functionality

#### 🔧 Standard Mode
- **Guided Setup**: Step-by-step interface configuration
- **Connection Detection**: Warns before disconnecting from networks
- **SSID Display**: Shows current network name before switching
- **Process Management**: Automatically handles NetworkManager conflicts
- **Safety Checks**: Multiple confirmation prompts for destructive operations

#### ⚡ Quick Toggle Mode
- **Single-Key Controls**:
  - `m` → Switch to Monitor Mode
  - `n` → Switch to Managed Mode
  - `q` → Quit Application
- **Real-Time Status**: Current mode displayed at each iteration
- **Instant Feedback**: Color-coded success/failure indicators
- **No Restart Required**: Keep toggling without relaunching

#### 🩹 Recovery Mode
Fixes interfaces corrupted by penetration testing tools:
- **Virtual Interface Cleanup** - Removes orphaned `mon0`, `wlan0mon` interfaces
- **Process Termination** - Force-kills zombie wpa_supplicant/dhclient
- **Rename Detection** - Restores `wlp2s0mon` → `wlp2s0`
- **Nuclear Reset** - Complete wireless subsystem restoration
- **Service Recovery** - Automatic NetworkManager restart

### Advanced Features

- **Multi-Interface Support**: Handles systems with multiple wireless adapters
- **Preference System**: Stores last-used interface and mode
- **Error Handling**: Robust failure recovery with detailed error messages
- **Verbose Logging**: Debug mode for troubleshooting
- **Man Page**: Complete documentation (`man airmonitor`)

---

## 🚀 Installation

### Global Installation (Recommended)

Install system-wide for the `sudo airmonitor` command:

```bash
# Clone the repository
git clone https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-.git
cd ALL-free-LINUX-tools-/airmonitor

# Run the installer
sudo ./install.sh
```

The installer will:
- ✅ Auto-detect your Linux distribution
- ✅ Install required dependencies (iw, wireless-tools, iproute2)
- ✅ Copy airmonitor to `/usr/local/bin/`
- ✅ Create man page documentation
- ✅ Verify installation

### Manual Installation

```bash
# Make executable
chmod +x airmonitor.sh

# Run directly
sudo ./airmonitor.sh
```

### Supported Distributions

| Distribution | Package Manager | Status |
|-------------|----------------|--------|
| Arch Linux / Manjaro | pacman | ✅ Fully Supported |
| Debian / Ubuntu | apt | ✅ Fully Supported |
| Kali Linux | apt | ✅ Fully Supported |
| Parrot OS | apt | ✅ Fully Supported |
| Fedora / RHEL | dnf | ✅ Fully Supported |
| openSUSE | zypper | ✅ Fully Supported |

---

## 📖 Usage

### Quick Start

```bash
# Global installation
sudo airmonitor

# Direct execution
sudo ./airmonitor.sh
```

### Usage Examples

#### Standard Mode (Guided Setup)
```bash
$ sudo airmonitor
# Follow on-screen prompts
# Select interface → Confirm network disconnect → Switch mode
```

#### Quick Toggle Mode
```bash
$ sudo airmonitor
# Choose option [2] Quick Toggle Mode
# Press 'm' for monitor, 'n' for managed, 'q' to quit
```

#### Recovery Mode
```bash
$ sudo airmonitor
# Choose option [3] Recovery Mode
# Automatically detects and fixes interface issues
```

### Command Options

Once launched, airmonitor presents an interactive menu:

```
╔══════════════════════════════════════════════╗
║ Choose Operation Mode                      ║
╚══════════════════════════════════════════════╝
   [1] Standard Mode (guided setup)
   [2] Quick Toggle Mode (m/n keys)
   [3] Recovery Mode (fix interface issues)
   [4] Exit
```

---

## 🛠️ Requirements

### System Requirements

- **OS**: Linux-based distribution (kernel 3.10+)
- **Shell**: Bash 4.0 or higher
- **Privileges**: Root access (sudo)
- **Hardware**: Wireless adapter with monitor mode support

### Software Dependencies

Automatically installed by `install.sh`:

| Package | Purpose | Required |
|---------|---------|----------|
| `iw` | Modern wireless configuration | ✅ Yes |
| `wireless-tools` | Legacy wireless support (iwconfig) | ✅ Yes |
| `iproute2` | Network interface management | ✅ Yes |
| `systemd` | Service management | ✅ Yes |
| `NetworkManager` | Network connection handling | ⚠️ Optional |

### Hardware Compatibility

**Supported Chipsets** (Monitor Mode):
- Atheros (ath9k, ath10k)
- Ralink (rt2800usb, rt2870)
- Realtek (rtl8812au, rtl8188eus)
- Intel (iwlwifi - limited support)
- Broadcom (with proper drivers)

**Check Your Adapter**:
```bash
# Check if monitor mode is supported
iw list | grep -A 10 "Supported interface modes" | grep monitor
```

---

## 📚 Documentation

### Configuration Files

- **User Config**: `~/.amigo_monitor_config`
  - Stores preferred interface
  - Saves last mode used
  - Tracks usage timestamp

### Man Page

After installation, access full documentation:

```bash
man airmonitor
```

### Troubleshooting

#### Interface Not Detected
```bash
# Check wireless interfaces
ip link show
iw dev

# Restart wireless service
sudo systemctl restart NetworkManager
```

#### Mode Switch Fails
```bash
# Use Recovery Mode (option 3)
# Or manually reset:
sudo systemctl stop NetworkManager
sudo ip link set wlp2s0 down
sudo iw wlp2s0 set type managed
sudo ip link set wlp2s0 up
sudo systemctl start NetworkManager
```

#### Permission Denied
```bash
# Ensure running as root
sudo airmonitor

# Check sudo privileges
sudo -v
```

---

## 🔧 Uninstallation

### Complete Removal

```bash
# Run uninstaller
sudo ./uninstall.sh
```

The uninstaller will:
- Remove `/usr/local/bin/airmonitor`
- Delete man page
- Optionally remove user config files
- Clean up backup files

### Manual Removal

```bash
# Remove executable
sudo rm /usr/local/bin/airmonitor

# Remove man page
sudo rm /usr/local/share/man/man1/airmonitor.1.gz

# Remove config (optional)
rm ~/.amigo_monitor_config
```

---

## 🎬 Demo

### Standard Mode Flow
```
[*] Found wireless interface: wlp2s0
[?] Use this interface? [Y/n]: Y
[+] Target interface: wlp2s0
[*] Current mode: MANAGED

[!] You are connected to Wi-Fi SSID 'MyNetwork'
[!] Switching to monitor mode will disconnect you
   Continue? [y/N]: y

[*] Scanning for interfering processes...
[!] Stopping NetworkManager...
[*] Switching wlp2s0 to monitor mode...
[+] wlp2s0 is now in MONITOR mode
```

### Quick Toggle Mode
```
╔══════════════════════════════════════════════╗
║ Quick Mode Toggle                         ║
╚══════════════════════════════════════════════╝
[*] Current mode: MANAGED

   Press [m] → Switch to Monitor Mode
   Press [n] → Switch to Managed Mode
   Press [q] → Quit

   Your choice: m

[*] Switching wlp2s0 to monitor mode...
[+] wlp2s0 is now in MONITOR mode
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Reporting Issues

Found a bug? [Open an issue](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-/issues) with:
- Your Linux distribution and version
- Wireless adapter model
- Complete error output
- Steps to reproduce

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow existing code style (bash best practices)
- Add comments for complex logic
- Test on multiple distributions
- Update documentation as needed

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 amigo-d-cyber

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## ⚠️ Disclaimer

**FOR EDUCATIONAL AND AUTHORIZED SECURITY TESTING ONLY**

This tool is designed for:
- ✅ Penetration testing on networks you own or have written permission to test
- ✅ Security research in controlled lab environments
- ✅ Network administration on your own infrastructure
- ✅ Educational purposes in cybersecurity training

**Illegal Use is Prohibited:**
- ❌ Unauthorized network access
- ❌ Attacking networks without permission
- ❌ Any activity violating local/international laws

**The author assumes NO LIABILITY for misuse. Users are solely responsible for ensuring their actions comply with applicable laws.**

---

## 👨‍💻 Author

**amigo-d-cyber**

- GitHub: [@amigo-d-cyber](https://github.com/amigo-d-cyber)
- Repository: [ALL-free-LINUX-tools-](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-)

---

## 🌟 Acknowledgments

- Inspired by classic wireless security tools
- Built with the Linux security community in mind
- Thanks to all contributors and testers

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-/issues)
- **Discussions**: [GitHub Discussions](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-/discussions)
- **Documentation**: `man airmonitor` (after installation)

---

<div align="center">

**Stay bloody, stay sharp! 🩸⚡**

Made with ❤️ by the underground

[![GitHub Stars](https://img.shields.io/github/stars/amigo-d-cyber/ALL-free-LINUX-tools-?style=social)](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-)
[![GitHub Forks](https://img.shields.io/github/forks/amigo-d-cyber/ALL-free-LINUX-tools-?style=social)](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-)

</div>
