ServerSock = {}

local PlayGameCore = require("PlayGame.Core")

ServerSock.clientNum = 0

function ServerSock.Init()
    Server = Sock.newServer("*", 22122, 2)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    Server:on(
        "connect",
        function(data, client)
            client:send("SetArmyID", {armyID = client:getIndex()})
            ServerSock.clientNum = ServerSock.clientNum + 1
            -- TODO为了前期调试方便用的2个而不是自动加载的个数
            if ServerSock.clientNum == 2 then
                Server:sendToAll("GameStart")
                Timer.Begin()
            end
        end
    )
    Server:on(
        "PushMove",
        function(data)
            Server:sendToAll("PushMove", data)
            PlayGameCore.PushMove(data)
        end
    )
end

function ServerSock.SendGameMapMoveUpdate()
    Server:sendToAll("GameMapMoveUpdate")
    CGameMap.MoveUpdate()
end

function ServerSock.SendGameMapUpdate()
    Server:sendToAll("GameMapUpdate")
    CGameMap.Update()
end

function ServerSock.SendGameMapBigUpdate()
    Server:sendToAll("GameMapBigUpdate")
    CGameMap.BigUpdate()
end

return ServerSock
