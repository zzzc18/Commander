ServerSock = {}

local PlayGameCore = require("PlayGame.Core")

ServerSock.clientNum = 0

ServerSock.Sync = {}

function ServerSock.Sync:Init()
    self.clientSyncState = {}
    self.clientSyncTimeout = 1.0 --seconds
    self.clientSyncTime = 0
end

function ServerSock.Sync:Clear()
    for armyID, val in pairs(self.clientSyncState) do
        if val == "Sync" then
            self.clientSyncState[armyID] = "unSync"
        end
    end
end

function ServerSock.Sync:IsSync()
    for armyID, val in pairs(self.clientSyncState) do
        if val == "unSync" then
            return false
        end
    end
    return true
end

function ServerSock.Sync:SetSync(armyID)
    self.clientSyncState[armyID] = "Sync"
end

function ServerSock.Sync:Update(dt)
    self.clientSyncTime = self.clientSyncTime + dt
end

function ServerSock.Sync:Timeout()
    return self.clientSyncTime >= self.clientSyncTimeout
end

function ServerSock.Sync:TimerReset()
    self.clientSyncTime = 0
end

function ServerSock.Sync:KillTimeoutClient()
    for armyID, val in pairs(self.clientSyncState) do
        if val == "unSync" then
            self.clientSyncState[armyID] = "lose"
            ServerSock.SendLose(armyID, -1)
        end
    end
end

function ServerSock.Init(armyNum)
    print(armyNum)
    print(Command["[port]"])
    Server = Sock.newServer("*", Command["[port]"], armyNum)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    ServerSock.Sync:Init()
    Server:on(
        "connect",
        function(data, client)
            client:send("SetArmyID", {armyID = client:getIndex()})
            ServerSock.clientNum = ServerSock.clientNum + 1
            ServerSock.Sync:SetSync(client:getIndex())
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
    -- 尝试解决error during service，进行各客户端同步
    Server:on(
        "RoundPulse",
        function(data, client)
            ServerSock.Sync:SetSync(client:getIndex())
        end
    )
end

function ServerSock.SendUpdate(dt)
    if ServerSock.Sync:IsSync() then
        ServerSock.Sync:Clear()
        Server:sendToAll("Update", dt)
        PlayGame.step = CSystem.Update(dt)
    else
        ServerSock.Sync:Update(dt)
        if ServerSock.Sync:Timeout() then
            ServerSock.Sync:TimerReset()
            ServerSock.Sync:KillTimeoutClient()
        end
    end
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
