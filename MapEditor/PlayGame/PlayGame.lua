local PlayGame = {}

local Operation = require("PlayGame.Operation")

PlayGame.armyNum = 0
PlayGame.droppedFilePath = nil
PlayGame.droppedFile = nil

function PlayGame.Init()
    CVerification.Register(0, 3)
    PlayGame.LoadMap()
    Coordinate.Init()
end

function PlayGame.LoadMap()
    if PlayGame.droppedFile == nil then
        PlayGame.armyNum = CGameMap.LoadMap("Output", "1v1.map")
    else
        PlayGame.armyNum = CGameMap.LoadMap(PlayGame.droppedFilePath, PlayGame.droppedFile)
    end
    BasicMap.Init()
end

function PlayGame.wheelmoved(x, y)
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
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

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    MapAdjust.Update()
    Operation.Update()
    Coordinate.update(dt)
end

function PlayGame.draw()
    BasicMap.DrawMap()
    Operation.DrawSelect()
    Coordinate.draw()
end

return PlayGame
