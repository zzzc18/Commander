local Operation = {}

Operation.stateKey = {
    lshift = false,
    lctrl = false,
    lalt = false,
    rshift = false,
    rctrl = false,
    ralt = false,
    application = false
}

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

    if
        key == "lshift" or key == "lctrl" or key == "lalt" or key == "rshift" or key == "rctrl" or key == "ralt" or
            key == "application"
     then
        Operation.stateKey[key] = true
    end

    if (Operation.stateKey["lctrl"] or Operation.stateKey["rctrl"]) and key == "s" then
        CGameMap.SaveEdit()
        Debug.Log("info", "Saved")
        return
    end

    Operation.ResizeMap(key)

    if Operation.SelectPos == nil then
        return
    end

    local x = Operation.SelectPos.x
    local y = Operation.SelectPos.y
    if key == "h" then
        CGameMap.ChangeType(x, y, 1)
        Debug.Log("info", string.format("Change %d,%d to HILL type", x, y))
    elseif key == "b" then
        CGameMap.ChangeType(x, y, 2)
        Debug.Log("info", string.format("Change %d,%d to BLANK type", x, y))
    elseif key == "k" then
        CGameMap.ChangeType(x, y, 3)
        Debug.Log("info", string.format("Change %d,%d to KING type", x, y))
    elseif key == "f" then
        CGameMap.ChangeType(x, y, 4)
        Debug.Log("info", string.format("Change %d,%d to FORT type", x, y))
    elseif key == "m" then
        CGameMap.ChangeType(x, y, 6)
        Debug.Log("info", string.format("Change %d,%d to MARSH type", x, y))
    elseif key == "space" then
        CGameMap.ChangeBelong(x, y, Color.colorNum)
        if CGameMap.GetNodeType(x, y) ~= "NODE_TYPE_HILL" then
            Debug.Log("info", string.format("Change the belong of %d,%d", x, y))
        end
    end
    -- elseif if key == "o" then
    --     CGameMap.ChangeType(x, y, 5)  --禁用obstacle，调了也没用
    --     Debug.Log("info", string.format("Change %d,%d to OBSTACLE type", x, y))

    Operation.Select(x, y)
end

function Operation.CatchKeyreleased(key)
    if
        key == "lshift" or key == "lctrl" or key == "lalt" or key == "rshift" or key == "rctrl" or key == "ralt" or
            key == "application"
     then
        Operation.stateKey[key] = false
    end
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
                if Operation.stateKey["lctrl"] or Operation.stateKey["rctrl"] then
                    for i = 1, 10 do
                        Operation.Increase(x, y)
                    end
                    Debug.Log("info", string.format("Increase 10 at %d,%d", x, y))
                else
                    Operation.Increase(x, y)
                    Debug.Log("info", string.format("Increase 1 at %d,%d", x, y))
                end
            elseif button == 2 then
                if Operation.stateKey["lctrl"] or Operation.stateKey["rctrl"] then
                    for i = 1, 10 do
                        Operation.Decrease(x, y)
                    end
                    Debug.Log("info", string.format("Decrease 10 at %d,%d", x, y))
                else
                    Operation.Decrease(x, y)
                    Debug.Log("info", string.format("Decrease 1 at %d,%d", x, y))
                end
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

function Operation.ResizeMap(key)
    if not (key == "w" or key == "s" or key == "a" or key == "d") then
        return
    end
    if Operation.stateKey["lalt"] or Operation.stateKey["ralt"] then
        CGameMap.ResizeMap(key, 1)
        Debug.Log("info", "Enlarge map")
    end
    if Operation.stateKey["lshift"] or Operation.stateKey["rshift"] then
        CGameMap.ResizeMap(key, 0)
        Debug.Log("info", "Shrink map")
    end
    BasicMap.Init()
    Operation.SelectPos = nil
end

function Operation.Update(mouseX, mouseY)
    -- print(BasicMap.MapSize.x, BasicMap.MapSize.y)
end

return Operation
