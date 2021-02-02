Buttons = {}

EachButton = {}

IsPause = false

function EachButton:Load()
    self.button_last = {}
    self.button_pause = {}
    self.button_continue = {}
    self.button_next = {}
    self.button_shift_speed = {}
    self.button_last.imag = love.graphics.newImage("data/Picture/BUTTON_TYPE_LAST.png")
    self.button_pause.imag = love.graphics.newImage("data/Picture/BUTTON_TYPE_PAUSE.png")
    self.button_continue.imag = love.graphics.newImage("data/Picture/BUTTON_TYPE_CONTINUE.png")
    self.button_next.imag = love.graphics.newImage("data/Picture/BUTTON_TYPE_NEXT.png")
    self.button_shift_speed.imag = love.graphics.newImage("data/Picture/BUTTON_TYPE_SHIFTSPEED.png")
    self.button_last.x = 400
    self.button_last.y = 0
    self.button_last.ratio = self.initialRatio
    self.button_last.scalingcenter = 0
    self.button_last.diaphaneity = 0.5
    self.button_pause.x = 500
    self.button_pause.y = 0
    self.button_pause.ratio = self.initialRatio
    self.button_pause.scalingcenter = 0
    self.button_pause.diaphaneity = 0.5
    self.button_continue.x = 500
    self.button_continue.y = 0
    self.button_continue.ratio = self.initialRatio
    self.button_continue.scalingcenter = 0
    self.button_continue.diaphaneity = 0.5
    self.button_next.x = 600
    self.button_next.y = 0
    self.button_next.ratio = self.initialRatio
    self.button_next.scalingcenter = 0
    self.button_next.diaphaneity = 0.5
    self.button_shift_speed.x = 800
    self.button_shift_speed.y = 0
    self.button_shift_speed.ratio = self.initialRatio
    self.button_shift_speed.scalingcenter = 0
    self.button_shift_speed.diaphaneity = 0.5
    self.button_last.name = "last"
    self.button_pause.name = "pause"
    self.button_continue.name = "continue"
    self.button_next.name = "next"
    self.button_shift_speed.name = "shift speed"
    self.offset = 25
    self.initialRatio = 0.2
    self.laterRatio = 0.25
end

function Buttons.Init()
    EachButton:Load()
end

function Buttons.DrawButtons()
    love.graphics.setColor(1, 1, 1, EachButton.button_last.diaphaneity)
    love.graphics.draw(
        EachButton.button_last.imag,
        EachButton.button_last.x,
        EachButton.button_last.y,
        0,
        EachButton.button_last.ratio,
        EachButton.button_last.ratio,
        EachButton.offset,
        -EachButton.offset,
        EachButton.button_last.scalingcenter,
        EachButton.button_last.scalingcenter
    )
    EachButton.button_last.ratio = EachButton.initialRatio
    love.graphics.setColor(1, 1, 1, EachButton.button_next.diaphaneity)
    love.graphics.draw(
        EachButton.button_next.imag,
        EachButton.button_next.x,
        EachButton.button_next.y,
        0,
        EachButton.button_next.ratio,
        EachButton.button_next.ratio,
        EachButton.offset,
        -EachButton.offset,
        EachButton.button_next.scalingcenter,
        EachButton.button_next.scalingcenter
    )
    EachButton.button_next.ratio = EachButton.initialRatio
    if IsPause == false then
        love.graphics.setColor(1, 1, 1, EachButton.button_pause.diaphaneity)
        love.graphics.draw(
            EachButton.button_pause.imag,
            EachButton.button_pause.x,
            EachButton.button_pause.y,
            0,
            EachButton.button_pause.ratio,
            EachButton.button_pause.ratio,
            EachButton.offset,
            -EachButton.offset,
            EachButton.button_pause.scalingcenter,
            EachButton.button_pause.scalingcenter
        )
        EachButton.button_pause.ratio = EachButton.initialRatio
    else
        love.graphics.setColor(1, 1, 1, EachButton.button_continue.diaphaneity)
        love.graphics.draw(
            EachButton.button_continue.imag,
            EachButton.button_continue.x,
            EachButton.button_continue.y,
            0,
            EachButton.button_continue.ratio,
            EachButton.button_continue.ratio,
            EachButton.offset,
            -EachButton.offset,
            EachButton.button_continue.scalingcenter,
            EachButton.button_continue.scalingcenter
        )
        EachButton.button_continue.ratio = EachButton.initialRatio
    end
    love.graphics.setColor(1, 1, 1, EachButton.button_shift_speed.diaphaneity)
    love.graphics.draw(
        EachButton.button_shift_speed.imag,
        EachButton.button_shift_speed.x,
        EachButton.button_shift_speed.y,
        0,
        EachButton.button_shift_speed.ratio,
        EachButton.button_shift_speed.ratio,
        EachButton.offset,
        -EachButton.offset,
        EachButton.button_shift_speed.scalingcenter,
        EachButton.button_shift_speed.scalingcenter
    )
    EachButton.button_shift_speed.ratio = EachButton.initialRatio
end

function EachButton:ClickedDraw(button)
    button.diaphaneity = 1
    return button.name
end

-- mode==0时为点击，1为悬浮,2为松开
function Buttons.MouseState(mouseX, mouseY, mode)
    -- if mode ~= 1 then
    --     print(mode)
    -- end
    local name = nil
    if
        mouseX > EachButton.button_last.x and mouseX < EachButton.button_last.x + 50 and mouseY > EachButton.button_last.y and
            mouseY < EachButton.button_last.y + 50
     then
        if mode == 0 then
            name = EachButton:ClickedDraw(EachButton.button_last)
        elseif mode == 1 then
            EachButton:MouseSuspension(EachButton.button_last)
        else
            EachButton:ButtonsRelease(EachButton.button_last)
        end
    elseif
        mouseX > EachButton.button_pause.x and mouseX < EachButton.button_pause.x + 50 and mouseY > EachButton.button_pause.y and
            mouseY < EachButton.button_pause.y + 50
     then
        if mode == 0 then
            -- print(type(EachButton.button_continue))
            if IsPause == false then
                -- IsPause = true
                name = EachButton:ClickedDraw(EachButton.button_pause)
            else
                -- IsPause = false
                name = EachButton:ClickedDraw(EachButton.button_continue)
            end
        elseif mode == 1 then
            if IsPause == false then
                EachButton:MouseSuspension(EachButton.button_pause)
            else
                EachButton:MouseSuspension(EachButton.button_continue)
            end
        else
            if IsPause == false then
                EachButton:ButtonsRelease(EachButton.button_pause)
            else
                EachButton:ButtonsRelease(EachButton.button_continue)
            end
        end
    elseif
        mouseX > EachButton.button_next.x and mouseX < EachButton.button_next.x + 50 and mouseY > EachButton.button_next.y and
            mouseY < EachButton.button_next.y + 50
     then
        if mode == 0 then
            name = EachButton:ClickedDraw(EachButton.button_next)
        elseif mode == 1 then
            EachButton:MouseSuspension(EachButton.button_next)
        else
            EachButton:ButtonsRelease(EachButton.button_next)
        end
    elseif
        mouseX > EachButton.button_shift_speed.x and mouseX < EachButton.button_shift_speed.x + 50 and
            mouseY > EachButton.button_shift_speed.y and
            mouseY < EachButton.button_shift_speed.y + 50
     then
        if mode == 0 then
            name = EachButton:ClickedDraw(EachButton.button_shift_speed)
        elseif mode == 1 then
            EachButton:MouseSuspension(EachButton.button_shift_speed)
        else
            EachButton:ButtonsRelease(EachButton.button_shift_speed)
        end
    elseif mode == 2 then
        EachButton:ClearAll()
    end
    return name
end

function EachButton:ClearAll()
    EachButton.button_last.diaphaneity = 0.5
    EachButton.button_pause.diaphaneity = 0.5
    EachButton.button_continue.diaphaneity = 0.5
    EachButton.button_next.diaphaneity = 0.5
    EachButton.button_shift_speed.diaphaneity = 0.5
end

function EachButton:ButtonsRelease(button)
    button.diaphaneity = 0.5
    print(button.name)
    if button == EachButton.button_pause then
        IsPause = true
    elseif button == EachButton.button_continue then
        IsPause = false
    end
end

function EachButton:MouseSuspension(button)
    button.ratio = EachButton.laterRatio
end

return Buttons
