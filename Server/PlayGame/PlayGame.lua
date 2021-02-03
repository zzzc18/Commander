PlayGame = {}

require("PlayGame.Judgement")

PlayGame.GameState = "READY"
--READY:游戏未开始，不显示界面
--Start:游戏进行中
--Over:游戏介绍，显示界面，不发送地图更新
PlayGame.armyID = nil
PlayGame.armyNum = 0

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
    if PlayGame.GameState == "READY" then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    if PlayGame.GameState == "READY" then
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
    if PlayGame.GameState == "READY" then
        return
    end
    BasicMap.DrawMap()
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    MapAdjust.Update()
    Judgement.Judge()
    if PlayGame.GameState == "Start" then
        ServerSock.SendUpdate(dt)
    end
end

return PlayGame
