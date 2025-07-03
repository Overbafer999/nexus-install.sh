# 🚀 Nexus Network Prover Auto-Installer

<div align="center">

```
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
║                  Version 2.3 - FIXED                         ║
╚═══════════════════════════════════════════════════════════════╝
```

**💰 Automatically installs and optimizes Nexus Network Prover for NEX Points farming**

[![Follow @Over9725](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?logo=twitter)](https://twitter.com/Over9725)

</div>

## 🎯 What This Script Does

- **🔍 Auto-detects** your server specs and optimizes accordingly
- **💰 Installs Nexus Network Prover** for earning NEX Points
- **⚡ Simple screen-based management** instead of systemd
- **🔧 Easy commands** (`nexus-start`, `nexus-stop`, `nexus-status`)
- **🔄 Auto-restart after VPS reboot** configured
- **📊 Performance tier classification** for optimal earnings
- **🚫 FIXED: Version conflicts** - Always installs latest version
- **🧹 Smart cleanup** - Removes old versions automatically

## ⚡ One-Click Installation

```bash
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/install.sh | bash
```

## 🖥️ Requirements

- **Linux** (Ubuntu, Debian, CentOS, Fedora, Arch)
- **2+ CPU cores, 4+ GB RAM, 10+ GB disk**
- **sudo privileges**
- **Stable internet connection**

## 💰 After Installation

```bash
# Check if prover is running (shows version too!)
nexus-status

# View live logs (prover keeps running in background)
screen -r nexus

# Detach from logs (Ctrl+A then D)
# Prover continues running after you detach

# Restart prover if needed
nexus-stop
nexus-start
```

## 🔗 Important: Link Your Node

**To earn NEX Points, you MUST link your Node ID:**

1. **Go to:** [https://beta.nexus.xyz/](https://beta.nexus.xyz/)
2. **Create account** or login
3. **Add Node** → **CLI Node**
4. **Copy the provided Node ID** during installation
5. **Start earning!** 💰

## 🏆 Performance Tiers

| Server Type | Specs | Expected Speed | Earning Potential |
|-------------|-------|----------------|-------------------|
| 🔥 **HIGH_END** | 16+ cores, 32+ GB | 1000+ Hz | **Top 10%** |
| ⚡ **PERFORMANCE** | 8+ cores, 16+ GB | 500-1000 Hz | **Top 25%** |
| 🚀 **STANDARD** | 4+ cores, 8+ GB | 100-500 Hz | **Top 50%** |
| 💻 **BASIC** | 2+ cores, 4+ GB | 50-100 Hz | **Participant** |

*Higher Hz = More NEX Points earned*

## 🛠️ Management Commands

```bash
# Start prover
nexus-start

# Stop prover  
nexus-stop

# Check status and version
nexus-status

# View live logs
screen -r nexus

# Detach from logs (prover keeps running)
# Press: Ctrl+A then D

# Check installed version
nexus-network --version

# Check your Node ID
cat ~/.nexus/config.json | grep node_id
```

## 🔄 Updating Your Node

### **🚀 Easy Update (Recommended):**
```bash
# Just re-run the installer - it will:
# ✅ Clean old versions automatically
# ✅ Install latest version
# ✅ Keep your Node ID and settings
# ✅ Fix any version conflicts

curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/install.sh | bash
```

### **📦 Check Version After Update:**
```bash
# All these should show the SAME latest version now:
nexus-network --version
/usr/local/bin/nexus-network --version
nexus-status
```

### **🔧 Manual Binary Update (Advanced):**
```bash
# Stop current prover
nexus-stop

# Remove old installations to prevent conflicts
sudo find / -name "nexus-network" -type f 2>/dev/null | xargs sudo rm -f

# Build fresh from source
rm -rf ~/.nexus/network-api
git clone https://github.com/nexus-xyz/network-api.git ~/.nexus/network-api
cd ~/.nexus/network-api/clients/cli
cargo clean && cargo update && cargo build --release
sudo cp target/release/nexus-network /usr/local/bin/
sudo chmod +x /usr/local/bin/nexus-network

# Restart with new version
nexus-start
```

### **🩹 Fix Version Conflicts:**
```bash
# If you have multiple versions showing different numbers:
nexus-stop
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/install.sh | bash
# This will clean everything and install fresh
```

## 🔍 Troubleshooting

**❌ Not earning points?**
```bash
# 1. Check if prover is running
nexus-status

# 2. Check Node ID is linked at https://beta.nexus.xyz/

# 3. View logs for errors
screen -r nexus

# 4. Verify version is latest
nexus-network --version
```

**❌ Prover stopped working?**
```bash
# Restart the prover
nexus-stop
nexus-start

# Check status
nexus-status
```

**❌ Version conflicts (old 0.8.13 still showing)?**
```bash
# Re-run installer to fix conflicts
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/install.sh | bash
```

**❌ Need to see what's happening?**
```bash
# View live logs
screen -r nexus

# To exit logs without stopping prover:
# Press Ctrl+A then D
```

**❌ Binary not found after update?**
```bash
# Check all possible locations
sudo find / -name "nexus-network" -type f 2>/dev/null

# If multiple found, use the latest one:
which nexus-network
```

## 💡 Pro Tips

- **🔄 Auto-restart enabled** - prover starts automatically after VPS reboot
- **📊 Monitor proving speed** in dashboard  
- **🔗 Link multiple servers** with different Node IDs
- **⚡ Higher specs = Higher earnings**
- **📱 Check leaderboard** for your ranking
- **🖥️ Use `screen` commands** for easy management
- **🔄 Easy updates** - installer handles version conflicts automatically
- **📦 Always check version** after updates with `nexus-status`
- **🧹 Clean installs** prevent conflicts with old versions

## 🆕 What's New in Version 2.3

- **🚫 FIXED: Version conflicts** - No more stuck on old 0.8.13
- **🧹 Smart cleanup** - Automatically removes old installations
- **🔄 Force latest** - Always pulls and installs newest version
- **📦 Version verification** - Checks version is actually updated
- **🛠️ Better error handling** - Clearer messages when things go wrong
- **📊 Enhanced status** - Shows version in status command
- **🔧 Improved scripts** - Management scripts show current version

## 🌐 Official Links

- **Dashboard:** [https://beta.nexus.xyz/](https://beta.nexus.xyz/)
- **Documentation:** [https://docs.nexus.xyz/](https://docs.nexus.xyz/)
- **Discord:** [https://discord.gg/nexus-xyz](https://discord.gg/nexus-xyz)
- **Twitter:** [https://twitter.com/nexus_xyz](https://twitter.com/nexus_xyz)

---

<div align="center">

**Made by [OveR (@Over9725)](https://twitter.com/Over9725) 💰**

*Optimizing crypto earning, one script at a time* 🚀

*Version 2.3 - No More Version Conflicts!* ✅

[![Follow on Twitter](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/Over9725)

</div>
