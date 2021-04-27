Coordinate = {}

local Suspension = {}

function Coordinate.invalid()
    Coordinate.available = false
end

function Coordinate.valid()
    Coordinate.available = true
end

function Coordinate.Init()
    if not Coordinate.available then
        return
    end
    Suspension.triggerTime = 0.2
    Suspension.suspendTime = 0
    Suspension.lastX, Suspension.lastY = love.mouse.getPosition()
end

function Coordinate.DeInit()
    Suspension = {}
end

function Coordinate.draw()
    if not Coordinate.available then
        return
    end
    if Suspension.suspendTime >= Suspension.triggerTime then
        local x, y = BasicMap.Pixel2Coordinate(Suspension.lastX, Suspension.lastY)
        local mapSizeX, mapSizeY = CGameMap.GetSize()
        if x < 0 or y < 0 or x >= mapSizeX or y >= mapSizeY then
            return
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(x .. " " .. y, love.mouse.getX() + 10, love.mouse.getY() + 10, 0, 1.5, 1.5)
    end
end

function Coordinate.update(dt)
    if not Coordinate.available then
        return
    end
    if Suspension.lastX == love.mouse.getX() and Suspension.lastY == love.mouse.getY() then
        if Suspension.suspendTime < Suspension.triggerTime then
            Suspension.suspendTime = Suspension.suspendTime + dt
        end
    else
        Suspension.suspendTime = 0
    end
    Suspension.lastX, Suspension.lastY = love.mouse.getPosition()
end

return Coordinate
