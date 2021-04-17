::注释见QuickRun_3Player.bat
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
@cscript ..\sleep.vbs >nul
start lovec .
del /f /s /q ..\sleep.vbs