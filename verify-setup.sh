#!/bin/bash

# Easy-MCP Setup Verification Script
# This script checks if your Easy-MCP installation is complete

set -e

echo "🔍 Easy-MCP Setup Verification"
echo "=============================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Function to check condition
check() {
    if eval "$2"; then
        echo -e "${GREEN}✅ $1${NC}"
        ((PASSED++))
    else
        echo -e "${RED}❌ $1${NC}"
        ((FAILED++))
    fi
}

echo "📋 Checking Prerequisites..."
check "Docker installed" "command -v docker &> /dev/null"
check "Claude CLI installed" "command -v claude &> /dev/null"
check "Git installed" "command -v git &> /dev/null"

echo ""
echo "📁 Checking Easy-MCP Installation..."
check "Easy-MCP directory exists" "[ -d ~/easy-mcp ]"
check "Configuration files exist" "[ -f ~/easy-mcp/docker-compose.yml ]"

echo ""
echo "🐳 Checking Docker Services..."
if [ -d ~/easy-mcp ]; then
    cd ~/easy-mcp
    RUNNING_SERVICES=$(docker compose ps --format json 2>/dev/null | grep -c '"State":"running"' || echo 0)
    check "All 4 services running" "[ $RUNNING_SERVICES -eq 4 ]"
    
    if [ $RUNNING_SERVICES -gt 0 ]; then
        echo "   Services status:"
        docker compose ps --format "table {{.Service}}\t{{.Status}}" | sed 's/^/   /'
    fi
fi

echo ""
echo "🚀 Checking Auto-Start Configuration..."
check "Launch agent installed" "[ -f ~/Library/LaunchAgents/com.duetright.claude-complete.plist ]"
check "Desktop shortcut created" "[ -f ~/Desktop/Claude-Code.command ]"
check "Spotlight app installed" "[ -d ~/Applications/Claude\ Code.app ]"

echo ""
echo "⚙️ Checking Claude Configuration..."
check "Claude config exists" "[ -f ~/Library/Application\ Support/Claude/claude_desktop_config.json ]"

echo ""
echo "🔧 Checking Terminal Integration..."
# Check in current shell and config files
check "Terminal alias 'cc' configured" "alias cc &>/dev/null || grep -q 'alias cc=' ~/.zshrc 2>/dev/null || grep -q 'alias cc=' ~/.zprofile 2>/dev/null"

echo ""
echo "=============================="
echo "📊 Summary: $PASSED passed, $FAILED failed"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✨ All checks passed! Your Easy-MCP setup is complete.${NC}"
    echo ""
    echo "🎯 Quick Start:"
    echo "   • Type 'cc' in terminal to start Claude with MCP"
    echo "   • Use Desktop shortcut 'Claude-Code.command'"
    echo "   • Search 'Claude Code' in Spotlight"
else
    echo -e "${RED}⚠️  Some checks failed. Please run the setup:${NC}"
    echo "   cd ~/easy-mcp && ./start.sh"
    echo ""
    echo "For detailed setup instructions, see:"
    echo "   ~/easy-mcp/docs/mac-mini-setup-guide.md"
fi

echo "=============================="