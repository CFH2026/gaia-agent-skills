# Laptop Info Skill

A comprehensive skill to retrieve detailed information about the current laptop/machine.

## Features

This skill provides:
- **User Information:** Current username, user ID, and home directory
- **System Information:** OS type, version, hostname, and machine architecture
- **Hardware Details:** CPU model, number of cores, and total RAM
- **Disk Information:** Total, used, and available disk space
- **Network Information:** Local IP and public IP addresses
- **System Status:** System uptime and load average

## Files

- `SKILL.md` - Skill metadata and description
- `get_laptop_info.sh` - Shell script implementation
- `README.md` - This file

## Supported Platforms

- macOS
- Linux (various distributions)
- Any Unix-like system with standard utilities

## Requirements

The script uses standard system commands available on all Unix systems:
- `whoami`, `id`, `hostname` - User and system info
- `sysctl` (macOS) or `/proc` (Linux) - Hardware details
- `df` - Disk information
- `ifconfig` or `hostname -I` - Network configuration
- `uptime`, `curl` (optional for public IP) - System status

## Usage

```bash
/get_laptop_info.sh
```

Or invoke via the gaia-agent-skills framework:
```bash
/laptop-info
```

## Sample Output

```
=== LAPTOP INFORMATION ===

👤 USER INFORMATION
  Username: carlson
  User ID: 501
  Home Directory: /Users/carlson

💻 SYSTEM INFORMATION
  OS: macOS
  OS Version: 26.4.1
  Hostname: Carlsons-MacBook-Air.local
  Machine Type: arm64

... and more
```

## Notes

- The public IP lookup requires internet connectivity and uses `ipify.org` API with a 2-second timeout
- All information is collected locally without external dependencies (except public IP)
- The script is read-only and doesn't modify any system settings
