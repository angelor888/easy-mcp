#!/bin/bash

# Claude Code Auto-Start Installer
# This script sets up automatic startup for Claude Code with all dependencies

set -e

echo "🚀 Claude Code Auto-Start Installer"
echo "==================================="
echo ""

# Get the installation directory
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "📁 Installation directory: $INSTALL_DIR"

# Check prerequisites
echo ""
echo "🔍 Checking prerequisites..."

# Check Claude CLI
if ! command -v claude &> /dev/null; then
    echo "❌ Claude CLI not found. Please install Claude Code first."
    echo "   Visit: https://claude.ai/download"
    exit 1
else
    echo "✅ Claude CLI found"
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker Desktop first."
    echo "   Visit: https://www.docker.com/products/docker-desktop"
    exit 1
else
    echo "✅ Docker found"
fi

# Check if easy-mcp directory exists
if [ ! -f "$INSTALL_DIR/docker-compose.yml" ]; then
    echo "❌ This doesn't appear to be the easy-mcp directory."
    echo "   Please run this script from the easy-mcp repository."
    exit 1
else
    echo "✅ Easy-MCP repository confirmed"
fi

# Update paths in scripts
echo ""
echo "📝 Configuring scripts..."

# Create a temporary copy of the startup script with correct paths
cp "$INSTALL_DIR/auto-start/scripts/claude-complete-startup.sh" "$INSTALL_DIR/auto-start/scripts/claude-complete-startup.sh.tmp"
sed -i '' "s|~/easy-mcp|$INSTALL_DIR|g" "$INSTALL_DIR/auto-start/scripts/claude-complete-startup.sh.tmp"

# Make scripts executable
chmod +x "$INSTALL_DIR/auto-start/scripts/"*.sh
echo "✅ Scripts configured"

# Install launch agent
echo ""
echo "🚀 Installing launch agent..."

# Create launch agent with correct paths
cat > ~/Library/LaunchAgents/com.duetright.claude-complete.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.duetright.claude-complete</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$INSTALL_DIR/auto-start/scripts/claude-complete-startup.sh</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>KeepAlive</key>
    <false/>
    
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/claude-complete.log</string>
    
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/claude-complete-error.log</string>
    
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
</dict>
</plist>
EOF

# Unload any existing agent
launchctl unload ~/Library/LaunchAgents/com.duetright.claude-complete.plist 2>/dev/null || true

# Load the new agent
launchctl load ~/Library/LaunchAgents/com.duetright.claude-complete.plist
echo "✅ Launch agent installed"

# Create desktop shortcut
echo ""
echo "🖥️  Creating desktop shortcut..."
cat > ~/Desktop/Claude-Code.command << EOF
#!/bin/bash
# Claude Code Complete Startup
# This ensures Docker and MCP services are running

echo "🚀 Starting Claude Code with all services..."
bash $INSTALL_DIR/auto-start/scripts/claude-complete-startup.sh
EOF
chmod +x ~/Desktop/Claude-Code.command
echo "✅ Desktop shortcut created"

# Create Applications shortcut
echo ""
echo "📁 Creating Applications shortcut..."
mkdir -p ~/Applications
cp ~/Desktop/Claude-Code.command ~/Applications/
echo "✅ Applications shortcut created"

# Create Spotlight app
echo ""
echo "🔍 Creating Spotlight app..."
bash "$INSTALL_DIR/auto-start/scripts/create-claude-app.sh"
echo "✅ Spotlight app created"

# Add terminal aliases
echo ""
echo "⌨️  Adding terminal shortcuts..."

# Add to .zshrc if not already present
if ! grep -q "alias cc=" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Claude Code shortcuts" >> ~/.zshrc
    echo "alias cc='cd $INSTALL_DIR && claude'" >> ~/.zshrc
    echo "alias claude-mcp='cd $INSTALL_DIR && claude'" >> ~/.zshrc
    echo "alias claude-status='bash $INSTALL_DIR/auto-start/scripts/claude-status.sh'" >> ~/.zshrc
    echo "✅ Terminal shortcuts added to ~/.zshrc"
else
    echo "✅ Terminal shortcuts already configured"
fi

# Also add to .zprofile for login shells
if ! grep -q "alias cc=" ~/.zprofile 2>/dev/null; then
    echo "" >> ~/.zprofile
    echo "# Claude Code shortcuts" >> ~/.zprofile
    echo "alias cc='cd $INSTALL_DIR && claude'" >> ~/.zprofile
    echo "alias claude-mcp='cd $INSTALL_DIR && claude'" >> ~/.zprofile
    echo "alias claude-status='bash $INSTALL_DIR/auto-start/scripts/claude-status.sh'" >> ~/.zprofile
fi

# Clean up temporary files
rm -f "$INSTALL_DIR/auto-start/scripts/claude-complete-startup.sh.tmp"

# Run status check
echo ""
echo "🔍 Running status check..."
bash "$INSTALL_DIR/auto-start/scripts/claude-status.sh"

echo ""
echo "==================================="
echo "✅ Installation Complete!"
echo ""
echo "🎯 You now have:"
echo "   • Auto-start on login"
echo "   • Desktop shortcut (Claude-Code.command)"
echo "   • Spotlight search (search for 'Claude Code')"
echo "   • Terminal commands: cc, claude-mcp, claude-status"
echo ""
echo "💡 Tips:"
echo "   • Drag Claude-Code.command to your Dock for easy access"
echo "   • Make sure Docker Desktop is set to start on login"
echo "   • Check logs at ~/Library/Logs/claude-complete.log"
echo ""
echo "🚀 Start Claude Code now with: cc"
echo "==================================="