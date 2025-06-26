#!/bin/bash

# Nexus Network Prover - Auto-Optimized Installation Script
# Made by OveR (@Over9725) - Follow for more crypto optimizations
# For NEX Points farming in Nexus Network

set -euo pipefail

# Colors & Constants
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'; NC='\033[0m'
OFFICIAL_INSTALLER="https://cli.nexus.xyz/"
REPO_URL="https://github.com/nexus-xyz/network-api.git"

# Logging
log() { echo -e "${2:-$GREEN}[$(date +'%H:%M:%S')] $1${NC}"; }
error() { log "$1" "$RED" && exit 1; }
warn() { log "$1" "$YELLOW"; }

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
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
log "🎯 Installing optimized Nexus Network Prover for NEX Points farming"
echo ""
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
        TIER="HIGH_END"; TIER_EMOJI="🔥"; PERF_RATING="Excellent"
    elif [ "$CPU_CORES" -ge 8 ] && [ "$RAM_TOTAL_GB" -ge 16 ]; then
        TIER="PERFORMANCE"; TIER_EMOJI="⚡"; PERF_RATING="Great"
    elif [ "$CPU_CORES" -ge 4 ] && [ "$RAM_TOTAL_GB" -ge 8 ]; then
        TIER="STANDARD"; TIER_EMOJI="🚀"; PERF_RATING="Good"
    else
        TIER="BASIC"; TIER_EMOJI="💻"; PERF_RATING="Basic"
    fi
    
    log "   $TIER_EMOJI Server Tier: $TIER ($PERF_RATING proving performance)"
    log "   ✅ System check complete"
}

# Dependencies Installation
install_deps() {
    log "📦 Installing dependencies..."
    
    if command -v apt-get >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get update -y >/dev/null
        sudo apt-get install -y curl git build-essential pkg-config libssl-dev \
            protobuf-compiler ca-certificates >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
        sudo yum groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo yum install -y curl git openssl-devel protobuf-devel >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo dnf install -y curl git openssl-devel protobuf-devel >/dev/null 2>&1
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm curl git base-devel openssl protobuf >/dev/null 2>&1
    else
        error "❌ Unsupported OS. Install dependencies manually"
    fi
    
    log "   ✅ Dependencies installed"
}

# Rust Installation (Required for Nexus Network)
setup_rust() {
    log "🦀 Setting up Rust..."
    
    if ! command -v rustc >/dev/null 2>&1; then
        log "   📥 Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable >/dev/null
        source ~/.cargo/env
    fi
    
    rustup update stable >/dev/null 2>&1 || true
    rustup default stable >/dev/null 2>&1
    
    # Add RISC-V target (required for Nexus)
    rustup target add riscv32i-unknown-none-elf >/dev/null 2>&1 || true
    
    local rust_version
    rust_version=$(rustc --version 2>/dev/null || echo "Unknown")
    log "   ✅ Rust ready: $rust_version"
}

# Check internet connectivity and installer availability
check_nexus_installer() {
    log "🌐 Checking Nexus installer availability..."
    
    # Test general internet
    curl -s --connect-timeout 10 https://github.com >/dev/null 2>&1 || error "❌ No internet connection"
    
    # Test Nexus installer endpoint
    if curl -s --connect-timeout 15 --head "$OFFICIAL_INSTALLER" >/dev/null 2>&1; then
        log "   ✅ Official installer available"
        USE_OFFICIAL=true
    else
        warn "   ⚠️  Official installer not accessible, using backup method"
        USE_OFFICIAL=false
    fi
}

# Method 1: Official Installer (Recommended)
install_official() {
    log "🚀 Installing via official installer..."
    
    # Set non-interactive mode and run as nexus user if we're root
    if [ "$EUID" -eq 0 ]; then
        log "   📥 Installing as nexus user..."
        su - nexus -c 'export NONINTERACTIVE=1 && curl -sSf https://cli.nexus.xyz/ | sh'
    else
        export NONINTERACTIVE=1
        curl -sSf "$OFFICIAL_INSTALLER" | sh
    fi
    
    # Check if installation succeeded
    local possible_paths=(
        "/home/nexus/.nexus/nexus-cli/target/release/nexus-network"
        "$HOME/.nexus/nexus-cli/target/release/nexus-network"  
        "/usr/local/bin/nexus-network"
        "/home/nexus/.local/bin/nexus-network"
        "$HOME/.local/bin/nexus-network"
    )
    
    for path in "${possible_paths[@]}"; do
        if [ -f "$path" ]; then
            log "   ✅ Found binary at: $path"
            NEXUS_BINARY="$path"
            return 0
        fi
    done
    
    warn "   ⚠️  Official installer completed but binary not found, trying backup method"
    return 1
}

# Method 2: Build from Source (Backup)
install_from_source() {
    log "🔨 Installing from source (backup method)..."
    
    local repo_dir="$NEXUS_HOME/.nexus/network-api"
    
    # Clone repository
    if [ -d "$repo_dir" ]; then
        cd "$repo_dir"
        git pull >/dev/null 2>&1 || (cd ~ && rm -rf "$repo_dir" && git clone "$REPO_URL" "$repo_dir")
    else
        mkdir -p "$NEXUS_HOME/.nexus"
        git clone "$REPO_URL" "$repo_dir" >/dev/null
    fi
    
    cd "$repo_dir/clients/cli"
    
    # Build release version
    log "   🔧 Building optimized binary..."
    if [ "$EUID" -eq 0 ]; then
        # Build as nexus user
        chown -R nexus:nexus "$repo_dir"
        su - nexus -c "cd $repo_dir/clients/cli && cargo build --release" || error "❌ Build failed"
    else
        cargo build --release >/dev/null 2>&1 || error "❌ Build failed"
    fi
    
    # Set binary path
    NEXUS_BINARY="$repo_dir/clients/cli/target/release/nexus-network"
    
    if [ ! -f "$NEXUS_BINARY" ]; then
        error "❌ Build completed but binary not found"
    fi
    
    # Install binary to system path
    sudo cp "$NEXUS_BINARY" /usr/local/bin/nexus-network
    sudo chmod +x /usr/local/bin/nexus-network
    NEXUS_BINARY="/usr/local/bin/nexus-network"
    
    log "   ✅ Source installation completed"
}

# Create Node Configuration
create_node_config() {
    log "🔧 Creating node configuration..."
    
    mkdir -p "$NEXUS_HOME/.nexus"
    
    # Generate or prompt for Node ID
    if [ -z "${NEXUS_NODE_ID:-}" ]; then
        echo ""
        log "🔑 Node ID Configuration:"
        log "   💡 Get your Node ID from: https://beta.nexus.xyz/"
        echo "   Enter your Node ID (or press Enter to generate random):"
        read -r NODE_ID -t 30 || NODE_ID=""
        
        if [ -z "$NODE_ID" ]; then
            NODE_ID="auto-$(hostname | cut -c1-8)-$(openssl rand -hex 6 2>/dev/null || date +%s | md5sum | cut -c1-12)"
            warn "   🎲 Generated random Node ID: $NODE_ID"
            warn "   ⚠️  Link it later at https://beta.nexus.xyz/ to earn NEX Points!"
        else
            log "   ✅ Using Node ID: $NODE_ID"
        fi
    else
        NODE_ID="$NEXUS_NODE_ID"
        log "   ✅ Using provided Node ID: $NODE_ID"
    fi
    
    # Create config file
    cat > "$NEXUS_HOME/.nexus/config.json" << EOF
{
    "node_id": "$NODE_ID"
}
EOF
    
    chmod 600 "$NEXUS_HOME/.nexus/config.json"
    chown -R $NEXUS_USER:$NEXUS_USER "$NEXUS_HOME/.nexus" 2>/dev/null || true
    log "   ✅ Configuration saved"
}

# Create Systemd Service
create_service() {
    log "⚙️  Creating systemd service..."
    
    # Determine binary location
    local binary_path="$NEXUS_BINARY"
    
    if [ ! -f "$binary_path" ]; then
        error "❌ Nexus binary not found at: $binary_path"
    fi
    
    # Service priority based on server tier
    case $TIER in
        "HIGH_END") NICE="-10"; IO_CLASS="1" ;;
        "PERFORMANCE") NICE="-5"; IO_CLASS="1" ;;
        "STANDARD") NICE="0"; IO_CLASS="2" ;;
        "BASIC") NICE="5"; IO_CLASS="3" ;;
    esac
    
    sudo tee /etc/systemd/system/nexus-prover.service >/dev/null << EOF
[Unit]
Description=Nexus Network Prover (Optimized by OveR)
Documentation=https://nexus.xyz/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$NEXUS_USER
WorkingDirectory=$NEXUS_HOME
ExecStart=$binary_path start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

# Performance optimizations for $TIER tier
Nice=$NICE
IOSchedulingClass=$IO_CLASS
LimitNOFILE=65536
Environment=RUST_LOG=info

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    log "   ✅ Service created and configured"
}

# Test Installation
test_installation() {
    log "🧪 Testing installation..."
    
    # Find and test binary
    local binary_cmd="$NEXUS_BINARY"
    
    if [ ! -f "$binary_cmd" ]; then
        error "❌ Nexus binary not found at: $binary_cmd"
    fi
    
    # Test binary execution
    if timeout 10 $binary_cmd --help >/dev/null 2>&1; then
        log "   ✅ Binary test passed"
    else
        warn "   ⚠️  Binary test timeout (normal for network connection)"
    fi
    
    # Test config file
    if [ -f "$NEXUS_HOME/.nexus/config.json" ]; then
        local test_node_id
        test_node_id=$(grep "node_id" "$NEXUS_HOME/.nexus/config.json" | cut -d'"' -f4)
        log "   ✅ Config test passed (Node ID: $test_node_id)"
    else
        error "❌ Config file not found"
    fi
}

# Performance Analysis
show_performance_info() {
    log "📊 Performance Analysis:"
    
    # Expected performance based on specs
    case $TIER in
        "HIGH_END")
            EXPECTED_HZ="1000+ Hz"
            EXPECTED_RANK="Top 10%"
            ;;
        "PERFORMANCE")
            EXPECTED_HZ="500-1000 Hz"
            EXPECTED_RANK="Top 25%"
            ;;
        "STANDARD")
            EXPECTED_HZ="100-500 Hz"
            EXPECTED_RANK="Top 50%"
            ;;
        "BASIC")
            EXPECTED_HZ="50-100 Hz"
            EXPECTED_RANK="Participant"
            ;;
    esac
    
    echo ""
    log "   🎯 Server Tier: $TIER_EMOJI $TIER"
    log "   ⚡ Expected Speed: $EXPECTED_HZ"
    log "   🏆 Expected Ranking: $EXPECTED_RANK"
    log "   💰 Earning Potential: Proportional to proving speed"
    echo ""
}

# Internet connectivity check
check_internet() {
    curl -s --connect-timeout 10 https://github.com >/dev/null 2>&1 || error "❌ No internet connection"
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
    check_internet
    
    # System analysis
    detect_and_optimize
    install_deps
    setup_rust
    check_nexus_installer
    
    # Installation methods
    if [ "$USE_OFFICIAL" = true ]; then
        if ! install_official; then
            install_from_source
        fi
    else
        install_from_source
    fi
    
    # Set final binary path if not set
    if [ -z "${NEXUS_BINARY:-}" ]; then
        if [ -f "/usr/local/bin/nexus-network" ]; then
            NEXUS_BINARY="/usr/local/bin/nexus-network"
        else
            error "❌ No Nexus binary found after installation"
        fi
    fi
    
    # Configuration
    create_node_config
    create_service
    test_installation
    show_performance_info
    
    # Success message
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 NEXUS NETWORK PROVER INSTALLATION COMPLETED! 🎉          ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log "📝 Made by OveR (@Over9725)"
    log "$TIER_EMOJI Server Tier: $TIER"
    log "💰 Ready to farm NEX Points!"
    echo ""
    echo -e "${YELLOW}🚀 Quick Start Commands:${NC}"
    echo -e "   Start service:    ${BLUE}sudo systemctl start nexus-prover${NC}"
    echo -e "   Enable autostart: ${BLUE}sudo systemctl enable nexus-prover${NC}"
    echo -e "   Check status:     ${BLUE}sudo systemctl status nexus-prover${NC}"
    echo -e "   View logs:        ${BLUE}sudo journalctl -u nexus-prover -f${NC}"
    echo -e "   Stop service:     ${BLUE}sudo systemctl stop nexus-prover${NC}"
    echo ""
    echo -e "${PURPLE}🔗 Important Links:${NC}"
    echo -e "   Dashboard:        ${BLUE}https://beta.nexus.xyz/${NC}"
    echo -e "   Link Node ID:     ${BLUE}Account → Add Node → CLI Node${NC}"
    echo -e "   Track Progress:   ${BLUE}View leaderboard and NEX Points${NC}"
    echo ""
    echo -e "${YELLOW}💡 Tips:${NC}"
    echo -e "   • Link your Node ID at beta.nexus.xyz to earn NEX Points"
    echo -e "   • Keep your VPS running 24/7 for maximum earnings"
    echo -e "   • Monitor logs to ensure proving is working"
    echo -e "   • Join Discord for community support"
    echo ""
    echo -e "${PURPLE}🔥 Your optimized prover is ready! Follow @Over9725 for more!${NC}"
    echo ""
}

# Error handling
trap 'echo -e "\n${RED}❌ Installation failed! Check errors above.${NC}"; exit 1' ERR

# Run main function
main "$@"
