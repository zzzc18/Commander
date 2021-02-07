Buttons = {}

EachButton = {}
ButtonsBasic = {}

IsPause = false

function Buttons.Init()
    ButtonsBasic:Load()
end

function ButtonsBasic:NewButton(path, name, x, y)
    local button = {}
    button.imag = love.graphics.newImage(path)
    button.name = name
    button.x = x
    button.y = y
    button.ratio = self.ratio
    button.offset = -20
    button.scalingcenterX = 0
    button.scalingcenterY = 0
    button.diaphaneity = self.initialDiaphaneity
    return button
end

function ButtonsBasic:Load()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    EachButton.Last = ButtonsBasic:NewButton("data/Picture/BUTTON_TYPE_LAST.png", "last", windowWidth * 0.35, windowHeight * 0)
    EachButton.Pause =
        ButtonsBasic:NewButton("data/Picture/BUTTON_TYPE_PAUSE.png", "pause", windowWidth * 0.45, windowHeight * 0)
    EachButton.Continue =
        ButtonsBasic:NewButton("data/Picture/BUTTON_TYPE_CONTINUE.png", "continue", windowWidth * 0.45, windowHeight * 0)
    EachButton.Next = ButtonsBasic:NewButton("data/Picture/BUTTON_TYPE_NEXT.png", "next", windowWidth * 0.55, windowHeight * 0)
    EachButton.ShiftSpeed =
        ButtonsBasic:NewButton("data/Picture/BUTTON_TYPE_SHIFTSPEED.png", "shiftSpeed", windowWidth * 0.65, windowHeight * 0)
    self.initialRatio = 0.2
    self.laterRatio = 0.25
    self.initialDiaphaneity = 0.5
    self.laterDiaphaneity = 1
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
                0,
                button.ratio,
                button.ratio,
                button.offset,
                button.offset,
                button.scalingcenterX,
                button.scalingcenterY
            )
            button.ratio = ButtonsBasic.initialRatio
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
    button.ratio = self.laterRatio * love.graphics.getWidth() / 1080
end

function Buttons.Update()
    local windowWidth = love.graphics.getWidth()
    EachButton.Last.x = windowWidth * 0.35
    EachButton.Pause.x = windowWidth * 0.45
    EachButton.Continue.x = windowWidth * 0.45
    EachButton.Next.x = windowWidth * 0.55
    EachButton.ShiftSpeed.x = windowWidth * 0.65
    for i, button in pairs(EachButton) do
        button.ratio = ButtonsBasic.initialRatio * windowWidth / 1080
    end
    Buttons.MouseState(love.mouse.getX(), love.mouse.getY(), 1)
end

return Buttons
