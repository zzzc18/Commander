Operation = {}

function Operation.Select(x, y)
    if true or CGameMap.GetBelong(x, y) == PlayGame.armyID then -- TODO: fix true
        Operation.SelectPos = {}
        Operation.SelectPos.x = x
        Operation.SelectPos.y = y
    end
end

function Operation.CatchKeyPressed(key)
    if key == "escape" then
        -- Operation.MoveTo(-1, -1)
        return
    end

    if key == "return" then
        CGameMap.SaveEdit()
        return
    end

    if Operation.SelectPos == nil then
        return
    end

    if key == "h" then
        CGameMap.ChangeType(Operation.SelectPos.x, Operation.SelectPos.y, 1)
        return
    end
    if key == "b" then
        CGameMap.ChangeType(Operation.SelectPos.x, Operation.SelectPos.y, 2)
        return
    end
    if key == "k" then
        CGameMap.ChangeType(Operation.SelectPos.x, Operation.SelectPos.y, 3)
        return
    end
    if key == "f" then
        CGameMap.ChangeType(Operation.SelectPos.x, Operation.SelectPos.y, 4)
        return
    end
    if key == "o" then
        CGameMap.ChangeType(Operation.SelectPos.x, Operation.SelectPos.y, 5)
        return
    end
    if key == "m" then
        CGameMap.ChangeType(Operation.SelectPos.x, Operation.SelectPos.y, 6)
        return
    end
    if key == "space" then
        CGameMap.ChangeBelong(Operation.SelectPos.x, Operation.SelectPos.y)
    end

    local x = Operation.SelectPos.x
    local y = Operation.SelectPos.y
    local mode = x % 2 + 1
    local moveOp = {
        ["q"] = {BasicMap.direction[mode][6][1], BasicMap.direction[mode][6][2]},
        ["e"] = {BasicMap.direction[mode][1][1], BasicMap.direction[mode][1][2]},
        ["d"] = {BasicMap.direction[mode][2][1], BasicMap.direction[mode][2][2]},
        ["c"] = {BasicMap.direction[mode][3][1], BasicMap.direction[mode][3][2]},
        ["z"] = {BasicMap.direction[mode][4][1], BasicMap.direction[mode][4][2]},
        ["a"] = {BasicMap.direction[mode][5][1], BasicMap.direction[mode][5][2]}
    }
    -- print("Caught key pressed (Move operation): ", moveOp[key])

    if (moveOp[key] == nil) then
        return
    end
    x = x + moveOp[key][1]
    y = y + moveOp[key][2]
    Operation.Select(x, y)
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
    if Operation.SelectPos ~= nil then
        if Operation.SelectPos.x == x and Operation.SelectPos.y == y then -- 再次选择了已选位置
            -- Operation.Select(x, y)
            --print(string.format("Current select: %d,%d", Operation.SelectPos.x, Operation.SelectPos.y))
            if button == 1 then
                Operation.Increase(x, y)
            elseif button == 2 then
                Operation.Decrease(x, y)
            end
        else
            Operation.Select(x, y)
        end
    else
        Operation.Select(x, y)
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

function Operation.Increase(x, y)
    local newRequest = {
        aimX = x,
        aimY = y
    }
    EditorSock.Increase(newRequest)
end

function Operation.Decrease(x, y)
    local newRequest = {
        aimX = x,
        aimY = y
    }
    EditorSock.Decrease(newRequest)
end

return Operation
