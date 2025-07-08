# Claude Code Quick Start Guide

One-page reference for getting Claude Code up and running on Mac.

## 🚀 Installation (5 minutes)

### 1. Download & Install
```bash
# Download from: https://claude.ai/download
# Install the .dmg file
# Launch Claude from Applications
```

### 2. Verify Installation
```bash
claude --version  # Should show version number
```

### 3. Start Using
```bash
cd ~/your-project
claude
```

---

## 🎯 Essential Commands

```bash
# File Operations
"Create a new file called config.js"
"Edit the README to add installation instructions"
"Show me all .js files in this project"

# Code Analysis
"Explain how the authentication works"
"Find all TODO comments"
"What does this function do?"

# Running Commands
"Run npm install"
"Execute the test suite"
"Start the development server"

# Git Operations
"Show me the git status"
"Create a commit with these changes"
"What changed in the last commit?"
```

---

## ⚡ Keyboard Shortcuts

- **Ctrl+C**: Exit Claude
- **Ctrl+L**: Clear screen
- **Up/Down**: Navigate command history
- **Tab**: Auto-complete file paths

---

## 🚀 Advanced Setup with MCP (Optional)

Get web automation, memory, and enhanced features:

```bash
# 1. Install Docker Desktop
# 2. Setup Easy-MCP
git clone https://github.com/angelor888/easy-mcp.git
cd easy-mcp
./start.sh

# 3. Enable auto-start
bash auto-start/install.sh

# 4. Use enhanced Claude
cc  # Starts Claude with MCP features
```

---

## 💡 Pro Tips

### 1. Create Project Guidelines
Add `CLAUDE.md` to your project root:
```markdown
# Claude Instructions
- Use TypeScript
- Follow our ESLint rules
- Write tests for new features
```

### 2. Quick Access
After MCP setup, you get:
- **Terminal**: Type `cc` anywhere
- **Desktop**: Double-click shortcut
- **Spotlight**: Search "Claude Code"

### 3. MCP Features
With MCP enabled:
```bash
# Web automation
"Take a screenshot of our website"

# Memory
"Remember this project uses React 18"

# Enhanced search
"Find all API endpoints across the codebase"
```

---

## 🔧 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| "command not found" | Restart terminal after install |
| Can't edit files | Check file permissions |
| MCP not working | Ensure Docker is running |
| Authentication issues | Re-launch Claude app |

---

## 📊 Status Check

```bash
# Basic Claude
claude --version

# With MCP (if installed)
cd ~/easy-mcp
./verify-setup.sh
```

---

## 🆘 Getting Help

- **In Claude**: `/help`
- **Documentation**: https://docs.anthropic.com/claude-code
- **Issues**: https://github.com/anthropics/claude-code/issues

---

**Remember**: No npm install needed! Just download the app and start coding with AI! 🎉