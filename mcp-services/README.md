# Easy-MCP Services

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-22%2B-green)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://www.docker.com/)

> **專業級 Model Context Protocol 服務集合**

Easy-MCP Services 提供完整的 MCP 服務實作，包含檔案系統、記憶體、瀏覽器自動化和通用工具等核心功能，專為 Claude Desktop 和其他 MCP 客戶端優化。

---

## 🚀 服務概覽

### 核心服務架構

| 服務 | 功能 | 端口 | 狀態 |
|------|------|------|------|
| **🗂️ Filesystem** | 檔案系統操作與管理 | 8082 | ✅ 穩定 |
| **🧠 Memory** | 知識圖譜記憶體存儲 | 8085 | ✅ 穩定 |
| **🌐 Puppeteer** | 無頭瀏覽器自動化 | 8084 | ✅ 穩定 |
| **🔧 Everything** | 多功能 MCP 工具集 | 8086 | ✅ 穩定 |

### 技術標準

- **Node.js**: 22.0.0+
- **TypeScript**: 5.6.3+
- **MCP Protocol**: 官方標準
- **Docker**: 容器化部署
- **架構**: Monorepo + Workspaces

---

## 📦 安裝與構建

### 前置需求

```bash
# Node.js 22+
node --version  # v22.0.0+

# npm 10+
npm --version   # 10.0.0+

# Docker（用於容器化部署）
docker --version
```

### 開發環境設置

```bash
# 安裝依賴
npm install

# 構建所有服務
npm run build

# 監視模式開發
npm run watch

# 清理建置檔案
npm run clean
```

---

## 🐳 Docker 部署

### 容器化配置

每個服務都配備專用的 Dockerfile：

```
mcp-services/
├── filesystem.Dockerfile    # 檔案系統服務 (port 8082)
├── memory.Dockerfile       # 記憶體服務 (port 8085)
├── puppeteer.Dockerfile    # 瀏覽器服務 (port 8084)
├── everything.Dockerfile   # 通用工具服務 (port 8086)
```

### 服務啟動

```bash
# 使用 Docker Compose 啟動所有服務
cd ..
docker-compose up -d

# 檢查服務狀態
docker-compose ps

# 查看服務日誌
docker-compose logs -f
```

---

## 🛠️ 服務詳細說明

### 1. Filesystem Service

**功能特性**：
- 檔案讀寫操作
- 目錄管理
- 檔案搜尋
- 權限控制

**API 工具**：
- `read_file`: 讀取檔案內容
- `write_file`: 寫入檔案
- `list_directory`: 列出目錄
- `search_files`: 搜尋檔案

### 2. Memory Service

**功能特性**：
- 知識圖譜存儲
- 實體關係管理
- 記憶體持久化
- 語義搜尋

**API 工具**：
- `create_entities`: 建立實體
- `create_relations`: 建立關係
- `search_nodes`: 搜尋節點
- `read_graph`: 讀取圖譜

### 3. Puppeteer Service

**功能特性**：
- 網頁自動化
- 截圖生成
- PDF 轉換
- 表單互動

**API 工具**：
- `navigate`: 導航網頁
- `screenshot`: 擷取截圖
- `click`: 點擊元素
- `fill`: 填寫表單

### 4. Everything Service

**功能特性**：
- 示例工具集
- 多媒體處理
- 資源管理
- 通知系統

**API 工具**：
- `echo`: 回音測試
- `add`: 數值運算
- `longRunningOperation`: 長時間操作
- `annotatedMessage`: 標註訊息

---

## ⚙️ 開發指南

### 工作區架構

```
src/
├── filesystem/          # 檔案系統服務
│   ├── index.ts        # 服務入口
│   ├── package.json    # 套件配置
│   └── README.md       # 服務文檔
├── memory/             # 記憶體服務
├── puppeteer/          # 瀏覽器服務
└── everything/         # 通用工具服務
```

### Claude Desktop 配置

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "docker",
      "args": ["exec", "-i", "mcp-filesystem-enhanced", "mcp-server-filesystem", "/app/projects"]
    },
    "memory": {
      "command": "docker", 
      "args": ["exec", "-i", "mcp-memory-enhanced", "node", "/app/dist/index.js"]
    },
    "puppeteer": {
      "command": "docker",
      "args": ["exec", "-i", "mcp-puppeteer-enhanced", "node", "/app/dist/index.js"]
    },
    "everything": {
      "command": "docker",
      "args": ["exec", "-i", "mcp-everything-enhanced", "node", "/app/dist/index.js"]
    }
  }
}
```

---

## 🔒 安全與最佳實踐

### 安全措施

- **容器隔離**: 每個服務運行在獨立容器
- **權限控制**: 最小權限原則
- **網路隔離**: 自定義 Docker 網路
- **資源限制**: CPU 和記憶體限制

### 效能優化

- **並行構建**: 多服務並行編譯
- **增量更新**: 只重建變更的服務
- **資源共享**: 共用 node_modules
- **快取策略**: Docker 層級快取

---

## 📈 版本資訊

- **當前版本**: v2.3.0
- **MCP 協定**: 0.6.2
- **發布日期**: 2025-06-29
- **維護狀態**: 🟢 積極維護

### 更新日誌

**v2.3.0** (2025-06-29)
- 🎯 專案架構專業化重構
- 🗂️ 移除不使用的服務（19個→4個）
- 🧹 清理測試檔案和開發垃圾
- 📝 完整文檔重寫
- 🔧 更新 package.json 配置
- ✅ 確保與當前 Docker 配置完全相符

---

## 🤝 貢獻指南

### 開發流程

1. Fork 專案
2. 建立功能分支
3. 實作功能與測試
4. 提交 Pull Request

### 貢獻規範

- 遵循 TypeScript 最佳實踐
- 完整的單元測試
- 詳細的程式碼註解
- 更新相關文檔

---

## 📄 授權條款

本專案採用 [MIT License](../LICENSE) 授權。

---

## 🔗 相關連結

- **專案首頁**: [GitHub](https://github.com/s123104/easy-mcp)
- **問題回報**: [Issues](https://github.com/s123104/easy-mcp/issues)
- **功能建議**: [Discussions](https://github.com/s123104/easy-mcp/discussions)
- **MCP 官方文檔**: [Model Context Protocol](https://modelcontextprotocol.io)

---

<div align="center">

**由 Easy-MCP Team 用 ❤️ 打造**

[⭐ Star on GitHub](https://github.com/s123104/easy-mcp) | [🐛 Report Bug](https://github.com/s123104/easy-mcp/issues) | [💡 Request Feature](https://github.com/s123104/easy-mcp/discussions)

</div> 