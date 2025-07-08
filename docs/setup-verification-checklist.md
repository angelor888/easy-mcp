# ✅ Easy-MCP Setup Verification Checklist

Use this checklist to verify your Easy-MCP installation is complete and working correctly.

## 🔍 Quick Verification Commands

Run these commands in order to verify your setup:

```bash
# 1. Check Docker is running
docker --version && echo "✅ Docker installed" || echo "❌ Docker not found"

# 2. Check Claude CLI
which claude && echo "✅ Claude CLI installed" || echo "❌ Claude CLI not found"

# 3. Check Git
git --version && echo "✅ Git installed" || echo "❌ Git not found"

# 4. Check Easy-MCP directory
[ -d ~/easy-mcp ] && echo "✅ Easy-MCP cloned" || echo "❌ Easy-MCP not found"

# 5. Check Docker services
cd ~/easy-mcp && docker compose ps | grep -c "Up" | xargs -I {} sh -c '[ {} -eq 4 ] && echo "✅ All services running" || echo "❌ Some services not running"'

# 6. Check auto-start
[ -f ~/Library/LaunchAgents/com.duetright.claude-complete.plist ] && echo "✅ Auto-start enabled" || echo "❌ Auto-start not configured"

# 7. Check terminal alias
alias cc >/dev/null 2>&1 && echo "✅ Terminal shortcuts configured" || echo "❌ Terminal shortcuts not found"
```

## 📋 Manual Verification Checklist

### Prerequisites
- [ ] macOS version 10.14 or later
- [ ] At least 8GB RAM available
- [ ] 20GB free disk space

### Core Components
- [ ] Docker Desktop installed and running
- [ ] Claude Code CLI installed (`claude` command works)
- [ ] Git installed and configured
- [ ] Homebrew installed (optional but recommended)

### Easy-MCP Repository
- [ ] Repository cloned to `~/easy-mcp`
- [ ] All scripts are executable (`ls -la *.sh` shows -rwxr-xr-x)
- [ ] `.env` file exists (copied from `.env.example`)
- [ ] Secrets configured in `secrets/` directory

### Docker Services
- [ ] mcp-filesystem running on port 8082
- [ ] mcp-puppeteer running on port 8084
- [ ] mcp-memory running on port 8085
- [ ] mcp-everything running on port 8086

### Claude Configuration
- [ ] `claude_desktop_config.json` in `~/Library/Application Support/Claude/`
- [ ] Configuration points to correct service URLs
- [ ] Claude Desktop can connect to MCP services

### Auto-Start Features
- [ ] Launch agent installed (`~/Library/LaunchAgents/com.duetright.claude-complete.plist`)
- [ ] Desktop shortcut created (`~/Desktop/Claude-Code.command`)
- [ ] Spotlight app installed (`~/Applications/Claude Code.app`)
- [ ] Terminal aliases work (`cc`, `claude-mcp`, `claude-status`)

### Functionality Tests
- [ ] Can start Claude with `cc` command
- [ ] Claude shows MCP tools available
- [ ] Docker services remain running after restart
- [ ] Auto-start works on system login

## 🧪 Service Health Check

Run this comprehensive health check:

```bash
#!/bin/bash
# Save as check-health.sh and run

echo "🔍 Easy-MCP Health Check"
echo "========================"

# Function to check command exists
check_command() {
    if command -v $1 &> /dev/null; then
        echo "✅ $2 is installed"
        return 0
    else
        echo "❌ $2 is not installed"
        return 1
    fi
}

# Check prerequisites
echo -e "\n📋 Prerequisites:"
check_command docker "Docker"
check_command claude "Claude CLI"
check_command git "Git"

# Check Easy-MCP
echo -e "\n📁 Easy-MCP Installation:"
if [ -d ~/easy-mcp ]; then
    echo "✅ Easy-MCP directory exists"
    cd ~/easy-mcp
    
    # Check services
    echo -e "\n🐳 Docker Services:"
    if docker compose ps | grep -q "Up"; then
        docker compose ps --format "table {{.Service}}\t{{.Status}}\t{{.Ports}}"
    else
        echo "❌ No services running"
    fi
else
    echo "❌ Easy-MCP not found at ~/easy-mcp"
fi

# Check auto-start
echo -e "\n🚀 Auto-Start Configuration:"
if [ -f ~/Library/LaunchAgents/com.duetright.claude-complete.plist ]; then
    echo "✅ Launch agent installed"
else
    echo "❌ Launch agent not found"
fi

if [ -f ~/Desktop/Claude-Code.command ]; then
    echo "✅ Desktop shortcut exists"
else
    echo "❌ Desktop shortcut not found"
fi

# Check Claude config
echo -e "\n⚙️ Claude Configuration:"
if [ -f ~/Library/Application\ Support/Claude/claude_desktop_config.json ]; then
    echo "✅ Claude config exists"
else
    echo "❌ Claude config not found"
fi

echo -e "\n✨ Health check complete!"
```

## 🚨 Common Issues and Fixes

### 1. Docker services not starting
```bash
cd ~/easy-mcp
./stop.sh
docker compose down -v
./start.sh
```

### 2. Claude can't find MCP tools
- Restart Claude Desktop app
- Verify `claude_desktop_config.json` has correct URLs
- Check Docker services are running

### 3. Auto-start not working
```bash
cd ~/easy-mcp
bash auto-start/uninstall.sh
bash auto-start/install.sh
```

### 4. Port conflicts
Edit `.env` file to change ports:
```env
FILESYSTEM_PORT=8182  # Changed from 8082
PUPPETEER_PORT=8184   # Changed from 8084
```

## 🎯 Success Criteria

Your setup is successful when:
1. ✅ All Docker services show "Up" status
2. ✅ `cc` command launches Claude from any directory
3. ✅ Claude Desktop shows MCP tools available
4. ✅ Services automatically start on Mac login
5. ✅ No error messages in Docker logs

## 📞 Getting Help

If verification fails:
1. Check the [Mac mini Setup Guide](mac-mini-setup-guide.md)
2. Review [Troubleshooting Guide](../README.md#-troubleshooting)
3. Check Docker logs: `docker compose logs -f`
4. Verify prerequisites are installed

---

*Use this checklist after installation to ensure everything is working correctly!*