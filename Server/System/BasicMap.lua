BasicMap = {}

BasicMap.Map = {}
BasicMap.MapSize = {}
BasicMap.Focus = {}
BasicMap.ratio = 1
--[[ 规定六边形相邻边从右上开始编号为1,顺时针增加
BasicMap.radius为六边形半径
BasicMap.horizontalDis为六边形与2或5号边相邻的六边形中心的距离，即水平距离，为半径sqrt(3)倍
BasicMap.verticalDis为六边形与1、3、4或6号边相邻的六边形中心的 竖直距离，为半径1.5倍
]]
BasicMap.radius = 40

function BasicMap.Coordinate2Pixel(x, y)
    -- 注意地图坐标的第一维是横坐标，第二维是纵坐标
    -- 而显示的时候，第一维是x轴（水平向右），第二维是y轴（竖直向下）
    -- 所以在这里要用Focus x,y（地图坐标）对应offset y,x（显示坐标）
    local retX, retY = BasicMap.Focus.pixelX, BasicMap.Focus.pixelY

    local offsetY, offsetX =
        (x - BasicMap.Focus.x) * BasicMap.verticalDis,
        (y - BasicMap.Focus.y) * BasicMap.horizontalDis

    -- 当前格子 与 基准格子 的 x坐标奇偶性不一致时，需要进行修正
    if (x - BasicMap.Focus.x) % 2 == 1 then
        offsetX = offsetX + BasicMap.horizontalDis / 2
    end
    retX, retY = retX + offsetX, retY + offsetY
    return retX, retY
end

function BasicMap.Pixel2Coordinate(pixelX, pixelY)
    local retX, retY
    for i = 0, BasicMap.MapSize.x - 1 do
        local tmpx, tmpy = BasicMap.Coordinate2Pixel(i, 0)
        if
            tmpy - BasicMap.verticalDis / 2 < pixelY and
                pixelY < tmpy + BasicMap.verticalDis / 2
         then
            retX = i
            break
        end
    end
    for i = 0, BasicMap.MapSize.y - 1 do
        local tmpx, tmpy = BasicMap.Coordinate2Pixel(0, i)
        if
            tmpx - BasicMap.horizontalDis / 2 < pixelX and
                pixelX < tmpx + BasicMap.horizontalDis / 2
         then
            retY = i
            break
        end
    end
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
