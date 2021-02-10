Welcome = {}

function Welcome.Init()
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()

    Title = {}
    Title.img = love.graphics.newImage("data/Picture/Title.PNG")
    Title.widthRatio = 0.6
    Title.heightRatio = 0.6

    Background = {}
    Background.img = love.graphics.newImage("data/Picture/Background.JPG")
    Background.widthRatio = 3
    Background.heightRatio = 3

    Buttons.Init()
end

function Welcome.DeInit()
    Title = {}
    Background = {}
    Buttons.DeInit()
end

function Welcome.draw()
    local PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    if Running == Welcome then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(Background.img, 0, 0, 0, Background.widthRatio, Background.heightRatio)
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
    Buttons.MouseState(pixelX, pixelY, 2)
end

function Welcome.keypressed(key, scancode, isrepeat)
end

function Welcome.keyreleased(key, scancode)
end

function Welcome.wheelmoved(x, y)
end

function Welcome.update()
    local PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    Title.widthRatio = 0.6 * PixelHeight / 990
    Title.heightRatio = 0.6 * PixelHeight / 990
    Buttons.Update()
end

return Welcome
