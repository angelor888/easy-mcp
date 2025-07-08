#!/bin/bash

# Easy-MCP Mac mini One-Click Deployment Script
# This script automates the entire setup process for a new Mac mini

set -e  # Exit on any error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║        Easy-MCP Mac mini Deployment Script           ║"
echo "║                                                      ║"
echo "║  This will install and configure:                    ║"
echo "║  • Homebrew, Git, Docker Desktop                     ║"
echo "║  • Claude Desktop with MCP integration               ║"
echo "║  • Auto-start features and shortcuts                 ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to wait for user
wait_for_user() {
    echo -e "${YELLOW}$1${NC}"
    read -p "Press Enter to continue..."
}

# Step 1: Install Homebrew
echo -e "\n${BLUE}Step 1: Checking Homebrew...${NC}"
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# Step 2: Install Git
echo -e "\n${BLUE}Step 2: Checking Git...${NC}"
if ! command_exists git; then
    echo "Installing Git..."
    brew install git
else
    echo -e "${GREEN}✓ Git already installed${NC}"
fi

# Configure Git
echo "Configuring Git..."
git config --global user.name "Angelo Russoniello" 2>/dev/null || true
git config --global user.email "angelo@duetright.com" 2>/dev/null || true

# Step 3: Check Docker Desktop
echo -e "\n${BLUE}Step 3: Checking Docker Desktop...${NC}"
if ! command_exists docker; then
    echo -e "${YELLOW}Docker Desktop needs to be installed manually.${NC}"
    echo "Please:"
    echo "1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop"
    echo "2. Install Docker Desktop"
    echo "3. Launch Docker Desktop and complete setup"
    echo "4. Enable 'Start Docker Desktop when you log in' in settings"
    wait_for_user "After installing Docker Desktop"
    
    # Check again
    if ! command_exists docker; then
        echo -e "${RED}Docker still not found. Please install Docker Desktop and run this script again.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
    
    # Start Docker if not running
    if ! docker info &> /dev/null; then
        echo "Starting Docker Desktop..."
        open -a Docker
        echo "Waiting for Docker to start..."
        sleep 10
        
        # Wait up to 60 seconds for Docker to start
        counter=0
        while ! docker info &> /dev/null && [ $counter -lt 60 ]; do
            sleep 2
            counter=$((counter + 2))
            echo -n "."
        done
        echo
        
        if ! docker info &> /dev/null; then
            echo -e "${RED}Docker failed to start. Please start Docker Desktop manually.${NC}"
            exit 1
        fi
    fi
fi

# Step 4: Check Claude Desktop
echo -e "\n${BLUE}Step 4: Checking Claude Desktop...${NC}"
if ! command_exists claude; then
    echo -e "${YELLOW}Claude Desktop needs to be installed manually.${NC}"
    echo "Please:"
    echo "1. Download Claude from: https://claude.ai/download"
    echo "2. Install the downloaded .dmg file"
    echo "3. Launch Claude once to complete initial setup"
    wait_for_user "After installing Claude Desktop"
    
    # Check again
    if ! command_exists claude; then
        echo -e "${RED}Claude CLI still not found. Please install Claude Desktop and run this script again.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Claude Desktop already installed${NC}"
fi

# Step 5: Clone Easy-MCP
echo -e "\n${BLUE}Step 5: Setting up Easy-MCP...${NC}"
if [ -d ~/easy-mcp ]; then
    echo "Easy-MCP directory already exists."
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd ~/easy-mcp
        git pull origin main
    fi
else
    echo "Cloning Easy-MCP repository..."
    cd ~
    git clone https://github.com/angelor888/easy-mcp.git
fi

# Step 6: Run Easy-MCP setup
echo -e "\n${BLUE}Step 6: Running Easy-MCP automatic setup...${NC}"
cd ~/easy-mcp

# Make scripts executable
chmod +x *.sh
chmod +x auto-start/scripts/*.sh 2>/dev/null || true

# Run the setup
echo "Starting automatic setup..."
./start.sh

# Step 7: Configure secrets
echo -e "\n${BLUE}Step 7: Configuring secrets...${NC}"
if [ ! -f secrets/mcp_secret.txt ]; then
    mkdir -p secrets
    echo "$(openssl rand -hex 32)" > secrets/mcp_secret.txt
    echo -e "${GREEN}✓ Created MCP secret${NC}"
else
    echo -e "${GREEN}✓ MCP secret already exists${NC}"
fi

if [ ! -f secrets/filesystem_key.txt ]; then
    echo "$(openssl rand -hex 32)" > secrets/filesystem_key.txt
    echo -e "${GREEN}✓ Created filesystem key${NC}"
else
    echo -e "${GREEN}✓ Filesystem key already exists${NC}"
fi

# Step 8: Configure Claude Desktop
echo -e "\n${BLUE}Step 8: Configuring Claude Desktop...${NC}"
CLAUDE_CONFIG_DIR=~/Library/Application\ Support/Claude
mkdir -p "$CLAUDE_CONFIG_DIR"

if [ ! -f "$CLAUDE_CONFIG_DIR/claude_desktop_config.json" ] && [ -f claude_desktop_config.json.example ]; then
    cp claude_desktop_config.json.example "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
    echo -e "${GREEN}✓ Claude Desktop configured${NC}"
else
    echo -e "${GREEN}✓ Claude Desktop config already exists${NC}"
fi

# Step 9: Install auto-start
echo -e "\n${BLUE}Step 9: Installing auto-start features...${NC}"
if [ -f auto-start/install.sh ]; then
    bash auto-start/install.sh
else
    echo -e "${YELLOW}Auto-start installer not found, skipping...${NC}"
fi

# Step 10: Verification
echo -e "\n${BLUE}Step 10: Running verification...${NC}"
if [ -f verify-setup.sh ]; then
    ./verify-setup.sh
else
    # Basic verification
    echo "Checking services..."
    docker compose ps
fi

# Final instructions
echo -e "\n${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         🎉 Deployment Complete! 🎉                   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${BLUE}You can now use Claude with MCP in multiple ways:${NC}"
echo -e "  • Terminal: Type ${GREEN}cc${NC} from anywhere"
echo -e "  • Desktop: Double-click ${GREEN}Claude-Code.command${NC}"
echo -e "  • Spotlight: Search for ${GREEN}Claude Code${NC}"
echo -e "  • Check status: ${GREEN}claude-status${NC}"
echo
echo -e "${YELLOW}Important:${NC}"
echo "  • Docker Desktop should be set to start on login"
echo "  • Claude will now auto-start with your Mac"
echo "  • All MCP services are running in Docker"
echo
echo -e "${BLUE}Need help? Check:${NC}"
echo "  • ~/easy-mcp/docs/mac-mini-setup-guide.md"
echo "  • ~/easy-mcp/docs/setup-verification-checklist.md"
echo
echo -e "${GREEN}Happy coding with Claude! 🚀${NC}"