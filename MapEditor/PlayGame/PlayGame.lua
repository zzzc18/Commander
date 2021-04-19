local PlayGame = {}

local Operation = require("PlayGame.Operation")

PlayGame.armyNum = 0

function PlayGame.Init()
    CVerify.Register(0, 3)
    PlayGame.LoadMap()
end

function PlayGame.LoadMap()
    PlayGame.armyNum = CGameMap.LoadMap("default", "default")
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
end

function PlayGame.draw()
    BasicMap.DrawMap()
    Operation.DrawSelect()
end

return PlayGame
