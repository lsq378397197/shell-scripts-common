@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

set /p port=请输入端口号：

set "foundPID=0"
for /f "tokens=1-5" %%a in ('netstat -ano ^| find ":%port%"') do (
    if "%%e" == "" (
        set pid=%%d
    ) else (
        set pid=%%e
    )
    set "foundPID=1"
    echo !pid!
    taskkill /f /pid !pid!
)

if "!foundPID!"=="1" (
    echo 进程成功关闭。
) else (
    echo 未找到占用端口 %port% 的进程。
)

pause
