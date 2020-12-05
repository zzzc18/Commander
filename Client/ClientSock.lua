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
        "GameMapMoveUpdate",
        function()
            CGameMap.MoveUpdate()
        end
    )
    Client:on(
        "GameMapUpdate",
        function()
            CGameMap.Update()
        end
    )
    Client:on(
        "GameMapBigUpdate",
        function()
            CGameMap.BigUpdate()
        end
    )
    Client:on(
        "GameStart",
        function()
            PlayGame.GameState = "Start"
        end
    )

    Client:connect()
end

-- srcX,Y是出发点 dstX,Y是目标点，显然二者应当相邻
function ClientSock.SendMove(data)
    Client:send("PushMove", data)
end

return ClientSock
