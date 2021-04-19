local AI_SDK = {}

AI_SDK.TypeImplementation = "C++"
-- supported lang: "Lua", "C++"

local Core = require("AI.Core")
local Operation = require("PlayGame.Operation")
local CCore = require("lib.UserImplementation")

--READY:游戏未开始，不显示界面，无法操作
--Start:游戏进行中
--Over:游戏结束，显示界面，无法发送移动命令
--Menu:菜单界面
AI_SDK.gameState = "READY"
AI_SDK.judgementState = "Running"
AI_SDK.armyID = nil
AI_SDK.armyNum = 0
AI_SDK.KingPos = {x = -1, y = -1}
AI_SDK.SelectPos = {x = -1, y = -1}

local timer = 0

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
    local dict = {"default", "default", "C++"}
    local task = io.open("../ClientTask.txt", "r")
    if task ~= nil then
        PlayGame.task = true
        local i = 1
        for line in task:lines() do
            dict[i] = line
            i = i + 1
        end
        task:close()
    end
    AI_SDK.armyNum = CGameMap.LoadMap(dict[2], dict[3])
    AI_SDK.TypeImplementation = dict[4]
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

    if not AI_SDK.IsConnected(AI_SDK.SelectPos.x, AI_SDK.SelectPos.y, x, y) then
        return
    end

    local NewRequest = {
        armyID = AI_SDK.armyID,
        srcX = AI_SDK.SelectPos.x,
        srcY = AI_SDK.SelectPos.y,
        dstX = x,
        dstY = y,
        num = moveNum
    }
    ClientSock.SendMove(NewRequest)
    --  记录路径
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

-- 返回一个反向Table
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

-- 进行深拷贝，返回一个独立的Table
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
        if AI_SDK.TypeImplementation == "Lua" then
            Core.Main()
            print("Lua Implementation Invoke")
        else
            if AI_SDK.TypeImplementation == "C++" then
                CCore.userMain()
            end
        end
    end
    MapAdjust.Update()
    Buttons.Update()
end

function AI_SDK.setSelected(x, y)
    AI_SDK.SelectPos.x, AI_SDK.SelectPos.y = x, y
end

return AI_SDK
