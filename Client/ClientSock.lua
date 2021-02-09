ClientSock = {}

local PlayGameCore = require("PlayGame.Core")

function ClientSock.Init()
    Client = Sock.newClient("localhost", 22122)
    Client:setSerialization(Bitser.dumps, Bitser.loads)
    Client:on(
        "SetArmyID",
        function(data)
            print("Received Data")
            PlayGame.armyID = data.armyID
            print("armyID:" .. data.armyID)
            CVerify.Register(data.armyID)
            PlayGame.LoadMap()
        end
    )
    Client:on(
        "PushMove",
        function(data)
            PlayGameCore.PushMove(data)
        end
    )
    Client:on(
        "Update",
        function(data)
            Step = CSystem.Update(data)
        end
    )
    Client:on(
        "GameStart",
        function()
            PlayGame.GameState = "Start"
        end
    )
    Client:on(
        "GameOver",
        function()
            PlayGame.GameState = "Over"
        end
    )
    Client:on(
        "Lose",
        function(data)
            -- 说明所在部队的王死了
            if PlayGame.armyID == data.armyID then
                PlayGame.judgementState = "Lose"
            end
        end
    )
    Client:on(
        "Win",
        function(data)
            -- 说明所在部队获胜了
            if PlayGame.armyID == data.armyID then
                PlayGame.judgementState = "Win"
            end
        end
    )
    Client:on(
        "VanquisherID",
        function(data)
            -- 传递击败玩家者的ID
            CGameMap.Surrender(data.armyID, data.VanquisherID)
            if PlayGame.armyID == data.armyID then
                GameOver.VanquisherID = data.VanquisherID
            end
        end
    )

    Client:connect()
end

-- srcX,Y是出发点 dstX,Y是目标点，显然二者应当相邻
function ClientSock.SendMove(data)
    Client:send("PushMove", data)
end

return ClientSock
