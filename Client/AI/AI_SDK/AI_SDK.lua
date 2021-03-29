local AI_SDK = {}


AI_SDK.TypeImplementation = "Lua"
-- supported lang: "Lua", "C++"


local Core = require("AI.Core")
local Operation = require("PlayGame.Operation")

--READY:游戏未开始，不显示界面，无法操作
--Start:游戏进行中
--Over:游戏介绍，显示界面，无法发送移动命令
--Menu:菜单界面
AI_SDK.gameState = "READY"
AI_SDK.judgementState = "Running"
AI_SDK.armyID = nil
AI_SDK.armyNum = 0
AI_SDK.KingPos = {x = -1, y = -1}
-- 记录每个从王到每个点的路径，每个元素包含两个table和一个字符串
-- pos记录坐标，commands记录路径，type记录类型
AI_SDK.Unit = {}

local timer = 0
local TempCommand = {}
local TempCommandLength = 0

function AI_SDK.Init()
    AI_SDK.gameState = "READY"
    AI_SDK.judgementState = "Running"
    ClientSock.Init()
    Buttons.Init()
    BGAnimation.load()
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 9)))
end

function AI_SDK.DeInit()
    Buttons.DeInit()
    AI_SDK.KingPos = {x = -1, y = -1}
    Client:disconnect()
end

function AI_SDK.LoadMap()
    AI_SDK.armyNum = CGameMap.LoadMap()
    BasicMap.Init()
end

function AI_SDK.wheelmoved(x, y)
    if AI_SDK.gameState == "READY" then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function AI_SDK.mousepressed(pixelX, pixelY, button, istouch, presses)
    if AI_SDK.gameState == "READY" then
        return
    end
    Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
end

function AI_SDK.mousereleased(pixelX, pixelY, button, istouch, presses)
    if AI_SDK.gameState == "READY" then
        return
    end
    Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
end

function AI_SDK.keypressed(key, scancode, isrepeat)
    if AI_SDK.gameState == "READY" then
        return
    end
    if key == "escape" then
        Switcher.To(Welcome)
    end
end

function AI_SDK.keyreleased(key, scancode)
end

function AI_SDK.draw()
    if AI_SDK.gameState == "READY" then
        Picture.DrawReady(BGAnimation)
        return
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Step:" .. ReplayGame.step, 0, 0, 0, 2)
    BasicMap.DrawMap()
    BasicMap.DrawPath()
    Operation.DrawSelect()
    if AI_SDK.gameState == "Menu" then
        Operation.DrawMenu()
    end
    Operation.DrawButtons()
end

-- 移动的函数
function AI_SDK.MoveTo(x, y, moveNum, dir)
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

    if not AI_SDK.IsConnected(Core.SelectPos.x, Core.SelectPos.y, x, y) then
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
    --  记录路径
    if "NODE_TYPE_KING" == CGameMap.GetNodeType(x, y) then
        AI_SDK.addCommands({key = "isKing", dir = dir, x = x, y = y, type = "KING"})
    elseif "NODE_TYPE_BLANK" == CGameMap.GetNodeType(x, y) then
        AI_SDK.addCommands({key = "Done", dir = dir, x = x, y = y, type = "BLANK"})
    elseif "NODE_TYPE_FORT" == CGameMap.GetNodeType(x, y) then
        AI_SDK.addCommands({key = "Done", dir = dir, x = x, y = y, type = "FORT"})
    end
end

--检查pos之间是否相邻
-- 参数分别为点1和点2的坐标
function AI_SDK.IsConnected(posX1, posY1, posX2, posY2)
    if posX1 == posX2 then
        if posY1 - posY2 == 1 or posY2 - posY1 == 1 then
            return true
        end
    end

    if posX1 % 2 == 1 then
        if (posX1 == posX2 + 1 or posX1 == posX2 - 1) and (posY1 == posY2 or posY1 == posY2 - 1) then
            return true
        end
    else
        if (posX1 == posX2 + 1 or posX1 == posX2 - 1) and (posY1 == posY2 or posY1 == posY2 + 1) then
            return true
        end
    end
    return false
end

function AI_SDK.UpdateTimerSecond(dt)
end

-- 向Unit中添加路径
function AI_SDK.addCommands(data)
    if data.key == nil then
        AI_SDK.clearCommands()
    elseif data.key == "Done" then
        local isRepeated = false
        TempCommandLength = TempCommandLength + 1
        TempCommand[TempCommandLength] = data.dir
        for i, unit in pairs(AI_SDK.Unit) do
            if AI_SDK.armyID ~= CGameMap.GetBelong(unit.pos.x, unit.pos.y) and unit.type ~= "KING" then
                -- 移除无效路径
                table.remove(AI_SDK.Unit, i)
            elseif unit.pos.x == data.x and unit.pos.y == data.y then
                if #unit.commands > TempCommandLength then
                    -- 当前记录的路径更短,覆盖原有路径
                    unit.commands = AI_SDK.reverseTable(TempCommand)
                else
                    if #unit.commands < TempCommandLength then
                        -- 原有路径更短，覆盖暂存路径
                        TempCommand = AI_SDK.deepCopy(unit.commands)
                        TempCommandLength = #unit.commands
                    end
                end
                isRepeated = true
                break
            end
        end
        if not isRepeated then
            table.insert(
                AI_SDK.Unit,
                1,
                {pos = {x = data.x, y = data.y}, commands = AI_SDK.reverseTable(TempCommand), type = data.type}
            )
        end
    elseif data.key == "isKing" then
        if AI_SDK.armyID == CGameMap.GetBelong(data.x, data.y) then
            AI_SDK.clearCommands()
        else
            -- 记录下敌方王的位置，保留正向序列，用于进攻时调用
            print("Find a king!")
            local isRepeated = false
            TempCommandLength = TempCommandLength + 1
            TempCommand[TempCommandLength] = data.dir
            for i, unit in pairs(AI_SDK.Unit) do
                if AI_SDK.armyID == CGameMap.GetBelong(unit.pos.x, unit.pos.y) and unit.type == "KING" then
                    -- 移除无效路径
                    table.remove(AI_SDK.Unit, i)
                elseif unit.pos.x == data.x and unit.pos.y == data.y then
                    if #unit.commands > TempCommandLength then
                        -- 当前记录的路径更短,覆盖原有路径
                        unit.commands = AI_SDK.reverseTable(TempCommand)
                    else
                        if #unit.commands < TempCommandLength then
                            -- 原有路径更短，覆盖暂存路径
                            TempCommand = AI_SDK.deepCopy(unit.commands)
                            TempCommandLength = #unit.commands
                        end
                    end
                    isRepeated = true
                    break
                end
            end
            if not isRepeated then
                table.insert(
                    AI_SDK.Unit,
                    1,
                    {pos = {x = data.x, y = data.y}, commands = AI_SDK.reverseTable(TempCommand), type = data.type}
                )
            end
        end
    end
end

-- 清空暂存路径
function AI_SDK.clearCommands()
    TempCommand = {}
    TempCommandLength = 0
end

function AI_SDK.reverseTable(table)
    if nil == table then
        return nil
    end
    local reverseTable = {}
    for j = 1, #table do
        reverseTable[j] = table[#table - j + 1]
    end
    return reverseTable
end

-- 进行深拷贝
function AI_SDK.deepCopy(table)
    if nil == table then
        return nil
    end
    local res = {}
    for i, v in ipairs(table) do
        res[i] = v
    end
    return res
end

function AI_SDK.update(dt)
    if AI_SDK.gameState == "READY" then
        BGAnimation.update(dt)
    end
    timer = ReplayGame.step
    Client:update()
    if AI_SDK.gameState ~= "Start" and AI_SDK.gameState ~= "Menu" then
        return
    end
    if timer < ReplayGame.step then
        if AI_SDK.typeImplementation == "Lua" then
            Core.Main()
        else

        end
    end
    MapAdjust.Update()
    Buttons.Update()
end

return AI_SDK
