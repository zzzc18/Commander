PlayGame = {}

local Operation = require("PlayGame.Operation")

-- PlayGame.GameState = "READY"
PlayGame.judgementState = "Running"
PlayGame.armyID = nil
PlayGame.timerTotal = 0
PlayGame.timerSecond = 0
PlayGame.timer25Second = 0

function PlayGame.Init()
    CVerify.Register(0, 3)
    PlayGame.LoadMap()
    Picture.Init()
    Buttons.Init()
end

function PlayGame.LoadMap()
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    PlayGame.armyID = CGameMap.LoadMap()
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
    Operation.Update(love.mouse.getX(), love.mouse.getY())
end

function PlayGame.draw()
    BasicMap.DrawMap()
    Operation.DrawSelect()
    Operation.DrawButtons()
end

return PlayGame
