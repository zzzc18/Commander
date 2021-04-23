PlayGame = {}

local Judgement = require("PlayGame.Judgement")

--READY:游戏未开始，不显示界面
--Start:游戏进行中
--Over:游戏结束，显示界面，不发送地图更新
PlayGame.gameState = "READY"
PlayGame.armyID = nil
PlayGame.armyNum = 0

function PlayGame.Init(MapMode)
    -- CGameMap.RandomGenMap()
    -- CGameMap.WriteMap()
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
    if Command["[autoMatch]"] == "true" and PlayGame.gameState == "Over" then
        love.event.quit(0)
    end
end

return PlayGame
