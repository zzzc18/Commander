Buttons = {}

EachButton = {}
ButtonsBasic = {}
ButtonsData = {}

IsPause = false

function Buttons.Init()
    if Welcome == Running then
        --
        return
    end
    if PlayGame == Running then
        -- ButtonsBasic:Load()
        return
    end
    if ReplayGame == Running then
        ButtonsBasic:Load()
        return
    end
end

function Buttons.DeInit()
    EachButton = {}
    ButtonsData = {}
    IsPause = false
end

--orientation:旋转角度;  ratioX,ratioY:X,Y方向上的缩放比例;  diaphaneity:透明度;  offsetX,offsetY:偏移量（默认0）;  scalingcenterX,scalingcenterY:？？（默认0）
function Buttons.NewButton(
    path,
    name,
    x,
    y,
    orientation,
    ratioX,
    ratioY,
    diaphaneity,
    offsetX,
    offsetY,
    scalingcenterX,
    scalingcenterY)
    local button = {}
    button.imag = love.graphics.newImage(path)
    button.name = name
    button.x = x
    button.y = y
    button.orientation = orientation
    button.ratioX = ratioX
    button.ratioY = ratioY
    button.diaphaneity = diaphaneity
    if nil == offsetX then
        button.offsetX = 0
    else
        button.offsetX = offsetX
    end
    if nil == offsetY then
        button.offsetY = 0
    else
        button.offsetY = offsetY
    end
    if nil == scalingcenterX then
        button.scalingcenterX = 0
    else
        button.scalingcenterX = scalingcenterX
    end
    if nil == scalingcenterY then
        button.scalingcenterY = 0
    else
        button.scalingcenterY = scalingcenterY
    end
    table.insert(EachButton, button)
end

function ButtonsBasic:Load()
    if Welcome == Running then
        return
    end
    if PlayGame == Running then
        return
    end
    if ReplayGame == Running then
        local windowWidth, windowHeight = love.graphics.getDimensions()
        ButtonsData.initialRatio = 0.2
        ButtonsData.laterRatio = 0.25
        ButtonsData.initialDiaphaneity = 0.5
        ButtonsData.laterDiaphaneity = 1
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_LAST.png",
            "last",
            windowWidth * 0.35,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            ButtonsData.initialDiaphaneity,
            -20,
            -20
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_PAUSE.png",
            "pause",
            windowWidth * 0.45,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            ButtonsData.initialDiaphaneity,
            -20,
            -20
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_CONTINUE.png",
            "continue",
            windowWidth * 0.45,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            ButtonsData.initialDiaphaneity,
            -20,
            -20
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_NEXT.png",
            "next",
            windowWidth * 0.55,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            ButtonsData.initialDiaphaneity,
            -20,
            -20
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_SHIFTSPEED.png",
            "shiftSpeed",
            windowWidth * 0.65,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            ButtonsData.initialDiaphaneity,
            -20,
            -20
        )
    end
end

function Buttons.DrawButtons()
    if Welcome == Running then
        return
    end
    if PlayGame == Running then
        return
    end
    if ReplayGame == Running then
        for i, button in pairs(EachButton) do
            if true == IsPause and "pause" == button.name or false == IsPause and "continue" == button.name then
            else
                love.graphics.setColor(1, 1, 1, button.diaphaneity)
                love.graphics.draw(
                    button.imag,
                    button.x,
                    button.y,
                    button.orientation,
                    button.ratioX,
                    button.ratioY,
                    button.offsetX,
                    button.offsetY,
                    button.scalingcenterX,
                    button.scalingcenterY
                )
                button.ratioX = ButtonsData.initialRatio
                button.ratioY = ButtonsData.initialRatio
            end
        end
    end
end

-- mode==0时为点击，1为悬浮,2为松开
function Buttons.MouseState(mouseX, mouseY, mode)
    if Welcome == Running then
        return
    end
    if PlayGame == Running then
        return
    end
    if ReplayGame == Running then
        local name = nil
        local inButton = false
        for i, button in pairs(EachButton) do
            if true == IsPause and "pause" == button.name or false == IsPause and "continue" == button.name then
            else
                if
                    mouseX > button.x and mouseX < button.x + 63 * love.graphics.getWidth() / 1080 and mouseY > button.y and
                        mouseY < button.y + 63 * love.graphics.getWidth() / 1080
                 then
                    inButton = true
                    if 0 == mode then
                        button.diaphaneity = ButtonsData.laterDiaphaneity
                        name = "readyToClick"
                        break
                    elseif 1 == mode then
                        ButtonsBasic:MouseSuspension(button)
                        break
                    elseif 2 == mode then
                        name = ButtonsBasic:ButtonsRelease(button)
                        break
                    end
                end
            end
        end
        if not inButton then
            ButtonsBasic:CleanAll()
        end
        return name
    end
end

function ButtonsBasic:CleanAll()
    for i, button in pairs(EachButton) do
        button.diaphaneity = ButtonsData.initialDiaphaneity
    end
end

function ButtonsBasic:ButtonsRelease(button)
    button.diaphaneity = ButtonsData.initialDiaphaneity
    if "pause" == button.name then
        IsPause = true
    elseif "continue" == button.name then
        IsPause = false
    end
    print(button.name)
    return button.name
end

function ButtonsBasic:MouseSuspension(button)
    button.ratioX = ButtonsData.laterRatio * love.graphics.getWidth() / 1080
    button.ratioY = ButtonsData.laterRatio * love.graphics.getWidth() / 1080
end

function Buttons.Update()
    if Welcome == Running then
        return
    end
    if PlayGame == Running then
        return
    end
    if ReplayGame == Running then
        local windowWidth = love.graphics.getWidth()
        for i, button in pairs(EachButton) do
            if 1 == i or 2 == i then
                button.x = windowWidth * (i * 0.1 + 0.25)
            else
                button.x = windowWidth * (i * 0.1 + 0.15)
            end
            button.ratioX = ButtonsData.initialRatio * windowWidth / 1080
            button.ratioY = ButtonsData.initialRatio * windowWidth / 1080
        end
        Buttons.MouseState(love.mouse.getX(), love.mouse.getY(), 1)
        return
    end
end

return Buttons
