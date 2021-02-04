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
        return
    end

    if key == "return" then
        CGameMap.SaveEdit()
        return
    end

    if Operation.SelectPos == nil then
        return
    end

    local x = Operation.SelectPos.x
    local y = Operation.SelectPos.y
    if key == "h" then
        CGameMap.ChangeType(x, y, 1)
        return
    end
    if key == "b" then
        CGameMap.ChangeType(x, y, 2)
        return
    end
    if key == "k" then
        CGameMap.ChangeType(x, y, 3)
        return
    end
    if key == "f" then
        CGameMap.ChangeType(x, y, 4)
        return
    end
    if key == "o" then
        CGameMap.ChangeType(x, y, 5)
        return
    end
    if key == "m" then
        CGameMap.ChangeType(x, y, 6)
        return
    end
    if key == "space" then
        CGameMap.ChangeBelong(x, y)
    end

    Operation.Select(x, y)
end

function Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
    -- 鼠标坐标转换为地图坐标
    local x, y = BasicMap.Pixel2Coordinate(pixelX, pixelY)
    local buttonName = Buttons.MouseState(pixelX, pixelY, 0)
    --说明鼠标点了按钮
    if buttonName ~= nil then
        return
    end
    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end
    print("mouse pressed")
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

function Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
    Buttons.MouseState(pixelX, pixelY, 2)
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

function Operation.Increase(x, y)
    local newRequest = {
        aimX = x,
        aimY = y
    }
    CGameMap.IncreaseOrDecrease(newRequest.aimX, newRequest.aimY, 1)
end

function Operation.Decrease(x, y)
    local newRequest = {
        aimX = x,
        aimY = y
    }
    CGameMap.IncreaseOrDecrease(newRequest.aimX, newRequest.aimY, 2)
end

function Operation.Update(mouseX, mouseY)
    Buttons.MouseState(mouseX, mouseY, 1)
end

return Operation
