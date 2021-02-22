local AI_SDK = {}

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

local timer = 0
local isGaming = false

function AI_SDK.Init()
    AI_SDK.gameState = "READY"
    AI_SDK.judgementState = "Running"
    ClientSock.Init()
    Buttons.Init()
    BGAnimation.load()
end

function AI_SDK.DeInit()
    Buttons.DeInit()
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

function AI_SDK.UpdateTimerSecond(dt)
end

function AI_SDK.update(dt)
    if AI_SDK.gameState == "READY" then
        BGAnimation.update(dt)
    end
    Client:update()
    if AI_SDK.gameState ~= "Start" and AI_SDK.gameState ~= "Menu" then
        return
    end
    MapAdjust.Update()
    Operation.Update()
end

function AI_SDK.update(dt)
    if AI_SDK.gameState == "READY" then
        BGAnimation.update(dt)
    end
    if not isGaming and AI_SDK.gameState == "Start" then
        isGaming = true
        AI_SDK.KingPos.x, AI_SDK.KingPos.y = CGameMap.GetKingPos(AI_SDK.armyID)
    end
    timer = ReplayGame.step
    Client:update()
    if AI_SDK.gameState ~= "Start" and AI_SDK.gameState ~= "Menu" then
        return
    end
    if timer < ReplayGame.step then
        Core.Main()
    end
    MapAdjust.Update()
    Buttons.Update()
end

return AI_SDK
