BGAnimation = {}

function BGAnimation.load()
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    BGimg1 = {
        path = love.graphics.newImage("data/Picture/Background.JPG"),
        x = 0,
        y = 0
    }
    BGimg2 = {
        path = BGimg1.path,
        x = PixelWidth,
        y = 0
    }
    moveDistance = 0
    moveRate = 50
end

function BGAnimation.deLoad()
    BGimg1 = {}
    BGimg2 = {}
end

function BGAnimation.draw()
    love.graphics.draw(BGimg1.path, BGimg1.x, BGimg1.y)
    love.graphics.draw(BGimg2.path, BGimg2.x, BGimg2.y)
end

function BGAnimation.update(dt)
    if moveDistance < PixelWidth then
        BGimg1.x = BGimg1.x - dt * moveRate
        BGimg2.x = BGimg2.x - dt * moveRate
        moveDistance = moveDistance + dt * moveRate
    else
        BGimg1.x = 0
        BGimg2.x = PixelWidth
        moveDistance = 0
    end
end

return BGAnimation
