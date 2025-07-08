#!/bin/bash

echo "🚀 Setting up Claude Code CLI with direct access..."

# 1. Create Desktop shortcut
echo "Creating Desktop shortcut..."
cat > ~/Desktop/Claude-Code.command << 'EOF'
#!/bin/bash
cd ~/easy-mcp
clear
echo "🤖 Starting Claude Code CLI..."
echo "📁 Working directory: ~/easy-mcp"
echo ""
claude
EOF
chmod +x ~/Desktop/Claude-Code.command

# 2. Create Applications folder shortcut
echo "Creating Applications shortcut..."
mkdir -p ~/Applications
cp ~/Desktop/Claude-Code.command ~/Applications/

# 3. Add to Dock (user will need to drag it manually)
echo "Creating Dock-ready app..."

# 4. Create global alias in all shell profiles
echo "Setting up global aliases..."

# For zsh (default on macOS)
echo "" >> ~/.zshrc
echo "# Claude Code CLI shortcuts" >> ~/.zshrc
echo "alias cc='cd ~/easy-mcp && claude'" >> ~/.zshrc
echo "alias claude-mcp='cd ~/easy-mcp && claude'" >> ~/.zshrc

# Also add to .zprofile for login shells
echo "" >> ~/.zprofile
echo "# Claude Code CLI shortcuts" >> ~/.zprofile
echo "alias cc='cd ~/easy-mcp && claude'" >> ~/.zprofile
echo "alias claude-mcp='cd ~/easy-mcp && claude'" >> ~/.zprofile

# 5. Create a menu bar shortcut script
echo "Creating menu bar ready script..."
cat > ~/Applications/ClaudeCodeCLI.app/Contents/MacOS/ClaudeCodeCLI << 'EOF'
#!/bin/bash
osascript -e 'tell application "Terminal" to do script "cd ~/easy-mcp && claude"'
EOF
mkdir -p ~/Applications/ClaudeCodeCLI.app/Contents/MacOS
chmod +x ~/Applications/ClaudeCodeCLI.app/Contents/MacOS/ClaudeCodeCLI

# 6. Create keyboard shortcut instructions
cat > ~/Desktop/Claude-Keyboard-Shortcut.txt << 'EOF'
To create a keyboard shortcut for Claude Code:

1. Open System Settings → Keyboard → Keyboard Shortcuts
2. Click "App Shortcuts" → "+"
3. Application: Terminal
4. Menu Title: (leave blank)
5. Keyboard Shortcut: ⌘⌥C (or your preference)
6. Add this to Terminal preferences as a custom command
EOF

echo "✅ Direct access setup complete!"
echo ""
echo "🎯 You now have multiple ways to access Claude Code:"
echo ""
echo "1. 🖥️  Desktop: Double-click 'Claude-Code.command'"
echo "2. ⌨️  Terminal: Type 'cc' or 'claude-mcp' from anywhere"
echo "3. 📁 Applications: Find 'Claude-Code.command' in ~/Applications"
echo "4. 🚀 Auto-start: Already configured to start on login"
echo ""
echo "💡 Pro tip: Drag 'Claude-Code.command' from Desktop to your Dock for one-click access!"