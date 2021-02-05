BasicMap = {}

BasicMap.Map = {}
BasicMap.MapSize = {}
BasicMap.Focus = {}
BasicMap.ratio = 1
--[[ 
规定六边形相邻边从右上开始编号为1,顺时针增加
规定六边形顶点从正上方开始编号为1,顺时针增加
BasicMap.radius为六边形半径
BasicMap.horizontalDis为六边形与2或5号边相邻的六边形中心的距离，即水平距离，为半径sqrt(3)倍
BasicMap.verticalDis为六边形与1、3、4或6号边相邻的六边形中心的 竖直距离，为半径1.5倍
]]
BasicMap.radius = 40
--[[
六边形相邻格数组，偶数行是 BasicMap.direction[1][edgeID] 奇数行是 BasicMap.direction[2][edgeID]
]]
BasicMap.direction = {
    {{-1, 0}, {0, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}},
    {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {0, -1}, {-1, 0}}
}

function BasicMap.GetHexagonBesideByEdge(x, y, edgeID)
    local opt = x % 2 + 1
    return x + BasicMap.direction[opt][edgeID][1], y + BasicMap.direction[opt][edgeID][2]
end

function BasicMap.InsideHexagon(pixelX, pixelY, x, y)
    local centerPixelX, centerPixelY = BasicMap.Coordinate2Pixel(x, y)
    local node = {}
    node[1] = {centerPixelX, centerPixelY - BasicMap.radius}
    node[2] = {
        centerPixelX + math.sqrt(3) * BasicMap.radius,
        centerPixelY - BasicMap.radius / 2
    }
    node[3] = {
        centerPixelX + math.sqrt(3) * BasicMap.radius,
        centerPixelY + BasicMap.radius / 2
    }
    node[4] = {centerPixelX, centerPixelY + BasicMap.radius}
    node[5] = {
        centerPixelX - math.sqrt(3) * BasicMap.radius,
        centerPixelY + BasicMap.radius / 2
    }
    node[6] = {
        centerPixelX - math.sqrt(3) * BasicMap.radius,
        centerPixelY - BasicMap.radius / 2
    }
    -- 向量叉积的方式判断是否在六边形内
    for i = 1, 6 do
        local u = i
        local v = i + 1
        if v == 7 then
            v = 1
        end
        local vecEdge = {node[v][1] - node[u][1], node[v][2] - node[u][2]}
        local vecPixel = {pixelX - node[u][1], pixelY - node[u][2]}
        local crossVal = vecEdge[1] * vecPixel[2] - vecEdge[2] * vecPixel[1]
        if crossVal < 0 then
            return false
        end
    end
    return true
end

function BasicMap.Coordinate2Pixel(x, y)
    -- 注意地图坐标的第一维是横坐标，第二维是纵坐标
    -- 而显示的时候，第一维是x轴（水平向右），第二维是y轴（竖直向下）
    -- 所以在这里要用Focus x,y（地图坐标）对应offset y,x（显示坐标）
    local retX, retY = BasicMap.Focus.pixelX, BasicMap.Focus.pixelY

    local offsetY, offsetX = (x - BasicMap.Focus.x) * BasicMap.verticalDis, (y - BasicMap.Focus.y) * BasicMap.horizontalDis

    -- 当前格子 与 基准格子 的 x坐标奇偶性不一致时，需要进行修正
    if (x - BasicMap.Focus.x) % 2 == 1 then
        offsetX = offsetX + BasicMap.horizontalDis / 2
        if BasicMap.Focus.x % 2 == 1 then
            offsetX = offsetX - BasicMap.horizontalDis
        end
    end
    retX, retY = retX + offsetX, retY + offsetY
    return math.floor(retX), math.floor(retY)
end

-- 计算两个像素点之间的直线距离，参数为两个点的位置
function BasicMap.GetDisByPixel(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

-- pixel位置转坐标，返回值是该点的坐标
function BasicMap.Pixel2Coordinate(pixelX, pixelY)
    local retX, retY
    for i = 0, BasicMap.MapSize.x - 1 do
        local tmpx, tmpy = BasicMap.Coordinate2Pixel(i, 0)
        if tmpy - BasicMap.verticalDis / 2 < pixelY and pixelY < tmpy + BasicMap.verticalDis / 2 then
            retX = i
            break
        end
    end
    if retX == nil then
        return -1, -1
    end

    for i = 0, BasicMap.MapSize.y - 1 do
        local tmpx, tmpy = BasicMap.Coordinate2Pixel(retX, i)
        if tmpx - BasicMap.horizontalDis / 2 < pixelX and pixelX < tmpx + BasicMap.horizontalDis / 2 then
            retY = i
            break
        end
    end
    if retY == nil then
        return -1, -1
    end

    if BasicMap.InsideHexagon(pixelX, pixelY, retX, retY) then
        return retX, retY
    end
    -- 上述步骤选取可能会错判在边角除的点，因此比对下一行该选定格子周围的几个格子，
    -- 寻找是否有比当前选定的更合理的点

    -- TODO: 似乎用距离比叉积速度快，而且好像没毛病
    local direct = {1, 3, 4, 6}
    for i = 1, 4 do
        local tmpX, tmpY = BasicMap.GetHexagonBesideByEdge(retX, retY, direct[i])
        if BasicMap.InsideHexagon(pixelX, pixelY, tmpX, tmpY) then
            return tmpX, tmpY
        end
    end
    return -1, -1
end

--根据可见性和归属设定格子颜色
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

--绘制格子，包括地形和部队
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

--绘制从x,y格子延伸出的路径
function BasicMap.DrawPath(x, y)
    if CGameMap.GetVision(x, y) and CGameMap.GetUnitNum(x, y) ~= 0 then
        local belong = CGameMap.GetBelong(x, y)
        if belong ~= 0 then
            local step = 0
            local srcX, srcY, dstX, dstY = CGameMap.GetArmyPath(belong, step)
            while srcX ~= -1 do
                local sx, sy = BasicMap.Coordinate2Pixel(srcX, srcY)
                local ds, dy = BasicMap.Coordinate2Pixel(dstX, dstY)
                Picture.DrawArrow(sx, sy, ds, dy)
                step = step + 1
                srcX, srcY, dstX, dstY = CGameMap.GetArmyPath(belong, step)
            end
        end
    end
end

function BasicMap.DrawMap()
    for i = 0, BasicMap.MapSize.x - 1 do
        for j = 0, BasicMap.MapSize.y - 1 do
            BasicMap.Map[i][j].nodeType = CGameMap.GetNodeType(i, j)
            BasicMap.DrawNode(i, j)
            BasicMap.DrawPath(i, j)
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
    BasicMap.horizontalDis = math.sqrt(3) * BasicMap.radius
    BasicMap.verticalDis = 1.5 * BasicMap.radius
end

return BasicMap
