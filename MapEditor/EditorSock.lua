EditorSock = {}

-- local PlayGameCore = require("PlayGame.Core")

function EditorSock.Init()
    Editor = Sock.newClient("localhost", 22122) --不想再写个newEditor函数->_->
    Editor:setSerialization(Bitser.dumps, Bitser.loads)
    Editor:connect()
end

-- IncreaseOrDecrease:1 is increase,2 is decrease
function EditorSock.Increase(data)
    -- Editor:send(data)
    CGameMap.IncreaseOrDecrease(data.aimX, data.aimY, 1)
end

function EditorSock.Decrease(data)
    CGameMap.IncreaseOrDecrease(data.aimX, data.aimY, 2)
end

return EditorSock
