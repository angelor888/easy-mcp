#!/bin/bash

echo "Creating Claude Code as a Spotlight-searchable app..."

# Create app bundle structure
APP_DIR="$HOME/Applications/Claude Code.app"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Create the executable
cat > "$APP_DIR/Contents/MacOS/Claude Code" << 'EOF'
#!/bin/bash
# Open Terminal and run Claude Code
osascript << 'END'
tell application "Terminal"
    activate
    do script "cd ~/easy-mcp && clear && echo '🤖 Claude Code CLI' && echo '📁 Working in: ~/easy-mcp' && echo '' && claude"
end tell
END
EOF

chmod +x "$APP_DIR/Contents/MacOS/Claude Code"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Claude Code</string>
    <key>CFBundleIdentifier</key>
    <string>com.duetright.claudecode</string>
    <key>CFBundleName</key>
    <string>Claude Code</string>
    <key>CFBundleDisplayName</key>
    <string>Claude Code</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.10</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
EOF

echo "✅ Claude Code app created!"
echo ""
echo "🎯 You can now:"
echo "1. Open Spotlight (⌘ Space) and type 'Claude Code'"
echo "2. Find it in ~/Applications folder"
echo "3. Drag it to your Dock for one-click access"
echo ""
echo "🚀 The app will open Terminal and start Claude Code automatically!"