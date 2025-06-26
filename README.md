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
╚═══════════════════════════════════════════════════════════════╝
```

**💰 Automatically installs and optimizes Nexus Network Prover for NEX Points farming**

[![Follow @Over9725](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?logo=twitter)](https://twitter.com/Over9725)

</div>

## 🎯 What This Script Does

- **🔍 Auto-detects** your server specs and optimizes accordingly
- **💰 Installs Nexus Network Prover** for earning NEX Points
- **⚡ Creates optimized systemd service** with performance tweaks
- **🔧 Handles Node ID configuration** for account linking
- **🚀 Dual installation methods** (official + backup)
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
# Start earning NEX Points
sudo systemctl start nexus-prover

# Enable 24/7 auto-start
sudo systemctl enable nexus-prover

# Check earning status
sudo systemctl status nexus-prover

# View proving logs
sudo journalctl -u nexus-prover -f
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

## 🛠️ Manual Commands

```bash
# Check your Node ID
cat ~/.nexus/config.json

# Restart prover
sudo systemctl restart nexus-prover

# Stop earning (not recommended!)
sudo systemctl stop nexus-prover

# Update to latest version (re-run installer)
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/install.sh | bash
```

## 💡 Pro Tips

- **🔄 Keep VPS running 24/7** for maximum NEX Points
- **📊 Monitor proving speed** in dashboard
- **🔗 Link multiple servers** with different Node IDs
- **⚡ Higher specs = Higher earnings**
- **📱 Check leaderboard** for your ranking

## 🔍 Troubleshooting

**Not earning points?**
```bash
# Check if Node ID is linked
# Go to https://beta.nexus.xyz/ → Account → Nodes

# Check service status
sudo systemctl status nexus-prover

# Check logs for errors
sudo journalctl -u nexus-prover -n 50
```

**Low proving speed?**
- Upgrade VPS specs (more CPU/RAM)
- Check network connection
- Ensure no other heavy processes running

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
