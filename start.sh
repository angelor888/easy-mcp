    #!/bin/bash
    # English: Script to build and start all MCP Docker services
    # Traditional Chinese: 建置並啟動所有 MCP Docker 服務的腳本

    echo "Starting Dockerized MCP Services..."
    echo "正在啟動 Docker 化的 MCP 服務..."

    # Ensure Docker is running
    if ! docker info > /dev/null 2>&1; then
      echo "Error: Docker does not seem to be running. Please start Docker Desktop and try again."
      echo "錯誤：Docker 似乎沒有在運行。請啟動 Docker Desktop 後再試一次。"
      exit 1
    fi

    # Navigate to the script's directory (project root)
    cd "$(dirname "$0")"

    # Copy .env.example to .env if .env doesn't exist
    if [ ! -f .env ]; then
      echo "No .env file found. Copying from .env.example..."
      echo "找不到 .env 檔案。正在從 .env.example 複製..."
      cp .env.example .env
      echo "IMPORTANT: Please open the .env file and fill in your actual API keys."
      echo "重要提示：請開啟 .env 檔案並填入您實際的 API 金鑰。"
    fi

    echo "Building and starting services in detached mode..."
    echo "正在以分離模式建置並啟動服務..."
    docker-compose up --build -d

    if [ $? -eq 0 ]; then
      echo "Services started successfully."
      echo "服務已成功啟動。"
      echo "Run './stop.sh' or 'docker-compose down' to stop them."
      echo "執行 './stop.sh' 或 'docker-compose down' 來停止服務。"
    else
      echo "Error starting services. Check the output above for details."
      echo "啟動服務時發生錯誤。請檢查上面的輸出以獲取詳細資訊。"
    fi