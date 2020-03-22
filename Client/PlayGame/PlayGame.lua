PlayGame = {}

local Operation = require("PlayGame.Operation")

PlayGame.GameState = "READY"
-- 现在这里仅供测试，应赋初值nil
PlayGame.armyID = 1

function PlayGame.Init(MapMode)
    CVerify.Register(1)
    Picture.Init()
    CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    -- CGameMap.LoadMap()
    BasicMap.Init()
end

function PlayGame.wheelmoved(x, y)
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    BasicMap.DrawMap()
    Operation.DrawSelect()
    Operation.DrawSelect()
end

function PlayGame.update(dt)
    MapAdjust.Update()
end

return PlayGame
