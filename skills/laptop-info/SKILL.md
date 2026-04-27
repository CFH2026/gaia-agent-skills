---
name: laptop-info
description: Get current laptop information including username, machine details, OS, and hardware specs
version: 1.0.0
---

# Laptop Information Skill

This skill retrieves detailed information about the current machine, including:
- Current username
- Machine hostname
- Operating system and version
- Hardware specifications (CPU, memory, disk)
- System uptime
- Network information

## Usage

When invoked, this skill will gather and display comprehensive laptop information using the provided shell script.

## Implementation

The skill uses a shell script (`get_laptop_info.sh`) to collect system information from various system commands. It's compatible with macOS, Linux, and other Unix-like systems.

## Output

The skill returns a structured summary of:
1. **User Information:** Current logged-in user and home directory
2. **System Information:** Hostname, OS name, and version
3. **Hardware Details:** CPU information, total RAM, disk usage
4. **Network Information:** IP addresses (local and public)
5. **System Status:** Uptime and load average
