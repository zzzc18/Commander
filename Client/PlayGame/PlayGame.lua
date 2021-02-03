PlayGame = {}

local Operation = require("PlayGame.Operation")

PlayGame.GameState = "READY"
PlayGame.judgementState = "Running"
PlayGame.armyID = nil

function PlayGame.Init()
    Picture.Init()
    ClientSock.Init()
end

function PlayGame.LoadMap()
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    CGameMap.LoadMap()
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
end

function PlayGame.keypressed(key, scancode, isrepeat)
    Operation.CatchKeyPressed(key)
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    if PlayGame.GameState == "READY" then
        return
    end
    BasicMap.DrawMap()
    Operation.DrawSelect()
    Picture.DrawJudgement(PlayGame.judgementState)
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    if PlayGame.GameState ~= "Start" then
        return
    end
    MapAdjust.Update()
end

return PlayGame
