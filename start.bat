@echo off
REM Script to build and start all MCP Docker services
REM Version: 1.0.0

REM Determine language (default to English, override with zh-TW if environment variable set)
set LANG=%LANG%
if "%LANG%"=="" set LANG=en
if "%LANG:zh_TW=%" neq "%LANG%" set LANG=zh-TW

REM Language-specific messages
if "%LANG%"=="zh-TW" (
  set MSG_START=正在啟動 Docker 化的 MCP 服務...
  set MSG_DOCKER_ERROR=錯誤：Docker 未運行。請啟動 Docker Desktop 後重試。
  set MSG_COMPOSE_ERROR=錯誤：docker compose 未安裝或不可用。請檢查 Docker 安裝。
  set MSG_ENV_MISSING=找不到 .env 檔案。正在從 .env.example 複製...
  set MSG_ENV_NOTE=重要提示：請開啟 .env 檔案並填入實際 API 金鑰。
  set MSG_ENV_EXAMPLE_MISSING=錯誤：.env.example 檔案不存在。請檢查專案檔案完整性。
  set MSG_BUILDING=正在以分離模式建置並啟動服務...
  set MSG_SUCCESS=服務已成功啟動。執行 stop.bat 或 docker compose down 停止服務。
  set MSG_ERROR=啟動服務失敗。請檢查輸出以獲取詳細資訊。
) else (
  set MSG_START=Starting Dockerized MCP Services...
  set MSG_DOCKER_ERROR=Error: Docker is not running. Please start Docker Desktop and try again.
  set MSG_COMPOSE_ERROR=Error: docker compose is not installed or unavailable. Please check Docker installation.
  set MSG_ENV_MISSING=No .env file found. Copying from .env.example...
  set MSG_ENV_NOTE=IMPORTANT: Please open the .env file and fill in your actual API keys.
  set MSG_ENV_EXAMPLE_MISSING=Error: .env.example合わせて file not found. Please check project file integrity.
  set MSG_BUILDING=Building and starting services in detached mode...
  set MSG_SUCCESS=Services started successfully. Run stop.bat or docker compose down to stop them.
  set MSG_ERROR=Error starting services. Check the output for details.
)

echo %MSG_START%

REM Check if Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo %MSG_DOCKER_ERROR%
  exit /b 1
)

REM Check if docker compose is available
docker compose version >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo %MSG_COMPOSE_ERROR%
  exit /b 1
)

REM Navigate to script's directory
cd /d "%~dp0"

REM Copy .env.example to .env if .env doesn't exist
if not exist .env (
  if not exist .env.example (
    echo %MSG_ENV_EXAMPLE_MISSING%
    exit /b 1
  )
  echo %MSG_ENV_MISSING%
  copy .env.example .env >nul
  if %ERRORLEVEL% neq 0 (
    echo Error copying .env.example to .env.
    exit /b 1
  )
  echo %MSG_ENV_NOTE%
)

echo %MSG_BUILDING%
docker compose up --build -d

if %ERRORLEVEL% equ 0 (
  echo %MSG_SUCCESS%
) else (
  echo %MSG_ERROR%
  exit /b 1
)