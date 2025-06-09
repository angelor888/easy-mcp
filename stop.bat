@echo off
REM Script to stop all MCP Docker services
REM Version: 1.0.0

REM Determine language (default to English, override with zh-TW if environment variable set)
set LANG=%LANG%
if "%LANG%"=="" set LANG=en
if "%LANG:zh_TW=%" neq "%LANG%" set LANG=zh-TW

REM Language-specific messages
if "%LANG%"=="zh-TW" (
  set MSG_STOP=正在停止 Docker 化的 MCP 服務...
  set MSG_DOCKER_ERROR=錯誤：Docker 未運行。請啟動 Docker Desktop 後重試。
  set MSG_COMPOSE_ERROR=錯誤：docker compose 未安裝或不可用。請檢查 Docker 安裝。
  set MSG_SUCCESS=服務已成功停止。
  set MSG_ERROR=停止服務失敗。請檢查輸出以獲取詳細資訊。
) else (
  set MSG_STOP=Stopping Dockerized MCP Services...
  set MSG_DOCKER_ERROR=Error: Docker is not running. Please start Docker Desktop and try again.
  set MSG_COMPOSE_ERROR=Error: docker compose is not installed or unavailable. Please check Docker installation.
  set MSG_SUCCESS=Services stopped successfully.
  set MSG_ERROR=Error stopping services. Check the output for details.
)

echo %MSG_STOP%

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

docker compose down

if %ERRORLEVEL% equ 0 (
  echo %MSG_SUCCESS%
) else (
  echo %MSG_ERROR%
  exit /b 1
)
