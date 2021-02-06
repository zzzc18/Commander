Judgement = {}

-- 储存各部队状态，1表示存活，0表示死亡
Judgement.state = {}

function Judgement.Init()
    for i = 1, PlayGame.armyNum do
        Judgement.state[i] = 1
    end
end

function Judgement.Judge()
    -- 存活部队数
    local aliveCnt = 0
    for i = 1, PlayGame.armyNum do
        local Vanquisher = CGameMap.Judge(i)
        -- i为要判断的ID，若其被击败，则Vanquisher是击败i的玩家ID,否则Vanquisher为0
        if Vanquisher ~= 0 and Judgement.state[i] == 1 then
            Judgement.state[i] = 0
            ServerSock.SendLose(i)
            ServerSock.SendVanquisherID(i, Vanquisher)
            CGameMap.Surrender(i, Vanquisher) -- 改归属
        end
        if Judgement.state[i] == 1 then
            aliveCnt = aliveCnt + 1
        end
    end
    --检查是否只剩下一个部队存活，如果是，发送胜利，并结束游戏
    if aliveCnt == 1 then
        for i = 1, PlayGame.armyNum do
            if Judgement.state[i] == 1 then
                ServerSock.SendWin(i)
                CGameMap.SaveGameOver(i)
                break
            end
        end
        ServerSock.SendGameOver()
        PlayGame.GameState = "Over"
    end
end

return Judgement
