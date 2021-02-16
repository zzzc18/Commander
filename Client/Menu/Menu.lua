Menu = {}

--存储菜单信息
MenuBasic = {}

function Menu.Init()
    MenuBasic.imag = love.graphics.newImage("data/Picture/menu.png")
    Buttons.Init()
end

function Menu.DeInit()
    MenuBasic = {}
    Buttons.DeInit()
end

function Menu.draw()
end

function Menu.update()
    -- Client:update()
    Buttons.Update()
    MapAdjust.Update()
end

function Menu.wheelmoved(x, y)
    MapAdjust.Catchwheelmoved(x, y)
end

function Menu.mousepressed(pixelX, pixelY, button, istouch, presses)
    Buttons.MouseState(pixelX, pixelY, 0)
end

function Menu.mousereleased(pixelX, pixelY, button, istouch, presses)
    local name = Buttons.MouseState(pixelX, pixelY, 2)
end

function Menu.keypressed(key, scancode, isrepeat)
end

function Menu.keyreleased(key, scancode)
end

return Menu
