@echo off
chcp 65001 >nul
REM ============================================
REM 一键提交脚本 - 双击运行
REM 自动 add + commit + push
REM 也可带参数: commit.bat "你的提交信息"
REM ============================================

cd /d "%~dp0"

echo.
echo ========================================
echo   Git 一键提交工具
echo ========================================
echo.

REM 检查是否有参数
if "%~1"=="" (
    set "COMMIT_MSG=auto-commit: %date% %time%"
    echo [INFO] 未指定提交信息，使用默认时间戳
) else (
    set "COMMIT_MSG=%~1"
    echo [INFO] 提交信息: %COMMIT_MSG%
)

echo.
echo [1/4] 检查 git 状态...
git status --short

echo.
echo [2/4] 添加所有修改...
git add -A
if %errorlevel% neq 0 (
    echo [ERROR] git add 失败
    pause
    exit /b 1
)

echo.
echo [3/4] 提交代码...
git commit -m "%COMMIT_MSG%"
if %errorlevel% neq 0 (
    echo [WARN] 没有需要提交的修改，或 commit 失败
)

echo.
echo [4/4] 推送到远端...
git push origin main
if %errorlevel% neq 0 (
    echo [ERROR] git push 失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo   提交并推送成功！
echo ========================================
echo.
pause
