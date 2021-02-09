ReplayGame = {}

ReplayGame.GameState = "READY"
ReplayGame.armyID = nil
ReplayGame.armyNum = 0

function ReplayGame.RunPermission()
    return ReplayGame.GameState == "Start"
end

function ReplayGame.Init(MapMode)
    Picture.Init()
    ReplayGame.armyNum = CGameMap.LoadReplayFile()
    CVerify.Register(0, 2)
    ReplayGame.GameState = "Start"
    BasicMap.Init()
    Buttons.Init(ReplayGame)
end

function ReplayGame.DeInit()
end

function ReplayGame.Destroy()
    --ReplayGame={}
end

function ReplayGame.wheelmoved(x, y)
    if not ReplayGame.RunPermission() then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function ReplayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    if not ReplayGame.RunPermission() then
        return
    end
    Buttons.MouseState(pixelX, pixelY, 0)
end

function ReplayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
    Buttons.MouseState(pixelX, pixelY, 2)
end

function ReplayGame.keypressed(key, scancode, isrepeat)
end

function ReplayGame.keyreleased(key, scancode)
end

function ReplayGame.draw()
    if not ReplayGame.RunPermission() then
        return
    end
    BasicMap.DrawMap()
    Buttons.DrawButtons()
end

function ReplayGame.UpdateTimerSecond(dt)
end

function ReplayGame.update(dt)
    if not ReplayGame.RunPermission() then
        return
    end
    MapAdjust.Update()
    Buttons.Update()
    for i = 1, ReplayGame.armyNum do
        if CGameMap.GetReplayStatus() == true then
            return
        --游戏结束，停止地图更新
        end
    end
    CSystem.Update(dt)
end

return ReplayGame
