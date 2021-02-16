PlayGame = {}

local Operation = require("PlayGame.Operation")

--READY:游戏未开始，不显示界面，无法操作
--Start:游戏进行中
--Over:游戏介绍，显示界面，无法发送移动命令
--Menu:菜单界面
PlayGame.GameState = "READY"
PlayGame.judgementState = "Running"
PlayGame.armyID = nil
PlayGame.armyNum = 0

function PlayGame.Init()
    Picture.Init()
    Menu:Load()
    ClientSock.Init()
    Buttons.Init()
end

function PlayGame.DeInit()
    PlayGame.GameState = "READY"
    Buttons.DeInit()
    Client:disconnect()
end

function PlayGame.Destroy()
    --PlayGame={}
end

function PlayGame.LoadMap()
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    PlayGame.armyNum = CGameMap.LoadMap()
    BasicMap.Init()
end

function PlayGame.wheelmoved(x, y)
    if PlayGame.GameState == "READY" then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    if PlayGame.GameState == "READY" then
        return
    end
    Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
    if PlayGame.GameState == "READY" then
        return
    end
    Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
    if PlayGame.GameState == "READY" then
        return
    end
    Operation.CatchKeyPressed(key)
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    if PlayGame.GameState == "READY" then
        Picture.DrawReady()
        return
    end
    BasicMap.DrawMap()
    Operation.DrawSelect()
    if PlayGame.GameState == "Menu" then
        Operation.DrawMenu()
    end
    Operation.DrawButtons()
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    Client:update()
    if PlayGame.GameState ~= "Start" and PlayGame.GameState ~= "Menu" then
        return
    end
    MapAdjust.Update()
    Operation.Update()
end

return PlayGame
