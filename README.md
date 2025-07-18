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
║                Version 2.4 OPTIMIZED - BALANCED PERFORMANCE  ║
╚═══════════════════════════════════════════════════════════════╝
```

**💰 Automatically installs and optimizes Nexus Network Prover for NEX Points farming**

**🔥 Version 2.4 OPTIMIZED - 3x smaller code, same functionality, bot-friendly balanced mode**

[![Follow @Over9725](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?logo=twitter)](https://twitter.com/Over9725)

</div>

## 🎯 What This Script Does

- **🔍 Auto-detects** your server specs and optimizes accordingly
- **💰 Installs Nexus Network Prover** for earning NEX Points
- **⚡ BALANCED performance mode** - targets 70-80% CPU usage
- **🤖 Bot-friendly** - reserves 25% system resources for other tasks
- **🔧 Easy commands** (`nexus-start`, `nexus-stop`, `nexus-status`, `nexus-monitor`)
- **🔄 Auto-restart after VPS reboot** configured
- **📊 Performance tier classification** for optimal earnings
- **🚫 FIXED: Version conflicts** - Always installs latest version
- **🧹 Smart cleanup** - Removes old versions automatically
- **📈 Live performance monitoring** with color-coded status

## ⚡ One-Click Installation

```bash
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/nexus-install.sh | bash
```

## 🖥️ Requirements

- **Linux** (Ubuntu, Debian, CentOS, Fedora, Arch)
- **2+ CPU cores, 4+ GB RAM, 10+ GB disk**
- **sudo privileges**
- **Stable internet connection**

## 💰 After Installation

```bash
# Check if prover is running with performance stats
nexus-status

# Live performance monitoring (new!)
nexus-monitor

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

## 🏆 Performance Tiers (Balanced Mode)

| Server Type | Specs | Expected Speed | CPU Target | Earning Potential |
|-------------|-------|----------------|------------|-------------------|
| 🔥 **HIGH_END** | 16+ cores, 32+ GB | 1000+ Hz | 70-80% (12-13 cores) | **Top 10%** |
| ⚡ **PERFORMANCE** | 8+ cores, 16+ GB | 500-1000 Hz | 70-80% (6-7 cores) | **Top 25%** |
| 🚀 **STANDARD** | 4+ cores, 8+ GB | 100-500 Hz | 70-80% (3 cores) | **Top 50%** |
| 💻 **BASIC** | 2+ cores, 4+ GB | 50-100 Hz | 70-80% (1-2 cores) | **Participant** |

*🤖 **Bot-Friendly**: Always reserves 25% resources for other processes*  
*Higher Hz = More NEX Points earned*

## 🛠️ Management Commands

```bash
# Start prover (balanced mode)
nexus-start

# Stop prover  
nexus-stop

# Check status with performance metrics
nexus-status

# Live performance monitor (NEW!)
nexus-monitor

# View live logs
screen -r nexus

# Detach from logs (prover keeps running)
# Press: Ctrl+A then D

# Check installed version
nexus-network --version

# Check your Node ID
cat ~/.nexus/config.json | grep node_id
```

## 📊 New Performance Monitoring

### **Live Status Check:**
```bash
nexus-status
```
**Example Output:**
```
⚡ NEXUS BALANCED MODE STATUS (Bot-Friendly)
════════════════════════════════════════════
📦 Version: nexus-network 0.10.0
📍 Binary: /usr/local/bin/nexus-network

✅ Nexus prover is running in BALANCED mode
⚡ CPU Usage: 75.2%
🧠 RAM Usage: 12.4%
🎯 Priority: -10 (moderate priority)
🖥️  CPU Cores: 0-5 (6/8 cores, leaving 2 for other tasks)
📊 System Load: 2.1
🔥 PID: 12345

📈 Performance Status:
   🔥 EXCELLENT - Target CPU utilization achieved (70-80%+)!

🤖 Bot-Friendly Status:
   Reserved CPU cores: 2 for other processes
   System load: 2.1 (should be < 8 for good performance)
```

### **Live Performance Monitor:**
```bash
nexus-monitor
```
**Real-time output:**
```
⚡ NEXUS BALANCED PERFORMANCE MONITOR
=====================================
Target: 70-80% CPU usage (bot-friendly)
Press Ctrl+C to exit

14:25:33 | CPU: 76.4% | RAM: 12.1% | Load: 2.0 | Temp: 65°C | 🔥 OPTIMAL
14:25:36 | CPU: 78.1% | RAM: 12.3% | Load: 2.1 | Temp: 66°C | 🔥 OPTIMAL
14:25:39 | CPU: 74.7% | RAM: 12.0% | Load: 1.9 | Temp: 64°C | 🔥 OPTIMAL
```

## 🔄 Updating Your Node

### **🚀 Easy Update (Recommended):**
```bash
# Just re-run the installer - it will:
# ✅ Clean old versions automatically
# ✅ Install latest version with balanced optimizations
# ✅ Keep your Node ID and settings
# ✅ Fix any version conflicts

curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/nexus-install.sh | bash
```

### **📦 Check Version After Update:**
```bash
# All these should show the SAME latest version now:
nexus-network --version
/usr/local/bin/nexus-network --version
nexus-status
```

## 🔍 Troubleshooting

**❌ Not earning points?**
```bash
# 1. Check if prover is running with performance stats
nexus-status

# 2. Check Node ID is linked at https://beta.nexus.xyz/

# 3. View logs for errors
screen -r nexus

# 4. Monitor live performance
nexus-monitor
```

**❌ Low CPU usage (below 70%)?**
```bash
# Check if Nexus has available tasks
nexus-monitor

# Wait 10-15 minutes for ramping up
# If still low, may be network-side task shortage
```

**❌ CPU usage too high (affecting other processes)?**
```bash
# Balanced mode automatically limits to 75% of cores
# Check system load in nexus-status
# If needed, restart for optimal balance
nexus-stop && nexus-start
```

**❌ Prover stopped working?**
```bash
# Restart the prover
nexus-stop
nexus-start

# Check status with performance metrics
nexus-status
```

**❌ Version conflicts?**
```bash
# Re-run installer to fix conflicts
curl -sSL https://raw.githubusercontent.com/Overbafer999/nexus-install.sh/main/nexus-install.sh | bash
```

## 💡 Pro Tips

- **📊 Monitor target: 70-80% CPU** for optimal farming vs system stability
- **🤖 Bot-friendly design** - always leaves resources for other processes  
- **🔄 Auto-restart enabled** - prover starts automatically after VPS reboot
- **📈 Use `nexus-monitor`** for real-time performance tracking
- **🎯 Color-coded status** - Green = optimal, Yellow = good, Red = low
- **⚡ Balanced priority (-10)** - high performance without system lockup
- **🔗 Link multiple servers** with different Node IDs
- **📱 Check leaderboard** for your ranking
- **🖥️ Reserved cores** - 25% always available for bots/other tasks
- **📦 Temperature monitoring** - keeps track of system health

## 🆕 What's New in Version 2.4 OPTIMIZED

- **⚡ BALANCED PERFORMANCE MODE** - Targets 70-80% CPU usage
- **🤖 BOT-FRIENDLY OPTIMIZATIONS** - Reserves 25% resources for other tasks  
- **📊 LIVE PERFORMANCE MONITORING** - Real-time CPU/RAM/temp tracking
- **🎯 COLOR-CODED STATUS** - Visual indicators for performance levels
- **🖥️ SMART CPU ALLOCATION** - Uses 75% of cores, leaves rest free
- **📈 ENHANCED STATUS COMMAND** - Detailed performance metrics
- **🔧 MODERATE PRIORITY (-10)** - High performance without system takeover
- **💻 TEMPERATURE MONITORING** - System health tracking
- **📊 LOAD BALANCING** - Optimal resource distribution
- **🛡️ SYSTEM STABILITY** - Prevents resource exhaustion
- **🚀 CODE OPTIMIZED** - 3x smaller script, same functionality
- **⚡ FASTER EXECUTION** - Streamlined installation process

## 🤖 Bot-Friendly Features

### **Resource Allocation:**
- **CPU Cores**: Uses 75% (e.g., 6 of 8 cores), reserves 25% for bots
- **Priority**: Moderate (-10) instead of maximum (-20)
- **Memory**: Conservative limits to prevent OOM
- **I/O**: Balanced priority, doesn't monopolize disk

### **Perfect for Multi-Service VPS:**
```bash
# Example on 8-core server:
# Nexus: Uses cores 0-5 (6 cores, 75%)
# Bot: Uses cores 6-7 (2 cores, 25%)
# Both run smoothly without interference!
```

### **Monitor Both Services:**
```bash
# Check Nexus performance
nexus-status

# Check overall system load
htop

# Live monitor Nexus impact
nexus-monitor
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

*Version 2.4 OPTIMIZED - Balanced Performance & Bot-Friendly!* ⚡🤖

[![Follow on Twitter](https://img.shields.io/badge/Follow-@Over9725-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/Over9725)

</div>
