Picture = {}

NodeImageSet = {}
SelectImage = {}

function NodeImageSet:Load()
    self.center = {}
    self.center.x = 97
    self.center.y = 97
    self.divRatio = 135
    self["NODE_TYPE_BLANK"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_BLANK.png")
    self["NODE_TYPE_HILL"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_HILL.png")
    self["NODE_TYPE_FORT"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_FORT.png")
    self["NODE_TYPE_KING"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_KING.png")
    self["NODE_TYPE_OBSTACLE"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_OBSTACLE.png")
    self["NODE_TYPE_MARSH"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_MARSH.png")
end

function SelectImage:Load()
    self.center = {}
    self.center.x = 113
    self.center.y = 113
    self.divRatio = 135
    self.image = love.graphics.newImage("data/Picture/Select.png")
end

function Picture.Init()
    NodeImageSet:Load()
    SelectImage:Load()
end

function Picture.DrawNode(pixelX, pixelY, nodeType)
    love.graphics.draw(
        NodeImageSet[nodeType],
        pixelX,
        pixelY,
        0,
        BasicMap.radius / NodeImageSet.divRatio, --- scale factor x
        BasicMap.radius / NodeImageSet.divRatio, --- scale factor y
        NodeImageSet.center.x,
        NodeImageSet.center.y
    )
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

return Picture
