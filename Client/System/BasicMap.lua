BasicMap = {}

MapSize = {}

Focus = {}

function BasicMap.Coordinate2Pixel(x, y)
    -- local ret = {}
    -- ret["X"], ret["Y"] =
    --     CMap.Coordinate2Pixel(
    --     x,
    --     y,
    --     Focus["X"],
    --     Focus["Y"],
    --     Focus["PixelX"],
    --     Focus["PixelY"],
    --     Radius
    -- )
    -- return ret
end

function BasicMap.DrawMap()
    for i = 0, MapSize["X"] do
        for j = 0, MapSize["Y"] do
            Geometry.DrawNode(i, j)
        end
    end
end

local focusNeedUpdate = false

function BasicMap.ChangeFocus(mouseState)
    if
        (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) and
            love.mouse.isDown(1)
     then
        local x, y = love.mouse.getPosition()
        local det = {}
        det["X"] = x - mouseState["X"]
        det["Y"] = y - mouseState["Y"]
        mouseState["X"] = x
        mouseState["Y"] = y
        Focus["PixelX"] = Focus["PixelX"] + det["X"]
        Focus["PixelY"] = Focus["PixelY"] + det["Y"]
        focusNeedUpdate = true
    elseif focusNeedUpdate then
        -- update focusX,foucsY
        focusNeedUpdate = false
        local center = {}
        center["PixelX"], center["PixelY"] = love.graphics.getDimensions()
        center["PixelX"] = center["PixelX"] / 2
        center["PixelY"] = center["PixelY"] / 2
        local x, y =
            CMap.Pixel2Coordinate(
            center["PixelX"],
            center["PixelY"],
            Focus["X"],
            Focus["Y"],
            Focus["PixelX"],
            Focus["PixelY"],
            Radius
        )
        -- (x,y)<->(pixelX, pixelY)
        local pixelX, pixelY =
            CMap.Coordinate2Pixel(
            x,
            y,
            Focus["X"],
            Focus["Y"],
            Focus["PixelX"],
            Focus["PixelY"],
            Radius
        )
        Focus["X"], Focus["Y"] = x, y
        Focus["PixelX"], Focus["PixelY"] = pixelX, pixelY
    end
    return mouseState["X"], mouseState["Y"]
end

function BasicMap.ChangeSize()
    Radius = Radius * Ratio
    Ratio = 1
    if
        (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) and
            (love.keyboard.isDown("0") or love.keyboard.isDown("kp0"))
     then
        Radius = 50
    end
end

function BasicMap.Pixel2Coordinate(x, y)
    return CMap.Pixel2Coordinate(
        x,
        y,
        Focus["X"],
        Focus["Y"],
        Focus["PixelX"],
        Focus["PixelY"],
        Radius
    )
end

return BasicMap
