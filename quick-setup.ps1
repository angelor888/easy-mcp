# Easy-MCP 快速環境安裝腳本
# Version: 2.0.0
# 支援 Windows 10/11 + Docker + WSL2 自動安裝與修復
# 作者: DevSecOps Ultimate Agent 2025

param(
    [switch]$Force,
    [string]$Language = "auto"
)

# 管理員權限檢查
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "需要管理員權限。正在重新啟動為管理員..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-File `"$PSCommandPath`" -Force:$Force -Language:$Language"
    exit
}

# 語言設定
$currentLang = if ($Language -eq "auto") { 
    if ($env:LANG -like "*zh*" -or [System.Globalization.CultureInfo]::CurrentCulture.Name -like "*zh*") { "zh-TW" } else { "en" }
} else { $Language }

# 多語言訊息
$Messages = @{
    "zh-TW" = @{
        Title = "Easy-MCP 環境快速安裝工具 v2.0"
        CheckingEnv = "正在檢測系統環境..."
        SystemInfo = "系統資訊："
        InstallingComponent = "正在安裝："
        ComponentExists = "已安裝："
        ComponentMissing = "缺失："
        InstallSuccess = "安裝成功："
        InstallFailed = "安裝失敗："
        WSLFixing = "正在修復 WSL2 問題..."
        WSLFixed = "WSL2 修復完成"
        RestartRequired = "需要重新啟動系統以完成安裝"
        SetupComplete = "環境安裝完成！"
        StartingServices = "正在啟動 MCP 服務..."
        PressEnterToContinue = "按 Enter 繼續..."
        Error = "錯誤："
        Warning = "警告："
        Info = "資訊："
    }
    "en" = @{
        Title = "Easy-MCP Quick Environment Setup Tool v2.0"
        CheckingEnv = "Checking system environment..."
        SystemInfo = "System Information:"
        InstallingComponent = "Installing:"
        ComponentExists = "Already installed:"
        ComponentMissing = "Missing:"
        InstallSuccess = "Successfully installed:"
        InstallFailed = "Failed to install:"
        WSLFixing = "Fixing WSL2 issues..."
        WSLFixed = "WSL2 fix completed"
        RestartRequired = "System restart required to complete installation"
        SetupComplete = "Environment setup completed!"
        StartingServices = "Starting MCP services..."
        PressEnterToContinue = "Press Enter to continue..."
        Error = "Error:"
        Warning = "Warning:"
        Info = "Info:"
    }
}

$msg = $Messages[$currentLang]

# 工具函數
function Write-ColorMessage {
    param([string]$Message, [string]$Color = "White", [string]$Prefix = "")
    $fullMessage = if ($Prefix) { "$Prefix $Message" } else { $Message }
    Write-Host $fullMessage -ForegroundColor $Color
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Install-WithWinget {
    param([string]$PackageId, [string]$Name)
    Write-ColorMessage "$($msg.InstallingComponent) $Name..." "Yellow"
    try {
        winget install --id $PackageId --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-ColorMessage "$($msg.InstallSuccess) $Name" "Green"
            return $true
        } else {
            Write-ColorMessage "$($msg.InstallFailed) $Name (Exit Code: $LASTEXITCODE)" "Red"
            return $false
        }
    } catch {
        Write-ColorMessage "$($msg.InstallFailed) $Name - $($_.Exception.Message)" "Red"
        return $false
    }
}

function Enable-WindowsFeature {
    param([string[]]$Features)
    foreach ($feature in $Features) {
        Write-ColorMessage "$($msg.InstallingComponent) Windows Feature: $feature..." "Yellow"
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart
            Write-ColorMessage "$($msg.InstallSuccess) $feature" "Green"
        } catch {
            Write-ColorMessage "$($msg.InstallFailed) $feature - $($_.Exception.Message)" "Red"
        }
    }
}

function Fix-WSL2-Issues {
    Write-ColorMessage $msg.WSLFixing "Yellow"
    
    # 清理損壞的 .wslconfig
    $wslConfigPath = "$env:USERPROFILE\.wslconfig"
    if (Test-Path $wslConfigPath) {
        Remove-Item $wslConfigPath -Force
        Write-ColorMessage "Removed corrupted .wslconfig" "Green"
    }
    
    # 啟用 Hyper-V 自動啟動
    bcdedit /set hypervisorlaunchtype auto | Out-Null
    
    # 下載並安裝最新 WSL2 內核
    $wslUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    $wslUpdatePath = "$env:TEMP\wsl_update_x64.msi"
    
    try {
        Invoke-WebRequest -Uri $wslUpdateUrl -OutFile $wslUpdatePath
        Start-Process msiexec.exe -ArgumentList "/i `"$wslUpdatePath`" /quiet" -Wait
        Remove-Item $wslUpdatePath -Force
        Write-ColorMessage "WSL2 kernel updated" "Green"
    } catch {
        Write-ColorMessage "Failed to update WSL2 kernel: $($_.Exception.Message)" "Red"
    }
    
    # 設定 WSL2 為預設
    wsl --set-default-version 2 | Out-Null
    
    # 清理損壞的 Docker WSL 分發版
    @("docker-desktop", "docker-desktop-data") | ForEach-Object {
        try {
            wsl --unregister $_ 2>$null
            Write-ColorMessage "Cleaned up WSL distribution: $_" "Green"
        } catch {
            # 忽略錯誤，可能原本就不存在
        }
    }
    
    # 重新啟動服務
    @("HvHost", "vmcompute") | ForEach-Object {
        try {
            Restart-Service $_ -Force
            Write-ColorMessage "Restarted service: $_" "Green"
        } catch {
            Write-ColorMessage "Failed to restart service: $_ - $($_.Exception.Message)" "Yellow"
        }
    }
    
    Write-ColorMessage $msg.WSLFixed "Green"
}

# 主安裝流程
Clear-Host
Write-Host "=" * 60 -ForegroundColor Cyan
Write-ColorMessage $msg.Title "Cyan"
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

Write-ColorMessage $msg.CheckingEnv "Yellow"

# 系統資訊檢測
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$cpuInfo = Get-CimInstance -ClassName Win32_Processor
$virtualizationEnabled = (Get-CimInstance -ClassName Win32_Processor).VirtualizationFirmwareEnabled

Write-ColorMessage $msg.SystemInfo "Cyan"
Write-ColorMessage "OS: $($osInfo.Caption) Build $($osInfo.BuildNumber)" "White"
Write-ColorMessage "CPU: $($cpuInfo.Name)" "White"
Write-ColorMessage "Virtualization: $(if ($virtualizationEnabled) { 'Enabled' } else { 'Disabled' })" "White"
Write-Host ""

# 環境檢測和安裝
$componentsToCheck = @{
    "winget" = @{ Command = "winget"; Name = "Windows Package Manager"; Install = $false }
    "git" = @{ Command = "git"; Name = "Git"; PackageId = "Git.Git"; Install = $true }
    "docker" = @{ Command = "docker"; Name = "Docker Desktop"; PackageId = "Docker.DockerDesktop"; Install = $true }
}

$needsRestart = $false
$missingComponents = @()

# 檢查必要組件
foreach ($comp in $componentsToCheck.GetEnumerator()) {
    $exists = Test-Command $comp.Value.Command
    if ($exists) {
        Write-ColorMessage "$($msg.ComponentExists) $($comp.Value.Name)" "Green"
    } else {
        Write-ColorMessage "$($msg.ComponentMissing) $($comp.Value.Name)" "Red"
        if ($comp.Value.Install) {
            $missingComponents += $comp.Value
        }
    }
}

# 檢查 Windows 功能
$requiredFeatures = @(
    "Microsoft-Windows-Subsystem-Linux",
    "VirtualMachinePlatform",
    "Microsoft-Hyper-V-All",
    "Containers"
)

$missingFeatures = @()
foreach ($feature in $requiredFeatures) {
    $featureState = Get-WindowsOptionalFeature -Online -FeatureName $feature -ErrorAction SilentlyContinue
    if ($featureState -and $featureState.State -eq "Enabled") {
        Write-ColorMessage "$($msg.ComponentExists) Windows Feature: $feature" "Green"
    } else {
        Write-ColorMessage "$($msg.ComponentMissing) Windows Feature: $feature" "Red"
        $missingFeatures += $feature
    }
}

# 安裝缺失組件
if ($missingComponents.Count -gt 0 -or $missingFeatures.Count -gt 0 -or $Force) {
    Write-Host ""
    Write-ColorMessage "Starting installation process..." "Yellow"
    
    # 檢查並安裝 winget（如果需要）
    if (-not (Test-Command "winget")) {
        Write-ColorMessage "Installing Windows Package Manager..." "Yellow"
        # 安裝 winget 的邏輯（透過 Microsoft Store 或直接下載）
        try {
            $wingetUrl = "https://aka.ms/getwinget"
            Start-Process $wingetUrl
            Write-ColorMessage "Please install Windows Package Manager from Microsoft Store and rerun this script." "Yellow"
            Read-Host $msg.PressEnterToContinue
            exit
        } catch {
            Write-ColorMessage "Failed to open Microsoft Store for winget installation." "Red"
            exit 1
        }
    }
    
    # 安裝軟體包
    foreach ($component in $missingComponents) {
        Install-WithWinget $component.PackageId $component.Name
    }
    
    # 啟用 Windows 功能
    if ($missingFeatures.Count -gt 0) {
        Enable-WindowsFeature $missingFeatures
        $needsRestart = $true
    }
    
    # 修復 WSL2 問題
    if ($Force -or (Test-Command "docker" -and $missingFeatures -contains "Microsoft-Windows-Subsystem-Linux")) {
        Fix-WSL2-Issues
        $needsRestart = $true
    }
    
    # 更新 PATH 環境變數
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

# 創建或更新 .env 文件
$envPath = Join-Path $PSScriptRoot ".env"
$envExamplePath = Join-Path $PSScriptRoot ".env.example"

if (-not (Test-Path $envPath) -and (Test-Path $envExamplePath)) {
    Copy-Item $envExamplePath $envPath
    Write-ColorMessage "Created .env file from .env.example" "Green"
            Write-ColorMessage "Please edit .env file and add your API keys." "Yellow"
        Write-ColorMessage "See docs/CLAUDE-CONFIG-GUIDE.md for Claude Desktop setup." "Cyan"
}

Write-Host ""
if ($needsRestart) {
    Write-ColorMessage $msg.RestartRequired "Red"
    Write-ColorMessage "Run the following command after restart:" "Yellow"
    Write-ColorMessage ".\start.bat" "Cyan"
    Write-Host ""
    $restart = Read-Host "Restart now? (y/N)"
    if ($restart -eq "y" -or $restart -eq "Y") {
        Restart-Computer -Force
    }
} else {
    Write-ColorMessage $msg.SetupComplete "Green"
    Write-Host ""
    
    # 檢查 Docker 是否運行，如果是則自動啟動服務
    if (Test-Command "docker") {
        try {
            docker info *>$null
            if ($LASTEXITCODE -eq 0) {
                Write-ColorMessage $msg.StartingServices "Yellow"
                & (Join-Path $PSScriptRoot "start.bat")
            } else {
                Write-ColorMessage "Docker is installed but not running. Please start Docker Desktop and run: .\start.bat" "Yellow"
            }
        } catch {
            Write-ColorMessage "Docker is installed but not accessible. Please start Docker Desktop and run: .\start.bat" "Yellow"
        }
    }
}

Write-Host ""
Read-Host $msg.PressEnterToContinue 