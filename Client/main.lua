package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerify = require("lib.Verify")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")

Sock = require("sock")
Bitser = require("spec.bitser")
PlayGame = require("PlayGame.PlayGame")
GameOver = require("GameOver.GameOver")
ReplayGame = require("Replayer.ReplayGame")
Welcome = require("Welcome.Welcome")
BGAnimation = require("Welcome.BGAnimation")
Switcher = require("Switcher")
AI_SDK = require("AI.AI_SDK.AI_SDK")

Command = {}
--客户端是否正运行自动对战任务，如果为true，客户端会在游戏结束或超时后关闭
Command["[autoMatch]"] = "false"
Command["[timeOut]"] = 1e10
Command["[mapDict]"] = "default"
Command["[mapName]"] = "default"
Command["[AIlang]"] = "Lua"
CurrentTime = 0

Font = {}

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Buttons")
require("System.Debug")
require("System.Coordinate")
require("ClientSock")

Running = {}

function love.load()
    Debug.Init()
    Debug.Log("info", "game start as client")
    Coordinate.valid()
    local task = io.open("../ClientTask.txt", "r")
    if task ~= nil then
        local line = task:read()
        while line ~= nil do
            Command[line] = task:read()
            if line == "[timeOut]" then
                Command[line] = tonumber(Command[line])
            end
            line = task:read()
        end
        task:close()
    end
    if Command["[autoMatch]"] == "true" then
        Debug.Log("info", "start as AI")
        Running = AI_SDK
    else
        Debug.Log("info", "start without task")
        if Visable then
            Running = Welcome
        else
            Running = PlayGame
        end
    end
    Running.Init()
    Switcher.Init()
    if Visable then
        local gillsans50 = love.graphics.newFont("Font/gillsans.ttf", 50)
        table.insert(Font, 1, gillsans50)
        Picture.Init()
    end
end

function love.wheelmoved(x, y)
    Running.wheelmoved(x, y)
end

function love.mousepressed(pixelX, pixelY, button, istouch, presses)
    Running.mousepressed(pixelX, pixelY, button, istouch, presses)
end

function love.mousereleased(pixelX, pixelY, button, istouch, presses)
    Running.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
    Debug.Log("info", "keypressed " .. key)
    Running.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Running.keyreleased(key, scancode)
end

function love.directorydropped(path)
    Debug.Log("info", "directorydropped " .. path)
    ReplayGame.droppedDir = path
end

function love.draw()
    Running.draw()
end

function love.update(dt)
    CurrentTime = CurrentTime + dt
    if CurrentTime > Command["[timeOut]"] and Command["[autoMatch]"] == "true" then
        Debug.Log("info", "game quit because timeout")
        love.event.quit(0)
    end
    -- 倍速开关，用于快速测试，可以通过注释和取消注释调整
    -- dt = dt * 10
    Running.update(dt)
end

function love.quit()
    Debug.Log("info", "game quit")
    return false
end
