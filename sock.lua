local sock = {}
-- local socket = require "socket"
-- local udp = socket.udp()
local Server = {}
--local PlayGameCore = require("PlayGame.Core")
-- require("ServerSock")
-- require("ClientSock")
Client_ip = {first = "localhost", second = "localhost"} --默认值 只有2个client
Client_port = {first = 22122, second = 22122}
function Server:update()
    local str, msg_or_ip, port_or_nil = udp:receivefrom()
    if str then
        local cmd, data = str:match("^(%S*) (.*)") -- to be modified
        if cmd == "connect" then
            ServerSock.clientNum = ServerSock.clientNum + 1
            udp:sendto(
                string.format("SetArmyID %d", ServerSock.clientNum),
                msg_or_ip,
                port_or_nil
            )
            if ServerSock.clientNum == 1 then
                Client_ip.first = msg_or_ip
                Client_port.first = port_or_nil
            else
                Client_ip.second = msg_or_ip
                Client_port.second = port_or_nil
            end

            if ServerSock.clientNum == 2 then
                udp:sendto("GameStart ", Client_ip.first, Client_port.first) --发送单个单词时结尾加一个空格
                udp:sendto("GameStart ", Client_ip.second, Client_port.second)
                Timer.Begin()
            end
        elseif cmd == "Move" then
            local Tdata = {armyID, srcX, srcY, dstX, dstY}
            Tdata.armyID, Tdata.srcX, Tdata.srcY, Tdata.dstX, Tdata.dstY =
                data:match(
                "^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)"
            )
            PlayGameCore.Move(Tdata)
        end
    end
    --socket.sleep(0.01)
end

local Client = {}

local str, msg
function Client:update()
    repeat
        str, msg = udp:receive() --data(string) and error_message(perhaps)
        local cmd, data
        if str then
            cmd, data = str:match("^(%S*) (.*)")
            if cmd == "SetArmyID" then
                PlayGame.armyID = tonumber(data)
                CVerify.Register(tonumber(data))
                PlayGame.LoadMap()
            elseif cmd == "GameStart" then
                PlayGame.GameState = "Start"
            elseif cmd == "Move" then
                local Tdate = {armyID, srcX, srcY, dstX, dstY}
                Tdata.armyID, Tdata.srcX, Tdata.srcY, Tdata.dstX, Tdata.dstY =
                    data:match(
                    "^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)"
                )
                PlayGameCore.Move(Tdata)
            elseif cmd == "GameMapMoveUpdate" then
                -- CGameMap.MoveUpdate()
            elseif cmd == "GameMapUpdate" then
                CGameMap.Update()
            elseif cmd == "GameMapBigUpdate" then
                CGameMap.BigUpdate()
            end
        end
    until not cmd
end

sock.newServer = function(server_adress, port)
    Server.adress = server_adress
    Server.port = port
    return Server
end

sock.newClient = function(client_adress, port)
    Client.adress = client_adress
    Client.port = port
    return Client
end

return sock
