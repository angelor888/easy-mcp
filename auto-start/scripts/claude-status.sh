#!/bin/bash

echo "🔍 Claude Code Environment Status"
echo "================================"

# Check Docker
if docker info > /dev/null 2>&1; then
    echo "✅ Docker Desktop: Running"
    
    # Check MCP services
    cd ~/easy-mcp 2>/dev/null
    if [ -d ~/easy-mcp ]; then
        RUNNING=$(docker compose ps --services --filter "status=running" 2>/dev/null | wc -l | tr -d ' ')
        echo "✅ MCP Services: $RUNNING/4 running"
        
        if [ "$RUNNING" -eq "4" ]; then
            echo "   ├─ mcp-filesystem (8082)"
            echo "   ├─ mcp-puppeteer (8084)"
            echo "   ├─ mcp-memory (8085)"
            echo "   └─ mcp-everything (8086)"
        else
            echo "   ⚠️  Some services not running. Run: docker compose up -d"
        fi
    fi
else
    echo "❌ Docker Desktop: Not running"
    echo "   Run: open -a Docker"
fi

# Check Claude Desktop
if pgrep -x "Claude" > /dev/null; then
    echo "✅ Claude Desktop: Running"
else
    echo "⚠️  Claude Desktop: Not running (optional)"
fi

# Check launch agent
if launchctl list | grep -q "com.duetright.claude-complete"; then
    echo "✅ Auto-start: Enabled"
else
    echo "❌ Auto-start: Not configured"
fi

# Check aliases
if grep -q "alias cc=" ~/.zshrc 2>/dev/null; then
    echo "✅ Terminal shortcuts: Configured (cc, claude-mcp)"
else
    echo "⚠️  Terminal shortcuts: Not configured"
fi

echo "================================"
echo "💡 Quick commands:"
echo "   cc               - Start Claude CLI"
echo "   claude-mcp       - Start Claude CLI"
echo "   docker compose ps - Check MCP services"