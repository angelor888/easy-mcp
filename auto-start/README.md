# 🚀 Claude Code Auto-Start Setup

Automatically start Claude Code with Docker and all MCP services when your Mac starts up.

## ✨ Features

- **Automatic Startup**: Claude Code launches on system boot
- **Service Management**: Ensures Docker and MCP services are running
- **Multiple Access Methods**: Desktop shortcuts, Spotlight search, terminal commands
- **Health Monitoring**: Built-in status checking
- **Easy Installation**: One-command setup

## 📋 Prerequisites

Before installing, ensure you have:
- macOS 10.10 or later
- Claude Code CLI installed (`claude` command available)
- Docker Desktop installed
- Easy-MCP repository cloned

## 🚀 Quick Install

```bash
cd ~/easy-mcp
bash auto-start/install.sh
```

That's it! The installer will set up everything automatically.

## 🛠️ What Gets Installed

### 1. **Launch Agent**
- Automatically starts Claude Code on login
- Manages Docker and MCP services startup
- Location: `~/Library/LaunchAgents/com.duetright.claude-complete.plist`

### 2. **Desktop Shortcut**
- Double-click icon on Desktop to start Claude
- Name: `Claude-Code.command`

### 3. **Spotlight App**
- Search "Claude Code" in Spotlight (⌘ Space)
- Location: `~/Applications/Claude Code.app`

### 4. **Terminal Shortcuts**
- `cc` - Start Claude Code from anywhere
- `claude-mcp` - Alternative command
- `claude-status` - Check system status

### 5. **Service Management**
- Automatic Docker startup check
- MCP containers management (filesystem, puppeteer, memory, everything)
- Health monitoring and logging

## 📖 Manual Installation

If you prefer to install manually:

### Step 1: Install Launch Agent
```bash
cp auto-start/launch-agents/com.duetright.claude-complete.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.duetright.claude-complete.plist
```

### Step 2: Create Desktop Shortcut
```bash
cp auto-start/templates/Claude-Code.command ~/Desktop/
chmod +x ~/Desktop/Claude-Code.command
# Edit the file to replace __INSTALL_PATH__ with your easy-mcp path
```

### Step 3: Install Terminal Shortcuts
```bash
echo "alias cc='cd ~/easy-mcp && claude'" >> ~/.zshrc
echo "alias claude-mcp='cd ~/easy-mcp && claude'" >> ~/.zshrc
source ~/.zshrc
```

### Step 4: Create Spotlight App
```bash
bash auto-start/scripts/create-claude-app.sh
```

## 🔧 Configuration

### Docker Auto-Start
Ensure Docker starts automatically:
1. Open Docker Desktop
2. Settings → General
3. Enable "Start Docker Desktop when you log in"

### Customizing Startup
Edit `~/easy-mcp/auto-start/scripts/claude-complete-startup.sh` to:
- Add additional services
- Change startup behavior
- Modify wait times

## 📊 Status Checking

Check if everything is running:
```bash
claude-status
```

Or manually:
```bash
bash ~/easy-mcp/auto-start/scripts/claude-status.sh
```

Expected output:
```
✅ Docker Desktop: Running
✅ MCP Services: 4/4 running
✅ Claude Desktop: Running
✅ Auto-start: Enabled
✅ Terminal shortcuts: Configured
```

## 🗑️ Uninstall

To remove auto-start:
```bash
cd ~/easy-mcp
bash auto-start/uninstall.sh
```

Or manually:
```bash
# Remove launch agent
launchctl unload ~/Library/LaunchAgents/com.duetright.claude-complete.plist
rm ~/Library/LaunchAgents/com.duetright.claude-complete.plist

# Remove shortcuts
rm ~/Desktop/Claude-Code.command
rm -rf ~/Applications/Claude\ Code.app
```

## 🔍 Troubleshooting

### Claude doesn't start automatically
1. Check if launch agent is loaded:
   ```bash
   launchctl list | grep claude
   ```
2. Check logs:
   ```bash
   tail -f ~/Library/Logs/claude-complete.log
   ```

### Docker not starting
1. Ensure Docker Desktop is set to start on login
2. Check Docker Desktop preferences
3. Try starting manually: `open -a Docker`

### MCP services not running
1. Check Docker is running first
2. Manually start services:
   ```bash
   cd ~/easy-mcp
   docker compose up -d
   ```

### Permission issues
1. Ensure scripts are executable:
   ```bash
   chmod +x ~/easy-mcp/auto-start/scripts/*.sh
   ```

## 📝 Logs

Startup logs are available at:
- Main log: `~/Library/Logs/claude-complete.log`
- Error log: `~/Library/Logs/claude-complete-error.log`

## 🤝 Contributing

To improve the auto-start setup:
1. Edit scripts in `auto-start/scripts/`
2. Test thoroughly
3. Submit a pull request

## 📄 License

Part of the Easy-MCP project. See main repository for license details.