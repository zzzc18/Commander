Operation = {}

-- 这段代码 if 里面去掉 true 是否还能正常运转？？
-- 将x,y格设为选中状态
function Operation.Select(x, y)
    if true or CGameMap.GetBelong(x, y) == PlayGame.armyID then
        Operation.SelectPos = {}
        Operation.SelectPos.x = x
        Operation.SelectPos.y = y
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
    if PlayGame.GameState ~= "Start" then
        return
    --只有游戏进行时才能发送
    end
    if x == -1 and y == -1 then --撤销移动
        local newRequest = {
            armyID = PlayGame.armyID,
            srcX = -1,
            srcY = -1,
            dstX = -1,
            dstY = -1
        }
        ClientSock.SendMove(newRequest)
        return
    end

    if not Operation.IsConnected(Operation.SelectPos.x, Operation.SelectPos.y, x, y) then
        return
    end

    local newRequest = {
        armyID = PlayGame.armyID,
        srcX = Operation.SelectPos.x,
        srcY = Operation.SelectPos.y,
        dstX = x,
        dstY = y
    }
    ClientSock.SendMove(newRequest)
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
    Operation.MoveTo(x, y)
    Operation.Select(x, y)
end

--依鼠标键按下的位置进行操作
function Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
    -- 鼠标坐标转换为地图坐标
    local x, y = BasicMap.Pixel2Coordinate(pixelX, pixelY)
    -- local buttonName = Buttons.MouseState(pixelX, pixelY, 0)
    if PlayGame.judgementState == "Win" or PlayGame.judgementState == "Lose" then
        GameOver.MouseStateForOpts(pixelX, pixelY, 0)
        return
    end
    -- --说明鼠标点了按钮
    -- if buttonName ~= nil then
    --     return
    -- end

    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end
    print("mouse_pressed")
    print(string.format("Chosen point %d %d", x, y))
    if Operation.SelectPos == nil then -- 没有选择的情况下要选择
        Operation.Select(x, y)
    else -- 选择后的情况要移动
        --print(string.format("Current select: %d,%d", Operation.SelectPos.x, Operation.SelectPos.y))
        Operation.MoveTo(x, y)
        Operation.Select(x, y)
    end
end

function Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
    -- Buttons.MouseState(pixelX, pixelY, 2)
    if PlayGame.judgementState == "Win" or PlayGame.judgementState == "Lose" then
        GameOver.MouseStateForOpts(pixelX, pixelY, 2)
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
    -- Buttons.DrawButtons()
end

function Operation.Update()
    -- Buttons.Update()
end

return Operation
