#!/bin/bash

# Nexus Network Prover - STABLE Installation Script
# Made by OveR (@Over9725) - Version 2.4 STABLE
# Based on working version with balanced performance

set -euo pipefail

# Colors & Constants
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'; NC='\033[0m'
OFFICIAL_INSTALLER="https://cli.nexus.xyz/"

# Logging
log() { echo -e "${2:-$GREEN}[$(date +'%H:%M:%S')] $1${NC}"; }
error() { log "$1" "$RED" && exit 1; }
warn() { log "$1" "$YELLOW"; }
info() { log "$1" "$CYAN"; }

# Banner
show_banner() {
clear
echo -e "${PURPLE}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗                 ║
║  ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝                 ║
║  ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗                 ║
║  ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║                 ║
║  ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║                 ║
║  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝                 ║
║                                                               ║
║        🚀 NETWORK PROVER AUTO-INSTALLER 🚀                   ║
║              Made by OveR (@Over9725)                         ║
║             💰 Farm NEX Points Optimally 💰                   ║
║              Version 2.4 STABLE - BALANCED PERFORMANCE       ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
log "🎯 Installing optimized Nexus Network Prover for NEX Points farming"
log "⚡ Version 2.4 STABLE - Balanced performance (70-80% CPU target, bot-friendly)"
echo ""
}

# Main function
main() {
    show_banner
    
    # Setup user environment
    if [ "$EUID" -eq 0 ]; then
        warn "⚠️  Running as root (VPS mode)"
        id "nexus" &>/dev/null || useradd -m -s /bin/bash nexus
        NEXUS_USER="nexus"; NEXUS_HOME="/home/nexus"
    else
        sudo -n true 2>/dev/null || error "❌ Need sudo privileges"
        NEXUS_USER="$USER"; NEXUS_HOME="$HOME"
    fi
    
    # Clean old installations
    log "🧹 Setting up system environment..."
    pkill -f nexus-network 2>/dev/null || true
    screen -S nexus -X quit 2>/dev/null || true
    sleep 2
    
    # Remove old binaries
    sudo rm -f /usr/local/bin/nexus-network /usr/local/bin/nexus-* 2>/dev/null || true
    rm -rf "$NEXUS_HOME/.nexus" 2>/dev/null || true
    
    # Test connectivity
    ping -c 1 8.8.8.8 >/dev/null 2>&1 || error "❌ No internet connection"
    
    # System specs
    CPU_CORES=$(nproc)
    RAM_TOTAL_GB=$(($(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024))
    [ "$CPU_CORES" -lt 2 ] && error "❌ Need at least 2 CPU cores"
    [ "$RAM_TOTAL_GB" -lt 4 ] && error "❌ Need at least 4GB RAM"
    
    # Performance tier
    if [ "$CPU_CORES" -ge 16 ] && [ "$RAM_TOTAL_GB" -ge 32 ]; then
        TIER="HIGH_END"; TIER_EMOJI="🔥"; EXPECTED_HZ="1000+"
    elif [ "$CPU_CORES" -ge 8 ] && [ "$RAM_TOTAL_GB" -ge 16 ]; then
        TIER="PERFORMANCE"; TIER_EMOJI="⚡"; EXPECTED_HZ="500-1000"
    elif [ "$CPU_CORES" -ge 4 ] && [ "$RAM_TOTAL_GB" -ge 8 ]; then
        TIER="STANDARD"; TIER_EMOJI="🚀"; EXPECTED_HZ="100-500"
    else
        TIER="BASIC"; TIER_EMOJI="💻"; EXPECTED_HZ="50-100"
    fi
    
    log "   🖥️  CPU: $CPU_CORES cores, RAM: ${RAM_TOTAL_GB}GB"
    log "   $TIER_EMOJI Server Tier: $TIER (Expected: ${EXPECTED_HZ} Hz)"
    
    # Node ID input
    log "🔑 Node ID Configuration Required"
    info "📋 Get your Node ID from: ${BLUE}https://beta.nexus.xyz/${NC} → Add Node → CLI Node"
    
    for attempt in {1..3}; do
        printf "Enter your Node ID: "
        read -r NODE_ID < /dev/tty
        
        if [ -n "$NODE_ID" ] && ! echo "$NODE_ID" | grep -q '[{}()[]"\\.]'; then
            log "   ✅ Node ID validated: $NODE_ID"
            break
        fi
        warn "   ❌ Invalid Node ID format! (Attempt $attempt/3)"
        [ $attempt -eq 3 ] && error "❌ Too many invalid attempts"
    done
    
    # Install dependencies
    log "📦 Installing dependencies and Rust..."
    if command -v apt-get >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get update -y >/dev/null && sudo apt-get install -y curl git build-essential pkg-config libssl-dev protobuf-compiler screen bc >/dev/null
    elif command -v yum >/dev/null 2>&1; then
        sudo yum groupinstall -y "Development Tools" >/dev/null && sudo yum install -y curl git openssl-devel protobuf-devel screen bc >/dev/null
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall -y "Development Tools" >/dev/null && sudo dnf install -y curl git openssl-devel protobuf-devel screen bc >/dev/null
    else
        error "❌ Unsupported OS"
    fi
    
    # Install Rust for nexus user if root
    if [ "$EUID" -eq 0 ]; then
        su - nexus -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >/dev/null 2>&1' || true
    else
        if ! command -v rustc >/dev/null 2>&1; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >/dev/null && source ~/.cargo/env
        fi
    fi
    log "   ✅ Dependencies and Rust installed"
    
    # Install Nexus
    log "🚀 Installing latest Nexus Network..."
    
    # Try official installer
    NEXUS_BINARY=""
    if [ "$EUID" -eq 0 ]; then
        if su - nexus -c "export NONINTERACTIVE=1; curl -sSf $OFFICIAL_INSTALLER | sh -s -- --force" 2>/dev/null; then
            # Find binary in common locations
            for loc in "/home/nexus/.nexus/bin/nexus-network" "/home/nexus/.cargo/bin/nexus-network" "/home/nexus/.local/bin/nexus-network"; do
                [ -f "$loc" ] && NEXUS_BINARY="$loc" && break
            done
        fi
    else
        if curl -sSf "$OFFICIAL_INSTALLER" | sh -s -- --force 2>/dev/null; then
            source ~/.cargo/env 2>/dev/null || export PATH="$HOME/.cargo/bin:$PATH"
            for loc in "$HOME/.nexus/bin/nexus-network" "$HOME/.cargo/bin/nexus-network" "$HOME/.local/bin/nexus-network"; do
                [ -f "$loc" ] && NEXUS_BINARY="$loc" && break
            done
        fi
    fi
    
    [ -z "$NEXUS_BINARY" ] && error "❌ Failed to install Nexus binary"
    
    # Install to system
    sudo cp "$NEXUS_BINARY" /usr/local/bin/nexus-network && sudo chmod +x /usr/local/bin/nexus-network
    
    local version=$(/usr/local/bin/nexus-network --version 2>/dev/null || echo "unknown")
    log "   ✅ Nexus installed: $version"
    
    # Apply optimizations
    log "⚡ Applying balanced performance optimizations..."
    [ -d "/sys/devices/system/cpu/cpu0/cpufreq" ] && echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1
    log "   ✅ Balanced optimizations applied"
    
    # Create simple config and scripts
    log "🔧 Creating configuration and services..."
    
    # Config
    mkdir -p "$NEXUS_HOME/.nexus"
    echo "{\"node_id\": \"$NODE_ID\"}" > "$NEXUS_HOME/.nexus/config.json"
    chmod 600 "$NEXUS_HOME/.nexus/config.json"
    chown -R $NEXUS_USER:$NEXUS_USER "$NEXUS_HOME/.nexus" 2>/dev/null || true
    
    # Create start script
    cat > /usr/local/bin/nexus-start << EOF
#!/bin/bash
screen -S nexus -X quit 2>/dev/null; sleep 2
CORES=\$(nproc); NEXUS_CORES=\$((CORES * 3 / 4)); CORE_LIST="0-\$((NEXUS_CORES-1))"
export RUST_LOG=info RAYON_NUM_THREADS=\$NEXUS_CORES
screen -dmS nexus bash -c "nice -n -10 taskset -c \$CORE_LIST sudo -u nexus /usr/local/bin/nexus-network start --node-id $NODE_ID"
sleep 3
if pgrep -f "nexus-network start" >/dev/null; then
    echo "⚡ Nexus started in BALANCED mode (cores: \$CORE_LIST)"
    echo "📊 View logs: screen -r nexus | Status: nexus-status"
else
    echo "❌ Failed to start"
fi
EOF
    
    # Create status script
    cat > /usr/local/bin/nexus-status << 'EOF'
#!/bin/bash
echo "⚡ NEXUS BALANCED STATUS"
if screen -list | grep -q "nexus"; then
    PID=$(pgrep -f "nexus-network start" | head -1)
    if [ -n "$PID" ]; then
        CPU=$(ps -p $PID -o %cpu --no-headers 2>/dev/null | tr -d ' ')
        echo "✅ Running - CPU: ${CPU}% | PID: $PID"
        echo "📊 View logs: screen -r nexus"
    else
        echo "❌ Screen exists but process not found"
    fi
else
    echo "❌ Not running - Start with: nexus-start"
fi
EOF
    
    # Create stop script
    cat > /usr/local/bin/nexus-stop << 'EOF'
#!/bin/bash
screen -S nexus -X quit 2>/dev/null && echo "✅ Stopped" || echo "ℹ️ Not running"
EOF
    
    # Create monitor script
    cat > /usr/local/bin/nexus-monitor << 'EOF'
#!/bin/bash
echo "⚡ PERFORMANCE MONITOR (Ctrl+C to exit)"
while true; do
    PID=$(pgrep -f "nexus-network start" | head -1)
    if [ -n "$PID" ]; then
        CPU=$(ps -p $PID -o %cpu --no-headers 2>/dev/null | tr -d ' ')
        printf "\r$(date +%H:%M:%S) | CPU: ${CPU}% | Status: Running          "
    else
        printf "\r$(date +%H:%M:%S) | Status: Not running                  "
    fi
    sleep 3
done
EOF
    
    # Make executable
    sudo chmod +x /usr/local/bin/nexus-start /usr/local/bin/nexus-stop /usr/local/bin/nexus-status /usr/local/bin/nexus-monitor
    
    log "   ✅ Services configured"
    
    # Start prover
    log "🚀 Starting Nexus prover..."
    /usr/local/bin/nexus-start
    
    # Success message
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 NEXUS NETWORK PROVER INSTALLATION COMPLETED! 🎉   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log "📝 Made by OveR (@Over9725) - Version 2.4 STABLE"
    log "$TIER_EMOJI Server Tier: $TIER | Node ID: $NODE_ID"
    log "📦 Version: $version | ⚡ Mode: BALANCED (70-80% CPU, bot-friendly)"
    echo ""
    echo -e "${YELLOW}🚀 Management Commands:${NC}"
    echo -e "   ${BLUE}nexus-start${NC} | ${BLUE}nexus-stop${NC} | ${BLUE}nexus-status${NC} | ${BLUE}nexus-monitor${NC}"
    echo -e "   ${BLUE}screen -r nexus${NC} (view logs, Ctrl+A+D to detach)"
    echo ""
    echo -e "${CYAN}🔗 Dashboard: ${BLUE}https://beta.nexus.xyz/${NC}"
    echo -e "${GREEN}⚡ BALANCED MODE: 70-80% CPU target, reserves 25% for bots/other tasks${NC}"
    echo -e "${PURPLE}Follow @Over9725 for more crypto optimizations!${NC}"
    echo ""
}

# Error handling
cleanup_on_error() {
    echo ""; log "Installation failed. Check errors above." "$RED"
    exit $?
}
trap cleanup_on_error ERR

# Run
main "$@"
