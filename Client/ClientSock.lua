ClientSock = {}

local Connected = 0

local PlayGameCore = require("PlayGame.Core")

function ClientSock.Init()
    Client = Sock.newClient("localhost", 22122)
    Client:setSerialization(Bitser.dumps, Bitser.loads)
    Client:on(
        "SetArmyID",
        function(data)
            Debug.Log("info", "Received armyID: " .. data.armyID)
            Running.armyID = data.armyID
            CVerify.Register(data.armyID)
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
            ReplayGame.step = CSystem.Update(data)
        end
    )
    Client:on(
        "GameStart",
        function()
            Running.gameState = "Start"
            BGAnimation.deLoad()
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

    Client:connect()
end

-- srcX,Y是出发点 dstX,Y是目标点，显然二者应当相邻
function ClientSock.SendMove(data)
    Client:send("PushMove", data)
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
