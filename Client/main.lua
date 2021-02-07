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

Font = {
    gillsans50 = love.graphics.newFont("Font/gillsans.ttf", 50)
}

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Buttons")
require("ClientSock")
require("GameOver")
require("Switcher")

Running = {}

function love.load()
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
    if key == "p" then
        Switcher.To("本地对局")
    end
    if key == "r" then
        Switcher.To("对局回放")
    end
    Running.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Running.keyreleased(key, scancode)
end

function love.draw()
    Running.draw()
end

function love.update(dt)
    -- 倍速开关，用于快速测试，可以通过注释和取消注释调整
    -- dt = dt * 10
    Client:update()
    Running.update(dt)
end

function love.quit()
    return false
end
