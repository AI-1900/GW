<#
.SYNOPSIS
    一键提交脚本：自动 add + commit + push
.DESCRIPTION
    用法:
      .\commit.ps1                          # 使用默认时间戳提交
      .\commit.ps1 "feat: add new kernel"  # 带自定义提交信息
      .\commit.ps1 -PushOnly                # 只 push，不 add/commit
#>

param(
    [Parameter(Position=0)]
    [string]$Message = "",

    [switch]$PushOnly
)

$RepoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $RepoPath

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Git 一键提交工具" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Push only 模式
if ($PushOnly) {
    Write-Host "[1/2] 推送到远端..." -ForegroundColor Yellow
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] push 失败" -ForegroundColor Red
        Read-Host "按回车退出"
        exit 1
    }
    Write-Host "`n[OK] Push 成功！`n" -ForegroundColor Green
    exit 0
}

# 检查 git 状态
Write-Host "[1/4] 检查修改状态..." -ForegroundColor Yellow
$status = git status --porcelain
if (-not $status) {
    Write-Host "`n[INFO] 没有需要提交的修改`n" -ForegroundColor Gray
    Read-Host "按回车退出"
    exit 0
}
$status -split "`n" | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }

# Add
Write-Host "`n[2/4] 添加所有修改..." -ForegroundColor Yellow
git add -A 2>&1 | Out-Null

# Commit
if (-not $Message) {
    $Message = "auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}
Write-Host "`n[3/4] 提交: $Message" -ForegroundColor Yellow
git commit -m $Message 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }

# Push
Write-Host "`n[4/4] 推送到远端..." -ForegroundColor Yellow
git push origin main 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  提交并推送成功！" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
} else {
    Write-Host "`n[ERROR] push 失败，请检查网络或权限`n" -ForegroundColor Red
}

Read-Host "按回车退出"
