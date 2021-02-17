ReplayGame = {}

ReplayGame.GameState = "READY"
ReplayGame.armyID = nil
ReplayGame.armyNum = 0

function ReplayGame.RunPermission()
    return ReplayGame.GameState == "Start" or ReplayGame.GameState == "Menu"
end

function ReplayGame.Init()
    Picture.Init()
    ReplayGame.armyNum = CGameMap.LoadReplayFile()
    CVerify.Register(0, 2)
    ReplayGame.GameState = "Start"
    BasicMap.Init()
    Buttons.Init()
    Menu:Load()
end

function ReplayGame.DeInit()
    Buttons.DeInit()
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
    local name = Buttons.MouseState(pixelX, pixelY, 2)
    if "menu" == name then
        ReplayGame.GameState = "Menu"
    elseif "continue_Opt" == name then
        ReplayGame.GameState = "Start"
    elseif "exit_Opt" == name then
        Switcher.Switch("w")
    end
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
    if ReplayGame.GameState == "Menu" then
        Picture.DrawMenu()
    end
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
