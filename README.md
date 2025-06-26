# 🚀 Nexus Prover Auto-Installer

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
║           🚀 AUTO-OPTIMIZED INSTALLATION 🚀                   ║
║                 Made by OveR (@Over9725)                      ║
╚═══════════════════════════════════════════════════════════════╝
```

**⚡ Automatically detects your server and builds optimized Nexus Prover**

[![Follow @Over9725](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?logo=twitter)](https://twitter.com/Over9725)

</div>

## 🔥 What This Script Does

- **🎯 Auto-detects** your CPU, RAM, and system specs
- **⚡ Builds optimized binary** with native CPU flags (AVX2, FMA, etc.)
- **🚀 35-70% faster** than default builds
- **⚙️ Creates systemd service** with optimal settings
- **🔧 Configures everything** automatically

## ⚡ One-Click Installation

```bash
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-auto-installer/main/install.sh | bash
```

## 🖥️ Requirements

- **Linux** (Ubuntu, Debian, CentOS, Fedora, Arch)
- **2+ CPU cores, 4+ GB RAM, 20+ GB disk**
- **sudo privileges**

## 🚀 After Installation

```bash
# Start node
sudo systemctl start nexus-prover

# Check status
sudo systemctl status nexus-prover

# View logs
sudo journalctl -u nexus-prover -f
```

## 🔥 Performance Tiers

| Server Type | Specs | Optimization | Speed Boost |
|-------------|-------|--------------|-------------|
| 🔥 **HIGH_END** | 16+ cores, 32+ GB | Maximum LTO + native CPU | **35-50%** |
| ⚡ **PERFORMANCE** | 8+ cores, 16+ GB | Full LTO + optimizations | **25-35%** |
| 🚀 **STANDARD** | 4+ cores, 8+ GB | Balanced optimization | **15-25%** |
| 💻 **BASIC** | 2+ cores, 4+ GB | Conservative optimization | **10-15%** |

## 🛠️ Manual Commands

```bash
# Run node directly
/usr/local/bin/nexus-prover

# Enable auto-start
sudo systemctl enable nexus-prover

# Update node (re-run installer)
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-auto-installer/main/install.sh | bash
```

---

<div align="center">

**Made by [OveR (@Over9725)](https://twitter.com/Over9725) 🚀**

*Follow for more crypto optimization scripts*

</div>
