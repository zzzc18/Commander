local PlayGame = {}

local Operation = require("PlayGame.Operation")

--READY:游戏未开始，不显示界面，无法操作
--Start:游戏进行中
--Over:游戏结束，显示界面，无法发送移动命令
--Menu:菜单界面
PlayGame.gameState = "READY"
PlayGame.judgementState = "Running"
PlayGame.armyID = nil
PlayGame.armyNum = 0

function PlayGame.Init()
    PlayGame.gameState = "READY"
    PlayGame.judgementState = "Running"
    ClientSock.Init()
    Buttons.Init()
    BGAnimation.load()
    Coordinate.Init()
end

function PlayGame.DeInit()
    Buttons.DeInit()
    Client:disconnect()
    Coordinate.DeInit()
end

function PlayGame.Destroy()
    --PlayGame={}
end

function PlayGame.LoadMap()
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    local command = {"false", "1e10", "default", "default", "C++"}
    local task = io.open("../ClientTask.txt", "r")
    if task ~= nil then
        local i = 1
        for line in task:lines() do
            command[i] = line
            i = i + 1
        end
        task:close()
    end
    PlayGame.armyNum = CGameMap.LoadMap(command[3], command[4])
    BasicMap.Init()
end

function PlayGame.wheelmoved(x, y)
    if PlayGame.gameState == "READY" then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    if PlayGame.gameState == "READY" then
        return
    end
    Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
    if PlayGame.gameState == "READY" then
        return
    end
    Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
    if PlayGame.gameState == "READY" then
        return
    end
    Operation.CatchKeyPressed(key)
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    if PlayGame.gameState == "READY" then
        Picture.DrawReady(BGAnimation)
        return
    end
    Picture.PrintStepAndSpeed(ReplayGame.step)
    BasicMap.DrawMap()
    BasicMap.DrawPath()
    Operation.DrawSelect()
    if PlayGame.gameState == "Menu" then
        Operation.DrawMenu()
    end
    Operation.DrawButtons()
    Coordinate.draw()
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    if PlayGame.gameState == "READY" then
        BGAnimation.update(dt)
    end
    ClientSock.Update()
    if PlayGame.gameState ~= "Start" and PlayGame.gameState ~= "Menu" then
        return
    end
    MapAdjust.Update()
    Operation.Update()
    Coordinate.update(dt)
end

return PlayGame
