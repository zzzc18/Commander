Picture = {}

local NodeImageSet = {}
local SelectImage = {}
local ArrowImage = {}
local ReadyImage = {}
local Menu = {}

function ReadyImage:Load()
    self.title = love.graphics.newImage("data/Picture/Title.png")
    self.ready = love.graphics.newImage("data/Picture/Waiting.png")
end

function NodeImageSet:Load()
    self.center = {}
    self.center.x = 97
    self.center.y = 97
    self.divRatio = 135
    self["NODE_TYPE_BLANK"] = love.graphics.newImage("data/Picture/NODE_TYPE_BLANK.png")
    self["NODE_TYPE_HILL"] = love.graphics.newImage("data/Picture/NODE_TYPE_HILL.png")
    self["NODE_TYPE_FORT"] = love.graphics.newImage("data/Picture/NODE_TYPE_FORT.png")
    self["NODE_TYPE_KING"] = love.graphics.newImage("data/Picture/NODE_TYPE_KING.png")
    self["NODE_TYPE_OBSTACLE"] = love.graphics.newImage("data/Picture/NODE_TYPE_OBSTACLE.png")
    self["NODE_TYPE_MARSH"] = love.graphics.newImage("data/Picture/NODE_TYPE_MARSH.png")
end

function SelectImage:Load()
    self.center = {}
    self.center.x = 113
    self.center.y = 113
    self.divRatio = 135
    self.image = love.graphics.newImage("data/Picture/Select.png")
end

function ArrowImage:Load()
    self.image = love.graphics.newImage("data/Picture/arrow.png")
    self.center = {x = 0, y = 25}
    self.divRatio = 50
end

function Menu:Load()
    self.image = love.graphics.newImage("data/Picture/menu.png")
end

function Picture.Init()
    NodeImageSet:Load()
    --if ServerSock == nil then
    SelectImage:Load()
    ArrowImage:Load()
    --end
    if ClientSock ~= nil then
        Menu:Load()
        ReadyImage:Load()
    end
    Debug.Log("info", "init Picture")
end

function Picture.DrawNode(pixelX, pixelY, nodeType, belong)
    local scaleFactor = BasicMap.radius / NodeImageSet.divRatio
    love.graphics.draw(
        NodeImageSet[nodeType],
        pixelX,
        pixelY,
        0,
        scaleFactor,
        scaleFactor,
        NodeImageSet.center.x,
        NodeImageSet.center.y
    )
    if nodeType == "NODE_TYPE_KING" or nodeType == "NODE_TYPE_FORT" then
        local nodeX, nodeY = {}, {}
        for i = 0, math.pi * 5 / 3, math.pi / 3 do --极坐标变换
            table.insert(nodeX, pixelX + math.sin(i) * BasicMap.radius + 13 * scaleFactor)
            table.insert(nodeY, pixelY + math.cos(i) * BasicMap.radius + 28 * scaleFactor)
        end
        if nodeType == "NODE_TYPE_FORT" then
            if belong == 0 then
                return
            end
            love.graphics.setColor(1, 0, 0, 1)
        else
            love.graphics.setColor(1, 1, 0, 1)
        end
        love.graphics.setLineWidth(5 * scaleFactor)
        love.graphics.polygon(
            "line",
            nodeX[1],
            nodeY[1],
            nodeX[2],
            nodeY[2],
            nodeX[3],
            nodeY[3],
            nodeX[4],
            nodeY[4],
            nodeX[5],
            nodeY[5],
            nodeX[6],
            nodeY[6]
        )
    end
end

function Picture.DrawSelect(pixelX, pixelY)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        SelectImage.image,
        pixelX,
        pixelY,
        0,
        BasicMap.radius / SelectImage.divRatio,
        BasicMap.radius / SelectImage.divRatio,
        SelectImage.center.x,
        SelectImage.center.y
    )
end

-- 画路径箭头
function Picture.DrawArrow(pixelX, pixelY, targetX, targetY)
    love.graphics.setColor(1, 1, 1)
    -- love.graphics.setLineWidth(10)
    -- love.graphics.line(pixelX, pixelY, targetX, targetY)
    local theta
    theta = math.atan((targetY - pixelY) / (targetX - pixelX))
    if (targetX - pixelX) < 0 then
        theta = theta + math.pi
    end
    love.graphics.draw(
        ArrowImage.image,
        pixelX,
        pixelY,
        theta,
        BasicMap.radius / ArrowImage.divRatio,
        BasicMap.radius / ArrowImage.divRatio,
        ArrowImage.center.x,
        ArrowImage.center.y
    )
end

function Picture.DrawReady(BGAnimation)
    love.graphics.setColor(1, 1, 1, 1)

    BGAnimation.draw()
    local title = {
        img = ReadyImage.title,
        ratioX = 0.6,
        ratioY = 0.6
    }
    local waiting = {
        img = ReadyImage.ready,
        ratioX = 0.4,
        ratioY = 0.4
    }
    love.graphics.draw(
        title.img,
        BGAnimation.PixelWidth / 2,
        BGAnimation.PixelHeight / 3,
        0,
        title.ratioX,
        title.ratioY,
        title.img:getWidth() / 2,
        title.img:getHeight() / 2
    )
    love.graphics.draw(
        waiting.img,
        BGAnimation.PixelWidth / 2,
        BGAnimation.PixelHeight / 3 * 2,
        0,
        waiting.ratioX,
        waiting.ratioY,
        waiting.img:getWidth() / 2,
        waiting.img:getHeight() / 2
    )
end

function Picture.DrawMenu()
    love.graphics.setColor(1, 1, 1, 1)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    love.graphics.draw(
        Menu.image,
        (windowWidth - (250 * windowHeight / 720)) / 2,
        (windowHeight - (360 * windowHeight / 720)) / 2,
        0,
        windowHeight / 720 / 2,
        windowHeight / 720 / 2,
        0,
        0
    )
end

function Picture.PrintStepAndSpeed(step, speed)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Step:" .. step, windowWidth - 120, 0, 0, 2)
    if speed ~= nil then
        love.graphics.print("Speed:" .. speed, windowWidth - 120, 25, 0, 2)
    end
end

return Picture
