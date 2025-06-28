#!/bin/bash
# Script to intelligently detect, install, and start all MCP Docker services
# Version: 2.1.0
# One-click deployment with automatic dependency detection and installation

# Navigate to script's directory
cd "$(dirname "$0")" || exit 1

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Determine language (default to English, override with zh-TW if LANG includes zh_TW)
if [[ "$LANG" =~ "zh" ]]; then
  CURRENT_LANG="zh-TW"
else
  CURRENT_LANG="en"
fi

# Language-specific messages
if [ "$CURRENT_LANG" = "zh-TW" ]; then
  MSG_WELCOME="🚀 歡迎使用 Easy-MCP 智能一鍵部署系統 v2.1"
  MSG_AUTO_DETECT="🔍 正在自動檢測和安裝環境依賴..."
  MSG_START="正在啟動 Docker 化的 MCP 服務..."
  MSG_DOCKER_ERROR="錯誤：Docker 未運行。正在嘗試自動啟動..."
  MSG_COMPOSE_ERROR="錯誤：docker compose 未安裝或不可用。請檢查 Docker 安裝。"
  MSG_ENV_MISSING="找不到 .env 檔案。正在從 .env.example 複製..."
  MSG_ENV_NOTE="重要提示：請開啟 .env 檔案並填入實際 API 金鑰。"
  MSG_ENV_EXAMPLE_MISSING="錯誤：.env.example 檔案不存在。請檢查專案檔案完整性。"
  MSG_BUILDING="正在以分離模式建置並啟動服務..."
  MSG_SUCCESS="🎉 服務已成功啟動！可以開始使用 Easy-MCP 了。"
  MSG_ERROR="啟動服務失敗。請檢查輸出以獲取詳細資訊。"
  MSG_ENV_SETUP="⚙️  正在自動安裝環境..."
  MSG_SETUP_SUCCESS="✅ 環境安裝完成，繼續啟動服務..."
  MSG_SETUP_FAILED="❌ 環境安裝失敗，請檢查錯誤訊息"
  MSG_DOCKER_STARTING="🐳 正在啟動 Docker，請稍候..."
  MSG_ALL_READY="🌟 系統已就緒！所有依賴都已安裝並運行。"
  MSG_DOCKER_WAIT="等待 Docker 啟動中..."
else
  MSG_WELCOME="🚀 Welcome to Easy-MCP Intelligent One-Click Deployment v2.1"
  MSG_AUTO_DETECT="🔍 Automatically detecting and installing environment dependencies..."
  MSG_START="Starting Dockerized MCP Services..."
  MSG_DOCKER_ERROR="Error: Docker is not running. Attempting auto-start..."
  MSG_COMPOSE_ERROR="Error: docker compose is not installed or unavailable. Please check Docker installation."
  MSG_ENV_MISSING="No .env file found. Copying from .env.example..."
  MSG_ENV_NOTE="IMPORTANT: Please open the .env file and fill in your actual API keys."
  MSG_ENV_EXAMPLE_MISSING="Error: .env.example file not found. Please check project file integrity."
  MSG_BUILDING="Building and starting services in detached mode..."
  MSG_SUCCESS="🎉 Services started successfully! Easy-MCP is ready to use."
  MSG_ERROR="Error starting services. Check the output for details."
  MSG_ENV_SETUP="⚙️  Auto-installing environment..."
  MSG_SETUP_SUCCESS="✅ Environment setup completed, continuing with service startup..."
  MSG_SETUP_FAILED="❌ Environment setup failed, please check error messages"
  MSG_DOCKER_STARTING="🐳 Starting Docker, please wait..."
  MSG_ALL_READY="🌟 System ready! All dependencies are installed and running."
  MSG_DOCKER_WAIT="Waiting for Docker to start..."
fi

echo
echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}${BOLD}$MSG_WELCOME${NC}"
echo -e "${CYAN}================================================================${NC}"
echo
echo -e "${YELLOW}$MSG_AUTO_DETECT${NC}"
echo

# Smart environment detection and auto-installation
NEED_SETUP=false
ENV_ISSUES=""

# Check if Git is available
if ! command -v git >/dev/null 2>&1; then
  echo -e "${RED}❌ Git not found${NC}"
  NEED_SETUP=true
  ENV_ISSUES="$ENV_ISSUES Git"
else
  echo -e "${GREEN}✅ Git is available${NC}"
fi

# Check if Docker is available
if ! command -v docker >/dev/null 2>&1; then
  echo -e "${RED}❌ Docker not found${NC}"
  NEED_SETUP=true
  ENV_ISSUES="$ENV_ISSUES Docker"
else
  echo -e "${GREEN}✅ Docker is available${NC}"
fi

# Auto-install missing dependencies
if [ "$NEED_SETUP" = true ]; then
  echo
  echo -e "${YELLOW}$MSG_ENV_SETUP${NC}"
  echo -e "${WHITE}Missing components:$ENV_ISSUES${NC}"
  echo
  
  if [ -f "quick-setup.sh" ]; then
    chmod +x "quick-setup.sh"
    if "./quick-setup.sh" --language "$CURRENT_LANG"; then
      echo
      echo -e "${GREEN}$MSG_SETUP_SUCCESS${NC}"
      echo
    else
      echo
      echo -e "${RED}$MSG_SETUP_FAILED${NC}"
      echo -e "${WHITE}Please run: ./quick-setup.sh --force${NC}"
      read -p "Press Enter to exit..."
      exit 1
    fi
  else
    echo -e "${RED}Quick setup script not found. Please install dependencies manually.${NC}"
    read -p "Press Enter to exit..."
    exit 1
  fi
else
  echo -e "${GREEN}$MSG_ALL_READY${NC}"
  echo
fi

# Smart Docker startup handling
check_docker() {
  if ! docker info >/dev/null 2>&1; then
    echo -e "${YELLOW}$MSG_DOCKER_STARTING${NC}"
    
    # Try to start Docker on different platforms
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS
      if ! pgrep -x "Docker" >/dev/null; then
        open -a Docker 2>/dev/null || {
          echo -e "${RED}Failed to start Docker Desktop. Please start it manually.${NC}"
          return 1
        }
      fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux
      if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl start docker 2>/dev/null || {
          echo -e "${RED}Failed to start Docker service. Please start it manually.${NC}"
          return 1
        }
      fi
    fi
    
    # Wait for Docker to start with timeout
    local wait_count=0
    local max_wait=20
    
    while [ $wait_count -lt $max_wait ]; do
      echo -e "${BLUE}$MSG_DOCKER_WAIT ($((wait_count+1))/$max_wait)${NC}"
      sleep 3
      
      if docker info >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Docker is running${NC}"
        return 0
      fi
      
      wait_count=$((wait_count + 1))
    done
    
    echo -e "${RED}Docker failed to start automatically. Please start Docker manually.${NC}"
    read -p "Press Enter when Docker is running..."
    check_docker
  else
    echo -e "${GREEN}✅ Docker is running${NC}"
  fi
}

# Check and start Docker
check_docker

# Check if docker compose is available
if ! docker compose version >/dev/null 2>&1; then
  echo -e "${RED}$MSG_COMPOSE_ERROR${NC}"
  read -p "Press Enter to exit..."
  exit 1
fi

echo -e "${GREEN}✅ Docker Compose is available${NC}"

# Handle .env file
if [ ! -f .env ]; then
  if [ ! -f .env.example ]; then
    echo -e "${RED}$MSG_ENV_EXAMPLE_MISSING${NC}"
    read -p "Press Enter to exit..."
    exit 1
  fi
  echo -e "${YELLOW}$MSG_ENV_MISSING${NC}"
  cp .env.example .env || exit 1
  echo -e "${YELLOW}$MSG_ENV_NOTE${NC}"
  echo
fi

echo -e "${CYAN}$MSG_BUILDING${NC}"
docker compose up --build -d

echo
if [ $? -eq 0 ]; then
  echo -e "${GREEN}$MSG_SUCCESS${NC}"
  echo
  echo -e "${WHITE}📋 Available Services:${NC}"
  echo -e "${WHITE}  🗂️  MCP Filesystem (Port 8082) - File management${NC}"
  echo -e "${WHITE}  🌐 MCP Puppeteer (Port 8084) - Browser automation${NC}"
  echo -e "${WHITE}  🧠 MCP Memory (Port 8085) - In-memory storage${NC}"
  echo -e "${WHITE}  🔧 MCP Everything (Port 8086) - Multi-purpose server${NC}"
  echo -e "${WHITE}  ⏰ MCP Time (uvx) - Time functions${NC}"
  echo -e "${WHITE}  📡 MCP Fetch (uvx) - URL content retrieval${NC}"
  echo
  echo -e "${CYAN}🔗 Next Steps:${NC}"
  echo -e "${WHITE}  1. Configure Claude Desktop: see claude_desktop_config.json.example${NC}"
  echo -e "${WHITE}  2. Edit .env file with your API keys${NC}"
  echo -e "${WHITE}  3. View documentation: docs/QUICK-START.md${NC}"
  echo
  echo -e "${CYAN}📊 Management Commands:${NC}"
  echo -e "${WHITE}  Logs: docker compose logs -f${NC}"
  echo -e "${WHITE}  Stop: ./stop.sh or docker compose down${NC}"
  echo -e "${WHITE}  Restart: ./start.sh${NC}"
  echo
  echo -e "${GREEN}✨ Easy-MCP is now ready for use!${NC}"
else
  echo
  echo -e "${RED}$MSG_ERROR${NC}"
  echo
  echo -e "${YELLOW}🔧 Troubleshooting:${NC}"
  echo -e "${WHITE}  1. Check if Docker Desktop is running${NC}"
  echo -e "${WHITE}  2. Verify .env file has correct values${NC}"
  echo -e "${WHITE}  3. Run 'docker compose logs' for detailed error messages${NC}"
  echo -e "${WHITE}  4. Run './quick-setup.sh --force' to reinstall environment${NC}"
  echo -e "${WHITE}  5. Check docs/QUICK-START.md for detailed guide${NC}"
  echo
  read -p "Press Enter to exit..."
  exit 1
fi

echo
echo -e "${WHITE}Press Enter to close this terminal...${NC}"
read -r

