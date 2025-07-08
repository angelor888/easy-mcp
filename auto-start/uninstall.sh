#!/bin/bash

# Claude Code Auto-Start Uninstaller
# This script removes all auto-start components

set -e

echo "🗑️  Claude Code Auto-Start Uninstaller"
echo "======================================"
echo ""
echo "This will remove:"
echo "  • Launch agent (auto-start on login)"
echo "  • Desktop shortcut"
echo "  • Applications shortcut" 
echo "  • Spotlight app"
echo "  • Terminal aliases"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstall cancelled"
    exit 0
fi

echo ""
echo "🔧 Removing components..."

# Unload and remove launch agent
echo ""
echo "📋 Removing launch agent..."
if [ -f ~/Library/LaunchAgents/com.duetright.claude-complete.plist ]; then
    launchctl unload ~/Library/LaunchAgents/com.duetright.claude-complete.plist 2>/dev/null || true
    rm ~/Library/LaunchAgents/com.duetright.claude-complete.plist
    echo "✅ Launch agent removed"
else
    echo "⚠️  Launch agent not found"
fi

# Remove desktop shortcut
echo ""
echo "🖥️  Removing desktop shortcut..."
if [ -f ~/Desktop/Claude-Code.command ]; then
    rm ~/Desktop/Claude-Code.command
    echo "✅ Desktop shortcut removed"
else
    echo "⚠️  Desktop shortcut not found"
fi

# Remove Applications shortcut
echo ""
echo "📁 Removing Applications shortcut..."
if [ -f ~/Applications/Claude-Code.command ]; then
    rm ~/Applications/Claude-Code.command
    echo "✅ Applications shortcut removed"
else
    echo "⚠️  Applications shortcut not found"
fi

# Remove Spotlight app
echo ""
echo "🔍 Removing Spotlight app..."
if [ -d ~/Applications/Claude\ Code.app ]; then
    rm -rf ~/Applications/Claude\ Code.app
    echo "✅ Spotlight app removed"
else
    echo "⚠️  Spotlight app not found"
fi

# Remove terminal aliases
echo ""
echo "⌨️  Removing terminal aliases..."

# Function to remove aliases from a file
remove_aliases() {
    local file=$1
    if [ -f "$file" ]; then
        # Create backup
        cp "$file" "$file.backup"
        
        # Remove Claude Code related lines
        sed -i '' '/# Claude Code shortcuts/d' "$file"
        sed -i '' '/alias cc=/d' "$file"
        sed -i '' '/alias claude-mcp=/d' "$file"
        sed -i '' '/alias claude-status=/d' "$file"
        
        echo "✅ Removed aliases from $file"
    fi
}

remove_aliases ~/.zshrc
remove_aliases ~/.zprofile
remove_aliases ~/.bashrc
remove_aliases ~/.bash_profile

# Remove logs
echo ""
echo "📄 Cleaning up logs..."
rm -f ~/Library/Logs/claude-complete.log
rm -f ~/Library/Logs/claude-complete-error.log
echo "✅ Logs removed"

echo ""
echo "======================================"
echo "✅ Uninstall Complete!"
echo ""
echo "📝 Notes:"
echo "   • Auto-start has been disabled"
echo "   • Your easy-mcp repository is untouched"
echo "   • Docker and MCP services remain installed"
echo "   • Claude Code CLI remains installed"
echo ""
echo "To reinstall auto-start later:"
echo "   cd ~/easy-mcp && bash auto-start/install.sh"
echo "======================================"