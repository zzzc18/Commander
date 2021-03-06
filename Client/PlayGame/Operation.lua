local Operation = {}

-- 这段代码 if 里面去掉 true 是否还能正常运转？？
-- 将x,y格设为选中状态
function Operation.Select(x, y)
    if CGameMap.GetNodeType(x, y) == "NODE_TYPE_HILL" then
        return
    end
    if true or CGameMap.GetBelong(x, y) == PlayGame.armyID then
        Operation.SelectPos = {}
        Operation.SelectPos.x = x
        Operation.SelectPos.y = y
        Debug.Log("info", string.format("Chosen point %d %d", x, y))
    end
end

--检查pos之间是否相邻
-- 参数分别为点1和点2的坐标
function Operation.IsConnected(posX1, posY1, posX2, posY2)
    if posX1 == posX2 then
        if posY1 - posY2 == 1 or posY2 - posY1 == 1 then
            return true
        end
    end

    if posX1 % 2 == 1 then
        if (posX1 == posX2 + 1 or posX1 == posX2 - 1) and (posY1 == posY2 or posY1 == posY2 - 1) then
            return true
        end
    else
        if (posX1 == posX2 + 1 or posX1 == posX2 - 1) and (posY1 == posY2 or posY1 == posY2 + 1) then
            return true
        end
    end
    return false
end

--发送移动命令
function Operation.MoveTo(x, y)
    if PlayGame.gameState ~= "Start" then
        return
    --只有游戏进行时才能发送
    end
    if x == -1 and y == -1 then --撤销移动
        local NewRequest = {
            armyID = PlayGame.armyID,
            srcX = -1,
            srcY = -1,
            dstX = -1,
            dstY = -1,
            num = 0
        }
        ClientSock.SendMove(NewRequest)
        Debug.Log("info", "move revoke")
        return
    end

    if not Operation.IsConnected(Operation.SelectPos.x, Operation.SelectPos.y, x, y) then
        Debug.Log("warning", "move illegal")
        return
    end
    if CGameMap.GetNodeType(x, y) == "NODE_TYPE_HILL" then
        Debug.Log("warning", "move illegal")
    end

    local NewRequest = {
        armyID = PlayGame.armyID,
        srcX = Operation.SelectPos.x,
        srcY = Operation.SelectPos.y,
        dstX = x,
        dstY = y,
        num = 0
    }
    ClientSock.SendMove(NewRequest)
    if CGameMap.GetNodeType(x, y) ~= "NODE_TYPE_HILL" then
        Debug.Log("info", string.format("move from %d,%d to %d,%d", Operation.SelectPos.x, Operation.SelectPos.y, x, y))
    end
end

--依按下的键盘按键进行操作
function Operation.CatchKeyPressed(key)
    --esc键撤销最后发出的移动命令
    if key == "escape" then
        Operation.MoveTo(-1, -1)
        return
    end

    if Operation.SelectPos == nil then
        return
    end

    local x = Operation.SelectPos.x
    local y = Operation.SelectPos.y
    local mode = x % 2 + 1
    local moveOp = {
        -- 按QEADZC进行移动
        ["q"] = {BasicMap.direction[mode][6][1], BasicMap.direction[mode][6][2]},
        ["e"] = {BasicMap.direction[mode][1][1], BasicMap.direction[mode][1][2]},
        ["d"] = {BasicMap.direction[mode][2][1], BasicMap.direction[mode][2][2]},
        ["c"] = {BasicMap.direction[mode][3][1], BasicMap.direction[mode][3][2]},
        ["z"] = {BasicMap.direction[mode][4][1], BasicMap.direction[mode][4][2]},
        ["a"] = {BasicMap.direction[mode][5][1], BasicMap.direction[mode][5][2]}
    }

    if (moveOp[key] == nil) then
        return
    end
    x = x + moveOp[key][1]
    y = y + moveOp[key][2]
    --防止越出地图边界
    local mapSizeX, mapSizeY = CGameMap.GetSize()
    if x < 0 or y < 0 or x >= mapSizeX or y >= mapSizeY then
        Debug.Log("warning", "invalid move")
        return
    end

    Operation.MoveTo(x, y)
    Operation.Select(x, y)
end

--依鼠标键按下的位置进行操作
function Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
    if 3 == button then
        return
    --按下滚轮不move
    end
    -- 鼠标坐标转换为地图坐标
    local x, y = BasicMap.Pixel2Coordinate(pixelX, pixelY)
    local name = Buttons.MouseState(pixelX, pixelY, 0)
    if "Clicked" == name then
        return
    end
    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end

    if Operation.SelectPos == nil then -- 没有选择的情况下要选择
        if CGameMap.GetBelong(x, y) == PlayGame.armyID then
            Operation.Select(x, y)
        end
    else -- 选择后的情况要移动
        Operation.MoveTo(x, y)
        if
            Operation.IsConnected(Operation.SelectPos.x, Operation.SelectPos.y, x, y) or
                CGameMap.GetBelong(x, y) == PlayGame.armyID
         then
            Operation.Select(x, y)
        end
    end
end

function Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
    local name = Buttons.MouseState(pixelX, pixelY, 2)
    if "menu" == name then
        Running.gameState = "Menu"
    elseif "continue" == name then
        Running.gameState = "Start"
    elseif "exit" == name then
        Switcher.To(Welcome)
    end
end

function Operation.DrawSelect()
    if Operation.SelectPos == nil then
        return
    end
    local pixelX, pixelY = BasicMap.Coordinate2Pixel(Operation.SelectPos.x, Operation.SelectPos.y)
    Picture.DrawSelect(pixelX, pixelY)
end

function Operation.DrawButtons()
    Buttons.DrawButtons()
end

function Operation.DrawMenu()
    Picture.DrawMenu()
end

function Operation.Update()
    Buttons.Update()
end

return Operation
