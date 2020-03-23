ClientSock = {}

local PlayGameCore = require("PlayGame.Core")

function ClientSock.Init()
    Client = Sock.newClient("localhost", 22122)
    Client:setSerialization(Bitser.dumps, Bitser.loads)
    Client:on(
        "SetArmyID",
        function(data)
            PlayGame.armyID = data.armyID
            CVerify.Register(data.armyID)
        end
    )
    Client:on(
        "Move",
        function(data)
            PlayGameCore.Move(data)
        end
    )
    Client:on(
        "GameMapUpdate",
        function()
            CGameMap.Update()
        end
    )
    Client:on("GameMapBigUpdate")
end

-- srcX,Y是出发点 dstX,Y是目标点，显然二者应当四联通相连
function ClientSock.SendMove(data)
    Client:send("Move", data)
end

return ClientSock
