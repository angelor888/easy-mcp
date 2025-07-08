# Mac mini Easy-MCP Deployment Checklist

Quick reference for deploying the complete Easy-MCP system on a Mac mini.

## 🚀 One-Command Deployment

```bash
# From your Mac mini:
curl -fsSL https://raw.githubusercontent.com/angelor888/easy-mcp/main/mac-mini-deploy.sh | bash
```

Or clone first:
```bash
git clone https://github.com/angelor888/easy-mcp.git
cd easy-mcp
./mac-mini-deploy.sh
```

## ✅ Pre-Deployment Checklist

Before running the script, have ready:
- [ ] Mac mini with macOS 10.14+
- [ ] Admin password (for installations)
- [ ] Internet connection
- [ ] 20GB free disk space
- [ ] Apple ID (for App Store if needed)

## 📋 What Gets Installed

### Automatic Installations:
- [x] Homebrew package manager
- [x] Git version control
- [x] Easy-MCP repository
- [x] All configuration files
- [x] Auto-start features

### Manual Installations Required:
- [ ] Docker Desktop (opens download page)
- [ ] Claude Desktop (opens download page)

## 🔄 Deployment Process

1. **Run deployment script** → 5 min
2. **Install Docker Desktop manually** → 5 min
3. **Install Claude Desktop manually** → 5 min
4. **Script continues automatically** → 10 min
5. **Verification runs** → 2 min

**Total time: ~25-30 minutes**

## 🎯 Post-Deployment Verification

The script automatically runs verification, but you can check manually:

```bash
# Quick status check
claude-status

# Detailed verification
cd ~/easy-mcp
./verify-setup.sh

# Test Claude with MCP
cc
```

## 🚀 Daily Usage

After deployment, you have multiple ways to start Claude:

| Method | Command/Action |
|--------|---------------|
| Terminal anywhere | `cc` |
| Desktop | Double-click shortcut |
| Spotlight | Search "Claude Code" |
| Direct | `cd ~/easy-mcp && claude` |

## 🔧 Troubleshooting Quick Fixes

### Docker not starting:
```bash
open -a Docker
# Wait 30 seconds
cd ~/easy-mcp && ./start.sh
```

### Services not running:
```bash
cd ~/easy-mcp
./stop.sh
./start.sh
```

### Claude not finding MCP:
```bash
# Restart Claude Desktop
killall Claude || true
open -a Claude
```

### Permission issues:
```bash
cd ~/easy-mcp
chmod +x *.sh
chmod +x auto-start/scripts/*.sh
```

## 📱 Remote Management

To manage your Mac mini remotely:

```bash
# Enable SSH on Mac mini:
# System Preferences → Sharing → Remote Login

# From another Mac:
ssh username@mac-mini.local
cd ~/easy-mcp
claude-status
```

## 🆘 Getting Help

1. **Check logs**: `docker compose logs -f`
2. **Review guide**: `~/easy-mcp/docs/mac-mini-setup-guide.md`
3. **Run verification**: `./verify-setup.sh`
4. **GitHub issues**: https://github.com/angelor888/easy-mcp/issues

## ✨ Success Indicators

You know deployment succeeded when:
- ✅ `cc` command works from any directory
- ✅ Docker shows 4 services running
- ✅ Desktop shortcut launches Claude
- ✅ Spotlight finds "Claude Code"
- ✅ Services auto-start on reboot

---

**Pro tip**: Save time by downloading Docker Desktop and Claude Desktop installers beforehand!