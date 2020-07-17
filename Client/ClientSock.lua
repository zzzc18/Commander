ClientSock = {}
local socket = require "socket"
local address, port = "localhost", 22122
local updaterate = 0 --unset
local t = 0
local PlayGameCore = require("PlayGame.Core")

function ClientSock.Init()
    Client = Sock.newClient("localhost", 22122)
    udp = socket:udp()
    udp:settimeout(0)
    udp:setpeername(address, port)
    local dg = "connect " -- 单个词指令后面要加一个空格
    udp:send(dg)
end

function ClientSock.SendMove(Tdata)
    local data =
        tostring(Tdata.armyID) ..
        " " ..
            tostring(Tdata.srcX) ..
                " " ..
                    tostring(Tdata.srcY) ..
                        " " ..
                            tostring(Tdata.dstX) .. " " .. tostring(Tdata.dstY)
    local dg = "Move" .. " " .. data
    udp:send(dg)
end

return ClientSock
