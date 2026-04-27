#!/bin/bash

# Get laptop information script
# Displays comprehensive system information

echo "=== LAPTOP INFORMATION ==="
echo ""

# User Information
echo "👤 USER INFORMATION"
echo "  Username: $(whoami)"
echo "  User ID: $(id -u)"
echo "  Home Directory: $HOME"
echo ""

# System Information
echo "💻 SYSTEM INFORMATION"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  OS: macOS"
    echo "  OS Version: $(sw_vers -productVersion)"
    echo "  Build Version: $(sw_vers -buildVersion)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "  OS: Linux"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "  Distro: $PRETTY_NAME"
    fi
    echo "  Kernel: $(uname -r)"
else
    echo "  OS: $(uname -s)"
    echo "  Release: $(uname -r)"
fi
echo "  Hostname: $(hostname)"
echo "  Machine Type: $(uname -m)"
echo ""

# Hardware Information
echo "⚙️  HARDWARE INFORMATION"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  CPU Model: $(sysctl -n machdep.cpu.brand_string)"
    echo "  CPU Cores: $(sysctl -n hw.ncpu)"
    memory_bytes=$(sysctl -n hw.memsize)
    memory_gb=$((memory_bytes / 1024 / 1024 / 1024))
    echo "  Total Memory: ${memory_gb}GB"
else
    if [ -f /proc/cpuinfo ]; then
        cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
        echo "  CPU Model: $cpu_model"
        cpu_cores=$(nproc)
        echo "  CPU Cores: $cpu_cores"
    fi
    if [ -f /proc/meminfo ]; then
        memory_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        memory_gb=$((memory_kb / 1024 / 1024))
        echo "  Total Memory: ${memory_gb}GB"
    fi
fi
echo ""

# Disk Information
echo "💾 DISK INFORMATION"
df -h / | awk 'NR==2 {print "  Total Disk: " $2; print "  Used Disk: " $3; print "  Available Disk: " $4; print "  Usage: " $5}'
echo ""

# Network Information
echo "🌐 NETWORK INFORMATION"
if [[ "$OSTYPE" == "darwin"* ]]; then
    local_ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')
    echo "  Local IP: ${local_ip:-N/A}"
else
    local_ip=$(hostname -I | awk '{print $1}')
    echo "  Local IP: ${local_ip:-N/A}"
fi

# Try to get public IP (with timeout)
public_ip=$(timeout 2 curl -s https://api.ipify.org 2>/dev/null || echo "N/A")
echo "  Public IP: $public_ip"
echo ""

# System Status
echo "📊 SYSTEM STATUS"
uptime_output=$(uptime | sed 's/.*up \([^,]*\).*/\1/')
echo "  Uptime: $uptime_output"
if [[ "$OSTYPE" == "darwin"* ]]; then
    load=$(sysctl -n vm.loadavg | awk '{print $2, $3, $4}')
else
    load=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
fi
echo "  Load Average: $load"
echo ""

echo "=== END OF REPORT ==="
