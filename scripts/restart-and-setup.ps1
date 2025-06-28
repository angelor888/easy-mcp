# 自動重新啟動並在重新啟動後執行 WSL 設置
# 請以管理員身份執行此腳本

Write-Host "=== 自動重新啟動和設置腳本 ===" -ForegroundColor Green

# 設置重新啟動後自動執行的任務
$scriptDir = Split-Path -Parent $PSCommandPath
$parentDir = Split-Path -Parent $scriptDir
$scriptPath = Join-Path $scriptDir "setup-wsl-post-reboot.ps1"
$taskName = "WSL-Docker-Setup"

Write-Host "1. 創建重新啟動後的自動執行任務..." -ForegroundColor Yellow

# 刪除舊任務（如果存在）
schtasks /delete /tn $taskName /f 2>$null

# 創建新任務
$action = "PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
schtasks /create /tn $taskName /tr $action /sc onlogon /ru "SYSTEM" /rl HIGHEST /f

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ 自動執行任務已創建" -ForegroundColor Green
} else {
    Write-Host "   ❌ 無法創建自動執行任務" -ForegroundColor Red
}

Write-Host "2. 系統將在 10 秒後自動重新啟動..." -ForegroundColor Yellow
Write-Host "   重新啟動後，WSL 設置將自動開始" -ForegroundColor Cyan

for ($i = 10; $i -gt 0; $i--) {
    Write-Host "   $i 秒後重新啟動..." -ForegroundColor Red
    Start-Sleep -Seconds 1
}

# 重新啟動系統
shutdown /r /t 0 