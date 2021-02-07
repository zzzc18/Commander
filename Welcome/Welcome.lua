Welcome = {}

function Welcome.Init()
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()

    Title = {
        img = love.graphics.newImage("data/Picture/Title.PNG"),
        widthRatio = 0.7,
        heightRatio = 0.7
    }
    Background = {
        img = love.graphics.newImage("data/Picture/Background.JPG"),
        widthRatio = 3,
        heightRatio = 3
    }
end
function Welcome.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        Background.img,
        0,
        0,
        0,
        Background.widthRatio,
        Background.heightRatio
    )
    love.graphics.draw(
        Title.img,
        PixelWidth / 2,
        PixelHeight / 3,
        0,
        Title.widthRatio,
        Title.heightRatio,
        Title.img:getWidth() / 2,
        Title.img:getHeight() / 2
    )
end
function Welcome.update()
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    Title.widthRatio = 0.7 * PixelHeight / 990
    Title.heightRatio = 0.7 * PixelHeight / 990
end

return Welcome
