Welcome = {}

require("Welcome.BGAnimation")

Welcome.name = "Welcome"

function Welcome.Init()
    -- PlayGame.Init()
    PressStart = false
    ReleaseStart = false
    OriColor = {1, 1, 1, 1}
    SelectedColor = {0.7, 0.7, 0.7, 1}
    ClickedColor = {0.439, 0.502, 0.565, 1}
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
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
    if ReleaseStart then
        PlayGame.draw()
    end
    local PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    if Running == Welcome then
        love.graphics.setColor(1, 1, 1, 1)
        BGAnimation.draw()
        love.graphics.draw(
            Title.img,
            PixelWidth / 2,
            PixelHeight / 4,
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
    local PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    BGAnimation.update(dt)
    Title.widthRatio = 0.6 * PixelHeight / 990
    Title.heightRatio = 0.6 * PixelHeight / 990
    Buttons.Update()
end

return Welcome
