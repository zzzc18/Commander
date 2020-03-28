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
require("ServerSock")
require("PlayGame.PlayGame")

function love.load()
    CVerify.Register(-1, 3)
    ServerSock.Init()
    Running = PlayGame
    Running.Init()
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
    -- Running.draw()
end

function love.update(dt)
    Server:update()
    Running.update(dt)
    Timer.Update(dt)
end

function love.quit()
    return false
end
