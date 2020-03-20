ServerSock = {}

function ServerSock.Init()
    Server = Sock.newServer("*", 22122, 2)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    Server:on(
        "connect",
        function(data, client)
            client:send("armyID", client:getIndex())
        end
    )
end

return ServerSock
