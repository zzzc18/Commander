Picture = {}

NodeImageSet = {}

function Picture.Init()
    NodeImageSet.center = {}
    NodeImageSet.center.x = 97
    NodeImageSet.center.y = 97
    NodeImageSet.ratio = 20 / 195
    NodeImageSet["NODE_TYPE_BLANK"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_BLANK.png")
    NodeImageSet["NODE_TYPE_HILL"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_HILL.png")
    NodeImageSet["NODE_TYPE_FORT"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_FORT.png")
    NodeImageSet["NODE_TYPE_KING"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_KING.png")
    NodeImageSet["NODE_TYPE_OBSTACLE"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_OBSTACLE.png")
    NodeImageSet["NODE_TYPE_MARSH"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_MARSH.png")
end

function Picture.DrawNode(pixelX, pixelY, nodeType, ratio)
    love.graphics.draw(
        NodeImageSet[nodeType],
        pixelX,
        pixelY,
        0,
        BasicMap.edgeLength / 195,
        BasicMap.edgeLength / 195,
        NodeImageSet.center.x,
        NodeImageSet.center.y
    )
end

return Picture
