# Claude Desktop 配置指南

## 📋 概述

本指南說明如何配置 Claude Desktop 以使用 Easy-MCP 服務。

## 🔧 配置步驟

### 1. 啟動 Easy-MCP 服務

首先啟動所有 MCP 服務：

```bash
# Windows
.\start.bat

# Linux/macOS
./start.sh
```

### 2. 複製配置文件

將 `claude_desktop_config.json.example` 複製為您的 Claude Desktop 配置：

**Windows:**
```bash
copy claude_desktop_config.json.example "%APPDATA%\Claude\claude_desktop_config.json"
```

**macOS:**
```bash
cp claude_desktop_config.json.example ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**Linux:**
```bash
cp claude_desktop_config.json.example ~/.config/Claude/claude_desktop_config.json
```

### 3. 重新啟動 Claude Desktop

配置完成後，重新啟動 Claude Desktop 應用程式以載入新配置。

## 📦 服務說明

### Docker 服務

以下服務需要 Docker 容器運行（使用 `start.bat` 或 `start.sh` 啟動）：

| 服務名稱 | 端口 | 功能描述 |
|---------|------|----------|
| **filesystem** | 8082 | 檔案系統操作 - 檔案讀取、寫入、搜尋 |
| **puppeteer** | 8084 | 網頁自動化 - 截圖、爬蟲、自動化測試 |
| **memory** | 8085 | 記憶體管理 - 對話歷史和知識庫 |
| **everything** | 8086 | 全功能搜尋 - 整合多種搜尋引擎 |

### uvx 服務

以下服務使用 uvx 運行（需要安裝：`pip install uvx`）：

| 服務名稱 | 功能描述 |
|---------|----------|
| **time** | 時間管理 - 時間查詢、時區轉換、日期計算 |
| **fetch** | HTTP 請求 - 網路請求、API 呼叫、資料擷取 |

## 🛠️ 配置文件內容

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "docker",
      "args": ["exec", "-i", "docker-site-mcp-filesystem", "node", "dist/index.js", "/app/projects"],
      "url": "http://localhost:8082"
    },
    "puppeteer": {
      "command": "docker",
      "args": ["exec", "-i", "docker-site-mcp-puppeteer", "node", "dist/index.js"],
      "url": "http://localhost:8084"
    },
    "memory": {
      "command": "docker",
      "args": ["exec", "-i", "docker-site-mcp-memory", "node", "dist/index.js"],
      "url": "http://localhost:8085"
    },
    "everything": {
      "command": "docker",
      "args": ["exec", "-i", "docker-site-mcp-everything", "node", "dist/index.js"],
      "url": "http://localhost:8086"
    },
    "time": {
      "command": "uvx",
      "args": ["mcp-server-time", "--local-timezone=Asia/Taipei"]
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    }
  },
  "globalShortcut": "Ctrl+Q"
}
```

## 🔍 故障排除

### 服務無法連接

1. **檢查 Docker 服務狀態：**
   ```bash
   docker compose ps
   ```

2. **查看服務日誌：**
   ```bash
   docker compose logs -f [service-name]
   ```

3. **重新啟動服務：**
   ```bash
   # Windows
   .\stop.bat
   .\start.bat
   
   # Linux/macOS
   ./stop.sh
   ./start.sh
   ```

### uvx 服務問題

1. **確認 uvx 已安裝：**
   ```bash
   pip install uvx
   ```

2. **檢查服務可用性：**
   ```bash
   uvx mcp-server-time --help
   uvx mcp-server-fetch --help
   ```

### 配置文件位置

如果不確定配置文件位置，請參考以下路徑：

- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux**: `~/.config/Claude/claude_desktop_config.json`

## 🎛️ 自定義配置

### 修改時區（time 服務）

```json
"time": {
  "command": "uvx",
  "args": ["mcp-server-time", "--local-timezone=YOUR_TIMEZONE"]
}
```

常用時區：
- 台北：`Asia/Taipei`
- 上海：`Asia/Shanghai`
- 東京：`Asia/Tokyo`
- 紐約：`America/New_York`
- 倫敦：`Europe/London`

### 修改檔案系統掛載點（filesystem 服務）

預設掛載點是 `./view` 目錄。如需修改，請編輯 `docker-compose.yml`：

```yaml
volumes:
  - /your/custom/path:/app/projects
```

然後重新啟動服務。

## 📞 支援

如有問題，請參考：
- [快速啟動指南](QUICK-START.md)
- [實施總結](IMPLEMENTATION-SUMMARY.md)
- [專案 README](README.md)

---

**版本**: Easy-MCP v2.0.0  
**最後更新**: 2025-06-29 