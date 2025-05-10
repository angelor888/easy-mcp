```bash
#!/bin/bash
# Script to stop all MCP Docker services
# Version: 1.0.0

# Determine language (default to English, override with zh-TW if LANG includes zh_TW)
if [[ "$LANG" =~ "zh_TW" ]]; then
  LANG="zh-TW"
else
  LANG="en"
fi

# Language-specific messages
if [ "$LANG" = "zh-TW" ]; then
  MSG_STOP="正在停止 Docker 化的 MCP 服務..."
  MSG_DOCKER_ERROR="錯誤：Docker 未運行。請啟動 Docker Desktop 後重試。"
  MSG_COMPOSE_ERROR="錯誤：docker compose 未安裝或不可用。請檢查 Docker 安裝。"
  MSG_SUCCESS="服務已成功停止。"
  MSG_ERROR="停止服務失敗。請檢查輸出以獲取詳細資訊。"
else
  MSG_STOP="Stopping Dockerized MCP Services..."
  MSG_DOCKER_ERROR="Error: Docker is not running. Please start Docker Desktop and try again."
  MSG_COMPOSE_ERROR="Error: docker compose is not installed or unavailable. Please check Docker installation."
  MSG_SUCCESS="Services stopped successfully."
  MSG_ERROR="Error stopping services. Check the output for details."
fi

echo "$MSG_STOP"

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

docker compose down

if [ $? -eq 0 ]; then
  echo "$MSG_SUCCESS"
else
  echo "$MSG_ERROR"
  exit 1
fi
```