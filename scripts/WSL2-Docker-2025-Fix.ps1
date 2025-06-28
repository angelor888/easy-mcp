# WSL2 + Docker Desktop 2025年最新修復腳本
# 解決 HCS_E_SERVICE_NOT_AVAILABLE 錯誤
# 請以管理員身份執行此腳本

param([switch]$AutoReboot)

Write-Host "=== WSL2 + Docker Desktop 2025年修復腳本 ===" -ForegroundColor Green
Write-Host "解決 HCS_E_SERVICE_NOT_AVAILABLE 錯誤" -ForegroundColor Cyan

# 檢查管理員權限
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ 需要管理員權限，請重新以管理員身份執行" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 管理員權限確認" -ForegroundColor Green

# 1. 清理可能損壞的配置文件
Write-Host "`n步驟 1: 清理損壞的配置文件..." -ForegroundColor Yellow
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
if (Test-Path $wslConfigPath) {
    Rename-Item $wslConfigPath "$env:USERPROFILE\.wslconfig.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "   ✅ 已備份並移除 .wslconfig 文件" -ForegroundColor Green
}

# 2. 強制啟用 Hyper-V 自動啟動
Write-Host "`n步驟 2: 啟用 Hyper-V 自動啟動..." -ForegroundColor Yellow
try {
    bcdedit /set hypervisorlaunchtype auto | Out-Null
    Write-Host "   ✅ Hyper-V 自動啟動已設定" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️ 設定 Hyper-V 自動啟動失敗: $($_.Exception.Message)" -ForegroundColor Yellow
}

# 3. 啟用必要的 Windows 功能
Write-Host "`n步驟 3: 啟用 Windows 功能..." -ForegroundColor Yellow
$features = @(
    "Microsoft-Windows-Subsystem-Linux",
    "VirtualMachinePlatform",
    "Microsoft-Hyper-V-All",
    "Containers"
)

foreach ($feature in $features) {
    try {
        Write-Host "   正在啟用 $feature..." -ForegroundColor Cyan
        dism.exe /online /enable-feature /featurename:$feature /all /norestart | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ $feature 啟用成功" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️ $feature 啟用可能失敗" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ❌ 啟用 $feature 失敗: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 4. 下載並安裝最新的 WSL2 內核更新
Write-Host "`n步驟 4: 更新 WSL2 內核..." -ForegroundColor Yellow
$wslUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$downloadPath = "$env:TEMP\wsl_update_x64.msi"

try {
    Write-Host "   正在下載 WSL2 內核更新..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $wslUpdateUrl -OutFile $downloadPath -UseBasicParsing
    Write-Host "   正在安裝 WSL2 內核更新..." -ForegroundColor Cyan
    Start-Process msiexec.exe -Wait -ArgumentList "/i $downloadPath /quiet"
    Write-Host "   ✅ WSL2 內核更新完成" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️ WSL2 內核更新失敗: $($_.Exception.Message)" -ForegroundColor Yellow
}

# 5. 清理舊的 Docker WSL 分發版
Write-Host "`n步驟 5: 清理舊的 Docker 分發版..." -ForegroundColor Yellow
$dockerDistros = @("docker-desktop", "docker-desktop-data")
foreach ($distro in $dockerDistros) {
    try {
        wsl --unregister $distro 2>$null
        Write-Host "   ✅ 已清理 $distro" -ForegroundColor Green
    } catch {
        Write-Host "   ℹ️ $distro 不存在，跳過" -ForegroundColor Gray
    }
}

# 6. 設定 WSL2 為預設版本
Write-Host "`n步驟 6: 設定 WSL2 為預設版本..." -ForegroundColor Yellow
try {
    wsl --set-default-version 2
    Write-Host "   ✅ WSL2 已設為預設版本" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️ 設定預設版本失敗: $($_.Exception.Message)" -ForegroundColor Yellow
}

# 7. 重新啟動關鍵服務
Write-Host "`n步驟 7: 重新啟動關鍵服務..." -ForegroundColor Yellow
$services = @("vmcompute", "LxssManager")
foreach ($service in $services) {
    try {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            Restart-Service -Name $service -Force
            Write-Host "   ✅ $service 已重新啟動" -ForegroundColor Green
        } else {
            Write-Host "   ℹ️ $service 服務不存在" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ⚠️ 重新啟動 $service 失敗: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# 8. 檢查系統是否需要重新啟動
Write-Host "`n步驟 8: 檢查重新啟動需求..." -ForegroundColor Yellow
$rebootRequired = $false

# 檢查 Windows 功能重新啟動標記
if (Get-ItemProperty "HKLM:Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) {
    $rebootRequired = $true
}

# 檢查 WSL 狀態
$wslStatus = wsl --status 2>&1
if ($wslStatus -like "*不支援 WSL2*" -or $wslStatus -like "*required feature is not installed*") {
    $rebootRequired = $true
}

if ($rebootRequired) {
    Write-Host "`n⚠️ 系統需要重新啟動才能完成修復" -ForegroundColor Red
    
    if ($AutoReboot) {
        Write-Host "10 秒後自動重新啟動..." -ForegroundColor Yellow
        for ($i = 10; $i -gt 0; $i--) {
            Write-Host "   $i..." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
        shutdown /r /t 0
    } else {
        Write-Host "請手動重新啟動系統，然後再次嘗試啟動 Docker Desktop" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n✅ 系統配置完成，可以嘗試啟動 Docker Desktop" -ForegroundColor Green
    
    # 嘗試啟動 Docker Desktop
    Write-Host "`n步驟 9: 嘗試啟動 Docker Desktop..." -ForegroundColor Yellow
    try {
        Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
        Write-Host "   ✅ Docker Desktop 啟動命令已執行" -ForegroundColor Green
        Write-Host "   請等待 Docker Desktop 完全啟動..." -ForegroundColor Cyan
    } catch {
        Write-Host "   ⚠️ 啟動 Docker Desktop 失敗: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "`n=== 修復腳本執行完成 ===" -ForegroundColor Green
Write-Host "如果問題仍然存在，請檢查：" -ForegroundColor Cyan
Write-Host "1. BIOS 中是否啟用了虛擬化功能" -ForegroundColor White
Write-Host "2. Windows 版本是否為最新" -ForegroundColor White
Write-Host "3. 防毒軟體是否阻擋了虛擬化功能" -ForegroundColor White
Write-Host "4. 是否需要更新 Docker Desktop 到最新版本" -ForegroundColor White 