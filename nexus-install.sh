#!/bin/bash

# Nexus Network Prover - Optimized Installation Script
# Made by OveR (@Over9725) - Version 2.4 OPTIMIZED - BALANCED PERFORMANCE

set -euo pipefail

# Colors & Constants
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'; NC='\033[0m'
OFFICIAL_INSTALLER="https://cli.nexus.xyz/"
REPO_URL="https://github.com/nexus-xyz/network-api.git"

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
║              Version 2.4 - BALANCED PERFORMANCE              ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
log "🎯 Installing optimized Nexus Network Prover for NEX Points farming"
log "⚡ Version 2.4 - Balanced performance (70-80% CPU target, bot-friendly)"
echo ""
}

# Cleanup, network setup, and system detection combined
setup_system() {
    log "🧹 Setting up system environment..."
    
    # Stop processes and cleanup
    pkill -f nexus-network 2>/dev/null || true
    screen -S nexus -X quit 2>/dev/null || true
    sleep 2
    
    # Remove old binaries from all locations
    local locations=("/usr/local/bin/nexus-network" "/usr/bin/nexus-network" "$NEXUS_HOME/.nexus/nexus-cli" "$NEXUS_HOME/.cargo/bin/nexus-network" "$HOME/.nexus" "$HOME/.cargo/bin/nexus-network")
    for loc in "${locations[@]}"; do
        sudo rm -rf "$loc" 2>/dev/null || rm -rf "$loc" 2>/dev/null || true
    done
    
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
}

# Node ID validation and input
get_node_id() {
    log "🔑 Node ID Configuration Required"
    info "📋 Get your Node ID from: ${BLUE}https://beta.nexus.xyz/${NC} → Add Node → CLI Node"
    
    for attempt in {1..3}; do
        printf "Enter your Node ID: "
        read -r NODE_ID < /dev/tty
        
        if [ -n "$NODE_ID" ] && ! echo "$NODE_ID" | grep -q '[{}()[]"\\.]'; then
            log "   ✅ Node ID validated: $NODE_ID"
            return 0
        fi
        warn "   ❌ Invalid Node ID format! (Attempt $attempt/3)"
    done
    error "❌ Too many invalid attempts"
}

# Dependencies and Rust installation
install_dependencies() {
    log "📦 Installing dependencies and Rust..."
    
    # Install system dependencies
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
    
    # Install Rust
    if [ "$EUID" -eq 0 ]; then
        su - nexus -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >/dev/null 2>&1' || true
    else
        if ! command -v rustc >/dev/null 2>&1; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >/dev/null && source ~/.cargo/env
        fi
    fi
    
    log "   ✅ Dependencies and Rust installed"
}

# Nexus installation (official installer or build from source)
install_nexus() {
    log "🚀 Installing latest Nexus Network..."
    
    # Try official installer first
    if curl -s --head "$OFFICIAL_INSTALLER" >/dev/null 2>&1; then
        if [ "$EUID" -eq 0 ]; then
            if su - nexus -c "export NONINTERACTIVE=1; curl -sSf $OFFICIAL_INSTALLER | sh -s -- --force" 2>/dev/null; then
                # Check multiple possible locations after official install
                for loc in "/home/nexus/.nexus/bin/nexus-network" "/home/nexus/.cargo/bin/nexus-network" "/home/nexus/.local/bin/nexus-network"; do
                    if [ -f "$loc" ]; then
                        NEXUS_BINARY="$loc"
                        break
                    fi
                done
            fi
        else
            if curl -sSf "$OFFICIAL_INSTALLER" | sh -s -- --force 2>/dev/null; then
                source ~/.cargo/env 2>/dev/null || export PATH="$HOME/.cargo/bin:$PATH"
                for loc in "$HOME/.nexus/bin/nexus-network" "$HOME/.cargo/bin/nexus-network" "$HOME/.local/bin/nexus-network"; do
                    if [ -f "$loc" ]; then
                        NEXUS_BINARY="$loc"
                        break
                    fi
                done
            fi
        fi
    fi
    
    # Only build from source if official installer completely failed
    if [ -z "${NEXUS_BINARY:-}" ] || [ ! -f "${NEXUS_BINARY:-}" ]; then
        log "   🔨 Official installer failed, building from source..."
        local repo_dir="$NEXUS_HOME/.nexus/network-api"
        rm -rf "$repo_dir" && mkdir -p "$NEXUS_HOME/.nexus"
        git clone --depth 1 "$REPO_URL" "$repo_dir" >/dev/null 2>&1 || error "❌ Failed to clone repository"
        
        cd "$repo_dir/clients/cli"
        if [ "$EUID" -eq 0 ]; then
            chown -R nexus:nexus "$repo_dir"
            su - nexus -c "cd $repo_dir/clients/cli && source ~/.cargo/env && cargo build --release" >/dev/null 2>&1 || error "❌ Build failed"
        else
            cargo build --release >/dev/null 2>&1 || error "❌ Build failed"
        fi
        NEXUS_BINARY="$repo_dir/clients/cli/target/release/nexus-network"
    else
        log "   ✅ Official installer succeeded"
    fi
    
    # Install to system path
    sudo cp "$NEXUS_BINARY" /usr/local/bin/nexus-network && sudo chmod +x /usr/local/bin/nexus-network
    NEXUS_BINARY="/usr/local/bin/nexus-network"
    
    # Verify version
    local version=$($NEXUS_BINARY --version 2>/dev/null || echo "unknown")
    log "   ✅ Nexus installed: $version"
}

# Apply balanced optimizations
apply_optimizations() {
    log "⚡ Applying balanced performance optimizations..."
    
    # CPU performance mode
    [ -d "/sys/devices/system/cpu/cpu0/cpufreq" ] && echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1
    
    # System limits
    cat << EOF | sudo tee -a /etc/security/limits.conf >/dev/null
nexus soft nofile 65536
nexus hard nofile 65536
nexus soft nproc 32768
nexus hard nproc 32768
EOF
    
    # Kernel optimization
    cat << EOF | sudo tee -a /etc/sysctl.conf >/dev/null
vm.swappiness=10
vm.dirty_ratio=20
vm.dirty_background_ratio=10
net.core.rmem_default=262144
net.core.wmem_default=262144
EOF
    sudo sysctl -p >/dev/null 2>&1
    
    log "   ✅ Balanced optimizations applied"
}

# Create config and management scripts
create_services() {
    log "🔧 Creating configuration and services..."
    
    # Node config
    mkdir -p "$NEXUS_HOME/.nexus"
    echo "{\"node_id\": \"$NODE_ID\"}" > "$NEXUS_HOME/.nexus/config.json"
    chmod 600 "$NEXUS_HOME/.nexus/config.json"
    chown -R $NEXUS_USER:$NEXUS_USER "$NEXUS_HOME/.nexus" 2>/dev/null || true
    
    # Startup script
    sudo tee /usr/local/bin/nexus-start.sh >/dev/null << 'EOF'
#!/bin/bash
screen -S nexus -X quit 2>/dev/null || true; sleep 2
NEXUS_BINARY="/usr/local/bin/nexus-network"
NODE_ID=$(grep "node_id" /home/nexus/.nexus/config.json 2>/dev/null || grep "node_id" $HOME/.nexus/config.json 2>/dev/null | cut -d'"' -f4)
[ -z "$NODE_ID" ] && echo "❌ Config not found" && exit 1
TOTAL_CORES=$(nproc); NEXUS_CORES=$((TOTAL_CORES * 3 / 4)); [ $NEXUS_CORES -lt 1 ] && NEXUS_CORES=1
CORE_LIST="0-$((NEXUS_CORES-1))"
export RUST_LOG=info RAYON_NUM_THREADS=$NEXUS_CORES RUSTFLAGS="-C target-cpu=native -C opt-level=2"
cd /home/nexus 2>/dev/null || cd $HOME
screen -dmS nexus bash -c "exec nice -n -10 taskset -c $CORE_LIST sudo -u nexus $NEXUS_BINARY start --node-id $NODE_ID"
sleep 5
if pgrep -f "nexus-network start" >/dev/null; then
    PID=$(pgrep -f "nexus-network start"); sudo renice -10 $PID 2>/dev/null; sudo taskset -cp $CORE_LIST $PID >/dev/null 2>&1
    echo "⚡ Nexus started in BALANCED mode - Cores: $CORE_LIST (${NEXUS_CORES}/${TOTAL_CORES}), Priority: -10"
    echo "📊 View logs: screen -r nexus | Status: nexus-status | Monitor: nexus-monitor"
else
    echo "❌ Failed to start"; exit 1
fi
EOF
    
    # Status script  
    sudo tee /usr/local/bin/nexus-status.sh >/dev/null << 'EOF'
#!/bin/bash
NEXUS_BINARY="/usr/local/bin/nexus-network"; VERSION=$($NEXUS_BINARY --version 2>/dev/null || echo "unknown")
echo "⚡ NEXUS BALANCED MODE STATUS (Bot-Friendly)"; echo "═══════════════════════════════════════════"
echo "📦 Version: $VERSION"; echo "📍 Binary: $NEXUS_BINARY"; echo ""
if screen -list | grep -q "nexus"; then
    PID=$(pgrep -f "nexus-network start" | head -1)
    if [ -n "$PID" ]; then
        CPU=$(ps -p $PID -o %cpu --no-headers 2>/dev/null | tr -d ' ' || echo "0")
        MEM=$(ps -p $PID -o %mem --no-headers 2>/dev/null | tr -d ' ' || echo "0")
        PRIORITY=$(ps -p $PID -o ni --no-headers 2>/dev/null | tr -d ' ' || echo "0")
        AFFINITY=$(taskset -cp $PID 2>/dev/null | cut -d: -f2 | tr -d ' ' || echo "unknown")
        LOAD=$(cat /proc/loadavg | cut -d' ' -f1); TOTAL_CORES=$(nproc)
        echo "✅ Nexus prover running in BALANCED mode"
        echo "⚡ CPU: ${CPU}% | RAM: ${MEM}% | Priority: $PRIORITY | Load: $LOAD"
        echo "🖥️  CPU Cores: $AFFINITY | PID: $PID"
        if command -v bc >/dev/null 2>&1 && [ -n "$CPU" ]; then
            if (( $(echo "$CPU > 70" | bc -l 2>/dev/null || echo 0) )); then echo "📈 🔥 EXCELLENT - Target achieved!"
            elif (( $(echo "$CPU > 50" | bc -l 2>/dev/null || echo 0) )); then echo "📈 ⚡ GOOD - Moderate utilization"
            else echo "📈 ⚠️  LOW - May need time to ramp up"; fi
        fi
        if [ "$AFFINITY" != "unknown" ]; then
            USED=$(echo $AFFINITY | tr ',' '\n' | wc -l); echo "🤖 Using $USED of $TOTAL_CORES cores ($(($TOTAL_CORES-$USED)) reserved for bots)"
        fi
    else
        echo "❌ Process not found - Try: nexus-stop && nexus-start"
    fi
else
    echo "❌ Not running - Start with: nexus-start"
fi
echo ""; echo "🔧 Commands: nexus-start | nexus-stop | nexus-monitor | screen -r nexus"
echo "💻 System: $(nproc) cores, Load: $(cat /proc/loadavg | cut -d' ' -f1-3), RAM: $(free -h | grep Mem | awk '{print $3"/"$2}')"
EOF
    
    # Monitor script
    sudo tee /usr/local/bin/nexus-monitor.sh >/dev/null << 'EOF'
#!/bin/bash
echo "⚡ NEXUS BALANCED PERFORMANCE MONITOR"; echo "Target: 70-80% CPU (bot-friendly) | Ctrl+C to exit"; echo ""
while true; do
    PID=$(pgrep -f "nexus-network start" | head -1)
    if [ -n "$PID" ]; then
        CPU=$(ps -p $PID -o %cpu --no-headers 2>/dev/null | tr -d ' ' || echo "0")
        MEM=$(ps -p $PID -o %mem --no-headers 2>/dev/null | tr -d ' ' || echo "0")
        LOAD=$(cat /proc/loadavg | cut -d' ' -f1)
        if command -v bc >/dev/null 2>&1 && [ -n "$CPU" ]; then
            if (( $(echo "$CPU > 70" | bc -l 2>/dev/null || echo 0) )); then COLOR="\033[0;32m"; STATUS="🔥 OPTIMAL"
            elif (( $(echo "$CPU > 50" | bc -l 2>/dev/null || echo 0) )); then COLOR="\033[0;33m"; STATUS="⚡ GOOD"
            else COLOR="\033[0;31m"; STATUS="⚠️  LOW"; fi
        else COLOR="\033[0;37m"; STATUS="📊 MONITOR"; fi
        TEMP=""; if command -v sensors >/dev/null 2>&1; then
            TEMP_VAL=$(sensors 2>/dev/null | grep -E "Core|CPU|Tctl" | head -1 | grep -o "+[0-9]*" | head -1 | tr -d '+')
            [ -n "$TEMP_VAL" ] && TEMP=" | Temp: ${TEMP_VAL}°C"
        fi
        printf "\r$(date '+%H:%M:%S') | ${COLOR}CPU: ${CPU}%\033[0m | RAM: ${MEM}% | Load: $LOAD$TEMP | $STATUS          "
    else
        printf "\r$(date '+%H:%M:%S') | ❌ Nexus process not running                                    "
    fi; sleep 3
done
EOF
    
    # Stop script
    sudo tee /usr/local/bin/nexus-stop.sh >/dev/null << 'EOF'
#!/bin/bash
if screen -list | grep -q "nexus"; then screen -S nexus -X quit; echo "✅ Nexus stopped"; else echo "ℹ️  Not running"; fi
EOF
    
    # Make executable and create aliases
    sudo chmod +x /usr/local/bin/nexus-*.sh
    for cmd in start stop status monitor; do sudo ln -sf /usr/local/bin/nexus-${cmd}.sh /usr/local/bin/nexus-${cmd}; done
    
    # Auto-restart cron
    (crontab -l 2>/dev/null | grep -v "nexus-start"; echo "@reboot sleep 60 && /usr/local/bin/nexus-start.sh") | crontab -
    
    log "   ✅ Services configured"
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
    
    # Installation steps
    setup_system
    get_node_id
    install_dependencies
    install_nexus
    apply_optimizations
    create_services
    
    # Start prover
    log "🚀 Starting Nexus prover..."
    /usr/local/bin/nexus-start.sh
    
    # Success message
    local final_version=$(/usr/local/bin/nexus-network --version 2>/dev/null || echo "unknown")
    echo ""; echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 NEXUS NETWORK PROVER INSTALLATION COMPLETED! 🎉   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"; echo ""
    log "📝 Made by OveR (@Over9725) - Version 2.4 OPTIMIZED"
    log "$TIER_EMOJI Server Tier: $TIER | Node ID: $NODE_ID"
    log "📦 Version: $final_version | ⚡ Mode: BALANCED (70-80% CPU, bot-friendly)"
    echo ""; echo -e "${YELLOW}🚀 Management Commands:${NC}"
    echo -e "   ${BLUE}nexus-start${NC} | ${BLUE}nexus-stop${NC} | ${BLUE}nexus-status${NC} | ${BLUE}nexus-monitor${NC}"
    echo -e "   ${BLUE}screen -r nexus${NC} (view logs, Ctrl+A+D to detach)"
    echo ""; echo -e "${CYAN}🔗 Dashboard: ${BLUE}https://beta.nexus.xyz/${NC}"
    echo -e "${GREEN}⚡ BALANCED MODE: 70-80% CPU target, reserves 25% for bots/other tasks${NC}"
    echo -e "${PURPLE}Follow @Over9725 for more crypto optimizations!${NC}"; echo ""
}

# Error handling
cleanup_on_error() {
    echo ""; log "Installation failed. Check errors above." "$RED"
    log "Support: https://discord.gg/nexus-xyz" "$CYAN"; exit $?
}
trap cleanup_on_error ERR

# Run
main "$@"
