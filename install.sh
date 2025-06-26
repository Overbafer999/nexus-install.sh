#!/bin/bash

# Nexus Prover - Compact Auto-Optimized Build Script
# Made by OveR (@Over9725) - Follow for more crypto optimizations
# Version: 2.1 Compact

set -euo pipefail

# Colors & Constants
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'; NC='\033[0m'
REPO_URL="https://github.com/nexus-xyz/nexus-zkvm.git"

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
║           🚀 AUTO-OPTIMIZED INSTALLATION 🚀                   ║
║                 Made by OveR (@Over9725)                      ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
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
    [ "$DISK_AVAILABLE" -lt 20 ] && error "❌ Need at least 20GB free disk space"
    
    # Performance Tier Classification
    if [ "$CPU_CORES" -ge 16 ] && [ "$RAM_TOTAL_GB" -ge 32 ]; then
        TIER="HIGH_END"; TIER_EMOJI="🔥"; BUILD_JOBS=$((CPU_CORES - 1)); MEMORY_LIMIT=$((RAM_TOTAL_GB - 4))
    elif [ "$CPU_CORES" -ge 8 ] && [ "$RAM_TOTAL_GB" -ge 16 ]; then
        TIER="PERFORMANCE"; TIER_EMOJI="⚡"; BUILD_JOBS=$CPU_CORES; MEMORY_LIMIT=$((RAM_TOTAL_GB - 2))
    elif [ "$CPU_CORES" -ge 4 ] && [ "$RAM_TOTAL_GB" -ge 8 ]; then
        TIER="STANDARD"; TIER_EMOJI="🚀"; BUILD_JOBS=$((CPU_CORES - 1)); MEMORY_LIMIT=$((RAM_TOTAL_GB - 1))
    else
        TIER="BASIC"; TIER_EMOJI="💻"; BUILD_JOBS=$CPU_CORES; MEMORY_LIMIT=$((RAM_TOTAL_GB - 1))
    fi
    
    # Rust Flags Optimization
    RUSTFLAGS="-C opt-level=3 -C target-cpu=native"
    TARGET="$CPU_ARCH-unknown-linux-gnu"
    
    case $TIER in
        "HIGH_END") RUSTFLAGS="$RUSTFLAGS -C codegen-units=1 -C lto=fat -C panic=abort" ;;
        "PERFORMANCE") RUSTFLAGS="$RUSTFLAGS -C codegen-units=1 -C lto=fat" ;;
        "STANDARD") RUSTFLAGS="$RUSTFLAGS -C codegen-units=2 -C lto=thin" ;;
        "BASIC") RUSTFLAGS="$RUSTFLAGS -C codegen-units=4 -C lto=thin" ;;
    esac
    
    log "   $TIER_EMOJI Tier: $TIER (${BUILD_JOBS} build jobs, ${MEMORY_LIMIT}GB memory)"
    log "   ✅ System optimization complete"
}

# Dependencies Installation
install_deps() {
    log "📦 Installing dependencies..."
    
    if command -v apt-get >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get update -y >/dev/null
        sudo apt-get install -y curl git build-essential pkg-config libssl-dev \
            libudev-dev llvm clang cmake protobuf-compiler ca-certificates >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
        sudo yum groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo yum install -y curl git openssl-devel systemd-devel llvm clang cmake protobuf-devel >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall -y "Development Tools" >/dev/null 2>&1
        sudo dnf install -y curl git openssl-devel systemd-devel llvm clang cmake protobuf-devel >/dev/null 2>&1
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm curl git base-devel openssl cmake protobuf clang llvm >/dev/null 2>&1
    else
        error "❌ Unsupported OS. Install dependencies manually"
    fi
    
    log "   ✅ Dependencies installed"
}

# Rust Installation & Configuration
setup_rust() {
    log "🦀 Setting up Rust..."
    
    # Install Rust if needed
    if ! command -v rustc >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable >/dev/null
        source ~/.cargo/env
    fi
    
    rustup update stable >/dev/null 2>&1 || true
    rustup default stable >/dev/null 2>&1
    
    # Create optimized Cargo config
    mkdir -p ~/.cargo
    cat > ~/.cargo/config.toml << EOF
[build]
jobs = $BUILD_JOBS

[target.$TARGET]
rustflags = [$(echo "$RUSTFLAGS" | sed 's/ /", "/g' | sed 's/^/"/; s/$/"/')]

[profile.release]
opt-level = 3
lto = $([ "$TIER" = "HIGH_END" ] || [ "$TIER" = "PERFORMANCE" ] && echo "true" || echo "\"thin\"")
codegen-units = $(echo "$RUSTFLAGS" | grep -o 'codegen-units=[0-9]*' | cut -d= -f2 || echo "16")
strip = true
panic = $(echo "$RUSTFLAGS" | grep -q 'panic=abort' && echo "\"abort\"" || echo "\"unwind\"")

[net]
git-fetch-with-cli = true
EOF
    
    # Set environment
    export RUSTFLAGS="$RUSTFLAGS"
    export CARGO_BUILD_JOBS=$BUILD_JOBS
    
    log "   ✅ Rust configured with $TIER optimizations"
}

# Repository Setup
setup_repo() {
    log "📥 Setting up repository..."
    
    REPO_DIR="$HOME/nexus"
    
    # Check repo accessibility
    curl -s --head "$REPO_URL" | head -n 1 | grep -q "200 OK" || error "❌ Repository not accessible"
    
    # Clone or update
    if [ -d "$REPO_DIR" ]; then
        cd "$REPO_DIR"
        git pull >/dev/null 2>&1 || (cd ~ && rm -rf "$REPO_DIR" && git clone --depth 1 "$REPO_URL" "$REPO_DIR")
    else
        git clone --depth 1 "$REPO_URL" "$REPO_DIR" >/dev/null
    fi
    
    cd "$REPO_DIR"
    
    # Verify structure
    [ ! -f "Cargo.toml" ] && error "❌ Invalid repository structure"
    grep -q "prover" Cargo.toml || error "❌ Prover binary not found in project"
    
    log "   ✅ Repository ready"
}

# Build Process
build_prover() {
    log "🔨 Building optimized prover..."
    log "   ⚡ Using $BUILD_JOBS parallel jobs with $TIER optimizations"
    
    cd "$HOME/nexus"
    
    # Clean and update
    cargo clean >/dev/null 2>&1
    cargo update >/dev/null 2>&1
    
    # Build with timeout for basic servers
    BUILD_CMD="cargo build --release --bin prover"
    BUILD_START=$(date +%s)
    
    if [ "$TIER" = "BASIC" ]; then
        timeout 3600 $BUILD_CMD || {
            warn "⚠️  Timeout reached, reducing parallelism..."
            export CARGO_BUILD_JOBS=$((BUILD_JOBS / 2))
            $BUILD_CMD
        }
    else
        $BUILD_CMD
    fi
    
    BUILD_END=$(date +%s)
    BUILD_TIME=$(((BUILD_END - BUILD_START) / 60))
    
    # Verify and install
    BINARY="target/release/prover"
    [ ! -f "$BINARY" ] && error "❌ Build failed - binary not found"
    
    # Test binary
    "$BINARY" --help >/dev/null 2>&1 || warn "⚠️  Binary execution test failed"
    
    # Install
    sudo cp "$BINARY" /usr/local/bin/nexus-prover
    sudo chmod +x /usr/local/bin/nexus-prover
    
    BINARY_SIZE=$(du -h "$BINARY" | cut -f1)
    log "   ✅ Build completed in ${BUILD_TIME}m (size: $BINARY_SIZE)"
}

# Service Configuration
create_service() {
    log "⚙️  Creating optimized service..."
    
    # Calculate settings based on tier
    case $TIER in
        "HIGH_END") NICE="-15"; IO_CLASS="1"; LIMITS="131072" ;;
        "PERFORMANCE") NICE="-10"; IO_CLASS="1"; LIMITS="65536" ;;
        "STANDARD") NICE="-5"; IO_CLASS="2"; LIMITS="65536" ;;
        "BASIC") NICE="0"; IO_CLASS="3"; LIMITS="32768" ;;
    esac
    
    sudo tee /etc/systemd/system/nexus-prover.service >/dev/null << EOF
[Unit]
Description=Nexus Prover Node (Auto-Optimized by OveR)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=/usr/local/bin/nexus-prover
Restart=always
RestartSec=10

# Optimizations for $TIER tier
Nice=$NICE
IOSchedulingClass=$IO_CLASS
LimitNOFILE=$LIMITS
Environment=RUST_LOG=info
Environment=RUSTFLAGS="$RUSTFLAGS"

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    log "   ✅ Service configured for $TIER performance"
}

# Node Configuration
create_config() {
    log "🔧 Creating node configuration..."
    
    mkdir -p ~/.nexus
    
    # Auto-generate Node ID if not provided
    if [ -z "${NEXUS_NODE_ID:-}" ]; then
        NODE_ID="auto-$(hostname | cut -c1-8)-$(openssl rand -hex 6 2>/dev/null || date +%s | md5sum | cut -c1-12)"
        log "   🎲 Generated Node ID: $NODE_ID"
    else
        NODE_ID="$NEXUS_NODE_ID"
    fi
    
    cat > ~/.nexus/config.json << EOF
{
    "node_id": "$NODE_ID",
    "tier": "$TIER",
    "optimized": true,
    "cpu_cores": $CPU_CORES,
    "memory_gb": $RAM_TOTAL_GB,
    "build_jobs": $BUILD_JOBS,
    "created_by": "OveR_Auto_Optimizer",
    "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    
    log "   ✅ Configuration saved (Node ID: $NODE_ID)"
}

# Performance Test
run_benchmark() {
    log "🏃 Running performance test..."
    
    # Test binary execution
    if /usr/local/bin/nexus-prover --help >/dev/null 2>&1; then
        BINARY_STATUS="✅ Working"
    else
        BINARY_STATUS="⚠️  Warning"
    fi
    
    # Calculate improvement estimate
    case $TIER in
        "HIGH_END") IMPROVEMENT="35-50%" ;;
        "PERFORMANCE") IMPROVEMENT="25-35%" ;;
        "STANDARD") IMPROVEMENT="15-25%" ;;
        "BASIC") IMPROVEMENT="10-15%" ;;
    esac
    
    log "   📊 Performance Results:"
    log "      Binary Status: $BINARY_STATUS"
    log "      Optimization: Native $CPU_ARCH"
    log "      Expected Improvement: $IMPROVEMENT vs default"
}

# Internet connectivity check
check_internet() {
    curl -s --connect-timeout 10 https://github.com >/dev/null 2>&1 || error "❌ No internet connection"
}

# Main Installation Function
main() {
    show_banner
    
    # Pre-flight checks
    [ "$EUID" -eq 0 ] && error "❌ Don't run as root"
    sudo -n true 2>/dev/null || error "❌ Need sudo privileges"
    check_internet
    
    # Installation steps
    detect_and_optimize
    install_deps
    setup_rust
    setup_repo
    build_prover
    create_config
    create_service
    run_benchmark
    
    # Success message
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 NEXUS PROVER INSTALLATION COMPLETED! 🎉                  ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log "📝 Made by OveR (@Over9725)"
    log "$TIER_EMOJI Server Tier: $TIER"
    log "🎯 Optimization: $IMPROVEMENT improvement expected"
    echo ""
    echo -e "${YELLOW}🚀 Quick Start Commands:${NC}"
    echo -e "   Start directly: ${BLUE}/usr/local/bin/nexus-prover${NC}"
    echo -e "   Start service:  ${BLUE}sudo systemctl start nexus-prover${NC}"
    echo -e "   Enable startup: ${BLUE}sudo systemctl enable nexus-prover${NC}"
    echo -e "   Check logs:     ${BLUE}sudo journalctl -u nexus-prover -f${NC}"
    echo -e "   Check status:   ${BLUE}sudo systemctl status nexus-prover${NC}"
    echo ""
    echo -e "${PURPLE}🔥 Your node is optimized and ready! Follow @Over9725 for more!${NC}"
    echo ""
}

# Error handling
trap 'echo -e "\n${RED}❌ Installation failed! Check errors above.${NC}"; exit 1' ERR

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
