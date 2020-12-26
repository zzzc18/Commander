PlayGame = {}

require("PlayGame.Judgement")

PlayGame.GameState = "READY"
PlayGame.armyID = nil
PlayGame.armyNum = 0

function PlayGame.RunPermission()
    return PlayGame.GameState == "Start"
end

function PlayGame.Init(MapMode)
    Picture.Init()
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    PlayGame.armyNum = CGameMap.LoadMap()
    CGameMap.InitSavedata()
    BasicMap.Init()
    Judgement.Init()
end

function PlayGame.wheelmoved(x, y)
    if not PlayGame.RunPermission() then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    if not PlayGame.RunPermission() then
        return
    end
end

function PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
    if key == "s" then
        CGameMap.WriteMap()
        print("Manually save map")
    end
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    if not PlayGame.RunPermission() then
        return
    end
    BasicMap.DrawMap()
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    if not PlayGame.RunPermission() then
        return
    end
    MapAdjust.Update()
    Judgement.Judge()
end

return PlayGame
