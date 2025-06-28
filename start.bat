@echo off
REM Script to intelligently detect, install, and start all MCP Docker services
REM Version: 2.1.0
REM One-click deployment with automatic dependency detection and installation

REM Navigate to script's directory first
cd /d "%~dp0"

REM Determine language (default to English, override with zh-TW if environment variable set)
set LANG=%LANG%
if "%LANG%"=="" set LANG=en
if "%LANG:zh_TW=%" neq "%LANG%" set LANG=zh-TW

REM Language-specific messages
if "%LANG%"=="zh-TW" (
  set MSG_WELCOME=🚀 歡迎使用 Easy-MCP 智能一鍵部署系統 v2.1
  set MSG_AUTO_DETECT=🔍 正在自動檢測和安裝環境依賴...
  set MSG_START=正在啟動 Docker 化的 MCP 服務...
  set MSG_DOCKER_ERROR=錯誤：Docker 未運行。正在嘗試自動啟動...
  set MSG_COMPOSE_ERROR=錯誤：docker compose 未安裝或不可用。請檢查 Docker 安裝。
  set MSG_ENV_MISSING=找不到 .env 檔案。正在從 .env.example 複製...
  set MSG_ENV_NOTE=重要提示：請開啟 .env 檔案並填入實際 API 金鑰。
  set MSG_ENV_EXAMPLE_MISSING=錯誤：.env.example 檔案不存在。請檢查專案檔案完整性。
  set MSG_BUILDING=正在以分離模式建置並啟動服務...
  set MSG_SUCCESS=🎉 服務已成功啟動！可以開始使用 Easy-MCP 了。
  set MSG_ERROR=啟動服務失敗。請檢查輸出以獲取詳細資訊。
  set MSG_ENV_SETUP=⚙️  正在自動安裝環境...
  set MSG_SETUP_SUCCESS=✅ 環境安裝完成，繼續啟動服務...
  set MSG_SETUP_FAILED=❌ 環境安裝失敗，請檢查錯誤訊息
  set MSG_DOCKER_STARTING=🐳 正在啟動 Docker Desktop，請稍候...
  set MSG_ALL_READY=🌟 系統已就緒！所有依賴都已安裝並運行。
) else (
  set MSG_WELCOME=🚀 Welcome to Easy-MCP Intelligent One-Click Deployment v2.1
  set MSG_AUTO_DETECT=🔍 Automatically detecting and installing environment dependencies...
  set MSG_START=Starting Dockerized MCP Services...
  set MSG_DOCKER_ERROR=Error: Docker is not running. Attempting auto-start...
  set MSG_COMPOSE_ERROR=Error: docker compose is not installed or unavailable. Please check Docker installation.
  set MSG_ENV_MISSING=No .env file found. Copying from .env.example...
  set MSG_ENV_NOTE=IMPORTANT: Please open the .env file and fill in your actual API keys.
  set MSG_ENV_EXAMPLE_MISSING=Error: .env.example file not found. Please check project file integrity.
  set MSG_BUILDING=Building and starting services in detached mode...
  set MSG_SUCCESS=🎉 Services started successfully! Easy-MCP is ready to use.
  set MSG_ERROR=Error starting services. Check the output for details.
  set MSG_ENV_SETUP=⚙️  Auto-installing environment...
  set MSG_SETUP_SUCCESS=✅ Environment setup completed, continuing with service startup...
  set MSG_SETUP_FAILED=❌ Environment setup failed, please check error messages
  set MSG_DOCKER_STARTING=🐳 Starting Docker Desktop, please wait...
  set MSG_ALL_READY=🌟 System ready! All dependencies are installed and running.
)

echo.
echo ================================================================
echo %MSG_WELCOME%
echo ================================================================
echo.
echo %MSG_AUTO_DETECT%
echo.

REM Smart environment detection and auto-installation
set NEED_SETUP=0
set ENV_ISSUES=

REM Check if Git is available
git --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo ❌ Git not found
  set NEED_SETUP=1
  set ENV_ISSUES=%ENV_ISSUES% Git
) else (
  echo ✅ Git is available
)

REM Check if Docker is available
docker --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo ❌ Docker not found
  set NEED_SETUP=1
  set ENV_ISSUES=%ENV_ISSUES% Docker
) else (
  echo ✅ Docker is available
)

REM Auto-install missing dependencies
if %NEED_SETUP%==1 (
  echo.
  echo %MSG_ENV_SETUP%
  echo Missing components:%ENV_ISSUES%
  echo.
  
  if exist "quick-setup.ps1" (
    powershell -ExecutionPolicy Bypass -File "quick-setup.ps1" -Language %LANG%
    if %ERRORLEVEL% equ 0 (
      echo.
      echo %MSG_SETUP_SUCCESS%
      echo.
    ) else (
      echo.
      echo %MSG_SETUP_FAILED%
      echo Please run: quick-setup.ps1 -Force
      pause
      exit /b 1
    )
  ) else (
    echo Quick setup script not found. Please install dependencies manually.
    pause
    exit /b 1
  )
) else (
  echo %MSG_ALL_READY%
  echo.
)

REM Smart Docker startup handling
:CHECK_DOCKER
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo %MSG_DOCKER_STARTING%
  
  REM Try to start Docker Desktop
  start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe" 2>nul
  if %ERRORLEVEL% neq 0 (
    start "" "%PROGRAMFILES%\Docker\Docker\Docker Desktop.exe" 2>nul
  )
  
  REM Wait for Docker to start (with timeout)
  set /a WAIT_COUNT=0
  :WAIT_DOCKER
  timeout /t 3 /nobreak >nul
  docker info >nul 2>&1
  if %ERRORLEVEL% equ 0 goto DOCKER_READY
  
  set /a WAIT_COUNT+=1
  if %WAIT_COUNT% lss 20 (
    echo Waiting for Docker to start... (%WAIT_COUNT%/20)
    goto WAIT_DOCKER
  )
  
  echo Docker failed to start automatically. Please start Docker Desktop manually.
  echo Press any key when Docker is running...
  pause >nul
  goto CHECK_DOCKER
)

:DOCKER_READY
echo ✅ Docker is running

REM Check if docker compose is available
docker compose version >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo %MSG_COMPOSE_ERROR%
  pause
  exit /b 1
)

echo ✅ Docker Compose is available

REM Handle .env file
if not exist .env (
  if not exist .env.example (
    echo %MSG_ENV_EXAMPLE_MISSING%
    pause
    exit /b 1
  )
  echo %MSG_ENV_MISSING%
  copy .env.example .env >nul
  if %ERRORLEVEL% neq 0 (
    echo Error copying .env.example to .env.
    pause
    exit /b 1
  )
  echo %MSG_ENV_NOTE%
  echo.
)

echo %MSG_BUILDING%
docker compose up --build -d
set COMPOSE_EXIT_CODE=%ERRORLEVEL%

echo.
if %COMPOSE_EXIT_CODE% equ 0 (
  echo %MSG_SUCCESS%
  echo.
  echo 📋 Available Services:
  echo   🗂️  MCP Filesystem ^(Port 8082^) - File management
  echo   🌐 MCP Puppeteer ^(Port 8084^) - Browser automation  
  echo   🧠 MCP Memory ^(Port 8085^) - In-memory storage
  echo   🔧 MCP Everything ^(Port 8086^) - Multi-purpose server
  echo   ⏰ MCP Time ^(uvx^) - Time functions
  echo   📡 MCP Fetch ^(uvx^) - URL content retrieval
  echo.
  echo 🔗 Next Steps:
  echo   1. Configure Claude Desktop: see claude_desktop_config.json.example
  echo   2. Edit .env file with your API keys
  echo   3. View documentation: docs/QUICK-START.md
  echo.
  echo 📊 Management Commands:
  echo   Logs: docker compose logs -f
  echo   Stop: stop.bat or docker compose down
  echo   Restart: start.bat
  echo.
  echo ✨ Easy-MCP is now ready for use!
) else (
  echo.
  echo %MSG_ERROR%
  echo.
  echo 🔧 Troubleshooting:
  echo   1. Check if Docker Desktop is running
  echo   2. Verify .env file has correct values
  echo   3. Run 'docker compose logs' for detailed error messages
  echo   4. Run 'quick-setup.ps1 -Force' to reinstall environment
  echo   5. Check docs/QUICK-START.md for detailed guide
  echo.
  pause
  exit /b 1
)

echo.
echo Press any key to close this window...
pause >nul

