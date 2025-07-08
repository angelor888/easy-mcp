# Standard Operating Procedure

## Title
Claude Code Complete Environment Startup

## Purpose
Ensure all required services are running for Claude Code to function properly with MCP integrations, webhooks, and automations.

## Scope
Applies to all Claude Code CLI usage with DuetRight's automation stack.

## Required Services

### 1. Docker Desktop
- **Purpose**: Runs MCP service containers
- **Status Check**: `docker info`
- **Start Command**: `open -a Docker`
- **Auto-start**: Enable in Docker Desktop → Settings → General → "Start Docker Desktop when you log in"

### 2. MCP Docker Services
Must be running in Docker:
- `mcp-filesystem-enhanced` (port 8082)
- `mcp-puppeteer-enhanced` (port 8084)
- `mcp-memory-enhanced` (port 8085)
- `mcp-everything-enhanced` (port 8086)

**Start Command**: 
```bash
cd ~/easy-mcp
docker compose up -d
```

### 3. Claude Desktop (Optional)
- **Purpose**: GUI interface for Claude
- **Start Command**: `open -a Claude`
- **Note**: Not required for CLI, but useful for testing MCP connections

### 4. Additional Services (As Needed)

#### Slack Bot
- **Check**: `pm2 status duetright-slack-bot`
- **Start**: `pm2 start ~/Projects/duetright-slack-bot/index.js --name duetright-slack-bot`

#### Jobber Agent
- **Check**: `curl http://localhost:3000/health`
- **Start**: Via Heroku or local deployment

## Startup Sequence

### Automatic (Recommended)
```bash
bash ~/easy-mcp/docs/claude-complete-startup.sh
```

### Manual Steps
1. Start Docker Desktop
2. Wait for Docker to be ready (whale icon steady)
3. Start MCP services: `cd ~/easy-mcp && docker compose up -d`
4. Verify services: `docker compose ps`
5. Start Claude CLI: `claude`

## Verification Checklist

- [ ] Docker Desktop running (whale icon in menu bar)
- [ ] All 4 MCP containers showing "Up" status
- [ ] Claude CLI responds to commands
- [ ] `/status` in Claude shows all MCP services connected
- [ ] No error messages in logs

## Troubleshooting

### Docker Won't Start
1. Check Activity Monitor for Docker processes
2. Restart Mac if needed
3. Reinstall Docker Desktop if persistent

### MCP Services Failing
```bash
docker compose down -v
docker system prune -f
docker compose up -d
```

### Claude Not Seeing MCP Services
1. Restart Claude Desktop
2. Check `~/Library/Application Support/Claude/claude_desktop_config.json`
3. Verify Docker containers are running

## Auto-Start Configuration

To enable complete auto-start:
```bash
# Install the launch agent
cp ~/easy-mcp/docs/claude-complete-startup.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.duetright.claude-complete.plist
```

## Monitoring

Check startup logs:
```bash
tail -f ~/Library/Logs/claude-complete.log
```

## Responsibilities
- **User**: Ensure Docker Desktop auto-start is enabled
- **System**: Launch agent handles service startup
- **DevOps**: Maintain startup scripts

---
*End of Document*