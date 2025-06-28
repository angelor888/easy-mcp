#!/bin/bash
# Easy-MCP 快速環境安裝腳本
# Version: 2.0.0
# 支援 Linux/macOS + Docker 自動安裝
# 作者: DevSecOps Ultimate Agent 2025

set -e

# 參數解析
FORCE=false
LANGUAGE="auto"

while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --language|-l)
            LANGUAGE="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --force, -f        Force reinstall all components"
            echo "  --language, -l     Set language (auto|en|zh-TW)"
            echo "  --help, -h         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# 語言設定
if [ "$LANGUAGE" = "auto" ]; then
    if [[ "$LANG" =~ "zh" ]]; then
        LANGUAGE="zh-TW"
    else
        LANGUAGE="en"
    fi
fi

# 多語言訊息
declare -A MESSAGES_ZH_TW=(
    ["title"]="Easy-MCP 環境快速安裝工具 v2.0"
    ["checking_env"]="正在檢測系統環境..."
    ["system_info"]="系統資訊："
    ["installing_component"]="正在安裝："
    ["component_exists"]="已安裝："
    ["component_missing"]="缺失："
    ["install_success"]="安裝成功："
    ["install_failed"]="安裝失敗："
    ["setup_complete"]="環境安裝完成！"
    ["starting_services"]="正在啟動 MCP 服務..."
    ["press_enter"]="按 Enter 繼續..."
    ["error"]="錯誤："
    ["warning"]="警告："
    ["info"]="資訊："
    ["need_sudo"]="需要 sudo 權限來安裝系統包"
    ["docker_not_running"]="Docker 未運行，請啟動 Docker Desktop 並執行: ./start.sh"
)

declare -A MESSAGES_EN=(
    ["title"]="Easy-MCP Quick Environment Setup Tool v2.0"
    ["checking_env"]="Checking system environment..."
    ["system_info"]="System Information:"
    ["installing_component"]="Installing:"
    ["component_exists"]="Already installed:"
    ["component_missing"]="Missing:"
    ["install_success"]="Successfully installed:"
    ["install_failed"]="Failed to install:"
    ["setup_complete"]="Environment setup completed!"
    ["starting_services"]="Starting MCP services..."
    ["press_enter"]="Press Enter to continue..."
    ["error"]="Error:"
    ["warning"]="Warning:"
    ["info"]="Info:"
    ["need_sudo"]="Need sudo privileges to install system packages"
    ["docker_not_running"]="Docker is not running. Please start Docker Desktop and run: ./start.sh"
)

# 選擇訊息語言
if [ "$LANGUAGE" = "zh-TW" ]; then
    declare -n MESSAGES=MESSAGES_ZH_TW
else
    declare -n MESSAGES=MESSAGES_EN
fi

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 工具函數
log_info() {
    echo -e "${WHITE}${MESSAGES[info]} $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}${MESSAGES[warning]} $1${NC}"
}

log_error() {
    echo -e "${RED}${MESSAGES[error]} $1${NC}"
}

log_success() {
    echo -e "${GREEN}$1${NC}"
}

log_installing() {
    echo -e "${YELLOW}${MESSAGES[installing_component]} $1...${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 檢測作業系統
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            OS_VERSION=$VERSION_ID
        else
            OS="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        OS_VERSION=$(sw_vers -productVersion)
    else
        OS="unknown"
    fi
}

# 安裝 Docker (Linux)
install_docker_linux() {
    log_installing "Docker (Linux)"
    
    case $OS in
        ubuntu|debian)
            # Ubuntu/Debian
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
            
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$OS $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        centos|rhel|fedora)
            # CentOS/RHEL/Fedora
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        arch)
            # Arch Linux
            sudo pacman -S --noconfirm docker docker-compose
            ;;
        *)
            log_error "Unsupported Linux distribution: $OS"
            return 1
            ;;
    esac
    
    # Enable and start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    log_success "${MESSAGES[install_success]} Docker"
}

# 安裝 Docker (macOS)
install_docker_macos() {
    log_installing "Docker Desktop (macOS)"
    
    if command_exists brew; then
        brew install --cask docker
    else
        log_error "Homebrew not found. Please install Homebrew first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
    
    log_success "${MESSAGES[install_success]} Docker Desktop"
    log_warning "Please start Docker Desktop from Applications folder"
}

# 安裝 Git
install_git() {
    log_installing "Git"
    
    case $OS in
        ubuntu|debian)
            sudo apt-get update && sudo apt-get install -y git
            ;;
        centos|rhel|fedora)
            sudo yum install -y git
            ;;
        arch)
            sudo pacman -S --noconfirm git
            ;;
        macos)
            if command_exists brew; then
                brew install git
            else
                # Git should be available through Xcode Command Line Tools
                xcode-select --install 2>/dev/null || true
            fi
            ;;
        *)
            log_error "Unsupported OS for Git installation: $OS"
            return 1
            ;;
    esac
    
    log_success "${MESSAGES[install_success]} Git"
}

# 安裝 Homebrew (macOS)
install_homebrew() {
    if [[ "$OS" == "macos" ]] && ! command_exists brew; then
        log_installing "Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            export PATH="/usr/local/bin:$PATH"
        fi
        
        log_success "${MESSAGES[install_success]} Homebrew"
    fi
}

# 主安裝流程
main() {
    clear
    echo -e "${CYAN}============================================================${NC}"
    echo -e "${CYAN}${MESSAGES[title]}${NC}"
    echo -e "${CYAN}============================================================${NC}"
    echo ""
    
    log_info "${MESSAGES[checking_env]}"
    
    # 檢測作業系統
    detect_os
    
    # 顯示系統資訊
    echo -e "${CYAN}${MESSAGES[system_info]}${NC}"
    echo -e "${WHITE}OS: $OS $OS_VERSION${NC}"
    echo -e "${WHITE}Shell: $SHELL${NC}"
    echo -e "${WHITE}User: $USER${NC}"
    echo ""
    
    # 檢查組件
    declare -A components_status=(
        ["git"]="missing"
        ["docker"]="missing"
    )
    
    missing_components=()
    
    # 檢查 Git
    if command_exists git; then
        echo -e "${GREEN}${MESSAGES[component_exists]} Git ($(git --version))${NC}"
        components_status["git"]="exists"
    else
        echo -e "${RED}${MESSAGES[component_missing]} Git${NC}"
        missing_components+=("git")
    fi
    
    # 檢查 Docker
    if command_exists docker; then
        echo -e "${GREEN}${MESSAGES[component_exists]} Docker ($(docker --version))${NC}"
        components_status["docker"]="exists"
    else
        echo -e "${RED}${MESSAGES[component_missing]} Docker${NC}"
        missing_components+=("docker")
    fi
    
    # 檢查 Homebrew (macOS)
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            echo -e "${GREEN}${MESSAGES[component_exists]} Homebrew ($(brew --version | head -n1))${NC}"
        else
            echo -e "${RED}${MESSAGES[component_missing]} Homebrew${NC}"
            missing_components+=("homebrew")
        fi
    fi
    
    echo ""
    
    # 安裝缺失組件
    if [ ${#missing_components[@]} -gt 0 ] || [ "$FORCE" = true ]; then
        echo -e "${YELLOW}Starting installation process...${NC}"
        echo ""
        
        # 檢查 sudo 權限（Linux）
        if [[ "$OS" != "macos" ]] && [ "$EUID" -ne 0 ]; then
            log_warning "${MESSAGES[need_sudo]}"
            sudo -v || { log_error "sudo access required"; exit 1; }
        fi
        
        # 安裝 Homebrew (macOS)
        if [[ "$OS" == "macos" ]] && [[ " ${missing_components[@]} " =~ " homebrew " ]]; then
            install_homebrew
        fi
        
        # 安裝 Git
        if [[ " ${missing_components[@]} " =~ " git " ]] || [ "$FORCE" = true ]; then
            install_git
        fi
        
        # 安裝 Docker
        if [[ " ${missing_components[@]} " =~ " docker " ]] || [ "$FORCE" = true ]; then
            if [[ "$OS" == "macos" ]]; then
                install_docker_macos
            else
                install_docker_linux
            fi
        fi
        
        echo ""
    fi
    
    # 創建或更新 .env 文件
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ENV_PATH="$SCRIPT_DIR/.env"
    ENV_EXAMPLE_PATH="$SCRIPT_DIR/.env.example"
    
    if [[ ! -f "$ENV_PATH" ]] && [[ -f "$ENV_EXAMPLE_PATH" ]]; then
        cp "$ENV_EXAMPLE_PATH" "$ENV_PATH"
        log_success "Created .env file from .env.example"
        log_warning "Please edit .env file and add your API keys."
        echo -e "${CYAN}See docs/CLAUDE-CONFIG-GUIDE.md for Claude Desktop setup.${NC}"
        echo ""
    fi
    
    log_success "${MESSAGES[setup_complete]}"
    echo ""
    
    # 檢查 Docker 是否運行，如果是則自動啟動服務
    if command_exists docker; then
        if docker info >/dev/null 2>&1; then
            echo -e "${YELLOW}${MESSAGES[starting_services]}${NC}"
            "$SCRIPT_DIR/start.sh"
        else
            log_warning "${MESSAGES[docker_not_running]}"
        fi
    fi
    
    echo ""
    echo -e "${WHITE}${MESSAGES[press_enter]}${NC}"
    read -r
}

# 執行主程式
main "$@" 