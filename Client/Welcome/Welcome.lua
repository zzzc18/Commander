Welcome = {}

function Welcome.Init()
    require("Client.Welcome.BGAnimation")
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()

    Title = {}
    Title.img = love.graphics.newImage("data/Picture/Title.PNG")
    Title.widthRatio = 0.6
    Title.heightRatio = 0.6

    -- Background = {}
    -- Background.img = love.graphics.newImage("data/Picture/Background.JPG")
    BGAnimation.load()
    BGimg1.widthRatio = 3
    BGimg1.heightRatio = 3
    BGimg2.widthRatio = 3
    BGimg2.heightRatio = 3

    Buttons.Init()
end

function Welcome.DeInit()
    Title = {}
    BGAnimation.deLoad()
    Buttons.DeInit()
end

function Welcome.draw()
    local PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    if Running == Welcome then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            BGimg1.path,
            BGimg1.x,
            BGimg1.y,
            0,
            BGimg1.widthRatio,
            BGimg1.heightRatio
        )
        love.graphics.draw(
            BGimg2.path,
            BGimg2.x,
            BGimg2.y,
            0,
            BGimg2.widthRatio,
            BGimg2.heightRatio
        )
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
        Switcher.Switch("p")
    end
    if "replay" == name then
        Switcher.Switch("r")
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
