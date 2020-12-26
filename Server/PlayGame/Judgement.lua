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
        local state = CLib.GameMapJudge(i)
        -- 状态由1变为0，说明当前部队死了
        if state == 0 and Judgement.state[i] == 1 then
            Judgement.state[i] = 0
            ServerSock.SendLose(i)
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
                break
            end
        end
        ServerSock.SendGameOver()
    end
end

return Judgement
