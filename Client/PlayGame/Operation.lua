Operation = {}

Operation.sequence = {}
Operation.selectPos = nil

function Operation.Select(x, y)
    if CGameMap.GetBelong(x, y) == PlayGame.armyID then
        Operation.selectPos = {}
        Operation.selectPos.x = x
        Operation.selectPos.y = y
    end
end

function Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
    -- 鼠标坐标转换为地图坐标
    local x, y = BasicMap.Pixel2Coordinate(pixelX, pixelY)
    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end
    if Operation.selectPos == nil then -- 没有选择的情况下要选择
        Operation.Select(x, y)
    else -- 选择后的情况要移动
        Operation.MoveTo(x, y)
    end
end

function Operation.DrawSelect()
    if Operation.selectPos == nil then
        return
    end
    local pixelX, pixelY =
        BasicMap.Coordinate2Pixel(Operation.selectPos.x, Operation.selectPos.y)
    Picture.DrawSelect(pixelX, pixelY)
end

return Operation
