# Easy-MCP 快速啟動指南

## 🚀 一鍵自動安裝和啟動

Easy-MCP 現在支援智能環境檢測和自動安裝！您只需要運行一個指令，系統會自動檢測並安裝所有必要的依賴。

### Windows 用戶

```bash
# 方法 1: 直接啟動（推薦）
.\start.bat

# 方法 2: 手動環境安裝
.\quick-setup.ps1

# 方法 3: 強制重新安裝環境
.\quick-setup.ps1 -Force
```

### Linux/macOS 用戶

```bash
# 方法 1: 直接啟動（推薦）
./start.sh

# 方法 2: 手動環境安裝
./quick-setup.sh

# 方法 3: 強制重新安裝環境
./quick-setup.sh --force
```

## 🔧 智能功能特色

### 自動環境檢測
- ✅ 自動檢測作業系統類型
- ✅ 檢查 Git 是否已安裝
- ✅ 檢查 Docker 是否已安裝並運行
- ✅ 檢查必要的 Windows 功能（WSL2、Hyper-V 等）

### 自動安裝功能
- 🔄 **Windows**: 使用 winget 自動安裝 Git 和 Docker Desktop
- 🔄 **Linux**: 支援 Ubuntu/Debian、CentOS/RHEL/Fedora、Arch Linux
- 🔄 **macOS**: 自動安裝 Homebrew 和 Docker Desktop

### WSL2 問題自動修復（Windows）
- 🛠️ 修復 `HCS_E_SERVICE_NOT_AVAILABLE` 錯誤
- 🛠️ 清理損壞的 .wslconfig 文件
- 🛠️ 自動啟用必要的 Windows 功能
- 🛠️ 下載最新的 WSL2 內核更新

### 智能啟動流程
- 🎯 自動創建 .env 文件
- 🎯 自動啟動 Docker Desktop（如果未運行）
- 🎯 智能錯誤診斷和修復建議
- 🎯 多語言支援（繁體中文/English）

## 📦 服務架構

安裝完成後，您將獲得以下 MCP 服務：

### Docker 服務（自動啟動）
- **MCP Filesystem** (Port 8082) - 文件系統操作
- **MCP Puppeteer** (Port 8084) - 網頁自動化
- **MCP Memory** (Port 8085) - 記憶體管理
- **MCP Everything** (Port 8086) - 全功能搜索

### uvx 服務（按需啟動）
- **MCP Time** - 時間相關操作
- **MCP Fetch** - HTTP 請求處理

## 🔍 故障排除

### 常見問題解決

1. **Docker 啟動失敗**
   ```bash
   # Windows
   .\quick-setup.ps1 -Force
   
   # Linux/macOS
   ./quick-setup.sh --force
   ```

2. **WSL2 虛擬化問題（Windows）**
   - 系統會自動檢測並修復
   - 如果需要重新啟動系統，請按照提示操作

3. **權限問題（Linux）**
   ```bash
   # 將用戶加入 docker 群組
   sudo usermod -aG docker $USER
   # 重新登入或執行
   newgrp docker
   ```

4. **查看詳細日誌**
   ```bash
   docker compose logs -f
   ```

### 手動清理和重置

```bash
# 停止所有服務
.\stop.bat  # Windows
./stop.sh   # Linux/macOS

# 完全清理（刪除容器和映像）
docker compose down --rmi all --volumes

# 重新建置和啟動
.\start.bat  # Windows
./start.sh   # Linux/macOS
```

## 🌐 多語言支援

系統支援自動語言檢測：

### 手動設定語言

**Windows:**
```bash
# 繁體中文
$env:LANG = "zh_TW"
.\start.bat

# English
$env:LANG = "en"
.\start.bat
```

**Linux/macOS:**
```bash
# 繁體中文
export LANG="zh_TW.UTF-8"
./start.sh

# English
export LANG="en_US.UTF-8"
./start.sh
```

## 📋 系統需求

### 最低需求
- **Windows**: Windows 10 Home 版本 1903 或更新
- **macOS**: macOS 10.14 或更新
- **Linux**: 支援 Docker 的現代發行版
- **RAM**: 至少 4GB（推薦 8GB）
- **儲存空間**: 至少 5GB 可用空間

### 推薦配置
- **RAM**: 8GB 或更多
- **CPU**: 支援虛擬化的多核心處理器
- **儲存空間**: 10GB 或更多的 SSD 空間

## 🔗 相關連結

- [Docker Desktop 官方網站](https://www.docker.com/products/docker-desktop/)
- [Git 官方網站](https://git-scm.com/)
- [WSL2 官方文檔](https://docs.microsoft.com/en-us/windows/wsl/)
- [MCP 官方文檔](https://modelcontextprotocol.io/)

---

**版本**: Easy-MCP v2.0.0  
**最後更新**: 2025-06-29  
**支援**: 如有問題，請查看故障排除章節或提交 Issue 