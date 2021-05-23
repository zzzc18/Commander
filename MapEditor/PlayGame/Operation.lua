local Operation = {}

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
        Debug.Log("info", "Saved")
        return
    end

    if Operation.SelectPos == nil then
        return
    end

    local x = Operation.SelectPos.x
    local y = Operation.SelectPos.y
    if key == "h" then
        CGameMap.ChangeType(x, y, 1)
        Debug.Log("info", string.format("Change %d,%d to HILL type", x, y))
        return
    end
    if key == "b" then
        CGameMap.ChangeType(x, y, 2)
        Debug.Log("info", string.format("Change %d,%d to BLANK type", x, y))
        return
    end
    if key == "k" then
        CGameMap.ChangeType(x, y, 3)
        Debug.Log("info", string.format("Change %d,%d to KING type", x, y))
        return
    end
    if key == "f" then
        CGameMap.ChangeType(x, y, 4)
        Debug.Log("info", string.format("Change %d,%d to FORT type", x, y))
        return
    end
    if key == "o" then
        CGameMap.ChangeType(x, y, 5)
        Debug.Log("info", string.format("Change %d,%d to OBSTACLE type", x, y))
        return
    end
    if key == "m" then
        CGameMap.ChangeType(x, y, 6)
        Debug.Log("info", string.format("Change %d,%d to MARSH type", x, y))
        return
    end
    if key == "space" then
        CGameMap.ChangeBelong(x, y, Color.colorNum)
        if CGameMap.GetNodeType(x, y) ~= "NODE_TYPE_HILL" then
            Debug.Log("info", string.format("Change the belong of %d,%d", x, y))
        end
    end

    Operation.Select(x, y)
end

function Operation.CatchMousePressed(pixelX, pixelY, button, istouch, presses)
    -- 鼠标坐标转换为地图坐标
    local x, y = BasicMap.Pixel2Coordinate(pixelX, pixelY)
    -- 说明鼠标点的位置不在地图中
    if x == -1 and y == -1 then
        return
    end
    if Operation.SelectPos ~= nil then
        if Operation.SelectPos.x == x and Operation.SelectPos.y == y then -- 再次选择了已选位置
            -- Operation.Select(x, y)
            --print(string.format("Current select: %d,%d", Operation.SelectPos.x, Operation.SelectPos.y))
            if button == 1 then
                Operation.Increase(x, y)
                Debug.Log("info", string.format("Increase 1 at %d,%d", x, y))
            elseif button == 2 then
                Operation.Decrease(x, y)
                Debug.Log("info", string.format("Decrease 1 at %d,%d", x, y))
            end
        else
            Operation.Select(x, y)
        end
    else
        Operation.Select(x, y)
    end
end

function Operation.CatchMouseReleased(pixelX, pixelY, button, istouch, presses)
end

function Operation.DrawSelect()
    if Operation.SelectPos == nil then
        return
    end
    local pixelX, pixelY = BasicMap.Coordinate2Pixel(Operation.SelectPos.x, Operation.SelectPos.y)
    Picture.DrawSelect(pixelX, pixelY)
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
end

return Operation
