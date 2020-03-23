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
    if CGameMap.GetBelong(x, y) == PlayGame.armyID then
        Operation.SelectPos = {}
        Operation.SelectPos.x = x
        Operation.SelectPos.y = y
    end
end

function Operation.MoveTo(x, y)
    local absDetX = math.abs(x - Operation.SelectPos.x)
    local absDetY = math.abs(y - Operation.SelectPos.y)
    -- 这里就是判断是否是四联通，如果括号内为真，
    -- 说明和所选中格子(即Operation.SelectPos)是四联通关系
    -- 否则就不执行MoveTo
    if not (absDetX * absDetY == 0 and absDetX + absDetY == 1) then
        return
    end
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
    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end
    if Operation.SelectPos == nil then -- 没有选择的情况下要选择
        Operation.Select(x, y)
    else -- 选择后的情况要移动
        Operation.MoveTo(x, y)
    end
end

function Operation.DrawSelect()
    if Operation.SelectPos == nil then
        return
    end
    local pixelX, pixelY =
        BasicMap.Coordinate2Pixel(Operation.SelectPos.x, Operation.SelectPos.y)
    Picture.DrawSelect(pixelX, pixelY)
end

function Operation.SendMove()
    if not Operation.Queue:Empty() then
        ClientSock.SendMove(Operation.Queue:Top())
        Operation.Queue:Pop()
    end
end

return Operation
