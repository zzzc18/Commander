EditorSock = {}

-- local PlayGameCore = require("PlayGame.Core")

function EditorSock.Init()
    Editor = Sock.newClient("localhost", 22122) --不想再写个newEditor函数->_->
    Editor:setSerialization(Bitser.dumps, Bitser.loads)
    -- Editor:on(
    --     "SetArmyID",
    --     function(data)
    --         print("Received Data")
    --         PlayGame.armyID = data.armyID
    --         CVerify.Register(data.armyID)
    --         PlayGame.LoadMap()
    --     end
    -- )
    -- Editor:on(
    --     "PushMove",
    --     function(data)
    --         PlayGameCore.PushMove(data)
    --     end
    -- )
    -- Editor:on(
    --     "GameMapMoveUpdate",
    --     function()
    --         CGameMap.MoveUpdate()
    --     end
    -- )
    -- Editor:on(
    --     "GameMapUpdate",
    --     function()
    --         CGameMap.Update()
    --     end
    -- )
    -- Editor:on(
    --     "GameMapBigUpdate",
    --     function()
    --         CGameMap.BigUpdate()
    --     end
    -- )
    -- Editor:on(
    --     "GameStart",
    --     function()
    --         PlayGame.GameState = "Start"
    --     end
    -- )
    -- Editor:on(
    --     "GameOver",
    --     function()
    --         -- PlayGame.GameState = "Over"
    --     end
    -- )
    -- Editor:on(
    --     "Lose",
    --     function(data)
    --         -- 说明所在部队的王死了
    --         if PlayGame.armyID == data.armyID then
    --             PlayGame.judgementState = "Lose"
    --         end
    --     end
    -- )
    -- Editor:on(
    --     "Win",
    --     function(data)
    --         -- 说明所在部队获胜了
    --         if PlayGame.armyID == data.armyID then
    --             PlayGame.judgementState = "Win"
    --         end
    --     end
    -- )

    Editor:connect()
end

-- IncreaseOrDecrease:1 is increase,2 is decrease
function EditorSock.Increase(data)
    -- Editor:send(data)
    CGameMap.IncreaseOrDecrease(data.aimX, data.aimY, 1)
end

function EditorSock.Decrease(data)
    CGameMap.IncreaseOrDecrease(data.aimX, data.aimY, 2)
end

return EditorSock
