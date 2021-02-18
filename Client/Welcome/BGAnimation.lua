BGAnimation = {}

function BGAnimation.load()
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    BGimg1 = {
        path = love.graphics.newImage("data/Picture/Background.JPG"),
        x = 0,
        y = 0,
        widthRatio = 3,
        heightRatio = 3
    }
    BGimg2 = {
        path = love.graphics.newImage("data/Picture/Background.JPG"),
        x = PixelWidth,
        y = 0,
        widthRatio = 3,
        heightRatio = 3
    }
    BGAnimation.moveDistance = 0
    BGAnimation.moveRate = 50
end

function BGAnimation.deLoad()
    BGimg1 = {}
    BGimg2 = {}
end

function BGAnimation.draw()
    love.graphics.draw(BGimg1.path, BGimg1.x, BGimg1.y, 0, BGimg1.widthRatio, BGimg1.heightRatio)
    love.graphics.draw(BGimg2.path, BGimg2.x, BGimg2.y, 0, BGimg2.widthRatio, BGimg2.heightRatio)
end

function BGAnimation.update(dt)
    if BGAnimation.moveDistance < PixelWidth then
        BGimg1.x = BGimg1.x - dt * BGAnimation.moveRate
        BGimg2.x = BGimg2.x - dt * BGAnimation.moveRate
        BGAnimation.moveDistance = BGAnimation.moveDistance + dt * BGAnimation.moveRate
    else
        BGimg1.x = 0
        BGimg2.x = PixelWidth
        BGAnimation.moveDistance = 0
    end
end

return BGAnimation
