#!/bin/bash

# Nexus Network Prover - Production Auto-Optimized Installation Script
# Made by OveR (@Over9725) - Follow for more crypto optimizations
# For NEX Points farming in Nexus Network
# Version: 2.4 - BALANCED PERFORMANCE OPTIMIZATIONS

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
log "⚡ Version 2.4 - Balanced performance (70-80% CPU target)"
log "🤖 Bot-friendly optimizations included"
echo ""
}

# Cleanup old installations to prevent conflicts
cleanup_old_installation() {
    log "🧹 Cleaning old installation to prevent version conflicts..."
    
    # Stop all processes
    pkill -f nexus-network 2>/dev/null || true
    screen -S nexus -X quit 2>/dev/null || true
    systemctl stop nexus-prover 2>/dev/null || true
    sleep 3
    
    # Remove ALL old binaries from possible locations
    local binary_locations=(
        "/usr/local/bin/nexus-network"
        "/usr/bin/nexus-network"
        "/bin/nexus-network"
        "$NEXUS_HOME/.nexus/nexus-cli/target/release/nexus-network"
        "$NEXUS_HOME/.local/bin/nexus-network"
        "$NEXUS_HOME/bin/nexus-network"
        "$NEXUS_HOME/.cargo/bin/nexus-network"
        "$HOME/.nexus/nexus-cli/target/release/nexus-network"
        "$HOME/.local/bin/nexus-network"
        "$HOME/bin/nexus-network"
        "$HOME/.cargo/bin/nexus-network"
    )
    
    for location in "${binary_locations[@]}"; do
        if [ -f "$location" ]; then
            log "   🗑️  Removing old binary: $location"
            sudo rm -f "$location" 2>/dev/null || rm -f "$location" 2>/dev/null || true
        fi
    done
    
    # Clean cache directories
    rm -rf "$NEXUS_HOME/.nexus/nexus-cli" 2>/dev/null || true
    rm -rf "$NEXUS_HOME/.nexus/network-api" 2>/dev/null || true
    rm -rf "$HOME/.nexus/nexus-cli" 2>/dev/null || true
    rm -rf "$HOME/.nexus/network-api" 2>/dev/null || true
    
    # Clean Cargo cache
    if [ "$EUID" -eq 0 ]; then
        su - nexus -c "cargo clean 2>/dev/null || true" || true
        su - nexus -c "rm -rf ~/.cargo/registry/cache/* 2>/dev/null || true" || true
    else
        cargo clean 2>/dev/null || true
        rm -rf ~/.cargo/registry/cache/* 2>/dev/null || true
    fi
    
    log "   ✅ Old installation cleaned"
}

# Network diagnostics and fixes
fix_network_issues() {
    log "🌐 Checking and fixing network connectivity..."
    
    # Test basic connectivity
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        error "❌ No internet connection. Check your network settings."
    fi
    
    # Test DNS resolution
    if ! nslookup google.com >/dev/null 2>&1; then
        warn "⚠️  DNS issues detected, fixing..."
        
        # Backup original resolv.conf
        sudo cp /etc/resolv.conf /etc/resolv.conf.backup 2>/dev/null || true
        
        # Set Google DNS
        echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf >/dev/null
        echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf >/dev/null
        echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf >/dev/null
        
        log "   ✅ DNS fixed with Google/Cloudflare servers"
    fi
    
    # Test HTTPS connectivity
    if ! curl -s --connect-timeout 10 https://github.com >/dev/null 2>&1; then
        warn "⚠️  HTTPS connectivity issues detected"
        
        # Check firewall
        if command -v ufw >/dev/null 2>&1; then
            local ufw_status=$(sudo ufw status | head -1)
            if echo "$ufw_status" | grep -q "active"; then
                log "   🔧 Configuring firewall for Nexus..."
                sudo ufw allow out 443 >/dev/null 2>&1 || true
                sudo ufw allow out 80 >/dev/null 2>&1 || true
            fi
        fi
    fi
    
    # Test Nexus connectivity
    if curl -s --connect-timeout 15 https://nexus.xyz >/dev/null 2>&1; then
        log "   ✅ Nexus network connectivity OK"
    else
        warn "   ⚠️  Nexus servers may be slow, but proceeding..."
    fi
}

# Node ID validation
validate_node_id() {
    local node_id=$1
    
    # Check length (should be reasonable)
    if [ ${#node_id} -lt 3 ]; then
        return 1
    fi
    
    # Check for invalid characters that caused issues
    if echo "$node_id" | grep -q '[{}()[]"\\]'; then
        return 1
    fi
    
    # Check for problematic patterns
    if echo "$node_id" | grep -q '\..*\.'; then
        return 1
    fi
    
    return 0
}

# Interactive Node ID input with validation
get_node_id() {
    log "🔑 Node ID Configuration Required"
    echo ""
    info "📋 To earn NEX Points, you MUST use a valid Node ID from Nexus:"
    info "   1. Visit: ${BLUE}https://beta.nexus.xyz/${NC}"
    info "   2. Create account or login"
    info "   3. Go to: Account → Add Node → CLI Node"
    info "   4. Copy the provided Node ID"
    echo ""
    
    local node_id=""
    local attempts=0
    local max_attempts=3
    
    while [ $attempts -lt $max_attempts ]; do
        printf "Enter your Node ID: "
        read -r node_id < /dev/tty
        
        if [ -z "$node_id" ]; then
            warn "   ❌ Node ID cannot be empty!"
            echo ""
            info "   💡 Please visit ${BLUE}https://beta.nexus.xyz/${NC} to get your Node ID"
            echo ""
        elif validate_node_id "$node_id"; then
            log "   ✅ Node ID format looks good: $node_id"
            echo ""
            printf "Confirm this Node ID? (y/N): "
            read -r confirm < /dev/tty
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                NODE_ID="$node_id"
                return 0
            else
                warn "   🔄 Please enter Node ID again..."
                echo ""
            fi
        else
            warn "   ❌ Invalid Node ID format!"
            info "   💡 Node ID should not contain special characters like . ( ) [ ] { }"
            echo ""
        fi
        
        attempts=$((attempts + 1))
        if [ $attempts -eq $max_attempts ]; then
            error "❌ Too many invalid attempts. Please visit https://beta.nexus.xyz/ to get a valid Node ID"
        fi
    done
}

# System Detection & Optimization
detect_and_optimize() {
    log "🔍 Detecting system specifications..."
    
    # CPU & Memory Detection
    CPU_CORES=$(nproc)
    CPU_ARCH=$(uname -m)
    RAM_TOTAL_GB=$(($(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024))
    DISK_AVAILABLE=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
    
    log "   🖥️  CPU: $CPU_CORES cores ($CPU_ARCH)"
    log "   🧠 RAM: ${RAM_TOTAL_GB}GB"
    log "   💾 Disk: ${DISK_AVAILABLE}GB available"
    
    # Requirements Check
    [ "$CPU_CORES" -lt 2 ] && error "❌ Need at least 2 CPU cores"
    [ "$RAM_TOTAL_GB" -lt 4 ] && error "❌ Need at least 4GB RAM"
    [ "$DISK_AVAILABLE" -lt 10 ] && error "❌ Need at least 10GB free disk space"
    
    # Performance Tier Classification for Nexus Network
    if [ "$CPU_CORES" -ge 16 ] && [ "$RAM_TOTAL_GB" -ge 32 ]; then
        TIER="HIGH_END"; TIER_EMOJI="🔥"; PERF_RATING="Excellent"; EXPECTED_HZ="1000+"
    elif [ "$CPU_CORES" -ge 8 ] && [ "$RAM_TOTAL_GB" -ge 16 ]; then
        TIER="PERFORMANCE"; TIER_EMOJI="⚡"; PERF_RATING="Great"; EXPECTED_HZ="500-1000"
    elif [ "$CPU_CORES" -ge 4 ] && [ "$RAM_TOTAL_GB" -ge 8 ]; then
        TIER="STANDARD"; TIER_EMOJI="🚀"; PERF_RATING="Good"; EXPECTED_HZ="100-500"
    else
        TIER="BASIC"; TIER_EMOJI="💻"; PERF_RATING="Basic"; EXPECTED_HZ="50-100"
    fi
    
    log "   $TIER_EMOJI Server Tier: $TIER ($PERF_RATING proving performance)"
    log "   📊 Expected Speed: ${EXPECTED_HZ} Hz"
    log "   ✅ System check complete"
}

# Dependencies Installation
install_deps() {
    log "📦 Installing dependencies..."
    
    if command -v apt-get >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get update -y >/dev/null
        sudo apt-get install -y curl git build-essential pkg-config libssl-dev \
            protobuf-compiler ca-certificates dnsutils screen bc >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
        sudo yum groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo yum install -y curl git openssl-devel protobuf-devel bind-utils screen bc >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo dnf install -y curl git openssl-devel protobuf-devel bind-utils screen bc >/dev/null 2>&1
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm curl git base-devel openssl protobuf bind screen bc >/dev/null 2>&1
    else
        error "❌ Unsupported OS. Install dependencies manually"
    fi
    
    log "   ✅ Dependencies installed"
}

# Enhanced Rust Installation with latest version
setup_rust() {
    log "🦀 Setting up latest Rust environment..."
    
    if [ "$EUID" -eq 0 ]; then
        # Install Rust for nexus user
        log "   📥 Installing latest Rust for nexus user..."
        su - nexus -c '
            if ! command -v rustc >/dev/null 2>&1; then
                curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
                source ~/.cargo/env
            fi
            rustup self update 2>/dev/null || true
            rustup update stable 2>/dev/null || true
            rustup default stable 2>/dev/null || true
            rustup target add riscv32i-unknown-none-elf 2>/dev/null || true
        '
    else
        # Regular user installation
        if ! command -v rustc >/dev/null 2>&1; then
            log "   📥 Installing latest Rust..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable >/dev/null
            source ~/.cargo/env
        fi
        
        rustup self update >/dev/null 2>&1 || true
        rustup update stable >/dev/null 2>&1 || true
        rustup default stable >/dev/null 2>&1
        rustup target add riscv32i-unknown-none-elf >/dev/null 2>&1 || true
    fi
    
    # Verify installation
    if [ "$EUID" -eq 0 ]; then
        local rust_version
        rust_version=$(su - nexus -c 'source ~/.cargo/env 2>/dev/null; rustc --version 2>/dev/null' || echo "System cargo available")
        log "   ✅ Latest Rust ready for nexus user: $rust_version"
    else
        local rust_version
        rust_version=$(rustc --version 2>/dev/null || echo "Unknown")
        log "   ✅ Latest Rust ready: $rust_version"
    fi
}

# Check internet connectivity and installer availability
check_nexus_installer() {
    log "🌐 Checking Nexus installer availability..."
    
    # Test Nexus installer endpoint with retry
    local attempts=0
    local max_attempts=3
    
    while [ $attempts -lt $max_attempts ]; do
        if curl -s --connect-timeout 15 --head "$OFFICIAL_INSTALLER" >/dev/null 2>&1; then
            log "   ✅ Official installer available"
            USE_OFFICIAL=true
            return 0
        fi
        
        attempts=$((attempts + 1))
        if [ $attempts -lt $max_attempts ]; then
            warn "   ⚠️  Installer check failed, retrying..."
            sleep 5
        fi
    done
    
    warn "   ⚠️  Official installer not accessible, will use backup method"
    USE_OFFICIAL=false
}

# Method 1: Official Installer (Recommended) - FIXED VERSION
install_official() {
    log "🚀 Installing LATEST version via official installer..."
    
    # Set non-interactive mode and run as nexus user if we're root
    if [ "$EUID" -eq 0 ]; then
        log "   📥 Installing as nexus user..."
        su - nexus -c "
            export NONINTERACTIVE=1
            source ~/.cargo/env 2>/dev/null || export PATH=\"\$HOME/.cargo/bin:\$PATH\"
            # Force latest version
            curl -sSf https://cli.nexus.xyz/ | sh -s -- --force
        " || {
            warn "   ⚠️  Official installer failed for nexus user"
            return 1
        }
    else
        export NONINTERACTIVE=1
        # Force latest version
        if ! curl -sSf "$OFFICIAL_INSTALLER" | sh -s -- --force; then
            warn "   ⚠️  Official installer failed"
            return 1
        fi
    fi
    
    # Find the installed binary dynamically
    log "   🔍 Locating installed binary..."
    
    if [ "$EUID" -eq 0 ]; then
        # Check where official installer put the binary for nexus user
        LATEST_BINARY=$(su - nexus -c 'source ~/.cargo/env 2>/dev/null || export PATH="$HOME/.cargo/bin:$PATH"; which nexus-network 2>/dev/null' || echo "")
        if [ -n "$LATEST_BINARY" ] && [ -f "$LATEST_BINARY" ]; then
            log "   ✅ Found latest binary at: $LATEST_BINARY"
            NEXUS_BINARY="$LATEST_BINARY"
            
            # Get version
            local version
            version=$(su - nexus -c "source ~/.cargo/env 2>/dev/null; $LATEST_BINARY --version 2>/dev/null" || echo "unknown")
            log "   📦 Official installer version: $version"
            return 0
        fi
    else
        # For regular user
        source ~/.cargo/env 2>/dev/null || export PATH="$HOME/.cargo/bin:$PATH"
        LATEST_BINARY=$(which nexus-network 2>/dev/null || echo "")
        if [ -n "$LATEST_BINARY" ] && [ -f "$LATEST_BINARY" ]; then
            log "   ✅ Found latest binary at: $LATEST_BINARY"
            NEXUS_BINARY="$LATEST_BINARY"
            
            # Get version
            local version
            version=$($LATEST_BINARY --version 2>/dev/null || echo "unknown")
            log "   📦 Official installer version: $version"
            return 0
        fi
    fi
    
    warn "   ⚠️  Official installer completed but binary not found, trying backup method"
    return 1
}

# Method 2: Build from Source (Backup) - FORCE LATEST
install_from_source() {
    log "🔨 Building LATEST version from source..."
    
    local repo_dir="$NEXUS_HOME/.nexus/network-api-latest"
    
    # Remove any existing directory
    rm -rf "$repo_dir" 2>/dev/null || true
    
    # Clone fresh repository
    mkdir -p "$NEXUS_HOME/.nexus"
    log "   📥 Cloning latest source..."
    if ! git clone --depth 1 "$REPO_URL" "$repo_dir" >/dev/null 2>&1; then
        error "❌ Failed to clone repository"
    fi
    
    cd "$repo_dir/clients/cli"
    
    # Build release version with latest dependencies
    log "   🔧 Building optimized binary with latest dependencies (10-15 minutes)..."
    if [ "$EUID" -eq 0 ]; then
        # Build as nexus user with proper Rust environment
        chown -R nexus:nexus "$repo_dir"
        su - nexus -c "
            source ~/.cargo/env 2>/dev/null || export PATH=\"\$HOME/.cargo/bin:\$PATH\"
            cd $repo_dir/clients/cli
            cargo clean
            cargo update
            cargo build --release
        " || {
            error "❌ Build failed"
        }
    else
        cargo clean
        cargo update
        cargo build --release || error "❌ Build failed"
    fi
    
    # Set binary path
    NEXUS_BINARY="$repo_dir/clients/cli/target/release/nexus-network"
    
    if [ ! -f "$NEXUS_BINARY" ]; then
        error "❌ Build completed but binary not found at: $NEXUS_BINARY"
    fi
    
    # Check version
    local version
    version=$("$NEXUS_BINARY" --version 2>/dev/null || echo "unknown")
    log "   📦 Built version: $version"
    
    log "   ✅ Source installation completed"
}

# Version verification function
verify_version() {
    log "🔍 Verifying installed version..."
    
    if [ ! -f "$NEXUS_BINARY" ]; then
        error "❌ Binary not found at: $NEXUS_BINARY"
    fi
    
    local version
    version=$("$NEXUS_BINARY" --version 2>/dev/null || echo "unknown")
    log "   📦 Installed version: $version"
    
    if echo "$version" | grep -q "0.8.13"; then
        error "❌ Still got old version 0.8.13! Installation failed."
    elif echo "$version" | grep -q "0.8."; then
        log "   ✅ Version looks updated: $version"
    else
        log "   ✅ Version installed: $version"
    fi
    
    return 0
}

# Install binary to system path ensuring latest version is used
install_binary_to_system() {
    log "📦 Installing binary to system path..."
    
    # Copy latest binary to system location
    sudo cp "$NEXUS_BINARY" /usr/local/bin/nexus-network
    sudo chmod +x /usr/local/bin/nexus-network
    
    # Verify system installation
    local system_version
    system_version=$(/usr/local/bin/nexus-network --version 2>/dev/null || echo "unknown")
    log "   📦 System binary version: $system_version"
    
    # Update NEXUS_BINARY to point to system location
    NEXUS_BINARY="/usr/local/bin/nexus-network"
    
    log "   ✅ Binary installed to system path"
}

# Create Node Configuration
create_node_config() {
    log "🔧 Creating node configuration..."
    
    mkdir -p "$NEXUS_HOME/.nexus"
    
    # Create config file with validated Node ID
    cat > "$NEXUS_HOME/.nexus/config.json" << EOF
{
    "node_id": "$NODE_ID"
}
EOF
    
    chmod 600 "$NEXUS_HOME/.nexus/config.json"
    chown -R $NEXUS_USER:$NEXUS_USER "$NEXUS_HOME/.nexus" 2>/dev/null || true
    
    log "   ✅ Configuration saved with Node ID: $NODE_ID"
}

# Balanced Performance Optimization - Bot-friendly
apply_balanced_optimizations() {
    log "⚡ Applying BALANCED performance optimizations (bot-friendly)..."
    
    # 1. Moderate CPU performance (not aggressive)
    if [ -d "/sys/devices/system/cpu/cpu0/cpufreq" ]; then
        log "   🖥️  Setting CPU to balanced performance mode..."
        # Use performance governor but don't force turbo
        echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1 || true
        log "     ✅ CPU Governor set to 'performance'"
    fi
    
    # 2. Moderate system limits (not excessive)
    log "   📈 Setting balanced system limits..."
    cat << EOF | sudo tee -a /etc/security/limits.conf >/dev/null
# Nexus Balanced Performance Limits (Added by OveR script v2.4)
nexus soft nofile 65536
nexus hard nofile 65536
nexus soft nproc 32768
nexus hard nproc 32768
EOF
    
    # 3. Conservative kernel optimization
    log "   🚀 Applying conservative kernel optimizations..."
    cat << EOF | sudo tee -a /etc/sysctl.conf >/dev/null
# Nexus Balanced Performance Optimization (Added by OveR script v2.4)
vm.swappiness=10
vm.dirty_ratio=20
vm.dirty_background_ratio=10
net.core.rmem_default=262144
net.core.wmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_max=16777216
EOF
    sudo sysctl -p >/dev/null 2>&1 || true
    
    log "   ✅ Balanced optimizations applied (system remains stable for other tasks)"
}

# Create BALANCED Screen-based Service - Bot-friendly
create_balanced_screen_service() {
    log "⚙️  Creating BALANCED screen-based service (70-80% CPU target)..."
    
    # Create balanced startup script
    sudo tee /usr/local/bin/nexus-start.sh >/dev/null << 'EOF'
#!/bin/bash
# Nexus Prover BALANCED Startup Script (Made by OveR v2.4) - Bot-friendly

# Kill existing session if exists
screen -S nexus -X quit 2>/dev/null || true
sleep 2

# Use the system binary (latest version)
NEXUS_BINARY="/usr/local/bin/nexus-network"

# Get Node ID from config
if [ -f "/home/nexus/.nexus/config.json" ]; then
    NODE_ID=$(grep "node_id" /home/nexus/.nexus/config.json | cut -d'"' -f4)
elif [ -f "$HOME/.nexus/config.json" ]; then
    NODE_ID=$(grep "node_id" $HOME/.nexus/config.json | cut -d'"' -f4)
else
    echo "❌ Config file not found"
    exit 1
fi

# Get version
VERSION=$($NEXUS_BINARY --version 2>/dev/null || echo "unknown")

# BALANCED PERFORMANCE SETTINGS - Bot-friendly
export RUST_LOG=info
export RAYON_NUM_THREADS=$(($(nproc) * 3 / 4))  # Use 75% of cores
export RUSTFLAGS="-C target-cpu=native -C opt-level=2"  # Moderate optimization

# Start new session with BALANCED priority and LIMITED cores for other tasks
cd /home/nexus 2>/dev/null || cd $HOME

# Calculate cores to use (leave 25% free for other processes like bots)
TOTAL_CORES=$(nproc)
NEXUS_CORES=$((TOTAL_CORES * 3 / 4))
if [ $NEXUS_CORES -lt 1 ]; then
    NEXUS_CORES=1
fi
CORE_LIST="0-$((NEXUS_CORES-1))"

# Start with moderate priority (-10) and limited CPU affinity
screen -dmS nexus bash -c "
    exec nice -n -10 taskset -c $CORE_LIST \
    sudo -u nexus env RUST_LOG=info RAYON_NUM_THREADS=$NEXUS_CORES RUSTFLAGS='-C target-cpu=native -C opt-level=2' \
    $NEXUS_BINARY start --node-id $NODE_ID
"

# Wait for startup
sleep 5

# Apply balanced optimizations to the running process
if pgrep -f nexus-network >/dev/null; then
    PID=$(pgrep -f nexus-network)
    
    # Set moderate priority (not maximum)
    sudo renice -10 $PID 2>/dev/null || true
    
    # Ensure limited cores are used (leave some for other tasks)
    sudo taskset -cp $CORE_LIST $PID >/dev/null 2>&1 || true
fi

# Check if session is running
if screen -list | grep -q "nexus"; then
    echo "⚡ Nexus prover started in BALANCED mode with version: $VERSION"
    echo "🎯 Priority: -10 (Moderate - bot-friendly)"
    echo "🖥️  CPU Cores: $CORE_LIST (${NEXUS_CORES}/${TOTAL_CORES} cores, leaving $((TOTAL_CORES-NEXUS_CORES)) for other tasks)"
    echo "🤖 Bot-friendly: ✅ (System resources reserved for other processes)"
    echo "📊 To view logs: screen -r nexus"
    echo "🔄 To detach: Ctrl+A then D"
else
    echo "❌ Failed to start nexus prover"
    exit 1
fi
EOF
    
    sudo chmod +x /usr/local/bin/nexus-start.sh
    
    # Enhanced status script with balanced performance info
    sudo tee /usr/local/bin/nexus-status.sh >/dev/null << 'EOF'
#!/bin/bash
# Nexus Prover BALANCED Status Script (Made by OveR v2.4)

NEXUS_BINARY="/usr/local/bin/nexus-network"
CURRENT_VERSION=$($NEXUS_BINARY --version 2>/dev/null || echo "unknown")

echo "⚡ NEXUS BALANCED MODE STATUS (Bot-Friendly)"
echo "════════════════════════════════════════════"
echo "📦 Version: $CURRENT_VERSION"
echo "📍 Binary: $NEXUS_BINARY"
echo ""

if screen -list | grep -q "nexus"; then
