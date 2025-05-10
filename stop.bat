    #!/bin/bash
    # English: Script to stop all MCP Docker services
    # Traditional Chinese: 停止所有 MCP Docker 服務的腳本

    echo "Stopping Dockerized MCP Services..."
    echo "正在停止 Docker 化的 MCP 服務..."

    # Ensure Docker is running
    if ! docker info > /dev/null 2>&1; then
      echo "Error: Docker does not seem to be running. Please start Docker Desktop and try again."
      echo "錯誤：Docker 似乎沒有在運行。請啟動 Docker Desktop 後再試一次。"
      exit 1
    fi

    # Navigate to the script's directory (project root)
    cd "$(dirname "$0")"

    docker-compose down

    if [ $? -eq 0 ]; then
      echo "Services stopped successfully."
      echo "服務已成功停止。"
    else
      echo "Error stopping services. Check the output above for details."
      echo "停止服務時發生錯誤。請檢查上面的輸出以獲取詳細資訊。"
    fi