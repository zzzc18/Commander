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
            if ServerSock.clientNum == armyNum then
                Server:sendToAll("GameStart")
                PlayGame.GameState = "Start"
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

function ServerSock.SendUpdate(dt)
    Server:sendToAll("Update", dt)
    CSystem.Update(dt)
end

function ServerSock.SendGameOver()
    Server:sendToAll("GameOver")
end

function ServerSock.SendLose(armyID, VanquisherID)
    Server:sendToAll("Lose", {armyID = armyID, VanquisherID = VanquisherID})
end

function ServerSock.SendWin(armyID)
    Server:sendToAll("Win", {armyID = armyID})
end

return ServerSock
