ClientSock = {}

ClientSock.Lock = 0

local Connected = 0

local PlayGameCore = require("PlayGame.Core")

function ClientSock.Init()
    Client = Sock.newClient("localhost", Command["[port]"])
    Client:setSerialization(Bitser.dumps, Bitser.loads)
    Client:on(
        "SetArmyID",
        function(data)
            Debug.Log("info", "Received armyID: " .. data.armyID)
            Running.armyID = data.armyID
            CVerification.Register(data.armyID)
            Running.LoadMap()
            if Running == AI_SDK then
                AI_SDK.KingPos.x, AI_SDK.KingPos.y = CGameMap.GetKingPos(AI_SDK.armyID)
            end
        end
    )
    Client:on(
        "PushMove",
        function(data)
            PlayGameCore.PushMove(data)
        end
    )
    Client:on(
        "Update",
        function(data)
            Running.step = CSystem.Update(data)
        end
    )
    Client:on(
        "UpdateStep",
        function(data)
            local lastStep = Running.step
            Running.step = CSystem.UpdateStep(data)
            if Command["[autoMatch]"] == "false" then
                ClientSock.SendStepPluse()
            end
            if lastStep < Running.step then
                ClientSock.Lock = 0
                Debug.Log("info", "unlocking at " .. lastStep .. " -> " .. Running.step)
            end
            Debug.Log("info", "Running.step = " .. Running.step)
        end
    )
    Client:on(
        "GameStart",
        function(data)
            Running.gameState = "Start"
            BGAnimation.deLoad()
            ReplayGame.droppedDir = data
        end
    )
    Client:on(
        "GameOver",
        function()
            PlayGame.gameState = "Over"
        end
    )
    Client:on(
        "Lose",
        function(data)
            -- 说明所在部队的王死了
            CGameMap.Surrender(data.armyID, data.vanquisherID)
            if Running.armyID == data.armyID then
                Running.judgementState = "Lose"
                Running.gameState = "Over"
                GameOver.vanquisherID = data.vanquisherID
                Switcher.To(GameOver)
            end
        end
    )
    Client:on(
        "Win",
        function(data)
            -- 说明所在部队获胜了
            if Running.armyID == data.armyID then
                Running.judgementState = "Win"
                Running.gameState = "Over"
                Switcher.To(GameOver)
            end
        end
    )
    -- 自动评测需要强制说明自己的ID，否则无法运行
    if Command["[autoMatch]"] == "true" then
        print(Command["[teamID]"])
        Client:connect(Command["[teamID]"])
    else
        Client:connect()
    end
end

function ClientSock.SendMove(data)
    ClientSock.Lock = ClientSock.Lock + 1
    print(ClientSock.Lock)
    if ClientSock.Lock < 2 then
        Client:send("PushMove", data)
    end
end

function ClientSock.SendStepPluse()
    Client:send("StepPluse", Running.step)
end

function ClientSock.Update()
    Client:update()
    if Connected == 0 and Client:isConnected() then
        Connected = 1
        Debug.Log("info", "connect")
    elseif Connected == 1 and not Client:isConnected() then
        Connected = 0
        Debug.Log("error", "disconnect")
    end
end

return ClientSock
