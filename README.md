## 💡 Pro Tips

- **🔄 Auto-restart enabled** - prover starts automatically after VPS reboot
- **📊 Monitor proving speed** in dashboard  
- **🔗 Link multiple servers** with different Node IDs
- **⚡ Higher specs = Higher earnings**
- **📱 Check leaderboard** for your ranking
- **🖥️ Use `screen` commands** for easy management
- **🔄 Easy updates** - just re-run installer to get latest version# 🚀 Nexus Network Prover Auto-Installer

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
# Check if prover is running
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
4. **Enter your Node ID** (shown during installation)
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

# Check status
nexus-status

# View live logs
screen -r nexus

# Detach from logs (prover keeps running)
# Press: Ctrl+A then D

# Check your Node ID
cat ~/.nexus/config.json | grep node_id
```

## 🔄 Updating Your Node

### **Update to Latest Version:**
```bash
# Stop current prover
nexus-stop

# Re-run installer (keeps your Node ID and settings)
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/install.sh | bash

# Your Node ID will be preserved automatically
```

### **Manual Binary Update:**
```bash
# If you just want to update the binary without full reinstall
nexus-stop
cd ~/.nexus/network-api && git pull
cd clients/cli && cargo build --release
sudo cp target/release/nexus-network /usr/local/bin/
nexus-start
```

### **Check Version:**
```bash
/usr/local/bin/nexus-network --version
```

### **Troubleshoot After Update:**
```bash
# If prover doesn't start after update
nexus-stop
rm -rf ~/.nexus/network-api
# Then re-run full installer
```

## 🔍 Troubleshooting

**Not earning points?**
```bash
# Check if prover is running
nexus-status

# Check Node ID is linked at https://beta.nexus.xyz/

# View logs for errors
screen -r nexus
```

**Prover stopped working?**
```bash
# Restart the prover
nexus-stop
nexus-start

# Check status
nexus-status
```

**Need to see what's happening?**
```bash
# View live logs
screen -r nexus

# To exit logs without stopping prover:
# Press Ctrl+A then D
```

## 🌐 Official Links

- **Dashboard:** [https://beta.nexus.xyz/](https://beta.nexus.xyz/)
- **Documentation:** [https://docs.nexus.xyz/](https://docs.nexus.xyz/)
- **Discord:** [https://discord.gg/nexus-xyz](https://discord.gg/nexus-xyz)
- **Twitter:** [https://twitter.com/nexus_xyz](https://twitter.com/nexus_xyz)

---

<div align="center">

**Made by [OveR (@Over9725)](https://twitter.com/Over9725) 💰**

*Optimizing crypto earning, one script at a time* 🚀

[![Follow on Twitter](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/Over9725)

</div>
