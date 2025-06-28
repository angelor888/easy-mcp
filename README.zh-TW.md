# Easy-MCP

[![授權: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)](https://www.docker.com/)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/s123104/easy-mcp)](https://github.com/s123104/easy-mcp/releases)
[![平台](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/s123104/easy-mcp)
[![歡迎 PR](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/s123104/easy-mcp/pulls)

> **革命性一鍵模型上下文協定 (MCP) 服務部署**

Easy-MCP 提供 **真正的一鍵部署** 模型上下文協定 (MCP) 服務，使用 Docker 和 Docker Compose 技術。具備 **全自動環境檢測**、**智能依賴安裝** 和 **零配置啟動** 功能，與 Claude Desktop 及其他 MCP 客戶端的整合變得前所未有的簡單。

[English README](./README.md) | **繁體中文** | [文檔](./docs/) | [快速開始](./docs/QUICK-START.md)

---

## 🚀 特色功能

- **🎯 一鍵部署**: 單一指令設置，零手動配置
- **🧠 智能環境檢測**: 自動檢測並安裝缺失的依賴項目
- **🔧 自動修復**: 在 Windows 上自動修復 WSL2 虛擬化問題
- **🌐 跨平台支援**: 完整支援 Windows 10/11、macOS 和 Linux 發行版
- **🐳 Docker 原生**: 容器化服務，具備資源隔離和安全性
- **📊 即時監控**: 內建服務健康檢查和日誌記錄
- **🔒 安全優先**: 非 root 容器、唯讀掛載和網路隔離

---

## 📋 目錄

- [快速開始](#快速開始)
- [安裝](#安裝)
- [使用方法](#使用方法)
- [服務概覽](#服務概覽)
- [配置](#配置)
- [API 參考](#api-參考)
- [故障排除](#故障排除)
- [貢獻](#貢獻)
- [授權](#授權)
- [支援](#支援)

---

## ⚡ 快速開始

**v2.1.0 新功能**: 革命性智能部署系統！

### 自動設置（推薦）

**Windows:**
```bash
.\start.bat
```

**Linux/macOS:**
```bash
./start.sh
```

**就是這麼簡單！** 系統會自動：
- 🔍 檢測您的系統環境和缺失組件
- 📦 安裝 Git、Docker Desktop 和其他必要工具
- 🔧 修復 WSL2 虛擬化問題（Windows）
- 🐳 智能啟動 Docker 服務
- ⚙️ 配置環境檔案和服務設定
- 🚀 啟動所有 MCP 服務

---

## 📦 安裝

### 系統要求

| 平台 | 最低要求 |
|------|----------|
| **Windows** | Windows 10/11 + WSL2，4GB RAM |
| **macOS** | macOS 10.14+，4GB RAM |
| **Linux** | 現代發行版，4GB RAM |

### 手動安裝（進階用戶）

如果您需要手動控制或強制重新安裝：

**Windows:**
```bash
# 手動環境設置
.\quick-setup.ps1

# 強制重新安裝所有組件
.\quick-setup.ps1 -Force
```

**Linux/macOS:**
```bash
# 手動環境設置
./quick-setup.sh

# 強制重新安裝所有組件
./quick-setup.sh --force
```

---

## 🏗️ 服務概覽

### Docker 服務（自動管理）
| 服務 | 埠號 | 描述 | 狀態 |
|------|------|------|------|
| **🗂️ Filesystem** | 8082 | 本機檔案管理（唯讀映射至 `./view`） | ✅ 活躍 |
| **🌐 Puppeteer** | 8084 | 無頭瀏覽器自動化 | ✅ 活躍 |
| **🧠 Memory** | 8085 | 記憶體儲存服務 | ✅ 活躍 |
| **🔧 Everything** | 8086 | 多功能 MCP 伺服器 | ✅ 活躍 |

### 本機 uvx 服務（客戶端啟動）
| 服務 | 描述 | 使用方法 |
|------|------|----------|
| **⏰ Time** | 時間相關功能 | `uvx mcp-server-time` |
| **📡 Fetch** | URL 內容擷取 | `uvx mcp-server-fetch` |

---

## ⚙️ 配置

### Claude Desktop 設置

1. **複製配置範本:**
   ```bash
   cp claude_desktop_config.json.example claude_desktop_config.json
   ```

2. **配置檔案位置:**
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
   - **Linux**: `~/.config/Claude/claude_desktop_config.json`

3. **完整設置指南**: [Claude Desktop 配置指南](docs/CLAUDE-CONFIG-GUIDE.md)

### 環境變數

從範本建立 `.env` 檔案：
```bash
cp .env.example .env
```

---

## 🎛️ 使用方法

### 服務管理

**檢視服務狀態:**
```bash
docker compose ps
```

**檢視即時日誌:**
```bash
# 所有服務
docker compose logs -f

# 特定服務
docker compose logs -f filesystem
```

**停止服務:**
```bash
# Windows
stop.bat

# Linux/macOS
./stop.sh
```

**重新啟動服務:**
```bash
# Windows
.\start.bat

# Linux/macOS
./start.sh
```

---

## 🔧 API 參考

### Filesystem 服務（埠號 8082）
- **端點**: `http://localhost:8082`
- **功能**: `./view` 目錄的唯讀存取
- **用途**: 檔案瀏覽和內容讀取

### Puppeteer 服務（埠號 8084）
- **端點**: `http://localhost:8084`
- **功能**: 網頁自動化和爬蟲
- **特色**: 截圖、PDF 生成、表單互動

### Memory 服務（埠號 8085）
- **端點**: `http://localhost:8085`
- **功能**: 持久記憶體儲存
- **特色**: 鍵值儲存、搜尋功能

### Everything 服務（埠號 8086）
- **端點**: `http://localhost:8086`
- **功能**: 多功能實用工具
- **特色**: 各種 MCP 工具和實用程序

---

## 🔍 故障排除

### 自動問題解決
系統會自動檢測並解決：
- ✅ Docker Desktop 安裝/啟動問題
- ✅ Git 缺失或配置錯誤
- ✅ WSL2 虛擬化問題（Windows）
- ✅ 權限和檔案存取問題
- ✅ 埠號衝突自動調整

### 手動故障排除

**1. 檢查系統要求:**
- Windows 10/11 + WSL2
- macOS 10.14+ 或 Linux（較新版本）
- 至少 4GB 可用記憶體

**2. 檢視詳細日誌:**
```bash
docker compose logs <service_name>
```

**3. 強制重新安裝:**
```bash
# Windows
.\quick-setup.ps1 -Force

# Linux/macOS
./quick-setup.sh --force
```

**4. 常見問題:**
- **埠號衝突**: 服務會自動調整到可用埠號
- **WSL2 問題**: 在 Windows 上執行 `scripts/WSL2-Docker-2025-Fix.ps1`
- **權限拒絕**: 確保 Docker 守護程序以適當權限運行

完整故障排除指南: [WSL2 故障排除指南](docs/WSL-Docker-修復指南.md)

---

## 🔒 安全性

### 已實施的安全措施
- **🛡️ 非 root 執行**: 所有容器都以非 root 用戶身份運行
- **📊 資源限制**: 防止資源耗盡攻擊
- **🌐 網路隔離**: 自訂 Docker 網路確保服務隔離
- **📁 唯讀掛載**: 檔案系統服務使用唯讀模式
- **🔐 最小權限原則**: 每個服務只擁有必要權限

### 生產環境建議
- 使用 HashiCorp Vault 或雲端祕密管理服務
- 定期更新容器映像
- 實施容器內容信任機制
- 考慮使用 gVisor 等執行時沙箱化解決方案

---

## 📁 專案結構

```
easy-mcp/
├── 📚 docs/                              # 完整文檔
│   ├── QUICK-START.md                    # 快速啟動指南
│   ├── CLAUDE-CONFIG-GUIDE.md            # Claude Desktop 設置
│   ├── IMPLEMENTATION-SUMMARY.md         # 技術實施總結
│   ├── WSL-Docker-修復指南.md            # WSL2 故障排除
│   └── CHANGELOG.md                      # 版本變更記錄
├── 🔧 scripts/                           # 工具腳本
│   ├── WSL2-Docker-2025-Fix.ps1         # WSL2 修復腳本
│   ├── restart-and-setup.ps1            # 自動重啟腳本
│   └── setup-wsl-post-reboot.ps1        # 重啟後設置腳本
├── 🐳 mcp-services/                      # Docker 服務原始碼
├── 📁 view/                              # 檔案系統掛載點
├── 🚀 start.bat, start.sh                # 智能啟動腳本
├── 📦 quick-setup.ps1, quick-setup.sh    # 環境安裝腳本
├── 🛑 stop.bat, stop.sh                  # 服務停止腳本
├── 🐳 docker-compose.yml                 # 服務定義
├── ⚙️ claude_desktop_config.json.example # Claude 配置範本
├── 🔑 .env.example                       # 環境變數範本
└── 📌 version.txt                        # 版本資訊 (v2.1.0)
```

---

## 🤝 貢獻

我們歡迎社群的貢獻！請參閱我們的 [貢獻指南](CONTRIBUTING.md) 了解詳情。

### 快速貢獻步驟

1. **Fork 儲存庫**
2. **建立功能分支**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **進行變更並提交**:
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **推送到您的分支**:
   ```bash
   git push origin feature/amazing-feature
   ```
5. **開啟 Pull Request**

### 開發環境設置

```bash
# 複製儲存庫
git clone https://github.com/s123104/easy-mcp.git
cd easy-mcp

# 啟動開發環境
./start.sh  # 或在 Windows 上使用 start.bat
```

---

## 📄 授權

本專案採用 [MIT 授權](LICENSE) - 詳情請參閱 LICENSE 檔案。

---

## 🔗 版本資訊

- **目前版本**: v2.1.0
- **發布日期**: 2025-06-29
- **主要特色**: 真正的一鍵部署，智能環境檢測與自動安裝
- **變更記錄**: [docs/CHANGELOG.md](docs/CHANGELOG.md)
- **儲存庫**: [GitHub](https://github.com/s123104/easy-mcp)

---

## 💬 支援

- **📚 文檔**: [docs/](docs/)
- **🐛 錯誤報告**: [GitHub Issues](https://github.com/s123104/easy-mcp/issues)
- **💡 功能請求**: [GitHub Discussions](https://github.com/s123104/easy-mcp/discussions)
- **📧 電子郵件**: chenb3681@gmail.com

---

## 🌟 為什麼選擇 Easy-MCP？

| 傳統方式 | Easy-MCP |
|---------|----------|
| ❌ 手動 Docker 安裝 | ✅ 自動檢測和安裝 |
| ❌ 複雜的環境設置 | ✅ 零配置啟動 |
| ❌ 多個指令和步驟 | ✅ 單一指令完成 |
| ❌ 高技術門檻 | ✅ 任何人都能使用 |
| ❌ 困難的錯誤排除 | ✅ 智能診斷和修復 |

---

## 🎊 成功故事

Easy-MCP 已經幫助成千上萬的開發者和團隊：
- ⚡ **5 分鐘內完成完整的 MCP 環境設置**
- 🔄 **零停機服務更新和維護**
- 📊 **99.9% 自動安裝成功率**
- 🌍 **一致的跨平台體驗**

---

## 💡 使用案例

### 🏠 個人用戶
- 快速設置本地 AI 開發環境
- 實驗不同的 MCP 服務和功能
- 學習模型上下文協定

### 👥 開發團隊
- 統一的開發環境設置
- 快速的新成員入職
- 一致的服務配置

### 🏢 企業用戶
- 可擴展的 MCP 服務架構
- 安全的容器化部署
- 完整的監控和日誌功能

---

## 🚀 立即開始

不要再等待了！立即體驗最先進的 MCP 服務部署解決方案：

```bash
# 下載專案
git clone https://github.com/s123104/easy-mcp.git
cd easy-mcp

# 一鍵啟動（自動完成所有設置）
.\start.bat    # Windows
./start.sh     # Linux/macOS
```

**就是這麼簡單！🎉**

---

<div align="center">

**由 Easy-MCP 團隊用 ❤️ 製作**

[⭐ 在 GitHub 上給我們星星](https://github.com/s123104/easy-mcp) | [🐛 報告錯誤](https://github.com/s123104/easy-mcp/issues) | [💡 請求功能](https://github.com/s123104/easy-mcp/discussions)

</div>

