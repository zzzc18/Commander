::尽管建立日志文件夹时有防止名称冲突的机制，但启动时间相隔过短仍会出问题
::此时多个程序的日志将输出到同一个文件中，最常见的情况是Server和第一个Client
::问题出现的几率可能与硬盘速度有关
::bat里没有延时命令，这里使用了一个临时的vbs脚本
@echo off
echo wscript.sleep 100>sleep.vbs
cd Server
start lovec .
@cscript ..\sleep.vbs >nul
@cscript ..\sleep.vbs >nul
cd ..\Client
start lovec .
@cscript ..\sleep.vbs >nul
start lovec .
@cscript ..\sleep.vbs >nul
start lovec .
del /f /s /q ..\sleep.vbs