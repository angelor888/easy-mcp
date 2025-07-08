# 🖥️ Easy-MCP Mac mini Setup Guide

Complete guide for setting up the Easy-MCP environment on a new Mac mini, migrating from an existing Mac setup.

## 📋 Pre-Installation Checklist

Before starting, ensure your Mac mini has:
- [ ] macOS 10.14 or later
- [ ] At least 8GB RAM (16GB recommended)
- [ ] 20GB free disk space
- [ ] Admin access to install software
- [ ] Internet connection

## 🚀 Step-by-Step Installation

### Step 1: Install Core Dependencies

```bash
# 1. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install Git
brew install git

# 3. Configure Git with your credentials
git config --global user.name "Angelo Russoniello"
git config --global user.email "angelo@duetright.com"
```

### Step 2: Install Docker Desktop

1. Download Docker Desktop for Mac from: https://www.docker.com/products/docker-desktop
2. Install and launch Docker Desktop
3. Configure Docker settings:
   - Open Docker Desktop → Settings
   - General: Enable "Start Docker Desktop when you log in"
   - Resources: Allocate at least 4GB RAM
   - Advanced: Enable "Use Docker Compose V2"

### Step 3: Install Claude Code

1. Download Claude Code from: https://claude.ai/download
2. Install the application
3. Verify installation:
   ```bash
   which claude
   # Should output: /usr/local/bin/claude or similar
   ```

### Step 4: Clone and Setup Easy-MCP

```bash
# 1. Clone the repository
cd ~
git clone https://github.com/angelor888/easy-mcp.git
cd easy-mcp

# 2. Run automatic setup
./start.sh

# This will:
# - Check all dependencies
# - Create necessary config files
# - Start Docker services
# - Configure MCP servers
```

### Step 5: Configure Secrets and Environment

```bash
# 1. Create secrets directory files
cp secrets/mcp_secret.txt.example secrets/mcp_secret.txt
cp secrets/filesystem_key.txt.example secrets/filesystem_key.txt

# 2. Generate secure keys
echo "$(openssl rand -hex 32)" > secrets/mcp_secret.txt
echo "$(openssl rand -hex 32)" > secrets/filesystem_key.txt

# 3. Create environment file (optional - defaults work fine)
cp .env.example .env
```

### Step 6: Configure Claude Desktop

```bash
# 1. Create Claude config directory if it doesn't exist
mkdir -p ~/Library/Application\ Support/Claude

# 2. Copy configuration
cp claude_desktop_config.json.example ~/Library/Application\ Support/Claude/claude_desktop_config.json

# 3. Verify the configuration
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Step 7: Install Auto-Start Feature

```bash
# Run the auto-start installer
cd ~/easy-mcp
bash auto-start/install.sh

# This installs:
# - Launch agent for auto-start
# - Desktop shortcut
# - Spotlight app
# - Terminal aliases (cc, claude-status)
```

### Step 8: Verify Installation

```bash
# 1. Check Docker services
docker compose ps
# Should show 4 services running

# 2. Test Claude with MCP
cc
# Or navigate to easy-mcp and run: claude

# 3. Check system status
claude-status

# Expected output:
# ✅ Docker Desktop: Running
# ✅ MCP Services: 4/4 running
# ✅ Claude Desktop: Configured
# ✅ Auto-start: Enabled
```

## 🔄 Migration from Existing Mac

If you're migrating from another Mac with Easy-MCP already set up:

### Option 1: Fresh Installation (Recommended)
Follow the steps above for a clean setup.

### Option 2: Migration with Settings
```bash
# On your old Mac, backup settings:
cd ~/easy-mcp
tar -czf ~/Desktop/easy-mcp-backup.tar.gz \
  .env \
  secrets/*.txt \
  ~/Library/Application\ Support/Claude/claude_desktop_config.json

# On your Mac mini, after cloning:
cd ~/easy-mcp
tar -xzf ~/Desktop/easy-mcp-backup.tar.gz
```

## 🎯 Quick Access Methods

After installation, you can start Claude Code in multiple ways:

1. **Terminal**: Type `cc` from anywhere
2. **Desktop**: Double-click "Claude-Code.command" on Desktop
3. **Spotlight**: Press ⌘+Space and search "Claude Code"
4. **Dock**: Drag the desktop shortcut to your Dock

## 🔧 Customization Options

### Change Service Ports
Edit `.env` file if you have port conflicts:
```env
FILESYSTEM_PORT=8082
PUPPETEER_PORT=8084
MEMORY_PORT=8085
EVERYTHING_PORT=8086
```

### Disable Auto-Start
```bash
cd ~/easy-mcp
bash auto-start/uninstall.sh
```

### Add to PATH permanently
```bash
echo 'export PATH="$HOME/easy-mcp:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 🆘 Troubleshooting

### Docker won't start
1. Ensure virtualization is enabled in Mac mini
2. Restart your Mac mini
3. Reinstall Docker Desktop

### Services fail to start
```bash
# Stop all services
cd ~/easy-mcp
./stop.sh

# Remove old containers
docker compose down -v

# Start fresh
./start.sh
```

### Claude can't find MCP servers
1. Ensure Docker is running
2. Check services: `docker compose ps`
3. Restart Claude Desktop app

### Permission issues
```bash
# Fix script permissions
chmod +x ~/easy-mcp/*.sh
chmod +x ~/easy-mcp/auto-start/scripts/*.sh
```

## 📱 Remote Access Setup (Optional)

To access your Mac mini's MCP services remotely:

1. **Enable Remote Login**:
   - System Preferences → Sharing → Remote Login

2. **Set up SSH key**:
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

3. **Configure port forwarding** (when connecting):
   ```bash
   ssh -L 8082:localhost:8082 \
       -L 8084:localhost:8084 \
       -L 8085:localhost:8085 \
       -L 8086:localhost:8086 \
       user@mac-mini-ip
   ```

## 🎉 Setup Complete!

Your Mac mini is now configured with:
- ✅ Easy-MCP with all services
- ✅ Claude Code with MCP integration
- ✅ Auto-start on login
- ✅ Multiple access methods
- ✅ Full Docker containerization

Start using Claude with MCP by typing `cc` in Terminal!

## 📚 Additional Resources

- [Easy-MCP Documentation](https://github.com/angelor888/easy-mcp)
- [Claude Desktop Docs](https://docs.anthropic.com/claude/docs/claude-desktop)
- [MCP Specification](https://modelcontextprotocol.io/)
- [Docker Documentation](https://docs.docker.com/)

---

*Last updated: January 8, 2025*