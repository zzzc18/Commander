ClientSock = {}

function ClientSock.Init()
    Client = Sock.newClient("localhost", 22122)
    Client:setSerialization(Bitser.dumps, Bitser.loads)
end

return ClientSock
