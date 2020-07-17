ServerSock = {}

local socket = require "socket"

function ServerSock.Init() --maxPeers are not set
    ServerSock.clientNum = 0 -- number of connected client
    udp = socket.udp()
    Server = Sock.newServer("localhost", 22122) 
    udp:settimeout(0)
    udp:setsockname("*", 22122)
end

function ServerSock.SendGameMapMoveUpdate()
    -- CGameMap.MoveUpdate()
    udp:sendto("GameMapMoveUpdate ", Client_ip.first, Client_port.first)
    udp:sendto("GameMapMoveUpdate ", Client_ip.second, Client_port.second)
end

function ServerSock.SendGameMapUpdate()
    udp:sendto("GameMapUpdate ", Client_ip.first, Client_port.first)
    udp:sendto("GameMapUpdate ", Client_ip.second, Client_port.second)
    CGameMap.Update()
end

function ServerSock.SendGameMapBigUpdate()
    udp:sendto("GameMapBigUpdate ", Client_ip.first, Client_port.first)
    udp:sendto("GameMapBigUpdate ", Client_ip.second, Client_port.second)
    CGameMap.BigUpdate()
end

return ServerSock
