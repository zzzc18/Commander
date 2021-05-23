PlayGame = {}

Judgement = require("PlayGame.Judgement")

--READY:游戏未开始，不显示界面
--Start:游戏进行中
--Over:游戏结束，显示界面，不发送地图更新
PlayGame.gameState = "READY"
PlayGame.step = 0
PlayGame.armyID = nil
PlayGame.armyNum = 0

function PlayGame.Init(MapMode)
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
    print(Command["[mapDict]"], Command["[mapName]"])
    PlayGame.armyNum = CGameMap.LoadMap(Command["[mapDict]"], Command["[mapName]"])
    CGameMap.InitSavedata(Command["[saveName]"], Command["[saveDict]"])
    BasicMap.Init()
    Judgement.Init()
    Coordinate.Init()
end

function PlayGame.wheelmoved(x, y)
    if PlayGame.gameState == "READY" then
        return
    end
    MapAdjust.Catchwheelmoved(x, y)
end

function PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    if PlayGame.gameState == "READY" then
        return
    end
end

function PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function PlayGame.keypressed(key, scancode, isrepeat)
    if key == "s" then
        CGameMap.WriteMap()
        Debug.Log("info", "Manually save map")
    end
end

function PlayGame.keyreleased(key, scancode)
end

function PlayGame.draw()
    if PlayGame.gameState == "READY" then
        return
    end
    BasicMap.DrawMap()
    BasicMap.DrawPath()
    Coordinate.draw()
end

function PlayGame.UpdateTimerSecond(dt)
end

function PlayGame.update(dt)
    MapAdjust.Update()
    if PlayGame.gameState == "Start" then
        Judgement.Judge()
        ServerSock.SendUpdate(dt)
        Coordinate.update(dt)
    end
    --服务端在到达步数限制后再运行5步，这是因为没有服务端客户端就无法更新步数导致不会退出。这额外的5步不会影响对战结果。
    if PlayGame.step > Command["[stepLimit]"] + 5 and Command["[autoMatch]"] == "true" then
        Judgement.SaveSumWhenTie()
        Debug.Log("info", "game quit because out of stepLimit")
        love.event.quit(0)
    end
end

return PlayGame
