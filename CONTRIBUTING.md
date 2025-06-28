# Contributing to Easy-MCP

首先，感謝您對 Easy-MCP 項目的關注和貢獻！我們非常歡迎來自社群的貢獻，無論是錯誤報告、功能建議、文檔改進還是程式碼貢獻。

## 🌟 貢獻方式

### 🐛 報告錯誤

如果您發現錯誤，請：

1. **檢查現有 Issues** - 確保該錯誤尚未被報告
2. **建立詳細的錯誤報告**，包括：
   - 清晰的標題和描述
   - 重現步驟
   - 預期行為 vs 實際行為
   - 您的環境資訊（作業系統、Docker 版本等）
   - 相關的日誌或截圖

### 💡 建議功能

我們樂於聽取新功能的想法：

1. **檢查現有 Issues 和 Discussions**
2. **開啟新的 Discussion** 先討論想法
3. **提供詳細的功能描述**，包括：
   - 功能的動機和用例
   - 建議的實作方式
   - 可能的替代方案

### 📝 改進文檔

文檔改進總是受歡迎的：

- 修正錯字或語法錯誤
- 改善現有說明的清晰度
- 添加缺失的文檔
- 翻譯成其他語言

### 🔧 程式碼貢獻

#### 開發環境設置

1. **Fork 儲存庫**
   ```bash
   git clone https://github.com/YOUR_USERNAME/easy-mcp.git
   cd easy-mcp
   ```

2. **設置開發環境**
   ```bash
   # 啟動服務
   ./start.sh  # Linux/macOS
   .\start.bat # Windows
   ```

3. **建立功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### 程式碼標準

- **命名規範**：使用清晰、描述性的變數和函數名稱
- **註解**：為複雜邏輯添加有意義的註解
- **錯誤處理**：適當處理錯誤情況
- **測試**：為新功能添加測試（如適用）

#### 提交訊息規範

使用 [Conventional Commits](https://conventionalcommits.org/) 格式：

```
<類型>[可選範圍]: <描述>

[可選正文]

[可選頁腳]
```

**類型：**
- `feat`: 新功能
- `fix`: 錯誤修復
- `docs`: 文檔變更
- `style`: 格式變更（不影響程式碼邏輯）
- `refactor`: 重構（既不是修復錯誤也不是添加功能）
- `test`: 添加或修改測試
- `chore`: 建置過程或輔助工具的變動

**範例：**
```
feat(docker): add new memory service configuration

Added support for custom memory limits and improved
container resource management.

Closes #123
```

#### Pull Request 流程

1. **確保您的程式碼通過所有檢查**
2. **更新相關文檔**
3. **添加或更新測試**（如適用）
4. **建立 Pull Request**，包括：
   - 清晰的標題和描述
   - 變更的動機和背景
   - 測試計劃
   - 相關的 Issue 編號

## 📋 開發指南

### 目錄結構

```
easy-mcp/
├── docs/                    # 文檔
├── mcp-services/           # MCP 服務原始碼
├── scripts/                # 工具腳本
├── view/                   # 檔案系統掛載點
├── docker-compose.yml      # Docker 服務配置
└── start.sh / start.bat    # 啟動腳本
```

### 測試

```bash
# 測試 Docker 服務
docker compose ps

# 檢查服務健康狀態
docker compose logs

# 測試腳本功能
./start.sh --dry-run  # 如果支援的話
```

### 除錯

```bash
# 查看詳細日誌
docker compose logs -f [service_name]

# 進入容器進行除錯
docker compose exec [service_name] /bin/bash
```

## 🔍 程式碼審查

所有貢獻都會經過程式碼審查過程：

### 審查標準

- **功能性**：程式碼是否實現了預期功能？
- **可讀性**：程式碼是否清晰易懂？
- **安全性**：是否存在安全風險？
- **效能**：是否會影響系統效能？
- **相容性**：是否與現有功能相容？

### 審查流程

1. **自動檢查**：GitHub Actions 會自動運行測試
2. **維護者審查**：項目維護者會審查您的程式碼
3. **討論和修改**：根據反饋進行必要的修改
4. **合併**：通過審查後合併到主分支

## 📜 行為準則

### 我們的承諾

為了營造開放和友好的環境，我們承諾：

- 使用友好和包容的語言
- 尊重不同的觀點和經驗
- 優雅地接受建設性批評
- 專注於對社群最有利的事情
- 對其他社群成員表現出同理心

### 不接受的行為

- 使用性別化語言或圖像，以及不受歡迎的性關注或調情
- 人身攻擊、政治攻擊或人身攻擊
- 公開或私人騷擾
- 未經明確許可發布他人的私人資訊
- 在專業環境中可能被認為不當的其他行為

## 🏆 認可

我們會在以下地方認可貢獻者：

- **CHANGELOG.md** - 記錄重要貢獻
- **README.md** - 特別貢獻者列表
- **GitHub Contributors** - 自動追蹤所有貢獻者

## ❓ 需要幫助？

如果您有任何問題，可以：

- 📖 查看 [文檔](docs/)
- 💬 在 [GitHub Discussions](https://github.com/s123104/easy-mcp/discussions) 中提問
- 🐛 在 [GitHub Issues](https://github.com/s123104/easy-mcp/issues) 中報告問題
- 📧 發送郵件到 chenb3681@gmail.com

## 📄 授權

通過貢獻，您同意您的貢獻將按照 [MIT License](LICENSE) 進行授權。

---

**感謝您幫助讓 Easy-MCP 變得更好！** 🎉
