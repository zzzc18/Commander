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

TimeOut = 1e10
CurrentTime = 0

Font = {
    gillsans50 = love.graphics.newFont("Font/gillsans.ttf", 50)
}

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
    local fp = io.open("../ClientTask.txt")
    if fp ~= nil then
        Debug.Log("info", "start as AI")
        TimeOut = tonumber(fp:read())
        Running = AI_SDK
        fp:close()
    else
        Running = PlayGame
    end
    Running.Init()
    Switcher.Init()
    Picture.Init()
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
    if CurrentTime > TimeOut then
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
