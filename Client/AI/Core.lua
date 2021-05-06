Core = {}

--这里是一份AI逻辑核心的示例，实际运行的会是Core.lua
--若想运行此示例，可将以下内容复制到Core.lua
local IsInit = false
local id

function Core.init()
    --我的id
    id = AI_SDK.armyID
end

function Core.Record()
    -- 这个数组记录了哪些是我的点
    local Collar = {}
    local X, Y, Num, pos
    Num = 0
    -- 遍历整个地图
    for i = 0, 23, 1 do
        for j = 0, 23, 1 do
            X = i
            Y = j
            if CGameMap.GetBelong(X, Y) == id then
                table.insert(Collar, {X = X, Y = Y})
                Num = Num + 1
            end
        end
    end
    -- 返回属于自己点的坐标和数量
    return Collar, Num
end

-- 主函数
function Core.Main()
    local Collar = {}
    local Num, X, Y, i
    local move_ratio = 0.5
    local ID = CGameMap.GetBelong(X, Y)
    if IsInit == false then
        Core.init()
        IsInit = true
    end
    Collar, Num = Core.Record()
    i = 1
    -- 随机选择自己的点
    while i <= Num / 2 + 1 do
        local choice = math.random(Num)
        X, Y = Collar[choice].X, Collar[choice].Y
        if CGameMap.GetUnitNum(X, Y) > 2 then
            break
        end
        i = i + 1
    end
    AI_SDK.setSelected(X, Y)
    ID = CGameMap.GetBelong(X, Y)
    -- 如果此点非法或是军队数量小于二，选择 王
    if X == -1 or Y == -1 or ID ~= id or CGameMap.GetUnitNum(X, Y) < 2 then
        AI_SDK.setSelected(CGameMap.GetKingPos(id))
    end

    -- 随机在六格方向上移动
    while true do
        local X1, Y1, NodeType
        i = math.random(6)
        X1, Y1 =
            AI_SDK.DirectionToDestination(
            AI_SDK.SelectPos.x,
            AI_SDK.SelectPos.y,
            i
        )

        NodeType = CGameMap.GetNodeType(X1, Y1)
        if NodeType == "NODE_TYPE_KING" then
            break
        end
        if
            NodeType == "NODE_TYPE_FORT" and
                CGameMap.GetUnitNum(AI_SDK.SelectPos.x, AI_SDK.SelectPos.y) >
                    CGameMap.GetUnitNum(X1, Y1)
         then
            break
        end
        if NodeType == "NODE_TYPE_BLANK" then
            break
        end
        if NodeType ~= "NODE_TYPE_HILL" then
            break
        end
    end

    AI_SDK.MoveByDirection(
        AI_SDK.SelectPos.x,
        AI_SDK.SelectPos.y,
        move_ratio,
        i
    )
    return
end
--若想运行此示例，可将以上内容复制到Core.lua

return Core
