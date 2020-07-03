Operation = {}

-- 这是一个记录移动操作的队列（先进后出）
-- 对于队列中的以及所有的移动指令格式全部固定
-- 为一个表 data={...} 其中有 armyID,srcX,srcY,dstX,dstY 5个元素
Operation.Queue = {}
Operation.SelectPos = nil

function Operation.Queue:Push(data)
    table.insert(self, data)
end

function Operation.Queue:Top()
    return self[1]
end

function Operation.Queue:Pop()
    table.remove(self, 1)
end

function Operation.Queue:Empty()
    return self[1] == nil
end

function Operation.Queue:Size()
    return #self
end

function Operation.Select(x, y)
    if true or CGameMap.GetBelong(x, y) == PlayGame.armyID then -- TODO: fix true
        Operation.SelectPos = {}
        Operation.SelectPos.x = x
        Operation.SelectPos.y = y
    end
end

function Operation.IsConnected(posX1, posY1, posX2, posY2)
    if posX1 == posX2 then
        if posY1 - posY2 == 1 or posY2 - posY1 == 1 then
            return true
        end
    end

    if posX1 % 2 == 1 then
        if (posX1 == posX2 + 1 or posX1 == posX2 - 1) and (posY1 == posY2 or posY1 == posY2 - 1) then return true end
    else
        if (posX1 == posX2 + 1 or posX1 == posX2 - 1) and (posY1 == posY2 or posY1 == posY2 + 1) then return true end
    end
    return false
end

function Operation.MoveTo(x, y)

    if not Operation.IsConnected(Operation.SelectPos.x, Operation.SelectPos.y, x, y) then
        print("!! NOT Connected")
        return
    end
    print("Connected")
    Operation.Queue:Push(
    {
        armyID = PlayGame.armyID,
        srcX = Operation.SelectPos.x,
        srcY = Operation.SelectPos.y,
        dstX = x,
        dstY = y
    }
    )
end

function Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
    -- 鼠标坐标转换为地图坐标
    local x, y = BasicMap.Pixel2Coordinate(pixelX, pixelY)
    print("mouse_pressed")

    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end
    print(string.format("Chosen point %d %d", x, y))
    if Operation.SelectPos == nil then -- 没有选择的情况下要选择
        Operation.Select(x, y)
    else -- 选择后的情况要移动
        Operation.MoveTo(x, y)
        -- TODO: delete debug
        Operation.Select(x, y)
        print(string.format("Current select: %d,%d", Operation.SelectPos.x, Operation.SelectPos.y))
    end
end

function Operation.DrawSelect()
    if Operation.SelectPos == nil then
        return
    end
    local pixelX, pixelY =    BasicMap.Coordinate2Pixel(Operation.SelectPos.x, Operation.SelectPos.y)
    Picture.DrawSelect(pixelX, pixelY)
end

function Operation.SendMove()
    if not Operation.Queue:Empty() then
        ClientSock.SendMove(Operation.Queue:Top())
        Operation.Queue:Pop()
    end
end

return Operation