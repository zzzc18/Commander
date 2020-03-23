package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerify = require("lib.Verify")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")

Sock = require("sock")
Bitser = require("spec.bitser")

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Timer")
require("Init")

function love.load()
    CVerify.Register(-1, 3)
end

function love.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
end

function love.draw()
end

function love.update(dt)
    Timer.Update()
    if Timer.second >= 1 then
        Timer.second = Timer.second - 1
        ServerSock.SendGameMapUpdate()
    end
    if Timer.second25 >= 25 then
        Timer.second25 = Timer.second25 - 25
        ServerSock.SendGameMapBigUpdate()
    end
end
