ServerSock = {}

local PlayGameCore = require("PlayGame.Core")

ServerSock.clientNum = 0

function ServerSock.Init(armyNum)
    print(armyNum)
    Server = Sock.newServer("*", Command["[port]"], armyNum)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    Server:on(
        "connect",
        function(data, client)
            client:send("SetArmyID", {armyID = client:getIndex()})
            ServerSock.clientNum = ServerSock.clientNum + 1
            if PlayGame.gameState == "Over" then
                PlayGame.gameState = "READY"
                Running.Init()
            end
            if ServerSock.clientNum == armyNum then
                Server:sendToAll("GameStart", CGameMap.GetFolder())
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
            Debug.Log("info", "Received PushMove from " .. data.armyID)
            Server:sendToAll("PushMove", data)
            PlayGameCore.PushMove(data)
        end
    )
end

function ServerSock.SendUpdate(dt)
    Server:sendToAll("Update", dt)
    PlayGame.step = CSystem.Update(dt)
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
