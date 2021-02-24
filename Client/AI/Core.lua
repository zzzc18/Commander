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
    local moveNum = 0 -- 为0时移动全部，为0到1之间实数时按比例移动，大于1时移动moveNum整数部分
    if AI_SDK.armyID ~= CGameMap.GetBelong(x, y) or unitNum <= 1 then -- 不移动，并让下次移动从王开始
        Core.SelectPos.x = AI_SDK.KingPos.x
        Core.SelectPos.y = AI_SDK.KingPos.y
        return
    elseif unitNum >= 50 and "NODE_TYPE_KING" == CGameMap.GetNodeType(x, y) then
        moveNum = 0.5 -- 只移动一半
    end
    local chance = 10 -- 随机选择的机会
    local mode
    while chance > 0 do
        x, y = Core.SelectPos.x, Core.SelectPos.y
        Core.rdmDirection = math.random(6)
        mode = x % 2 + 1
        x = x + BasicMap.direction[mode][Core.rdmDirection][1]
        y = y + BasicMap.direction[mode][Core.rdmDirection][2]
        if
            "NODE_TYPE_BLANK" == CGameMap.GetNodeType(x, y) or
                "NODE_TYPE_KING" == CGameMap.GetNodeType(x, y)
         then
            -- 尽可能地去攻占BLANK和进攻KING
            if AI_SDK.armyID ~= CGameMap.GetBelong(x, y) then
                AI_SDK.MoveTo(x, y, moveNum)
                Core.SelectPos.x, Core.SelectPos.y = x, y
                break
            else
                chance = chance - 1
                if chance < 3 then
                    -- 向己方地区移动
                    AI_SDK.MoveTo(x, y, moveNum)
                    Core.SelectPos.x, Core.SelectPos.y = x, y
                    break
                end
            end
        elseif "NODE_TYPE_FORT" == CGameMap.GetNodeType(x, y) then
            local fortNum = CGameMap.GetUnitNum(x, y)
            if
                AI_SDK.armyID ~= CGameMap.GetBelong(x, y) and
                    fortNum - 10 < unitNum
             then
                -- 在兵力足够时选择进攻FORT
                AI_SDK.MoveTo(x, y, moveNum)
                Core.SelectPos.x, Core.SelectPos.y = x, y
                break
            else
                if AI_SDK.armyID == CGameMap.GetBelong(x, y) then
                    -- 向己方FORT移动
                    AI_SDK.MoveTo(x, y, moveNum)
                    Core.SelectPos.x, Core.SelectPos.y = x, y
                    break
                else
                    chance = chance - 1
                end
            end
        else
            chance = chance - 1
        end
    end
    if chance <= 0 then
        -- 重新从王的位置开始
        Core.SelectPos.x = AI_SDK.KingPos.x
        Core.SelectPos.y = AI_SDK.KingPos.y
    end
end

return Core
