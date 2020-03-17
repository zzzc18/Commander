BasicMap = {}

BasicMap.Map = {}
BasicMap.MapSize = {}
BasicMap.Focus = {}
BasicMap.ratio = 1
BasicMap.edgeLength = 40

function BasicMap.Coornidate2Pixel(x, y)
    local retX, retY = BasicMap.Focus.pixelX, BasicMap.Focus.pixelY
    local offsetX, offsetY =
        (BasicMap.Focus.x - x) * BasicMap.edgeLength,
        (BasicMap.Focus.y - y) * BasicMap.edgeLength
    retX, retY = retX + offsetX, retY + offsetY
    return retX, retY
end

function BasicMap.Pixel2Coornidate(pixelX, pixelY)
    local retX, retY
    for i = 0, BasicMap.MapSize.x - 1 do
        local tmpx, tmpy = BasicMap.Coornidate2Pixel(i, 0)
        if
            tmpy - BasicMap.edgeLength / 2 < pixelY and
                pixelY < tmpy + BasicMap.edgeLength / 2
         then
            retX = i
            break
        end
    end
    for i = 0, BasicMap.MapSize.y - 1 do
        local tmpx, tmpy = BasicMap.Coornidate2Pixel(0, i)
        if
            tmpx - BasicMap.edgeLength / 2 < pixelX and
                pixelX < tmpx + BasicMap.edgeLength / 2
         then
            retY = i
            break
        end
    end
    if retY == nil then
        retX = 1
    end
    if retY == nil then
        retY = 1
    end
    return retX, retY
end

function BasicMap.DrawNode(x, y)
    local pixelX, pixelY = BasicMap.Coornidate2Pixel(x, y)
    Picture.DrawNode(
        pixelX,
        pixelY,
        BasicMap.Map[x][y].nodeType,
        BasicMap.ratio
    )
end

function BasicMap.DrawMap()
    for i = 0, BasicMap.MapSize.x - 1 do
        for j = 0, BasicMap.MapSize.y - 1 do
            BasicMap.DrawNode(i, j)
        end
    end
end

function BasicMap.Init()
    BasicMap.MapSize.x, BasicMap.MapSize.y = CGameMap.GetSize()
    for i = 0, BasicMap.MapSize.x - 1 do
        BasicMap.Map[i] = {}
        for j = 0, BasicMap.MapSize.y - 1 do
            BasicMap.Map[i][j] = {}
            BasicMap.Map[i][j].nodeType = CGameMap.GetNodeType(i, j)
        end
    end

    BasicMap.Focus.pixelX, BasicMap.Focus.pixelY = love.graphics.getDimensions()
    BasicMap.Focus.pixelX = BasicMap.Focus.pixelX / 2
    BasicMap.Focus.pixelY = BasicMap.Focus.pixelY / 2
    BasicMap.Focus.x = BasicMap.MapSize.x / 2
    BasicMap.Focus.y = BasicMap.MapSize.y / 2
end

return BasicMap
