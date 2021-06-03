package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerification = require("lib.Verification")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")

Bitser = require("spec.bitser")
PlayGame = require("PlayGame.PlayGame")

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Buttons")
require("System.Debug")
require("System.Coordinate")

Running = {}

function love.load()
    Picture.Init()
    Running = PlayGame
    Coordinate.valid()
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

function love.filedropped(file)
    Debug.Log("info", "directorydropped " .. file:getFilename())
    for word in string.gmatch(file:getFilename(), "Commander\\.*%.map") do
        for path in string.gmatch(word, "\\.*\\") do
            PlayGame.droppedFilePath = path
            -- print(path)
            PlayGame.droppedFile = string.sub(word, 10 + string.len(path))
            -- print(PlayGame.droppedFile)
        end
        -- for name in string.gmatch(word, "\\.*%.map") do
        -- print(name)
        -- end
    end
    PlayGame.LoadMap()
end

function love.update(dt)
    Running.update(dt)
end

function love.draw()
    Running.draw()
end

function love.quit()
    return false
end
