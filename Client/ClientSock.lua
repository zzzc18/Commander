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
            ReplayGame.step = CSystem.Update(data)
        end
    )
    Client:on(
        "GameStart",
        function()
            PlayGame.gameState = "Start"
            BGAnimation.deLoad()
        end
    )
    Client:on(
        "GameOver",
        function()
            PlayGame.gameState = "Over"
        end
    )
    Client:on(
        "Lose",
        function(data)
            -- 说明所在部队的王死了
            CGameMap.Surrender(data.armyID, data.vanquisherID)
            if PlayGame.armyID == data.armyID then
                PlayGame.judgementState = "Lose"
                PlayGame.gameState = "Over"
                GameOver.vanquisherID = data.vanquisherID
                Switcher.To(GameOver)
            end
        end
    )
    Client:on(
        "Win",
        function(data)
            -- 说明所在部队获胜了
            if PlayGame.armyID == data.armyID then
                PlayGame.judgementState = "Win"
                PlayGame.gameState = "Over"
                Switcher.To(GameOver)
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
