# WSL 和 Docker 重新啟動後自動設置腳本
# 請以管理員身份執行此腳本

Write-Host "=== WSL 和 Docker 自動設置腳本 ===" -ForegroundColor Green

# 1. 檢查 WSL 功能狀態
Write-Host "1. 檢查 WSL 功能狀態..." -ForegroundColor Yellow
try {
    $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    $vmPlatform = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
    
    Write-Host "   WSL 功能狀態: $($wslFeature.State)" -ForegroundColor Cyan
    Write-Host "   虛擬機平台狀態: $($vmPlatform.State)" -ForegroundColor Cyan
} catch {
    Write-Host "   無法檢查功能狀態，嘗試啟用..." -ForegroundColor Red
}

# 2. 確保功能已啟用
Write-Host "2. 確保所需功能已啟用..." -ForegroundColor Yellow
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 3. 下載並安裝 WSL2 內核更新
Write-Host "3. 下載並安裝 WSL2 內核更新..." -ForegroundColor Yellow
$wslUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$wslUpdatePath = "$env:TEMP\wsl_update_x64.msi"

try {
    Invoke-WebRequest -Uri $wslUpdateUrl -OutFile $wslUpdatePath -UseBasicParsing
    Start-Process msiexec.exe -Wait -ArgumentList "/i $wslUpdatePath /quiet"
    Write-Host "   WSL2 內核更新安裝完成" -ForegroundColor Green
} catch {
    Write-Host "   WSL2 內核更新下載失敗，請手動下載安裝" -ForegroundColor Red
}

# 4. 設置 WSL2 為預設版本
Write-Host "4. 設置 WSL2 為預設版本..." -ForegroundColor Yellow
wsl --set-default-version 2

# 5. 檢查 WSL 狀態
Write-Host "5. 檢查 WSL 最終狀態..." -ForegroundColor Yellow
wsl --status

# 6. 嘗試啟動 Docker Desktop
Write-Host "6. 重新啟動 Docker Desktop..." -ForegroundColor Yellow
Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

Write-Host "7. 等待 Docker Desktop 啟動..." -ForegroundColor Yellow
$dockerReady = $false
$attempts = 0
$maxAttempts = 30

while (!$dockerReady -and $attempts -lt $maxAttempts) {
    try {
        $env:PATH += ";C:\Program Files\Docker\Docker\resources\bin"
        $dockerInfo = docker info 2>$null
        if ($LASTEXITCODE -eq 0) {
            $dockerReady = $true
            Write-Host "   Docker Desktop 已就緒！" -ForegroundColor Green
        }
    } catch {
        # 繼續等待
    }
    
    if (!$dockerReady) {
        Start-Sleep -Seconds 10
        $attempts++
        Write-Host "   等待中... ($attempts/$maxAttempts)" -ForegroundColor Cyan
    }
}

if ($dockerReady) {
    Write-Host "8. 嘗試啟動 MCP 服務..." -ForegroundColor Yellow
    Set-Location "D:\easy-mcp"
    .\start.bat
} else {
    Write-Host "Docker Desktop 未能在預期時間內啟動。請手動檢查。" -ForegroundColor Red
}

Write-Host "=== 設置完成 ===" -ForegroundColor Green
Write-Host "如果仍有問題，請檢查："
Write-Host "1. BIOS 中是否啟用了虛擬化功能"
Write-Host "2. Windows 版本是否支援 WSL2 (Windows 10 版本 2004+ 或 Windows 11)"
Write-Host "3. 是否需要再次重新啟動系統" 