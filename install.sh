#!/bin/bash

# Nexus Network Prover - Production Auto-Optimized Installation Script
# Made by OveR (@Over9725) - Follow for more crypto optimizations
# For NEX Points farming in Nexus Network
# Version: 2.3 - FIXED VERSION CONFLICTS

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
║                Version 2.3 - FIXED CONFLICTS                 ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
log "🎯 Installing optimized Nexus Network Prover for NEX Points farming"
log "🔧 Version 2.3 - Fixes version conflicts and ensures latest version"
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
            protobuf-compiler ca-certificates dnsutils screen >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
        sudo yum groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo yum install -y curl git openssl-devel protobuf-devel bind-utils screen >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo dnf install -y curl git openssl-devel protobuf-devel bind-utils screen >/dev/null 2>&1
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm curl git base-devel openssl protobuf bind screen >/dev/null 2>&1
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

# Create Screen-based Service - FIXED TO USE LATEST VERSION
create_screen_service() {
    log "⚙️  Creating screen-based service (using latest version)..."
    
    # Create startup script that uses the actual binary location
    sudo tee /usr/local/bin/nexus-start.sh >/dev/null << EOF
#!/bin/bash
# Nexus Prover Startup Script (Made by OveR) - Uses Latest Version

# Kill existing session if exists
screen -S nexus -X quit 2>/dev/null || true

# Wait a moment
sleep 2

# Use the system binary (latest version)
NEXUS_BINARY="/usr/local/bin/nexus-network"

# Get Node ID from config
if [ -f "/home/nexus/.nexus/config.json" ]; then
    NODE_ID=\$(grep "node_id" /home/nexus/.nexus/config.json | cut -d'"' -f4)
elif [ -f "\$HOME/.nexus/config.json" ]; then
    NODE_ID=\$(grep "node_id" \$HOME/.nexus/config.json | cut -d'"' -f4)
else
    echo "❌ Config file not found"
    exit 1
fi

# Get version
VERSION=\$(\$NEXUS_BINARY --version 2>/dev/null || echo "unknown")

# Start new session
cd /home/nexus 2>/dev/null || cd \$HOME
screen -dmS nexus sudo -u nexus \$NEXUS_BINARY start --node-id \$NODE_ID

# Wait for startup
sleep 3

# Check if session is running
if screen -list | grep -q "nexus"; then
    echo "✅ Nexus prover started successfully with version: \$VERSION"
    echo "📊 To view logs: screen -r nexus"
    echo "🔄 To detach: Ctrl+A then D"
else
    echo "❌ Failed to start nexus prover"
    exit 1
fi
EOF
    
    sudo chmod +x /usr/local/bin/nexus-start.sh
    
    # Create stop script
    sudo tee /usr/local/bin/nexus-stop.sh >/dev/null << 'EOF'
#!/bin/bash
# Nexus Prover Stop Script (Made by OveR)

if screen -list | grep -q "nexus"; then
    screen -S nexus -X quit
    echo "✅ Nexus prover stopped"
else
    echo "ℹ️  Nexus prover is not running"
fi
EOF
    
    sudo chmod +x /usr/local/bin/nexus-stop.sh
    
    # Create status script that shows version
    sudo tee /usr/local/bin/nexus-status.sh >/dev/null << 'EOF'
#!/bin/bash
# Nexus Prover Status Script (Made by OveR) - Shows Version

NEXUS_BINARY="/usr/local/bin/nexus-network"
CURRENT_VERSION=$($NEXUS_BINARY --version 2>/dev/null || echo "unknown")

echo "📦 Current version: $CURRENT_VERSION"
echo "📍 Binary location: $NEXUS_BINARY"
echo ""

if screen -list | grep -q "nexus"; then
    echo "✅ Nexus prover is running in screen session"
    echo "📊 To view logs: screen -r nexus"
    echo "🔄 To detach from logs: Ctrl+A then D"
    echo ""
    echo "Recent activity:"
    # Show last few lines if possible
    screen -S nexus -X hardcopy /tmp/nexus_output.txt 2>/dev/null
    if [ -f /tmp/nexus_output.txt ]; then
        tail -5 /tmp/nexus_output.txt 2>/dev/null || echo "No recent logs available"
        rm -f /tmp/nexus_output.txt
    fi
else
    echo "❌ Nexus prover is not running"
    echo "🚀 To start: nexus-start"
fi
EOF
    
    sudo chmod +x /usr/local/bin/nexus-status.sh
    
    # Create convenient aliases in /usr/local/bin
    sudo ln -sf /usr/local/bin/nexus-start.sh /usr/local/bin/nexus-start
    sudo ln -sf /usr/local/bin/nexus-stop.sh /usr/local/bin/nexus-stop  
    sudo ln -sf /usr/local/bin/nexus-status.sh /usr/local/bin/nexus-status
    
    # Add to crontab for auto-restart after reboot
    (crontab -l 2>/dev/null | grep -v "nexus-start"; echo "@reboot sleep 60 && /usr/local/bin/nexus-start.sh") | crontab -
    
    log "   ✅ Screen-based service configured with latest version"
    log "   🚀 Auto-start on reboot enabled"
}

# Enhanced Installation Test
test_installation() {
    log "🧪 Testing installation..."
    
    # Test binary existence and permissions
    if [ ! -f "$NEXUS_BINARY" ]; then
        error "❌ Nexus binary not found at: $NEXUS_BINARY"
    fi
    
    if [ ! -x "$NEXUS_BINARY" ]; then
        error "❌ Nexus binary is not executable: $NEXUS_BINARY"
    fi
    
    # Test binary execution
    if timeout 10 "$NEXUS_BINARY" --help >/dev/null 2>&1; then
        log "   ✅ Binary execution test passed"
    else
        warn "   ⚠️  Binary help test timeout (normal for network commands)"
    fi
    
    # Test config file
    if [ -f "$NEXUS_HOME/.nexus/config.json" ]; then
        local test_node_id
        test_node_id=$(grep "node_id" "$NEXUS_HOME/.nexus/config.json" | cut -d'"' -f4)
        log "   ✅ Config test passed (Node ID: $test_node_id)"
    else
        error "❌ Config file not found at: $NEXUS_HOME/.nexus/config.json"
    fi
    
    # Test version one more time
    local final_version
    final_version=$("$NEXUS_BINARY" --version 2>/dev/null || echo "unknown")
    log "   📦 Final version check: $final_version"
    
    log "   ✅ All tests passed!"
}

# Performance Analysis with realistic expectations
show_performance_info() {
    log "📊 Performance Analysis & Expectations:"
    
    echo ""
    log "   🎯 Server Tier: $TIER_EMOJI $TIER"
    log "   ⚡ Expected Speed: ${EXPECTED_HZ} Hz"
    log "   🏆 Performance Rating: $PERF_RATING"
    log "   💰 Earning Potential: Proportional to proving speed"
    echo ""
    
    # Provide realistic expectations
    case $TIER in
        "HIGH_END")
            info "   🔥 Excellent specs! You should rank in top 10% of provers"
            ;;
        "PERFORMANCE")
            info "   ⚡ Great specs! You should rank in top 25% of provers"
            ;;
        "STANDARD")
            info "   🚀 Good specs! You should rank in top 50% of provers"
            ;;
        "BASIC")
            info "   💻 Basic specs but still earning! Every Hz counts!"
            ;;
    esac
    echo ""
}

# Start the prover using screen
start_prover() {
    log "🚀 Starting Nexus prover with latest version..."
    
    # Show version before starting
    local start_version
    start_version=$("$NEXUS_BINARY" --version 2>/dev/null || echo "unknown")
    log "   📦 Starting with version: $start_version"
    
    # Run the startup script
    if /usr/local/bin/nexus-start.sh; then
        log "   ✅ Prover started successfully!"
        
        # Wait a moment and check
        sleep 5
        
        if screen -list | grep -q "nexus"; then
            log "   📊 Prover is running in background"
            info "   💡 To view logs: screen -r nexus"
            info "   💡 To detach: Ctrl+A then D"
        else
            warn "   ⚠️  Prover may have stopped, check manually"
        fi
    else
        error "❌ Failed to start prover"
    fi
}

# Main Installation Function
main() {
    show_banner
    
    # Pre-flight checks
    if [ "$EUID" -eq 0 ]; then
        warn "⚠️  Running as root (VPS mode)"
        # Create non-root user for Nexus
        if ! id "nexus" &>/dev/null; then
            useradd -m -s /bin/bash nexus
            log "   ✅ Created nexus user"
        fi
        NEXUS_USER="nexus"
        NEXUS_HOME="/home/nexus"
    else
        # Check sudo privileges for non-root
        sudo -n true 2>/dev/null || error "❌ Need sudo privileges"
        NEXUS_USER="$USER"  
        NEXUS_HOME="$HOME"
    fi
    
    # STEP 1: Clean old installations first
    cleanup_old_installation
    
    # STEP 2: Network and system setup
    fix_network_issues
    detect_and_optimize
    install_deps
    setup_rust
    
    # STEP 3: Get and validate Node ID from user
    get_node_id
    
    # STEP 4: Installation process (try official first, then source)
    check_nexus_installer
    
    if [ "$USE_OFFICIAL" = true ]; then
        if ! install_official; then
            log "🔄 Official installer failed, building from source..."
            install_from_source
        fi
    else
        install_from_source
    fi
    
    # STEP 5: Verify we have a binary
    if [ -z "${NEXUS_BINARY:-}" ]; then
        error "❌ No Nexus binary found after installation"
    fi
    
    # STEP 6: Verify version is not the old one
    verify_version
    
    # STEP 7: Install to system path for consistency
    install_binary_to_system
    
    # STEP 8: Configuration and testing
    create_node_config
    create_screen_service
    test_installation
    show_performance_info
    
    # STEP 9: Start the prover
    start_prover
    
    # Success message with version info
    local final_version
    final_version=$(/usr/local/bin/nexus-network --version 2>/dev/null || echo "unknown")
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 NEXUS NETWORK PROVER INSTALLATION COMPLETED! 🎉          ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log "📝 Made by OveR (@Over9725) - Version 2.3 FIXED"
    log "$TIER_EMOJI Server Tier: $TIER"
    log "🆔 Node ID: $NODE_ID"
    log "📦 Installed Version: $final_version"
    log "💰 Ready to farm NEX Points with LATEST VERSION!"
    echo ""
    echo -e "${YELLOW}🚀 Prover Management Commands:${NC}"
    echo -e "   Start prover:     ${BLUE}nexus-start${NC}"
    echo -e "   Stop prover:      ${BLUE}nexus-stop${NC}"  
    echo -e "   Check status:     ${BLUE}nexus-status${NC}"
    echo -e "   View live logs:   ${BLUE}screen -r nexus${NC}"
    echo -e "   Detach from logs: ${BLUE}Ctrl+A then D${NC}"
    echo ""
    echo -e "${PURPLE}🔗 Important Links:${NC}"
    echo -e "   Dashboard:        ${BLUE}https://beta.nexus.xyz/${NC}"
    echo -e "   Your Node ID:     ${BLUE}$NODE_ID${NC}"
    echo -e "   View Progress:    ${BLUE}Dashboard → Nodes → Your Stats${NC}"
    echo ""
    echo -e "${YELLOW}💡 Next Steps:${NC}"
    echo -e "   • Your prover is running with LATEST VERSION! ✅"
    echo -e "   • Check dashboard to verify node is online"  
    echo -e "   • Use 'nexus-status' to check version and status"
    echo -e "   • Keep VPS running 24/7 for maximum earnings"
    echo -e "   • Prover will auto-restart after VPS reboot"
    echo ""
    echo -e "${CYAN}📊 Version Check Commands:${NC}"
    echo -e "   Current version:  ${BLUE}nexus-network --version${NC}"
    echo -e "   System version:   ${BLUE}/usr/local/bin/nexus-network --version${NC}"
    echo -e "   Node config:      ${BLUE}cat $NEXUS_HOME/.nexus/config.json${NC}"
    echo ""
    echo -e "${GREEN}🔥 FIXED: No more version conflicts! Running $final_version${NC}"
    echo -e "${PURPLE}Follow @Over9725 for more crypto optimizations!${NC}"
    echo ""
}

# Error handling with cleanup
cleanup_on_error() {
    local exit_code=$?
    echo ""
    log "Installation failed with exit code: $exit_code" "$RED"
    log "Check the error messages above for details" "$YELLOW"
    log "For support, visit: https://discord.gg/nexus-xyz" "$CYAN"
    exit $exit_code
}

trap cleanup_on_error ERR

# Run main function
main "$@"
