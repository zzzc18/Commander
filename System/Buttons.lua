Buttons = {}

EachButton = {}
ButtonsBasic = {}

IsPause = false

function Buttons.Init()
    ButtonsBasic:Load()
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
    return button
end

function ButtonsBasic:Load()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    self.initialRatio = 0.2
    self.laterRatio = 0.25
    self.initialDiaphaneity = 0.5
    self.laterDiaphaneity = 1
    EachButton.Last =
        Buttons.NewButton(
        "data/Picture/BUTTON_TYPE_LAST.png",
        "last",
        windowWidth * 0.35,
        windowHeight * 0,
        0,
        self.initialRatio,
        self.initialRatio,
        self.initialDiaphaneity,
        -20,
        -20
    )
    EachButton.Pause =
        Buttons.NewButton(
        "data/Picture/BUTTON_TYPE_PAUSE.png",
        "pause",
        windowWidth * 0.45,
        windowHeight * 0,
        0,
        self.initialRatio,
        self.initialRatio,
        self.initialDiaphaneity,
        -20,
        -20
    )
    EachButton.Continue =
        Buttons.NewButton(
        "data/Picture/BUTTON_TYPE_CONTINUE.png",
        "continue",
        windowWidth * 0.45,
        windowHeight * 0,
        0,
        self.initialRatio,
        self.initialRatio,
        self.initialDiaphaneity,
        -20,
        -20
    )
    EachButton.Next =
        Buttons.NewButton(
        "data/Picture/BUTTON_TYPE_NEXT.png",
        "next",
        windowWidth * 0.55,
        windowHeight * 0,
        0,
        self.initialRatio,
        self.initialRatio,
        self.initialDiaphaneity,
        -20,
        -20
    )
    EachButton.ShiftSpeed =
        Buttons.NewButton(
        "data/Picture/BUTTON_TYPE_SHIFTSPEED.png",
        "shiftSpeed",
        windowWidth * 0.65,
        windowHeight * 0,
        0,
        self.initialRatio,
        self.initialRatio,
        self.initialDiaphaneity,
        -20,
        -20
    )
end

function Buttons.DrawButtons()
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
            button.ratioX = ButtonsBasic.initialRatio
            button.ratioY = ButtonsBasic.initialRatio
        end
    end
end

-- mode==0时为点击，1为悬浮,2为松开
function Buttons.MouseState(mouseX, mouseY, mode)
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
                    button.diaphaneity = ButtonsBasic.laterDiaphaneity
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

function ButtonsBasic:CleanAll()
    for i, button in pairs(EachButton) do
        button.diaphaneity = self.initialDiaphaneity
    end
end

function ButtonsBasic:ButtonsRelease(button)
    button.diaphaneity = self.initialDiaphaneity
    if button == EachButton.Pause then
        IsPause = true
    elseif button == EachButton.Continue then
        IsPause = false
    end
    print(button.name)
    return button.name
end

function ButtonsBasic:MouseSuspension(button)
    button.ratioX = self.laterRatio * love.graphics.getWidth() / 1080
    button.ratioY = self.laterRatio * love.graphics.getWidth() / 1080
end

function Buttons.Update()
    local windowWidth = love.graphics.getWidth()
    EachButton.Last.x = windowWidth * 0.35
    EachButton.Pause.x = windowWidth * 0.45
    EachButton.Continue.x = windowWidth * 0.45
    EachButton.Next.x = windowWidth * 0.55
    EachButton.ShiftSpeed.x = windowWidth * 0.65
    for i, button in pairs(EachButton) do
        button.ratioX = ButtonsBasic.initialRatio * windowWidth / 1080
        button.ratioY = ButtonsBasic.initialRatio * windowWidth / 1080
    end
    Buttons.MouseState(love.mouse.getX(), love.mouse.getY(), 1)
end

return Buttons
