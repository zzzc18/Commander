ServerSock = {}

local PlayGameCore = require("PlayGame.Core")

ServerSock.stepTime = 0.5
ServerSock.stepTimeAutoMatch = 0.2
ServerSock.ClientID = {}
ServerSock.clientNum = 0

ServerSock.Sync = {}
ServerSock.StepTimer = {}

function ServerSock.StepTimer:Init(autoMatch)
    if autoMatch == "true" then
        self.limit = ServerSock.stepTimeAutoMatch
    else
        self.limit = ServerSock.stepTime
    end
    self.timer = 0
end

function ServerSock.StepTimer:Update(dt)
    self.timer = self.timer + dt
end

function ServerSock.StepTimer:TimeIsUp()
    return self.timer > self.limit
end

function ServerSock.StepTimer:TimerReset()
    self.timer = 0
end

function ServerSock.Sync:Init(clientNum)
    self.clientStep = {}
    for i = 1, clientNum do
        self.clientStep[i] = 0
    end
    self.clientSyncTimeout = 1.1 --seconds
    self.clientSyncTime = 0
end

function ServerSock.Sync:IsSync()
    for armyID, val in pairs(self.clientStep) do
        if val ~= Running.step and val >= 0 then
            return false
        end
    end
    return true
end

function ServerSock.Sync:SetSync(armyID, data)
    if type(data) == "number" and self.clientStep[armyID] >= 0 then
        self.clientStep[armyID] = data
    end
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

function ServerSock.Sync:MarkTimeoutClient()
    for armyID, val in pairs(self.clientStep) do
        if val ~= Running.step and val >= 0 then
            if Running.step >= Command["[stepLimit]"] then
                -- ServerSock.SendWin(armyID)
                -- CGameMap.SaveGameOver(armyID)
                ServerSock.Sync:SetSync(armyID, -2)
                Judgement.state[armyID] = 1
            else
                ServerSock.Sync:SetSync(armyID, -2)
                Judgement.state[armyID] = 0
                ServerSock.SendLose(armyID, 0)
                CGameMap.Surrender(armyID, 0)
            end
        end
    end
end

function ServerSock.Init(armyNum)
    print(armyNum)
    print(Command["[port]"])
    Server = Sock.newServer("*", Command["[port]"], armyNum)
    Server:setSerialization(Bitser.dumps, Bitser.loads)
    ServerSock.Sync:Init(armyNum)
    ServerSock.StepTimer:Init(Command["[autoMatch]"])
    Server:on(
        "connect",
        function(data, client)
            if data == 0 then
                client:send("SetArmyID", {armyID = client:getIndex()})
                ServerSock.ClientID[client:getIndex()] = client:getIndex()
            else
                client:send("SetArmyID", {armyID = data})
                ServerSock.ClientID[client:getIndex()] = data
            end
            ServerSock.clientNum = ServerSock.clientNum + 1
            ServerSock.Sync:SetSync(ServerSock.ClientID[client:getIndex()], 0)
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
        function(data, client)
            ServerSock.clientNum = ServerSock.clientNum - 1
            ServerSock.Sync:SetSync(ServerSock.ClientID[client:getIndex()], -1)
        end
    )
    Server:on(
        "PushMove",
        function(data, client)
            Debug.Log("info", "Received PushMove from " .. data.armyID)
            if ServerSock.ClientID[client:getIndex()] == data.armyID then
                Server:sendToAll("PushMove", data)
                PlayGameCore.PushMove(data)
            end
        end
    )
    -- 尝试解决error during service，进行各客户端同步
    Server:on(
        "StepPluse",
        function(data, client)
            ServerSock.Sync:SetSync(ServerSock.ClientID[client:getIndex()], data)
        end
    )
end

function ServerSock.Sleep(t)
    local start = os.clock()
    while os.clock() - start < t do
    end
end

function ServerSock.SendUpdate(dt)
    ServerSock.StepTimer:Update(dt)
    ServerSock.Sync:Update(dt)
    if ServerSock.Sync:Timeout() then
        ServerSock.Sync:MarkTimeoutClient()
    end
    if ServerSock.Sync:IsSync() then
        ServerSock.Sync:TimerReset()
        if ServerSock.StepTimer:TimeIsUp() then
            ServerSock.StepTimer:TimerReset()
            Running.step = CSystem.UpdateStep(Running.step + 1)
            Server:sendToAll("UpdateStep", Running.step)
        end
    end
    -- Debug.Log("info", "Running.step = " .. Running.step)
end

function ServerSock.SendGameOver()
    Server:sendToAll("GameOver")
end

function ServerSock.SendLose(armyID, vanquisherID)
    ServerSock.Sync:SetSync(armyID, -2)
    Server:sendToAll("Lose", {armyID = armyID, vanquisherID = vanquisherID})
end

function ServerSock.SendWin(armyID)
    Server:sendToAll("Win", {armyID = armyID})
end

return ServerSock
