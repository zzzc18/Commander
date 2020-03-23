ServerSock = {}

function ServerSock.Init()
    Server = Sock.newServer("*", 22122, 2)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    Server:on(
        "connect",
        function(data, client)
            client:send("SetArmyID", {armyID = client:getIndex()})
        end
    )
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
