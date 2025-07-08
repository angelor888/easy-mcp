#!/bin/bash

# Claude Code Complete Startup Script
# This ensures all required services are running

echo "🚀 Starting Claude Code Complete Environment..."
echo "============================================"

# 1. Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "🐳 Starting Docker Desktop..."
        open -a Docker
        
        # Wait for Docker to start (max 60 seconds)
        echo "⏳ Waiting for Docker to start..."
        COUNTER=0
        while ! docker info > /dev/null 2>&1; do
            sleep 2
            COUNTER=$((COUNTER + 2))
            if [ $COUNTER -gt 60 ]; then
                echo "❌ Docker failed to start after 60 seconds"
                echo "Please start Docker Desktop manually"
                exit 1
            fi
            echo -n "."
        done
        echo " ✓"
    else
        echo "✅ Docker is already running"
    fi
}

# 2. Start MCP services
start_mcp_services() {
    echo "📦 Starting MCP Docker services..."
    cd ~/easy-mcp
    
    # Check if services are already running
    RUNNING=$(docker compose ps --services --filter "status=running" | wc -l)
    if [ $RUNNING -eq 4 ]; then
        echo "✅ All MCP services already running"
    else
        echo "🔄 Starting MCP services..."
        docker compose up -d
        sleep 3
        
        # Verify all services started
        echo "🔍 Verifying services..."
        docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    fi
}

# 3. Start Claude Desktop if needed
start_claude_desktop() {
    if pgrep -x "Claude" > /dev/null; then
        echo "✅ Claude Desktop is already running"
    else
        echo "🤖 Starting Claude Desktop..."
        open -a Claude
    fi
}

# 4. Start any other required services
start_additional_services() {
    # Add any other services here
    echo "🔧 Checking additional services..."
    
    # Example: Start Slack bot if needed
    # if ! pm2 list | grep -q "slack-bot"; then
    #     cd ~/Projects/duetright-slack-bot
    #     pm2 start index.js --name slack-bot
    # fi
    
    echo "✅ All additional services checked"
}

# 5. Health check
health_check() {
    echo ""
    echo "🏥 Running health checks..."
    echo "----------------------------"
    
    # Check Docker
    if docker info > /dev/null 2>&1; then
        echo "✅ Docker: Running"
    else
        echo "❌ Docker: Not running"
    fi
    
    # Check MCP services
    cd ~/easy-mcp
    RUNNING=$(docker compose ps --services --filter "status=running" | wc -l)
    echo "✅ MCP Services: $RUNNING/4 running"
    
    # Check Claude Desktop
    if pgrep -x "Claude" > /dev/null; then
        echo "✅ Claude Desktop: Running"
    else
        echo "⚠️  Claude Desktop: Not running (optional)"
    fi
    
    echo "----------------------------"
}

# Main execution
main() {
    check_docker
    start_mcp_services
    start_claude_desktop
    start_additional_services
    health_check
    
    echo ""
    echo "🎉 Claude Code environment is ready!"
    echo ""
    echo "🚀 Starting Claude Code CLI..."
    cd ~/easy-mcp
    claude
}

# Run main function
main