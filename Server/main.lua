package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerify = require("lib.Verify")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")

Sock = require("sock")
Bitser = require("spec.bitser")

TimeOut = 1e10
CurrentTime = 0

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Debug")
require("System.Coordinate")
require("ServerSock")
require("PlayGame.PlayGame")

function love.load()
    Debug.Init()
    Debug.Log("info", "game start as server")
    CVerify.Register(0, 3)
    Coordinate.valid()
    Running = PlayGame
    Running.Init()
    Picture.Init()
    ServerSock.Init(PlayGame.armyNum)
    local fp = io.open("../ServerTask.txt")
    if fp ~= nil then
        TimeOut = tonumber(fp:read())
        fp:close()
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
    Running.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Running.keyreleased(key, scancode)
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
    Server:update()
    Running.update(dt)
end

function love.quit()
    Debug.Log("info", "game quit")
    return false
end
