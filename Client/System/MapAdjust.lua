MapAdjust = {}

local focusNeedUpdate = false

-- function MapAdjust.ChangeFocus(mouseState)
--     if
--         (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) and
--             love.mouse.isDown(1)
--      then
--         local x, y = love.mouse.getPosition()
--         local det = {}
--         det["X"] = x - mouseState["X"]
--         det["Y"] = y - mouseState["Y"]
--         mouseState["X"] = x
--         mouseState["Y"] = y
--         Focus["PixelX"] = Focus["PixelX"] + det["X"]
--         Focus["PixelY"] = Focus["PixelY"] + det["Y"]
--         focusNeedUpdate = true
--     elseif focusNeedUpdate then
--         -- update focusX,foucsY
--         focusNeedUpdate = false
--         local center = {}
--         center["PixelX"], center["PixelY"] = love.graphics.getDimensions()
--         center["PixelX"] = center["PixelX"] / 2
--         center["PixelY"] = center["PixelY"] / 2
--         local x, y =
--             CMap.Pixel2Coordinate(
--             center["PixelX"],
--             center["PixelY"],
--             Focus["X"],
--             Focus["Y"],
--             Focus["PixelX"],
--             Focus["PixelY"],
--             Radius
--         )
--         -- (x,y)<->(pixelX, pixelY)
--         local pixelX, pixelY =
--             CMap.Coordinate2Pixel(
--             x,
--             y,
--             Focus["X"],
--             Focus["Y"],
--             Focus["PixelX"],
--             Focus["PixelY"],
--             Radius
--         )
--         Focus["X"], Focus["Y"] = x, y
--         Focus["PixelX"], Focus["PixelY"] = pixelX, pixelY
--     end
--     return mouseState["X"], mouseState["Y"]
-- end

function MapAdjust.ChangeSize()
    BasicMap.edgeLength = BasicMap.edgeLength * BasicMap.ratio
    if BasicMap.edgeLength > 100 then
        BasicMap.edgeLength = 100
    end
    if BasicMap.edgeLength < 20 then
        BasicMap.edgeLength = 20
    end
    BasicMap.ratio = 1
    if
        (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) and
            (love.keyboard.isDown("0") or love.keyboard.isDown("kp0"))
     then
        BasicMap.edgeLength = 50
    end
end

function MapAdjust.Catchwheelmoved(x, y)
    if love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl") then
        BasicMap.ratio = math.abs(y)
        if y > 0 then
            BasicMap.ratio = 1.1 ^ BasicMap.ratio
        elseif y < 0 then
            BasicMap.ratio = 0.9 ^ BasicMap.ratio
        end
    end
end

return MapAdjust
