# WSL2 和 Docker Desktop 修復指南

## 🔍 問題診斷結果

✅ **硬體支援**: AMD Ryzen 5 7535HS 支援虛擬化且已啟用  
✅ **系統版本**: Windows 10 版本 2009 支援 WSL2  
⚠️ **待解決**: WSL 功能需要重新啟動才能生效  

## 🚀 自動化解決方案

### 方案 1: 完全自動化（推薦）

1. **以管理員身份**運行 PowerShell
2. 執行以下命令：
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File restart-and-setup.ps1
   ```
3. 系統將自動重新啟動並完成所有設置

### 方案 2: 半自動化

1. **手動重新啟動**系統
2. 重新啟動後，**以管理員身份**運行 PowerShell
3. 執行以下命令：
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File setup-wsl-post-reboot.ps1
   ```

## 🛠️ 手動修復步驟（如果自動化失敗）

### 步驟 1: 啟用 Windows 功能
```powershell
# 以管理員身份執行
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

### 步驟 2: 重新啟動系統
```powershell
shutdown /r /t 0
```

### 步驟 3: 安裝 WSL2 內核更新
1. 下載 WSL2 內核更新：https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
2. 執行下載的 MSI 檔案進行安裝

### 步驟 4: 設置 WSL2 為預設
```powershell
wsl --set-default-version 2
```

### 步驟 5: 驗證 WSL 狀態
```powershell
wsl --status
```

### 步驟 6: 重新啟動 Docker Desktop
```powershell
Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

### 步驟 7: 等待 Docker 就緒並啟動 MCP 服務
```powershell
# 等待 Docker 完全啟動後
cd D:\easy-mcp
.\start.bat
```

## 🔧 故障排除

### 如果 WSL 仍然無法啟動：

1. **檢查 BIOS 設置**：
   - 重新啟動進入 BIOS
   - 確保 "Virtualization Technology" 或 "AMD-V" 已啟用
   - 保存並退出

2. **檢查 Hyper-V 衝突**：
   ```powershell
   # 以管理員身份執行
   bcdedit /set hypervisorlaunchtype off
   # 重新啟動後再執行
   bcdedit /set hypervisorlaunchtype auto
   ```

3. **完全重新安裝 WSL**：
   ```powershell
   # 以管理員身份執行
   wsl --unregister docker-desktop
   wsl --unregister docker-desktop-data
   wsl --install
   ```

### 如果 Docker Desktop 無法啟動：

1. **重置 Docker Desktop**：
   - 開啟 Docker Desktop
   - 點擊設定 (Settings)
   - 選擇 "Reset" 標籤
   - 點擊 "Reset to factory defaults"

2. **檢查 Windows 服務**：
   ```powershell
   # 確保以下服務正在運行
   Get-Service -Name "*docker*" | Start-Service
   ```

## 📁 文件說明

- `setup-wsl-post-reboot.ps1`: 重新啟動後完整設置腳本
- `restart-and-setup.ps1`: 自動重新啟動和設置腳本
- `WSL-Docker-修復指南.md`: 本說明文件

## ✅ 驗證步驟

完成修復後，執行以下命令確認一切正常：

```powershell
# 檢查 WSL 狀態
wsl --status

# 檢查 Docker 狀態
docker --version
docker info

# 檢查 MCP 服務
docker ps
```

## 📞 如需進一步協助

如果問題仍然存在，請檢查：
1. Windows 版本是否為最新
2. 是否有防毒軟體阻擋虛擬化功能
3. 系統檔案是否完整 (`sfc /scannow`)

---
**最後更新**: 2025年6月
**狀態**: 已針對 AMD Ryzen 5 7535HS + Windows 10 Home 版本 2009 優化** 