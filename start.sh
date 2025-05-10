```bash
#!/bin/bash
# Script to build and start all MCP Docker services
# Version: 1.0.0

# Determine language (default to English, override with zh-TW if LANG includes zh_TW)
if [[ "$LANG" =~ "zh_TW" ]]; then
  LANG="zh-TW"
else
  LANG="en"
fi

# Language-specific messages
if [ "$LANG" = "zh-TW" ]; then
  MSG_START="正在啟動 Docker 化的 MCP 服務..."
  MSG_DOCKER_ERROR="錯誤：Docker 未運行。請啟動 Docker Desktop 後重試。"
  MSG_COMPOSE_ERROR="錯誤：docker compose 未安裝或不可用。請檢查 Docker 安裝。"
  MSG_ENV_MISSING="找不到 .env 檔案。正在從 .env.example 複製..."
  MSG_ENV_NOTE="重要提示：請開啟 .env 檔案並填入實際 API 金鑰。"
  MSG_ENV_EXAMPLE_MISSING="錯誤：.env.example 檔案不存在。請檢查專案檔案完整性。"
  MSG_BUILDING="正在以分離模式建置並啟動服務..."
  MSG_SUCCESS="服務已成功啟動。執行 './stop.sh' 或 'docker compose down' 停止服務。"
  MSG_ERROR="啟動服務失敗。請檢查輸出以獲取詳細資訊。"
else
  MSG_START="Starting Dockerized MCP Services..."
  MSG_DOCKER_ERROR="Error: Docker is not running. Please start Docker Desktop and try again."
  MSG_COMPOSE_ERROR="Error: docker compose is not installed or unavailable. Please check Docker installation."
  MSG_ENV_MISSING="No .env file found. Copying from .env.example..."
  MSG_ENV_NOTE="IMPORTANT: Please open the .env file and fill in your actual API keys."
  MSG_ENV_EXAMPLE_MISSING="Error: .env.example file not found. Please check project file integrity."
  MSG_BUILDING="Building and starting services in detached mode..."
  MSG_SUCCESS="Services started successfully. Run './stop.sh' or 'docker compose down' to stop them."
  MSG_ERROR="Error starting services. Check the output for details."
fi

echo "$MSG_START"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "$MSG_DOCKER_ERROR"
  exit 1
fi

# Check if docker compose is available
if ! docker compose version >/dev/null 2>&1; then
  echo "$MSG_COMPOSE_ERROR"
  exit 1
fi

# Navigate to script's directory
cd "$(dirname "$0")" || exit 1

# Copy .env.example to .env if .env doesn't exist
if [ ! -f .env ]; then
  if [ ! -f .env.example ]; then
    echo "$MSG_ENV_EXAMPLE_MISSING"
    exit 1
  fi
  echo "$MSG_ENV_MISSING"
  cp .env.example .env || exit 1
  echo "$MSG_ENV_NOTE"
fi

echo "$MSG_BUILDING"
docker compose up --build -d

if [ $? -eq 0 ]; then
  echo "$MSG_SUCCESS"
else
  echo "$MSG_ERROR"
  exit 1
fi
```