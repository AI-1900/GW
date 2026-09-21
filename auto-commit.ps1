# auto-commit.ps1
# 每日自动提交并推送修改到 GitHub
# 由 Windows 任务计划程序每日凌晨 3:00 触发

$RepoPath = "D:\luke\GW"
$LogFile  = "$RepoPath\auto-commit.log"
$Branch   = "main"
$Remote   = "origin"

# 日志函数
function Write-Log {
    param([string]$msg)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $msg
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
    Write-Host $line
}

Write-Log "===== Auto-commit started ====="

# 切换到仓库目录
Set-Location $RepoPath
Write-Log "Working directory: $RepoPath"

# 检查是否有修改
$status = git status --porcelain
if (-not $status) {
    Write-Log "No changes detected. Nothing to commit."
    Write-Log "===== Auto-commit finished (no changes) ====="
    exit 0
}

Write-Log "Changes detected:"
$status -split "`n" | ForEach-Object { Write-Log "  $_" }

# 添加所有修改
git add -A
Write-Log "git add -A done"

# 提交（带时间戳）
$commitMsg = "auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg
if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: git commit failed (exit $LASTEXITCODE)"
    Write-Log "===== Auto-commit failed ====="
    exit 1
}
Write-Log "Committed: $commitMsg"

# 推送到远端
git push $Remote $Branch 2>&1 | ForEach-Object { Write-Log "  push: $_" }
if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: git push failed (exit $LASTEXITCODE)"
    Write-Log "===== Auto-commit failed ====="
    exit 1
}

Write-Log "Push successful to $Remote/$Branch"
Write-Log "===== Auto-commit finished successfully ====="
