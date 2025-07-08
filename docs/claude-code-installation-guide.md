# Claude Code Installation Guide for Mac

Accurate installation guide for Claude Code on Mac systems, including optional MCP integration.

## 🚀 Quick Overview

Claude Code is an AI coding assistant that provides:
- Natural language code editing and generation
- Direct file system access and modification
- Command execution and automation
- Git integration and workflow support
- Optional MCP (Model Context Protocol) services for enhanced capabilities

## 📋 System Requirements

### For Basic Claude Code:
- macOS 10.14 or later
- 4GB RAM minimum (8GB recommended)
- Internet connection for AI features

### For Claude Code with MCP:
- All basic requirements plus:
- Docker Desktop for Mac
- 8GB RAM minimum (16GB recommended)
- 10GB free disk space

## 💻 Basic Installation

### Step 1: Download Claude Desktop

1. Visit: https://claude.ai/download
2. Click "Download for Mac"
3. You'll get a `.dmg` file (e.g., `Claude-1.0.0.dmg`)

### Step 2: Install Claude Desktop

1. Open the downloaded `.dmg` file
2. Drag Claude to your Applications folder
3. Launch Claude from Applications or Spotlight

### Step 3: Verify CLI Installation

```bash
# The CLI is automatically installed with the desktop app
which claude
# Should output: /usr/local/bin/claude or similar

# Test the CLI
claude --version
```

### Step 4: First Launch

```bash
# Navigate to any project directory
cd ~/your-project

# Start Claude Code
claude

# You'll see the Claude interface ready for commands
```

## 🔐 Authentication

Claude Code uses in-app authentication:
1. On first launch, you'll be prompted to sign in
2. Use your Claude account (create one at claude.ai if needed)
3. No OAuth or browser redirect required
4. Authentication persists between sessions

## 🚀 Enhanced Setup with MCP (Optional)

For advanced features like web automation, memory, and enhanced file operations:

### Step 1: Install Docker Desktop

1. Download from: https://www.docker.com/products/docker-desktop
2. Install and launch Docker Desktop
3. Enable "Start Docker Desktop when you log in" in settings

### Step 2: Clone Easy-MCP

```bash
# Clone the repository
cd ~
git clone https://github.com/angelor888/easy-mcp.git
cd easy-mcp

# Run automatic setup
./start.sh
```

### Step 3: Configure MCP Services

```bash
# Create secrets (if needed)
cp secrets/mcp_secret.txt.example secrets/mcp_secret.txt
cp secrets/filesystem_key.txt.example secrets/filesystem_key.txt

# Generate secure keys
echo "$(openssl rand -hex 32)" > secrets/mcp_secret.txt
echo "$(openssl rand -hex 32)" > secrets/filesystem_key.txt
```

### Step 4: Install Auto-Start (Recommended)

```bash
# Enable automatic startup
bash auto-start/install.sh

# This creates:
# - Auto-start on login
# - Desktop shortcut
# - Spotlight app
# - Terminal command 'cc'
```

### Step 5: Verify MCP Setup

```bash
# Check services
docker compose ps

# Start Claude with MCP
cc  # or 'claude' in easy-mcp directory

# Verify MCP tools are available in Claude
```

## ⚙️ Configuration

### Basic Claude Settings

Access settings within Claude:
- Use `/config` command
- Or through GUI settings menu

### MCP Configuration

Claude Desktop config location:
```bash
~/Library/Application Support/Claude/claude_desktop_config.json
```

Example MCP configuration:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "docker",
      "args": ["exec", "-i", "mcp-filesystem-enhanced", "mcp-server-filesystem", "/view"]
    },
    "puppeteer": {
      "command": "docker",
      "args": ["exec", "-i", "mcp-puppeteer-enhanced", "mcp-server-puppeteer"]
    },
    "memory": {
      "command": "docker",
      "args": ["exec", "-i", "mcp-memory-enhanced", "mcp-server-memory"]
    }
  }
}
```

## 🎯 Essential Commands

| Command | Description |
|---------|-------------|
| `/help` | Show all available commands |
| `/config` | Configure Claude settings |
| `/clear` | Clear conversation context |
| `/exit` or `Ctrl+C` | Exit Claude Code |
| `/bug` | Report issues |
| `/feedback` | Send feedback |

## 📁 Project Configuration

### Create Project Guidelines

Add a `CLAUDE.md` file to your project root:

```markdown
# Project Guidelines for Claude

## Code Style
- Use TypeScript for all new files
- Follow ESLint configuration
- Use async/await over promises

## Testing
- Write tests for all new features
- Maintain 80% code coverage
- Use Jest for unit tests

## Git Conventions
- Use conventional commits
- Create feature branches
- Squash commits before merging
```

### Custom Commands

Create custom commands in `.claude/commands/`:
```bash
mkdir -p .claude/commands
# Add custom command scripts here
```

## 🔧 Troubleshooting

### Common Issues

**"command not found: claude"**
- Ensure Claude Desktop is installed
- Restart terminal after installation
- Check: `ls -la /usr/local/bin/claude`

**Permission Denied**
- Don't use sudo with claude
- Ensure proper file permissions in project

**Docker Services Not Found (MCP)**
- Ensure Docker Desktop is running
- Check: `docker compose ps` in easy-mcp directory
- Restart services: `./stop.sh && ./start.sh`

**MCP Tools Not Available**
- Verify claude_desktop_config.json exists
- Restart Claude Desktop app
- Check Docker services are running

### Debug Commands

```bash
# Check Claude version
claude --version

# Verify MCP services (if using)
cd ~/easy-mcp
docker compose ps
./verify-setup.sh

# Check Claude config
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

## 🎉 Quick Start Examples

### Basic Usage
```bash
cd ~/your-project
claude

# Try these commands:
# "Show me all the TODO comments in this project"
# "Create a new function to validate email addresses"
# "Run the tests and show me any failures"
```

### With MCP Features
```bash
# Start with MCP support
cc  # or cd ~/easy-mcp && claude

# Advanced commands:
# "Take a screenshot of example.com"
# "Remember this project uses React 18 with TypeScript"
# "Search for all API endpoints in the codebase"
```

## 📚 Additional Resources

- **Official Documentation**: https://docs.anthropic.com/en/docs/claude-code
- **GitHub Issues**: https://github.com/anthropics/claude-code/issues
- **Easy-MCP Repository**: https://github.com/angelor888/easy-mcp
- **MCP Specification**: https://modelcontextprotocol.io/

## 🆘 Getting Help

1. Use `/help` within Claude Code
2. Check the official docs
3. File issues on GitHub
4. For MCP issues: Check Easy-MCP documentation

---

*Last updated: January 2025*
*Verified on macOS Sonoma & Sequoia*