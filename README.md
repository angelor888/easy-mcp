# Dockerized MCP (Model Context Protocol) Services

This project provides a streamlined way to deploy a suite of Model Context Protocol (MCP) services using Docker and Docker Compose. It's designed for developers of all skill levels who want to quickly set up and run these tools for integration with applications like Claude Desktop or other compatible clients. This guide provides detailed steps for both macOS and Windows users.

**English** | [繁體中文](#docker化的-mcp-模型上下文協定-服務)

## Included MCP Services

This project configures two types of MCP services:

1.  **Dockerized Services**: These run in isolated Docker containers, managed by `docker-compose`.

    - **Filesystem**: Access and manage local files (maps to `./view` directory on host).
    - **Brave Search**: Utilize Brave Search API (requires API key).
    - **Puppeteer**: Control a headless Chrome browser for web automation tasks.
    - **Memory**: Basic in-memory storage.
    - **Everything**: A general-purpose MCP server.

2.  **Locally Run `uvx` Services**: These are configured to be started by your MCP client application (e.g., Claude Desktop) using the `uvx` command-line tool. They are not managed by the Docker quick start scripts in this repository.
    - **Time**: Provides time-related functionalities.
    - **Fetch**: Fetches content from URLs.

## Prerequisites

Before you begin, ensure you have the following installed:

1.  **Docker Desktop**:

    - **macOS**: [Download and install Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
    - **Windows**: [Download and install Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/). Ensure that WSL 2 (Windows Subsystem for Linux 2) is enabled and configured as the backend for Docker Desktop for optimal performance.
    - Verify Docker is running by opening a terminal (Terminal on macOS, PowerShell or Command Prompt on Windows) and typing `docker --version` and `docker-compose --version` (or `docker compose version` for newer installations).

2.  **`uvx` (for Time and Fetch services)**:

    - If you intend to use the `Time` and `Fetch` MCP services as configured in `claude_desktop_config.json.example`, you'll need `uvx`. `uvx` is a command-line tool, and its installation might vary. Typically, it's part of the Model Context Protocol ecosystem or installed alongside client applications like Claude Desktop.
    - To check if `uvx` is available and in your system's PATH, open a terminal and type `uvx --version`. If it's not found, you may need to consult the MCP documentation or specific instructions for installing `uvx` relevant to your client application.

3.  **Git**:
    - **macOS**: Git is usually pre-installed. Check with `git --version`. If not, install via [Homebrew](https://brew.sh/) (`brew install git`) or download from the [official Git website](https://git-scm.com/download/mac).
    - **Windows**: Download and install Git from the [official Git website](https://git-scm.com/download/win). Ensure it's added to your PATH during installation.

## Getting Started

1.  **Clone the Repository**:
    Open your terminal (Terminal on macOS, Git Bash or PowerShell on Windows) and run:

    ```bash
    git clone https://github.com/NovaProtocol/easy-mcp-docker.git
    cd easy-mcp-docker
    ```

    (Replace `https://github.com/NovaProtocol/easy-mcp-docker.git` with your actual repository URL if different.)

2.  **Configure Environment Variables (for Dockerized Services)**:
    The `mcp-brave-search` service (and potentially others you add later) requires API keys or other sensitive information for its operation. These are managed for the Docker services via an `.env` file in the project root.

    - Copy the example environment file:
      ```bash
      cp .env.example .env
      ```
      (On Windows Command Prompt, use: `copy .env.example .env`)
    - Open the newly created `.env` file with a text editor.
    - Replace `your_brave_api_key_here` with your actual Brave Search API key.
    - _Note_: This `.env` file is specifically for the Docker services defined in `docker-compose.yml`. It is listed in `.gitignore` and should **never** be committed to your repository if it contains real secrets.

3.  **Configure Your MCP Client (e.g., Claude Desktop)**:
    To use these MCP services, you need to configure your client application. This project includes a `claude_desktop_config.json.example` file as a template for Claude Desktop users.

    - **Locate your client's configuration file**:
      - **Claude Desktop (macOS)**: `~/Library/Application Support/Claude/claude_desktop_config.json`
      - **Claude Desktop (Windows)**: `%APPDATA%\\Claude\\claude_desktop_config.json`
      - **Claude Desktop (Linux)**: `~/.config/Claude/claude_desktop_config.json`
    - **Important: Always back up your existing client configuration file before making changes.**
    - Open `claude_desktop_config.json.example` from this repository and review its structure.
    - Carefully merge or adapt its settings into your actual client configuration file.
    - **Crucial - API Keys in Client Configuration**:
      - In your client's configuration (e.g., `claude_desktop_config.json`), services like `brave-search` might have an `env` block:
        ```json
        "env": {
          "BRAVE_API_KEY": "your_brave_api_key_here"
        }
        ```
      - You **must** replace `"your_brave_api_key_here"` with your **real Brave API key** directly in your client's JSON configuration file if the client requires it for initialization or direct use (e.g., if Claude Desktop uses this to pass the key to the `docker exec` command).
      - **Security Note**: Your client configuration file (e.g., `claude_desktop_config.json`) is stored on your local machine. The Docker services in _this_ project read their environment variables from the project's `.env` file. However, the client application itself (like Claude Desktop) reads its configuration from its own JSON file. Be extremely mindful of how you share or back up your client configuration file if it contains sensitive API keys. This `easy-mcp-docker` project and its `.env` file are separate from your client application's configuration.
    - The `claude_desktop_config.json.example` shows:
      - Dockerized services (like `filesystem`, `brave-search`) configured with `command: "docker"` and `args` using `docker exec [...]`. This allows Claude Desktop to manage these as child processes. The `url` field (e.g., `http://localhost:8082`) is the primary way MCP clients typically connect to services that are already running via Docker Compose.
      - `uvx` services (`time`, `fetch`) configured with `command: "uvx"`. Claude Desktop will attempt to run these locally using the `uvx` tool when the services are activated in the client.

4.  **Build and Start Dockerized Services**:
    Navigate to the project root directory in your terminal.
    - **Using Quick Start Scripts (Recommended)**:
      These scripts handle the `docker-compose` commands for you.
      - **macOS/Linux**:
        ```bash
        chmod +x start.sh
        ./start.sh
        ```
      - **Windows**:
        Double-click the `start.bat` file in File Explorer, or run it from Command Prompt:
        ```bat
        start.bat
        ```
    - **Using Docker Compose Directly**:
      `bash
docker-compose up --build -d
`
      This command will build the Docker images (if they don't exist or if Dockerfiles have changed) and start all services defined in `docker-compose.yml` in detached mode (running in the background).

## Verifying Services

- **Dockerized Services**: Check Docker Desktop's dashboard or run `docker ps` in the terminal. You should see containers like `easy-mcp-docker-mcp-filesystem-1` (or similar, depending on your project directory name prefix), `easy-mcp-docker-mcp-brave-search-1`, etc., in a running state.
- **Client Application Logs**: Consult the logs for each service within your client application (e.g., Claude Desktop logs typically in `~/Library/Logs/Claude/` on macOS) to ensure they initialize correctly and connect to the Dockerized services (via their URLs like `http://localhost:8082`) or that `uvx` services start as expected.
- **Service Endpoints**: The Dockerized MCP services will be available at the ports defined in `docker-compose.yml` and `claude_desktop_config.json.example` (e.g., `mcp-filesystem` at `http://localhost:8082`).

## Project Structure

- `.git/`: Your local Git repository data.
- `.gitignore`: Specifies intentionally untracked files that Git should ignore.
- `claude_desktop_config.json.example`: Example configuration for Claude Desktop.
- `custom_user_services/`: Placeholder for your custom Dockerized services.
  - `README.md`: Instructions for adding custom services (English & Traditional Chinese).
- `docker-compose.yml`: Defines all the MCP services for Docker Compose.
- `LICENSE`: Project license file (MIT License).
- `mcp_services/`: Contains the source code and Dockerfiles for all Node.js based MCP services that are Dockerized by this project.
  - `Dockerfile` (for Filesystem service)
  - `brave.Dockerfile`, `puppeteer.Dockerfile`, etc.
  - `package.json`, `package-lock.json`, `tsconfig.json`, `src/`, etc. (Node.js project files for the services)
- `README.md`: This main readme file (English & Traditional Chinese).
- `view/`: Local directory mapped to `/app/projects` inside the `mcp-filesystem` Docker container.
  - `README.md`: Explains how to use this directory.
- `.env.example`: Template for environment variables for Dockerized services.
- `.env`: Your local environment variables for Dockerized services (gitignored).
- `start.sh`: Quick start script for macOS/Linux (manages Docker services).
- `start.bat`: Quick start script for Windows (manages Docker services).
- `stop.sh`: Quick stop script for macOS/Linux (manages Docker services).
- `stop.bat`: Quick stop script for Windows (manages Docker services).

## Disabling Specific Services

- **Dockerized Services**: If you don't need all the Dockerized MCP services, you can disable specific ones:
  1.  Open the `docker-compose.yml` file in a text editor.
  2.  Locate the service definition block for the service you want to disable (e.g., `mcp-puppeteer:`).
  3.  Comment out the entire block for that service by adding a `#` at the beginning of each line in that block.
  4.  Save the `docker-compose.yml` file.
  5.  When you next run `docker-compose up --build -d` (or the start scripts), the commented-out services will not be built or started.
- **`uvx` Services (`time`, `fetch`)**: To disable these, you would remove or comment out their corresponding entries from your client application's configuration file (e.g., `claude_desktop_config.json`). These are not managed by `docker-compose.yml` or the start/stop scripts in this repository.

## Extending with Custom Services

Refer to the `README.md` inside the `custom_user_services/` directory for instructions on how to add and configure your own Dockerized applications to run alongside these MCP services.

## Stopping Dockerized Services

- **Using Quick Stop Scripts**:
  - **macOS/Linux**: `./stop.sh`
  - **Windows**: `stop.bat`
- **Using Docker Compose Directly**:
  ```bash
  docker-compose down
  ```
  This command stops and removes the containers, networks, and volumes created by `docker-compose up` for the Dockerized services.

## Troubleshooting

- **Ensure Docker is running**: Check the Docker Desktop application.
- **Check Dockerized service logs**: `docker-compose logs <service_name>` (e.g., `docker-compose logs mcp-filesystem`). You can also view logs via Docker Desktop.
- **Port conflicts**: Verify that the ports defined in `docker-compose.yml` for Dockerized services are not already in use on your system. You can change them in `docker-compose.yml` (e.g., change `"8082:8082"` to `"8182:8082"`) and also update the corresponding `url` in your client's configuration (e.g., `claude_desktop_config.json`).
- **`.env` file**: Ensure your `.env` file (for Dockerized services) exists in the project root and is correctly populated with necessary API keys.
- **Client Configuration (e.g., `claude_desktop_config.json`)**: Double-check for typos, correct API keys (if needed directly in this file), and correct URLs/ports for Dockerized services, and correct `command`/`args` for `uvx` services.
- **`uvx` path/installation**: If `time` or `fetch` services fail to start via your client application, ensure `uvx` is correctly installed and accessible in your system's PATH, and that the paths in your client configuration are correct.

---

# Docker 化的 MCP (模型上下文協定) 服務

本專案提供了一種使用 Docker 和 Docker Compose 部署一系列模型上下文協定 (MCP) 服務的簡化方法。它專為各種技能水平的開發人員設計，讓他們能夠快速設定並執行這些工具，以便與 Claude Desktop 或其他相容的客戶端應用程式整合。本指南為 macOS 和 Windows 使用者提供了詳細的步驟。

[English](#dockerized-mcp-model-context-protocol-services) | **繁體中文**

## 內含的 MCP 服務

本專案設定了兩種類型的 MCP 服務：

1.  **Docker 化服務**：這些服務在隔離的 Docker 容器中運行，由 `docker-compose` 管理。

    - **Filesystem (檔案系統)**：存取和管理本機檔案 (映射到主機上的 `./view` 目錄)。
    - **Brave Search (Brave 搜尋)**：利用 Brave Search API (需要 API 金鑰)。
    - **Puppeteer**：控制無頭 Chrome 瀏覽器以執行 Web 自動化任務。
    - **Memory (記憶體)**：基本的記憶體內儲存。
    - **Everything (萬能服務)**：一個通用的 MCP 伺服器。

2.  **本機運行的 `uvx` 服務**：這些服務被設定為由您的 MCP 客戶端應用程式 (例如 Claude Desktop) 使用 `uvx` 命令列工具啟動。它們不由本儲存庫中的 Docker 快速啟動腳本管理。
    - **Time (時間服務)**：提供時間相關功能。
    - **Fetch (擷取服務)**：從 URL 擷取內容。

## 先決條件

在開始之前，請確保您已安裝以下軟體：

1.  **Docker Desktop**:

    - **macOS**: [下載並安裝 Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
    - **Windows**: [下載並安裝 Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)。為獲得最佳性能，請確保已啟用 WSL 2 (Windows Subsystem for Linux 2) 並將其設定為 Docker Desktop 的後端。
    - 開啟終端機 (macOS 為 Terminal，Windows 為 PowerShell 或命令提示字元) 並輸入 `docker --version` 和 `docker-compose --version` (或對於較新版本，輸入 `docker compose version`) 來驗證 Docker 是否正在運行。

2.  **`uvx` (用於 Time 和 Fetch 服務)**:

    - 如果您打算使用 `claude_desktop_config.json.example` 中設定的 `Time` 和 `Fetch` MCP 服務，則需要 `uvx`。`uvx` 是一個命令列工具，其安裝方式可能有所不同。通常，它是模型上下文協定生態系統的一部分，或隨 Claude Desktop 等客戶端應用程式一同安裝。
    - 若要檢查 `uvx` 是否可用且位於系統 PATH 中，請開啟終端機並輸入 `uvx --version`。如果找不到該指令，您可能需要查閱 MCP 文件或與您的客戶端應用程式相關的 `uvx` 特定安裝說明。

3.  **Git**:
    - **macOS**: Git 通常已預先安裝。請使用 `git --version` 檢查。如果未安裝，可透過 [Homebrew](https://brew.sh/) (`brew install git`) 安裝或從 [Git 官方網站](https://git-scm.com/download/mac) 下載。
    - **Windows**: 從 [Git 官方網站](https://git-scm.com/download/win) 下載並安裝 Git。在安裝過程中，請確保已將其新增至您的 PATH。

## 開始使用

1.  **複製儲存庫**：
    開啟您的終端機 (macOS 為 Terminal，Windows 為 Git Bash 或 PowerShell) 並執行：

    ```bash
    git clone https://github.com/NovaProtocol/easy-mcp-docker.git
    cd easy-mcp-docker
    ```

    (如果不同，請將 `https://github.com/NovaProtocol/easy-mcp-docker.git` 替換為您實際的儲存庫 URL。)

2.  **設定環境變數 (用於 Docker 化服務)**：
    `mcp-brave-search` 服務 (以及您之後可能添加的其他服務) 的運行需要 API 金鑰或其他敏感資訊。這些資訊透過專案根目錄中的 `.env` 檔案為 Docker 服務進行管理。

    - 複製範例環境檔案：
      ```bash
      cp .env.example .env
      ```
      (在 Windows 命令提示字元中，請使用：`copy .env.example .env`)
    - 使用文字編輯器開啟新建立的 `.env` 檔案。
    - 將 `your_brave_api_key_here` 替換為您實際的 Brave Search API 金鑰。
    - _注意_：此 `.env` 檔案專門用於 `docker-compose.yml` 中定義的 Docker 服務。它已列在 `.gitignore` 中，如果包含真實的秘密金鑰，則**絕不應**提交到您的儲存庫。

3.  **設定您的 MCP 客戶端 (例如 Claude Desktop)**：
    若要使用這些 MCP 服務，您需要設定您的客戶端應用程式。本專案包含一個 `claude_desktop_config.json.example` 檔案，作為 Claude Desktop 使用者的模板。

    - **找到您客戶端的設定檔**：
      - **Claude Desktop (macOS)**: `~/Library/Application Support/Claude/claude_desktop_config.json`
      - **Claude Desktop (Windows)**: `%APPDATA%\\Claude\\claude_desktop_config.json`
      - **Claude Desktop (Linux)**: `~/.config/Claude/claude_desktop_config.json`
    - **重要：在進行更改之前，請務必備份您現有的客戶端設定檔。**
    - 開啟本儲存庫中的 `claude_desktop_config.json.example` 並檢閱其結構。
    - 仔細地將其設定合併或調整到您實際的客戶端設定檔中。
    - **關鍵 - 在客戶端設定中處理 API 金鑰**：
      - 在您的客戶端設定中 (例如 `claude_desktop_config.json`)，像 `brave-search` 這樣的服務可能會有一個 `env` 區塊：
        ```json
        "env": {
          "BRAVE_API_KEY": "your_brave_api_key_here"
        }
        ```
      - 如果客戶端需要金鑰進行初始化或直接使用 (例如，如果 Claude Desktop 使用此金鑰傳遞給 `docker exec` 命令)，您**必須**在客戶端的 JSON 設定檔中直接將 `"your_brave_api_key_here"` 替換為您**真實的 Brave API 金鑰**。
      - **安全提示**：您的客戶端設定檔 (例如 `claude_desktop_config.json`) 儲存在您的本機電腦上。*此*專案中的 Docker 服務從專案的 `.env` 檔案讀取其環境變數。然而，客戶端應用程式本身 (如 Claude Desktop) 從其自己的 JSON 檔案讀取其設定。如果您在客戶端設定檔中包含敏感的 API 金鑰，請極度注意如何分享或備份該檔案。此 `easy-mcp-docker` 專案及其 `.env` 檔案與您的客戶端應用程式的設定是分開的。
    - `claude_desktop_config.json.example` 顯示：
      - Docker 化服務 (如 `filesystem`、`brave-search`) 設定了 `command: "docker"` 和使用 `docker exec [...]` 的 `args`。這允許 Claude Desktop 將這些作為子程序管理。`url` 欄位 (例如 `http://localhost:8082`) 是 MCP 客戶端通常連接到透過 Docker Compose 已運行服務的主要方式。
      - `uvx` 服務 (`time`、`fetch`) 設定了 `command: "uvx"`。當在客戶端中啟動這些服務時，Claude Desktop 將嘗試使用 `uvx` 工具在本機運行它們。

4.  **建置並啟動 Docker 化服務**：
    在終端機中導覽至專案根目錄。
    - **使用快速啟動腳本 (建議使用)**：
      這些腳本為您處理 `docker-compose` 命令。
      - **macOS/Linux**:
        ```bash
        chmod +x start.sh
        ./start.sh
        ```
      - **Windows**:
        在檔案總管中雙擊 `start.bat` 檔案，或從命令提示字元執行：
        ```bat
        start.bat
        ```
    - **直接使用 Docker Compose**:
      `bash
docker-compose up --build -d
`
      此命令將建置 Docker 映像檔 (如果它們不存在或 Dockerfile 已更改)，並以分離模式 (在背景運行) 啟動 `docker-compose.yml` 中定義的所有服務。

## 驗證服務

- **Docker 化服務**: 檢查 Docker Desktop 的儀表板或在終端機中執行 `docker ps`。您應該會看到像 `easy-mcp-docker-mcp-filesystem-1` (或類似名稱，取決於您的專案目錄名稱前綴)、`easy-mcp-docker-mcp-brave-search-1` 等容器處於運行狀態。
- **客戶端應用程式日誌**: 查閱您客戶端應用程式中每個服務的日誌 (例如，macOS 上的 Claude Desktop 日誌通常位於 `~/Library/Logs/Claude/`)，以確保它們正確初始化並連接到 Docker 化服務 (透過其 URL，如 `http://localhost:8082`)，或者 `uvx` 服務如預期啟動。
- **服務端點**: Docker 化的 MCP 服務將在 `docker-compose.yml` 和 `claude_desktop_config.json.example` 中定義的埠號上可用 (例如，`mcp-filesystem` 在 `http://localhost:8082`)。

## 專案結構

- `.git/`: 您的本機 Git 儲存庫資料。
- `.gitignore`: 指定 Git 應忽略的非追蹤檔案。
- `claude_desktop_config.json.example`: Claude Desktop 的範例設定檔。
- `custom_user_services/`: 供您放置自訂 Docker 化服務的預留目錄。
  - `README.md`: 新增自訂服務的說明 (英文和繁體中文)。
- `docker-compose.yml`: 為 Docker Compose 定義所有 MCP 服務。
- `LICENSE`: 專案授權條款檔案 (MIT License)。
- `mcp_services/`: 包含本專案 Docker 化的所有基於 Node.js 的 MCP 服務的原始碼和 Dockerfile。
  - `Dockerfile` (用於 Filesystem 服務)
  - `brave.Dockerfile`, `puppeteer.Dockerfile`, 等。
  - `package.json`, `package-lock.json`, `tsconfig.json`, `src/`, 等 (服務的 Node.js 專案檔案)。
- `README.md`: 此主要的 readme 檔案 (英文和繁體中文)。
- `view/`: 映射到 `mcp-filesystem` Docker 容器內 `/app/projects` 的本機目錄。
  - `README.md`: 說明如何使用此目錄。
- `.env.example`: Docker 化服務的環境變數模板。
- `.env`: 您本地的 Docker 化服務環境變數 (已被 gitignore)。
- `start.sh`: macOS/Linux 的快速啟動腳本 (管理 Docker 服務)。
- `start.bat`: Windows 的快速啟動腳本 (管理 Docker 服務)。
- `stop.sh`: macOS/Linux 的快速停止腳本 (管理 Docker 服務)。
- `stop.bat`: Windows 的快速停止腳本 (管理 Docker 服務)。

## 停用特定服務

- **Docker 化服務**：如果您不需要所有的 Docker 化 MCP 服務，您可以輕鬆地停用特定的服務：
  1.  使用文字編輯器開啟 `docker-compose.yml` 檔案。
  2.  找到您想要停用之服務的服務定義區塊 (例如 `mcp-puppeteer:`)。
  3.  透過在該區塊中每一行的開頭加上 `#` 來註解掉整個服務區塊。
  4.  儲存 `docker-compose.yml` 檔案。
  5.  當您下次執行 `docker-compose up --build -d` (或啟動腳本) 時，被註解掉的服務將不會被建置或啟動。
- **`uvx` 服務 (`time`, `fetch`)**：要停用這些服務，您需要從您的客戶端應用程式的設定檔 (例如 `claude_desktop_config.json`) 中移除或註解掉它們對應的條目。這些服務不由本儲存庫中的 `docker-compose.yml` 或啟動/停止腳本管理。

## 使用自訂服務擴展

有關如何新增和設定您自己的 Docker 化應用程式以與這些 MCP 服務一起運行的說明，請參閱 `custom_user_services/` 目錄內的 `README.md`。

## 停止 Docker 化服務

- **使用快速停止腳本**：
  - **macOS/Linux**: `./stop.sh`
  - **Windows**: `stop.bat`
- **直接使用 Docker Compose**:
  ```bash
  docker-compose down
  ```
  此命令會停止並移除由 `docker-compose up` 為 Docker 化服務建立的容器、網路和磁碟區。

## 疑難排解

- **確保 Docker 正在運行**：檢查 Docker Desktop 應用程式。
- **檢查 Docker 化服務日誌**：`docker-compose logs <service_name>` (例如 `docker-compose logs mcp-filesystem`)。您也可以透過 Docker Desktop 查看日誌。
- **埠號衝突**：驗證 `docker-compose.yml` 中為 Docker 化服務定義的埠號在您的系統上未被使用。您可以在 `docker-compose.yml` 中更改它們 (例如，將 `"8082:8082"` 改為 `"8182:8082"`)，並同時更新您的客戶端設定 (例如 `claude_desktop_config.json`) 中相應的 `url`。
- **`.env` 檔案**：確保您的 `.env` 檔案 (用於 Docker 化服務) 存在於專案根目錄且已正確填寫必要的 API 金鑰。
- **客戶端設定 (例如 `claude_desktop_config.json`)**：再次檢查是否有拼寫錯誤、正確的 API 金鑰 (如果此檔案中直接需要)、Docker 化服務的正確 URL/埠號，以及 `uvx` 服務的正確 `command`/`args`。
- **`uvx` 路徑/安裝**：如果 `time` 或 `fetch` 服務無法透過您的客戶端應用程式啟動，請確保 `uvx` 已正確安裝並可在您系統的 PATH 中存取，且您客戶端設定中的路徑正確。
