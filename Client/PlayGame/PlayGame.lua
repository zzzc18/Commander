PlayGame = {}

function PlayGame.Init(MapMode)
    Picture.Init()
    CGameMap.RandomGenMap()
    CGameMap.WriteMap()
    -- CGameMap.LoadMap()
    BasicMap.Init()
end

function PlayGame.wheelmoved(x, y)
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    BasicMap.DrawMap()
end

function PlayGame.update(dt)
    MapAdjust.Update()
end

return PlayGame
