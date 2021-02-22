local Core = {}

Core.SelectPos = {x = -1, y = -1}
Core.rdmDirection = 0

function Core.Main(data)
    Core.AIMove_mode1(data)
    return
end

-- 从王的位置随机移动，当军队数量下降到1时重新从王的位置开始移动
function Core.AIMove_mode1(data)
    if Core.SelectPos.x == -1 and AI_SDK.KingPos.x ~= -1 then
        Core.SelectPos.x = AI_SDK.KingPos.x
        Core.SelectPos.y = AI_SDK.KingPos.y
    end
    local x, y = Core.SelectPos.x, Core.SelectPos.y
    local unitNum = CGameMap.GetUnitNum(x, y)
    local moveNum = 0
    if AI_SDK.armyID ~= CGameMap.GetBelong(x, y) or unitNum <= 1 then -- 不移动，并让下次移动从王开始
        Core.SelectPos.x = AI_SDK.KingPos.x
        Core.SelectPos.y = AI_SDK.KingPos.y
        Core.MoveTo(-1, -1)
        return
    elseif unitNum >= 50 then
        moveNum = 0.5 -- 只移动一半
    end
    local chance = 9 -- 随机选择的机会
    local mode
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 9)))
    while true do
        x, y = Core.SelectPos.x, Core.SelectPos.y
        Core.rdmDirection = math.random(6)
        mode = x % 2 + 1
        x = x + BasicMap.direction[mode][Core.rdmDirection][1]
        y = y + BasicMap.direction[mode][Core.rdmDirection][2]
        if
            "NODE_TYPE_BLANK" == CGameMap.GetNodeType(x, y) or
                "NODE_TYPE_KING" == CGameMap.GetNodeType(x, y)
         then
            if AI_SDK.armyID ~= CGameMap.GetBelong(x, y) then
                Core.MoveTo(x, y, moveNum)
                Core.SelectPos.x, Core.SelectPos.y = x, y
                break
            else
                chance = chance - 1
                if chance < 3 then
                    Core.MoveTo(x, y, moveNum)
                    Core.SelectPos.x, Core.SelectPos.y = x, y
                    break
                end
            end
        elseif "NODE_TYPE_FORT" == CGameMap.GetNodeType(x, y) then
            local fortNum = CGameMap.GetUnitNum(x, y)
            if fortNum - 10 < unitNum then
                Core.MoveTo(x, y, moveNum)
                Core.SelectPos.x, Core.SelectPos.y = x, y
                break
            else
                chance = chance - 1
                if chance < 0 then
                    Core.SelectPos.x = AI_SDK.KingPos.x
                    Core.SelectPos.y = AI_SDK.KingPos.y
                    break
                end
            end
        else
            chance = chance - 1
            if chance <= 0 then
                Core.SelectPos.x = AI_SDK.KingPos.x
                Core.SelectPos.y = AI_SDK.KingPos.y
                break
            end
        end
    end
end

function Core.MoveTo(x, y, moveNum)
    if AI_SDK.gameState ~= "Start" then
        return
    --只有游戏进行时才能发送
    end
    if x == -1 and y == -1 then --撤销移动
        local NewRequest = {
            armyID = AI_SDK.armyID,
            srcX = -1,
            srcY = -1,
            dstX = -1,
            dstY = -1,
            num = 0
        }
        ClientSock.SendMove(NewRequest)
        return
    end

    if not Core.IsConnected(Core.SelectPos.x, Core.SelectPos.y, x, y) then
        return
    end

    local NewRequest = {
        armyID = AI_SDK.armyID,
        srcX = Core.SelectPos.x,
        srcY = Core.SelectPos.y,
        dstX = x,
        dstY = y,
        num = moveNum
    }
    ClientSock.SendMove(NewRequest)
end

--检查pos之间是否相邻
-- 参数分别为点1和点2的坐标
function Core.IsConnected(posX1, posY1, posX2, posY2)
    if posX1 == posX2 then
        if posY1 - posY2 == 1 or posY2 - posY1 == 1 then
            return true
        end
    end

    if posX1 % 2 == 1 then
        if
            (posX1 == posX2 + 1 or posX1 == posX2 - 1) and
                (posY1 == posY2 or posY1 == posY2 - 1)
         then
            return true
        end
    else
        if
            (posX1 == posX2 + 1 or posX1 == posX2 - 1) and
                (posY1 == posY2 or posY1 == posY2 + 1)
         then
            return true
        end
    end
    return false
end

return Core
