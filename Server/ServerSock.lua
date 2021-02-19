ServerSock = {}

local PlayGameCore = require("PlayGame.Core")

ServerSock.clientNum = 0

function ServerSock.Init(armyNum)
    Server = Sock.newServer("*", 22122, armyNum)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    Server:on(
        "connect",
        function(data, client)
            client:send("SetArmyID", {armyID = client:getIndex()})
            ServerSock.clientNum = ServerSock.clientNum + 1
            -- TODO为了前期调试方便用的2个而不是自动加载的个数
            if PlayGame.gameState == "Over" then
                PlayGame.gameState = "READY"
                Running.Init()
            end
            if ServerSock.clientNum == armyNum then
                Server:sendToAll("GameStart")
                PlayGame.gameState = "Start"
            end
        end
    )
    Server:on(
        "disconnect",
        function()
            ServerSock.clientNum = ServerSock.clientNum - 1
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

function ServerSock.SendUpdate(dt)
    Server:sendToAll("Update", dt)
    CSystem.Update(dt)
end

function ServerSock.SendGameOver()
    Server:sendToAll("GameOver")
end

function ServerSock.SendLose(armyID, vanquisherID)
    Server:sendToAll("Lose", {armyID = armyID, vanquisherID = vanquisherID})
end

function ServerSock.SendWin(armyID)
    Server:sendToAll("Win", {armyID = armyID})
end

return ServerSock
