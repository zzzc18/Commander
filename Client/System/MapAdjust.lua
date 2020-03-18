MapAdjust = {}

MapAdjust.focusNeedUpdate = false
MapAdjust.mousePrePos = nil

function MapAdjust.ChangeFocusUpdate()
    if MapAdjust.mousePrePos == nil then
        return
    end
    if
        (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) and
            love.mouse.isDown(1)
     then
        local x, y = love.mouse.getPosition()
        local det = {}
        det.x = x - MapAdjust.mousePrePos.x
        det.y = y - MapAdjust.mousePrePos.y
        BasicMap.Focus.pixelX = BasicMap.Focus.pixelX + det.x
        BasicMap.Focus.pixelY = BasicMap.Focus.pixelY + det.y
        MapAdjust.focusNeedUpdate = true
    elseif MapAdjust.focusNeedUpdate then
        -- update focusX,foucsY
        MapAdjust.focusNeedUpdate = false
        local center = {}
        center.pixelX, center.pixelY = love.graphics.getDimensions()
        center.pixelX, center.pixelY = center.pixelX / 2, center.pixelY / 2
        local x, y = BasicMap.Pixel2Coordinate(center.pixelX, center.pixelY)

        -- (x,y)<->(pixelX, pixelY)
        local pixelX, pixelY = BasicMap.Coordinate2Pixel(x, y)
        BasicMap.Focus.x, BasicMap.Focus.y = x, y
        BasicMap.Focus.pixelX, BasicMap.Focus.pixelY = pixelX, pixelY
    end
end

function MapAdjust.ChangeSizeUpdate()
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

function MapAdjust.Update()
    MapAdjust.ChangeSizeUpdate()
    MapAdjust.ChangeFocusUpdate()
    if
        (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) and
            love.mouse.isDown(1)
     then
        MapAdjust.mousePrePos = {}
        MapAdjust.mousePrePos.x, MapAdjust.mousePrePos.y =
            love.mouse.getPosition()
    else
        MapAdjust.mousePrePos = nil
    end
end

return MapAdjust
