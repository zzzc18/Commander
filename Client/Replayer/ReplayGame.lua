local ReplayGame = {}

ReplayGame.droppedDir = ""
ReplayGame.step = 0
ReplayGame.gameState = "READY"
ReplayGame.armyNum = 0
ReplayGame.replaySpeed = 1

function ReplayGame.RunPermission()
    return ReplayGame.gameState == "Start" or ReplayGame.gameState == "Menu"
end

function ReplayGame.Init(MapMode)
    if ReplayGame.droppedDir == "" then
        Debug.Log("warning", "no folder to replay")
        ReplayGame.gameState = "READY"
        BGAnimation.load()
        return
    else
        ReplayGame.armyNum = CGameMap.LoadReplayFile(ReplayGame.droppedDir)
        CVerify.Register(0, 2)
        ReplayGame.gameState = "Start"
        BasicMap.Init()
        Buttons.Init()
    end
end

function ReplayGame.DeInit()
    Buttons.DeInit()
    ReplayGame.droppedDir = ""
    ReplayGame.gameState = "READY"
    ReplayGame.replaySpeed = 1
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
    if not ReplayGame.RunPermission() then
        return
    end
    local name = Buttons.MouseState(pixelX, pixelY, 2)
    if "menu" == name then
        ReplayGame.gameState = "Menu"
    elseif "continue_Opt" == name then
        ReplayGame.gameState = "Start"
    elseif "exit_Opt" == name then
        Switcher.To(Welcome)
    elseif "shiftSpeed" == name then
        ReplayGame.replaySpeed = ReplayGame.replaySpeed * 2
        if ReplayGame.replaySpeed > 4 then
            ReplayGame.replaySpeed = 0.25
        end
    end
end

function ReplayGame.keypressed(key, scancode, isrepeat)
end

function ReplayGame.keyreleased(key, scancode)
end

function ReplayGame.draw()
    if not ReplayGame.RunPermission() then
        Picture.DrawReady(BGAnimation)
        return
    end
    Picture.PrintStepAndSpeed(ReplayGame.step, ReplayGame.replaySpeed)
    BasicMap.DrawMap()
    BasicMap.DrawPath()
    if ReplayGame.gameState == "Menu" then
        Picture.DrawMenu()
    end
    Buttons.DrawButtons()
end

function ReplayGame.UpdateTimerSecond(dt)
end

function ReplayGame.update(dt)
    if not ReplayGame.RunPermission() then
        if ReplayGame.droppedDir == "" then
            BGAnimation.update(dt)
            return
        else
            ReplayGame.Init()
            BGAnimation.deLoad()
        end
    end
    MapAdjust.Update()
    Buttons.Update()
    for i = 1, ReplayGame.armyNum do
        if CGameMap.GetReplayStatus() == true then
            Buttons.isPause = true
            return
        --游戏结束，停止地图更新
        end
    end
    if not Buttons.isPause then
        ReplayGame.step = CSystem.Update(ReplayGame.replaySpeed * dt)
    end
end

return ReplayGame
