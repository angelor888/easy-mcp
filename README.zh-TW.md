# Docker 化的 MCP (模型上下文協定) 服務

本專案提供使用 Docker 和 Docker Compose 部署模型上下文協定 (MCP) 服務的簡化方案，適合各技能水平的開發者，方便與 Claude Desktop 等相容客戶端整合。本文檔為 macOS 和 Windows 使用者提供清晰的操作指引。

[English README](./README.md) | **繁體中文**

## 快速啟動

快速部署 MCP 服務只需以下步驟：

1. **安裝先決條件**：

   - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Git (`git --version` 確認)
   - `uvx` (如需 Time/Fetch 服務，執行 `uvx --version` 確認)

2. **複製儲存庫**：

   ```bash
   git clone https://github.com/NovaProtocol/easy-mcp.git
   cd easy-mcp
   ```

3. **設定環境變數**：

   ```bash
   cp .env.example .env
   ```

   - 編輯 `.env`，填入 Brave Search API 金鑰。

4. **啟動服務**：

   - **macOS/Linux**：
     ```bash
     chmod +x start.sh
     ./start.sh
     ```
   - **Windows**：執行 `start.bat`。

5. **驗證**：
   - 執行 `docker ps`，確認容器運行。
   - 檢查客戶端日誌，確保服務連線正常。

## 服務概述

本專案包含兩類 MCP 服務：

1. **Docker 化服務** (由 `docker-compose` 管理)：

   - **Filesystem**：管理本機檔案 (映射至 `./view`)。
   - **Brave Search**：使用 Brave Search API (需 API 金鑰)。
   - **Puppeteer**：無頭 Chrome 瀏覽器自動化。
   - **Memory**：記憶體儲存。
   - **Everything**：通用 MCP 伺服器。

2. **本機 `uvx` 服務** (由客戶端透過 `uvx` 啟動)：
   - **Time**：時間功能。
   - **Fetch**：URL 內容擷取。

## 先決條件

- **Docker Desktop**：

  - macOS/Windows：從 [Docker 官網](https://www.docker.com/products/docker-desktop/) 安裝。
  - Windows：啟用 WSL 2。
  - 驗證：`docker --version` 和 `docker-compose --version`。

- **uvx**：

  - 確認：`uvx --version`。
  - 未安裝請參考 MCP 或客戶端文件。

- **Git**：
  - macOS：預裝或透過 [Homebrew](https://brew.sh/) (`brew install git`)。
  - Windows：從 [Git 官網](https://git-scm.com/download/win) 安裝。

## 詳細設定

1. **客戶端設定 (如 Claude Desktop)**：

   - 設定檔路徑：
     - macOS：`~/Library/Application Support/Claude/claude_desktop_config.json`
     - Windows：`%APPDATA%\Claude\claude_desktop_config.json`
     - Linux：`~/.config/Claude/claude_desktop_config.json`
   - 備份設定檔。
   - 參考 `claude_desktop_config.json.example`，更新 API 金鑰和 URL。

2. **停用服務**：

   - Docker 化服務：在 `docker-compose.yml` 註解服務區塊，重新執行 `docker-compose up --build -d`。
   - uvx 服務：在客戶端設定檔移除相關條目。

3. **自訂服務**：
   - 參考 `custom_user_services/README.md` 新增 Docker 化服務。

## 停止服務

- **腳本**：
  - macOS/Linux：`./stop.sh`
  - Windows：`stop.bat`
- **Docker Compose**：
  ```bash
  docker-compose down
  ```

## 專案結構

- `.gitignore`：忽略檔案清單。
- `claude_desktop_config.json.example`：客戶端設定範例。
- `custom_user_services/`：自訂服務目錄。
- `docker-compose.yml`：Docker 服務定義。
- `LICENSE`：MIT 授權。
- `mcp_services/`：Node.js 服務原始碼。
- `view/`：映射至 `mcp-filesystem` 容器。
- `.env.example`, `.env`：環境變數。
- `start.sh`, `start.bat`, `stop.sh`, `stop.bat`：啟動/停止腳本。

## 疑難排解

- **Docker 未運行**：檢查 Docker Desktop。
- **日誌**：執行 `docker-compose logs <service_name>`。
- **埠衝突**：修改 `docker-compose.yml` 和客戶端設定中的埠。
- **.env**：確認檔案存在且金鑰正確。
- **uvx**：確保安裝且在 PATH 中。

## 授權

本專案採用 [MIT 授權](./LICENSE)。
