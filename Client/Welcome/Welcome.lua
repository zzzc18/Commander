local Welcome = {}

function Welcome.Init()
    Welcome.Title = {}
    Welcome.Title.img = love.graphics.newImage("data/Picture/Title.PNG")
    Welcome.Title.widthRatio = 0.6
    Welcome.Title.heightRatio = 0.6
    BGAnimation.load()
    Buttons.Init()
    Debug.Log("info", "init Welcome")
end

function Welcome.DeInit()
    Welcome.Title = {}
    BGAnimation.deLoad()
    Buttons.DeInit()
end

function Welcome.draw()
    local pixelWidth, pixelHeight = love.graphics.getPixelDimensions()
    love.graphics.setColor(1, 1, 1, 1)
    BGAnimation.draw()
    love.graphics.draw(
        Welcome.Title.img,
        pixelWidth / 2,
        pixelHeight / 4,
        0,
        Welcome.Title.widthRatio,
        Welcome.Title.heightRatio,
        Welcome.Title.img:getWidth() / 2,
        Welcome.Title.img:getHeight() / 2
    )
    Buttons.DrawButtons()
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
    if "a" == key then
        Switcher.To(AI_SDK)
    end
end

function Welcome.keyreleased(key, scancode)
end

function Welcome.wheelmoved(x, y)
end

function Welcome.update(dt)
    local pixelWidth, pixelHeight = love.graphics.getPixelDimensions()
    BGAnimation.update(dt)
    Welcome.Title.widthRatio = 0.6 * pixelHeight / 990
    Welcome.Title.heightRatio = 0.6 * pixelHeight / 990
    Buttons.Update()
end

return Welcome
