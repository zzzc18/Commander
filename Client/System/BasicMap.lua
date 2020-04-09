BasicMap = {}

BasicMap.Map = {}
BasicMap.MapSize = {}
BasicMap.Focus = {}
BasicMap.ratio = 1
BasicMap.edgeLength = 40

function BasicMap.Coordinate2Pixel(x, y)
    if x >= BasicMap.MapSize.x or y >= BasicMap.MapSize.y or x < 0 or y < 0 then
        return nil
    end
    -- 注意地图坐标的第一维是横坐标，第二维是纵坐标
    -- 而显示的时候，第一维是x轴（水平向右），第二维是y轴（竖直向下）
    -- 所以在这里要用Focus x,y（地图坐标）对应offset y,x（显示坐标）
    local retX, retY = BasicMap.Focus.pixelX, BasicMap.Focus.pixelY

    local offsetY, offsetX = (x - BasicMap.Focus.x) * BasicMap.verticalDis,
    (y - BasicMap.Focus.y) * BasicMap.horizontalDis

    -- 当前格子 与 基准格子 的 x坐标奇偶性不一致时，需要进行修正
    if (x - BasicMap.Focus.x) % 2 == 1 then
        offsetX = offsetX + BasicMap.horizontalDis / 2 - (BasicMap.Focus.x % 2) * BasicMap.horizontalDis
    end
    retX, retY = retX + offsetX, retY + offsetY
    return math.floor(retX), math.floor(retY)
end

function BasicMap.GetDisByPixel(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function BasicMap.Pixel2Coordinate(pixelX, pixelY)
    local retX, retY
    for i = 0, BasicMap.MapSize.x - 1 do
        local tmpx, tmpy = BasicMap.Coordinate2Pixel(i, 0)
        if tmpy - BasicMap.verticalDis / 2 < pixelY and pixelY < tmpy + BasicMap.verticalDis / 2 then
            retX = i
            break
        end
    end
    if pixelX < BasicMap.Coordinate2Pixel(retX, 0) - BasicMap.horizontalDis / 2
    or pixelX > BasicMap.Coordinate2Pixel(retX, BasicMap.MapSize - 1) + BasicMap.horizontalDis / 2 then
        retX = retX + 1
    end
    for i = 0, BasicMap.MapSize.y - 1 do
        local tmpx, tmpy = BasicMap.Coordinate2Pixel(retX, i)
        if
        tmpx - BasicMap.horizontalDis / 2 < pixelX and
        pixelX < tmpx + BasicMap.horizontalDis / 2
        then
            retY = i
            break
        end
    end

    --- 上述步骤选取可能会错判在边角除的点，因此比对下一行该选定格子周围的几个格子，寻找是否有比当前选定的更合理的点
    --- 即比对距离大小，若能找到距离更小的便更换选定格子坐标
    if retX < BasicMap.MapSize.x - 1 then
        for i = -1, 1 do
            if BasicMap.GetDisByPixel(BasicMap.Coordinate2Pixel(retX, retY), BasicMap.Coordinate2Pixel(retX + 1, retY + i)) then
                retX = retX + 1
                retY = retY + i
                break       --- 不会有两个格子同时满足条件
            end
        end
    end
    -- TODO: 可能还需要后续进行测试
    if retY == nil then
        retX = -1
    end
    if retY == nil then
        retY = -1
    end
    return retX, retY
end

function BasicMap.SetNodeColor(x, y)
    local unitNum = CGameMap.GetUnitNum(x, y)
    local belong = CGameMap.GetBelong(x, y)
    if belong == 0 then
        if CGameMap.GetVision(x, y) then
            love.graphics.setColor(Color.Army(0))
        else
            love.graphics.setColor(1, 1, 1, 0.2)
        end
    else
        love.graphics.setColor(Color.Army(belong))
    end
end

function BasicMap.DrawNode(x, y)
    local pixelX, pixelY = BasicMap.Coordinate2Pixel(x, y)
    BasicMap.SetNodeColor(x, y)
    Picture.DrawNode(pixelX, pixelY, BasicMap.Map[x][y].nodeType)
    local unitNum = CGameMap.GetUnitNum(x, y)
    -- TODO: 我觉得可能变成nil更合理
    if unitNum ~= 0 then
        love.graphics.setColor(Color.White())
        love.graphics.print(unitNum, pixelX, pixelY, 0, 1, 1, 2, 2)
    end
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
    BasicMap.horizontalDis = math.sqrt(3) * BasicMap.edgeLength
    BasicMap.verticalDis = 1.5 * BasicMap.edgeLength
end

return BasicMap