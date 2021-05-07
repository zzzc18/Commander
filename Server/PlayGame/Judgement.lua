local Judgement = {}

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
        local vanquisher = CGameMap.Judge(i)
        -- i为要判断的ID，若其被击败，则vanquisher是击败i的玩家ID,否则vanquisher为0
        if vanquisher ~= 0 and Judgement.state[i] == 1 then
            Judgement.state[i] = 0
            ServerSock.SendLose(i, vanquisher)
            CGameMap.Surrender(i, vanquisher) -- 改归属
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
        PlayGame.gameState = "Over"
        if Command["[autoMatch]"] == "true" then
            Server:update()
            Debug.Log("info","auto quit game")
            love.event.quit(0)
        end
    end
end

return Judgement
