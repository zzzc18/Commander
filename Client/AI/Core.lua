local Core = {}

Core.SelectPos = {x = -1, y = -1}
Core.rdmDirection = 0

local BackCommands = {}
-- Backing:正在撤退
-- Done:撤退完毕
local backState = "Done"
local backIndex = 1
local backCommandsIndex = 1
local AttackCommands = {}
-- Ready:可以进攻
-- Attacking:正在进攻
-- Done:进攻完毕
local attackState = "Done"
local attackIndex = 1

function Core.Main(data)
    if ReplayGame.step % 45 == 0 and backState ~= "Backing" and attackState == "Done" then
        Core.BackInit()
        Core.BackToKing()
    elseif backState == "Backing" then
        Core.BackToKing()
    elseif attackState == "Ready" then
        print("--Attacking--")
        attackState = "Attacking"
        attackIndex = 1
        Core.SelectPos.x, Core.SelectPos.y = AI_SDK.KingPos.x, AI_SDK.KingPos.y
        Core.Attack_mode1()
    elseif attackState == "Attacking" then
        Core.Attack_mode1()
    elseif backState == "Done" and attackState == "Done" then
        Core.AIMove_mode1(data)
    end
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
        AI_SDK.clearCommands()
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
        if "NODE_TYPE_BLANK" == CGameMap.GetNodeType(x, y) or "NODE_TYPE_KING" == CGameMap.GetNodeType(x, y) then
            -- 尽可能地去攻占BLANK和进攻KING
            if AI_SDK.armyID ~= CGameMap.GetBelong(x, y) then
                AI_SDK.MoveTo(x, y, moveNum, Core.rdmDirection)
                Core.SelectPos.x, Core.SelectPos.y = x, y
                break
            else
                chance = chance - 1
                if chance < 3 then
                    -- 向己方地区移动
                    AI_SDK.MoveTo(x, y, moveNum, Core.rdmDirection)
                    Core.SelectPos.x, Core.SelectPos.y = x, y
                    break
                end
            end
        elseif "NODE_TYPE_FORT" == CGameMap.GetNodeType(x, y) then
            local fortNum = CGameMap.GetUnitNum(x, y)
            if AI_SDK.armyID ~= CGameMap.GetBelong(x, y) and fortNum - 10 < unitNum then
                -- 在兵力足够时选择进攻FORT
                AI_SDK.MoveTo(x, y, moveNum, Core.rdmDirection)
                Core.SelectPos.x, Core.SelectPos.y = x, y
                break
            else
                if AI_SDK.armyID == CGameMap.GetBelong(x, y) then
                    chance = chance - 1
                    if "NODE_TYPE_FORT" ~= CGameMap.GetNodeType(Core.SelectPos.x, Core.SelectPos.y) or chance < 2 then
                        -- 向己方FORT移动,但是如果两个FORT相邻则降低优先级
                        AI_SDK.MoveTo(x, y, moveNum, Core.rdmDirection)
                        Core.SelectPos.x, Core.SelectPos.y = x, y
                        break
                    end
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
        AI_SDK.clearCommands()
    end
end

-- 为Core.BackToKing()初始化
function Core.BackInit()
    backIndex = 1
    backState = "Backing"
    -- 导入Unit中记录的路径
    for i, unit in pairs(AI_SDK.Unit) do
        if AI_SDK.armyID ~= CGameMap.GetBelong(unit.pos.x, unit.pos.y) then
            if unit.type == "KING" then
                print("Find a king, ready to attack!")
                if attackState ~= "Attacking" then
                    attackState = "Ready"
                    table.insert(
                        AttackCommands,
                        1,
                        {
                            pos = {x = unit.pos.x, y = unit.pos.y},
                            commands = AI_SDK.reverseTable(unit.commands),
                            type = unit.type
                        }
                    )
                end
            else
                -- 移除无效路径
                table.remove(AI_SDK.Unit, i)
            end
        else
            if #unit.commands > 12 then
                -- 路径太长，耽误时间
            else
                BackCommands[backIndex] = {
                    pos = {x = unit.pos.x, y = unit.pos.y},
                    commands = AI_SDK.deepCopy(unit.commands),
                    type = unit.type
                }
                backIndex = backIndex + 1
            end
            if backIndex > 30 then
                -- 当前撤退算法效率低，故限制最多进行30次撤退，防止AI进行过多低效撤退
                break
            end
        end
    end
    backIndex = 1
    backCommandsIndex = 1
    Core.SelectPos.x, Core.SelectPos.y = BackCommands[backIndex].pos.x, BackCommands[backIndex].pos.y
end

-- 让所有兵力撤回到王的位置
function Core.BackToKing()
    local x, y, mode, dir
    if
        CGameMap.GetUnitNum(Core.SelectPos.x, Core.SelectPos.y) <= 1 or
            (Core.SelectPos.x == AI_SDK.KingPos.x and Core.SelectPos.y == AI_SDK.KingPos.y)
     then
        -- 选择点兵力不足或者选择到了王，则开始下一轮撤退
        backIndex = backIndex + 1
        if backIndex > #BackCommands then
            -- 撤退完毕
            backState = "Done"
            print("All back completed! (1)")
            BackCommands = {}
        else
            Core.SelectPos.x, Core.SelectPos.y = BackCommands[backIndex].pos.x, BackCommands[backIndex].pos.y
            Core.BackToKing()
        end
        return
    else
        x, y = Core.SelectPos.x, Core.SelectPos.y
        if BackCommands[backIndex].commands[backCommandsIndex] == nil then
            -- 报错
            print("-------------------")
            print("An error occured: a invalid order!")
            print(
                "Information: backCommandsIndex= " ..
                    backCommandsIndex ..
                        " and #BackCommands[backIndex].commands = " .. #BackCommands[backIndex].commands
            )
            if BackCommands[backIndex].pos ~= nil then
                print(
                    "pos.x = " ..
                        BackCommands[backIndex].pos.x ..
                            " ,and pos.y = " ..
                                BackCommands[backIndex].pos.y .. " .The node type = " .. CGameMap.GetNodeType(x, y)
                )
            end
            if BackCommands[backIndex] == nil then
                print(
                    "Exactly, backIndex = " ..
                        backIndex .. " ,but this is a nil value in the table! The #BackCommands = " .. #BackCommands
                )
            else
                print("backIndex = " .. backIndex .. " , and #BackCommands = " .. #BackCommands)
            end
            print("-------------------")
        else
            if BackCommands[backIndex].commands[backCommandsIndex] <= 3 then
                dir = BackCommands[backIndex].commands[backCommandsIndex] + 3
            else
                dir = BackCommands[backIndex].commands[backCommandsIndex] - 3
            end
            mode = x % 2 + 1
            x = x + BasicMap.direction[mode][dir][1]
            y = y + BasicMap.direction[mode][dir][2]
            AI_SDK.MoveTo(x, y, 0)
            Core.SelectPos.x, Core.SelectPos.y = x, y
        end
        backCommandsIndex = backCommandsIndex + 1
        if backCommandsIndex > #BackCommands[backIndex].commands then
            backIndex = backIndex + 1
            backCommandsIndex = 1
            if backIndex > #BackCommands then
                -- 撤退完毕
                backIndex = 1
                backState = "Done"
                print("All back completed! (2)")
                BackCommands = {}
                return
            end
            Core.SelectPos.x, Core.SelectPos.y = BackCommands[backIndex].pos.x, BackCommands[backIndex].pos.y
        end
    end
end

-- 让AI从王的位置向另一个王进攻
function Core.Attack_mode1()
    if AttackCommands == nil or AttackCommands[1] == nil then
        print("Error: invalid attack command!")
        attackState = "Done"
        AttackCommands = {}
        return
    end
    local x, y, mode, dir
    dir = AttackCommands[1].commands[attackIndex]
    if dir == nil then
        print("Error: an invalid attackIndex!")
        attackState = "Done"
        AttackCommands = {}
        return
    end
    x, y = Core.SelectPos.x, Core.SelectPos.y
    mode = x % 2 + 1
    x = x + BasicMap.direction[mode][dir][1]
    y = y + BasicMap.direction[mode][dir][2]
    AI_SDK.MoveTo(x, y, 0)
    Core.SelectPos.x, Core.SelectPos.y = x, y
    attackIndex = attackIndex + 1
    if attackIndex > #AttackCommands[1].commands then
        print("Finished an attack!")
        attackState = "Done"
        AttackCommands = {}
        return
    end
end

return Core
