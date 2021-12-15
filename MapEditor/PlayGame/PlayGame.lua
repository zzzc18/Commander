local PlayGame = {}

local Operation = require("PlayGame.Operation")

PlayGame.armyNum = 0
PlayGame.droppedFile = nil

function PlayGame.Init()
    CVerification.Register(0, 3)
    PlayGame.LoadMap()
    Coordinate.Init()
end

function PlayGame.LoadMap()
    if PlayGame.droppedFile == nil then
        PlayGame.armyNum = CGameMap.LoadMap("default")
    else
        CGameMap.SaveEdit()
        Debug.Log("info", "Saved")
        PlayGame.armyNum = CGameMap.LoadMap(PlayGame.droppedFile)
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
    Operation.CatchKeyreleased(key)
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

function PlayGame.filedropped(file)
    fileName = file:getFilename()
    Debug.Log("info", "directory dropped " .. fileName)
    PlayGame.droppedFile = fileName
    -- for word in string.gmatch(fileName, "Commander\\.*%.map") do
    --     for path in string.gmatch(word, "\\.*\\") do
    --         PlayGame.droppedFilePath = path
    --         PlayGame.droppedFile = string.sub(word, 10 + string.len(path))
    --     end
    -- end
    PlayGame.LoadMap()
end

return PlayGame
