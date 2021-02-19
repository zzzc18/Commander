local Welcome = {}
local Title = {}

Welcome.name = "Welcome"

function Welcome.Init()
    -- PlayGame.Init()
    Welcome.pressStart = false
    Welcome.releaseStart = false
end

function Welcome.Init()
    Title = {}
    Title.img = love.graphics.newImage("data/Picture/Title.PNG")
    Title.widthRatio = 0.6
    Title.heightRatio = 0.6
    BGAnimation.load()
    Buttons.Init()
end

function Welcome.DeInit()
    Title = {}
    BGAnimation.deLoad()
    Buttons.DeInit()
end

function Welcome.draw()
    if Welcome.releaseStart then
        PlayGame.draw()
    end
    local pixelWidth, pixelHeight = love.graphics.getPixelDimensions()
    if Running == Welcome then
        love.graphics.setColor(1, 1, 1, 1)
        BGAnimation.draw()
        love.graphics.draw(
            Title.img,
            pixelWidth / 2,
            pixelHeight / 4,
            0,
            Title.widthRatio,
            Title.heightRatio,
            Title.img:getWidth() / 2,
            Title.img:getHeight() / 2
        )
        Buttons.DrawButtons()
    end
end

function Welcome.mousepressed(pixelX, pixelY, button, istouch, presses)
    Buttons.MouseState(pixelX, pixelY, 0)
end

function Welcome.mousereleased(pixelX, pixelY, button, istouch, presses)
    local name = Buttons.MouseState(pixelX, pixelY, 2)
    if "start" == name then
        Switcher.To(PlayGame)
    end
    if "replay" == name then
        Switcher.To(ReplayGame)
    end
end

function Welcome.keypressed(key, scancode, isrepeat)
end

function Welcome.keyreleased(key, scancode)
end

function Welcome.wheelmoved(x, y)
end

function Welcome.update(dt)
    local pixelWidth, pixelHeight = love.graphics.getPixelDimensions()
    BGAnimation.update(dt)
    Title.widthRatio = 0.6 * pixelHeight / 990
    Title.heightRatio = 0.6 * pixelHeight / 990
    Buttons.Update()
end

return Welcome
