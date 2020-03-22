package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

Sock = require("sock")
Bitser = require("spec.bitser")

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
end
