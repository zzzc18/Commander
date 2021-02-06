Buttons = {}

Buttons.ButtonsNum = 5

EachButton = {}

IsPause = false

function Buttons.Init()
    EachButton:Load()
end

function EachButton.NewButton(path, name, x, y, ratio)
    local button = {}
    button.imag = love.graphics.newImage(path)
    button.name = name
    button.x = x
    button.y = y
    button.ratio = ratio
    button.offset = 25
    button.scalingcenterX = 0
    button.scalingcenterY = 0
    button.diaphaneity = EachButton.initialDiaphaneity
    return button
end

function EachButton:Load()
    self[1] = EachButton.NewButton("data/Picture/BUTTON_TYPE_LAST.png", "last", 300, 0, self.initialRatio)
    self[2] = EachButton.NewButton("data/Picture/BUTTON_TYPE_PAUSE.png", "pause", 400, 0, self.initialRatio)
    self[3] = EachButton.NewButton("data/Picture/BUTTON_TYPE_CONTINUE.png", "continue", 400, 0, self.initialRatio)
    self[4] = EachButton.NewButton("data/Picture/BUTTON_TYPE_NEXT.png", "next", 500, 0, self.initialRatio)
    self[5] = EachButton.NewButton("data/Picture/BUTTON_TYPE_SHIFTSPEED.png", "shift_speed", 700, 0, self.initialRatio)
    self.initialRatio = 0.2
    self.laterRatio = 0.25
    self.initialDiaphaneity = 0.5
    self.laterDiaphaneity = 1
end

function Buttons.DrawButtons()
    for i = 1, Buttons.ButtonsNum do
        if true == IsPause and 2 == i or false == IsPause and 3 == i then
        else
            love.graphics.setColor(1, 1, 1, EachButton[i].diaphaneity)
            love.graphics.draw(
                EachButton[i].imag,
                EachButton[i].x,
                EachButton[i].y,
                0,
                EachButton[i].ratio,
                EachButton[i].ratio,
                EachButton[i].offset,
                -EachButton[i].offset,
                EachButton[i].scalingcenterX,
                EachButton[i].scalingcenterY
            )
            EachButton[i].ratio = EachButton.initialRatio
        end
    end
end

-- mode==0时为点击，1为悬浮,2为松开
function Buttons.MouseState(mouseX, mouseY, mode)
    local name = nil
    local inButton = false
    for i = 1, Buttons.ButtonsNum do
        if 2 == i and true == IsPause then
            i = i + 1
        end
        if 3 == i and false == IsPause then
            i = i + 1
        end
        if
            mouseX > EachButton[i].x and mouseX < EachButton[i].x + 50 and mouseY > EachButton[i].y and
                mouseY < EachButton[i].y + 50
         then
            inButton = true
            if 0 == mode then
                EachButton[i].diaphaneity = EachButton.laterDiaphaneity
                name = "readyToClick"
                break
            elseif 1 == mode then
                EachButton:MouseSuspension(EachButton[i])
                break
            elseif 2 == mode then
                name = EachButton:ButtonsRelease(EachButton[i])
                break
            end
        end
    end
    if not inButton then
        EachButton:CleanAll()
    end
    return name
end

function EachButton:CleanAll()
    for i = 1, Buttons.ButtonsNum do
        EachButton[i].diaphaneity = EachButton.initialDiaphaneity
    end
end

function EachButton:ButtonsRelease(button)
    button.diaphaneity = EachButton.initialDiaphaneity
    if button == EachButton[2] then
        IsPause = true
    elseif button == EachButton[3] then
        IsPause = false
    end
    print(button.name)
    return button.name
end

function EachButton:MouseSuspension(button)
    button.ratio = EachButton.laterRatio
end

return Buttons
