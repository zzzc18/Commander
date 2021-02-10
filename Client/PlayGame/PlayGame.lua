PlayGame = {}

local Operation = require("PlayGame.Operation")

PlayGame.GameState = "READY"
--READY:游戏未开始，不显示界面，无法操作
--Start:游戏进行中
--Over:游戏介绍，显示界面，无法发送移动命令
PlayGame.judgementState = "Running"
PlayGame.armyID = nil
PlayGame.armyNum = 0

function PlayGame.Init()
    Picture.Init()
    ClientSock.Init()
    Buttons.Init()
    GameOver.GameOverOptInit()
end

function PlayGame.DeInit()
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
    Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
    Operation.CatchKeyPressed(key)
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    if PlayGame.GameState == "READY" then
        BasicMap.DrawReady()
        return
    end
    BasicMap.DrawMap()
    Operation.DrawSelect()
    Operation.DrawButtons()
    if PlayGame.judgementState == "Lose" then
        GameOver.DrawJudgeInfo("Lose", GameOver.VanquisherID)
    elseif PlayGame.judgementState == "Win" then
        GameOver.DrawJudgeInfo("Win", nil)
    end
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    Client:update()
    if PlayGame.judgementState == "Lose" or PlayGame.judgementState == "Win" then
        GameOver.Update(love.mouse.getX(), love.mouse.getY())
    end
    if PlayGame.GameState ~= "Start" then
        return
    end
    MapAdjust.Update()
    Operation.Update()
end

return PlayGame
