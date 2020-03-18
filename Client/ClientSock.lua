ClientSock = {}

function ClientSock.Init()
    Client = Sock.newClient("localhost", 22122)
    Client:setSerialization(Bitser.dumps, Bitser.loads)
    Client:on(
        "SetArmyID",
        function(data)
            PlayGame.ArmyID = data.armyID
        end
    )
end

return ClientSock
