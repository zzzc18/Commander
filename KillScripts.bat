::强制停止所有Python脚本和love/lovec窗口
@echo off
taskkill /f /IM python.exe
taskkill /f /IM love.exe
taskkill /f /IM lovec.exe