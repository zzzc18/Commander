local BGAnimation = {}

BGAnimation.BGimg1 = {}
BGAnimation.BGimg2 = {}

function BGAnimation.load()
    BGAnimation.PixelWidth, BGAnimation.PixelHeight = love.graphics.getPixelDimensions()
    BGAnimation.BGimg1 = {
        path = love.graphics.newImage("data/Picture/Background.png"),
        x = 0,
        y = 0,
        widthRatio = 1,
        heightRatio = 1
    }
    BGAnimation.BGimg2 = {
        path = love.graphics.newImage("data/Picture/Background.png"),
        x = 1080,
        y = 0,
        widthRatio = 1,
        heightRatio = 1
    }
    BGAnimation.BGimg3 = {
        path = love.graphics.newImage("data/Picture/Background.png"),
        x = 2160,
        y = 0,
        widthRatio = 1,
        heightRatio = 1
    }
    BGAnimation.moveDistance = 0
    BGAnimation.moveRate = 50
end

function BGAnimation.deLoad()
    BGAnimation.BGimg1 = {}
    BGAnimation.BGimg2 = {}
    BGAnimation.BGimg3 = {}
end

function BGAnimation.draw()
    love.graphics.draw(
        BGAnimation.BGimg1.path,
        BGAnimation.BGimg1.x,
        BGAnimation.BGimg1.y,
        0,
        BGAnimation.BGimg1.widthRatio,
        BGAnimation.BGimg1.heightRatio
    )
    love.graphics.draw(
        BGAnimation.BGimg2.path,
        BGAnimation.BGimg2.x,
        BGAnimation.BGimg2.y,
        0,
        BGAnimation.BGimg2.widthRatio,
        BGAnimation.BGimg2.heightRatio
    )
    love.graphics.draw(
        BGAnimation.BGimg3.path,
        BGAnimation.BGimg3.x,
        BGAnimation.BGimg3.y,
        0,
        BGAnimation.BGimg3.widthRatio,
        BGAnimation.BGimg3.heightRatio
    )
end

function BGAnimation.update(dt)
    BGAnimation.PixelWidth, BGAnimation.PixelHeight = love.graphics.getPixelDimensions()
    -- BGAnimation.BGimg1.heightRatio = BGAnimation.PixelHeight / 720
    -- BGAnimation.BGimg2.heightRatio = BGAnimation.PixelHeight / 720
    -- BGAnimation.BGimg3.heightRatio = BGAnimation.PixelHeight / 720
    if BGAnimation.moveDistance < 1080 then
        BGAnimation.BGimg1.x = BGAnimation.BGimg1.x - dt * BGAnimation.moveRate
        BGAnimation.BGimg2.x = BGAnimation.BGimg2.x - dt * BGAnimation.moveRate
        BGAnimation.BGimg3.x = BGAnimation.BGimg3.x - dt * BGAnimation.moveRate
        BGAnimation.moveDistance = BGAnimation.moveDistance + dt * BGAnimation.moveRate
    else
        BGAnimation.BGimg1.x = 0
        BGAnimation.BGimg2.x = 1080
        BGAnimation.BGimg3.x = 2160
        BGAnimation.moveDistance = 0
    end
end

return BGAnimation
