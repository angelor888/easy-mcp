# Claude Code Installation Guide for Mac mini

## 🚀 Quick Overview
Claude Code is an AI coding assistant that lives in your terminal, understands your codebase, and helps you code faster through natural language commands.

**GitHub User**: @angelor888 (DuetRight LLC)  
**Location**: Seattle

---

## 📋 Prerequisites

### Required Software:
1. **macOS 10.14 or later**
2. **Claude Desktop App** (NOT npm package)
3. **Docker Desktop** (for MCP features)

### ⚠️ Important: 
- ❌ Node.js is NOT required
- ❌ npm is NOT required
- ❌ No npm installation commands

---

## 💻 Installation

### 1. Install Claude Desktop
```bash
# Download from:
https://claude.ai/download

# Install the downloaded .dmg file
# Drag Claude to Applications folder
```

### 2. Verify CLI Installation
```bash
# The CLI comes with the desktop app
which claude
# Output: /usr/local/bin/claude

# Test it works
claude --version
```

### 3. Basic Usage
```bash
# Navigate to your project
cd /path/to/your/project

# Launch Claude Code
claude
```

---

## 🚀 Enhanced Setup with MCP (Recommended)

### 1. Install Docker Desktop
- Download: https://www.docker.com/products/docker-desktop
- Install and launch Docker
- Enable "Start on login" in settings

### 2. Setup Easy-MCP
```bash
# Clone the repository
cd ~
git clone https://github.com/angelor888/easy-mcp.git
cd easy-mcp

# Run automatic setup
./start.sh
```

### 3. Enable Auto-Start
```bash
# Install auto-start features
bash auto-start/install.sh

# You now have:
# - Auto-start on login
# - Desktop shortcut
# - Spotlight app
# - 'cc' terminal command
```

### 4. Start Claude with MCP
```bash
# From anywhere in terminal
cc

# Or navigate to easy-mcp
cd ~/easy-mcp && claude
```

---

## ⚙️ Configuration

### Claude Desktop Config Location:
```bash
~/Library/Application Support/Claude/claude_desktop_config.json
```

### For MCP Integration:
The Easy-MCP setup automatically configures this file with the correct MCP server connections.

---

## 🎯 Key Features

**What You Can Do:**
- **Edit Files**: "Fix the bug in app.js"
- **Run Commands**: "Run the tests and fix any failures"
- **Git Operations**: "Create a commit with these changes"
- **Code Explanations**: "Explain how this authentication flow works"
- **With MCP**: Web automation, persistent memory, enhanced search

---

## 🛠️ Essential Commands

| Command | Description |
|---------|-------------|
| `/help` | Show all available commands |
| `/config` | Configure Claude Code settings |
| `/bug` | Report issues |
| `/clear` | Clear conversation context |
| `/exit` or `Ctrl+C` | Exit Claude Code |

---

## 📁 Project Setup Tips

### Create Project Guidelines
Add a `CLAUDE.md` file to your project root:
```markdown
# Project Guidelines for Claude

- Follow TypeScript best practices
- Use async/await over promises
- Write tests for all new features
- Follow existing code patterns
```

---

## 🔧 Troubleshooting

### Common Issues:

**"command not found: claude"**
- Make sure Claude Desktop is installed
- Restart your terminal
- Reinstall Claude Desktop if needed

**MCP services not available**
- Ensure Docker Desktop is running
- Check: `docker compose ps` in easy-mcp
- Run: `cd ~/easy-mcp && ./verify-setup.sh`

**Permission errors**
- Never use sudo with claude
- Check file permissions in your project

### Getting Help:
- Use `/bug` command in Claude Code
- Documentation: https://docs.anthropic.com/claude-code
- Issues: https://github.com/anthropics/claude-code/issues

---

## 🎉 You're Ready!

### Quick Start Example:
```bash
# Basic Claude
cd ~/your-project
claude

# With MCP features
cc

# Try these commands:
"Show me all the functions in this project"
"Create a new React component called UserProfile"
"Run the tests and fix any that are failing"
```

---

## 📚 Additional Resources

- **Official Docs**: https://docs.anthropic.com/claude-code
- **Easy-MCP Repo**: https://github.com/angelor888/easy-mcp
- **Mac mini Setup**: See `docs/mac-mini-setup-guide.md`

---

## ✅ Verification Checklist

Run this to verify your setup:
```bash
cd ~/easy-mcp
./verify-setup.sh
```

Expected output:
- ✅ Docker installed
- ✅ Claude CLI installed
- ✅ All 4 services running
- ✅ Auto-start enabled

---

**Note**: This guide corrects the misinformation about npm installation. Claude Code is a desktop application, not an npm package!