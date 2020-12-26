Buttons = {}

ButtonsImag = {}

ClickFlag = 0

function ButtonsImag:Load()
    self.position_last = {}
    self.position_pause = {}
    self.position_next = {}
    self.position_shift_speed = {}
    self.position_last.imag =
        love.graphics.newImage("data/Picture/NODE_TYPE_BLANK.png")
    self.position_pause.imag =
        love.graphics.newImage("data/Picture/NODE_TYPE_HILL.png")
    self.position_next.imag =
        love.graphics.newImage("data/Picture/NODE_TYPE_FORT.png")
    self.position_shift_speed.imag =
        love.graphics.newImage("data/Picture/NODE_TYPE_KING.png")
    self.position_last.x = 400
    self.position_last.y = 10
    self.position_last.scalingcenter = 0
    self.position_pause.x = 500
    self.position_pause.y = 10
    self.position_pause.scalingcenter = 0
    self.position_next.x = 600
    self.position_next.y = 10
    self.position_next.scalingcenter = 0
    self.position_shift_speed.x = 700
    self.position_shift_speed.y = 10
    self.position_shift_speed.scalingcenter = 0
    self.position_last.name = "last"
    self.position_pause.name = "pause"
    self.position_next.name = "next"
    self.position_shift_speed.name = "shiftspeed"
    self.ratio = 0.2
    self.diaphaneity = 0.5
    self.offset = 25
end

function Buttons:Init()
    ButtonsImag:Load()
end

-- function ButtonsImag:ButtonsPosition()
--     self.center = {}
--     self.center.x = 300
--     self.center.y = 0
-- end

function Buttons:DrawButtons()
    love.graphics.setColor(1, 1, 1, ButtonsImag.diaphaneity)

    -- local a = love.graphics.newImage("data/Picture/NODE_TYPE_HILL.png")
    love.graphics.draw(
        ButtonsImag.position_last.imag,
        ButtonsImag.position_last.x,
        ButtonsImag.position_last.y,
        0,
        ButtonsImag.ratio,
        ButtonsImag.ratio,
        ButtonsImag.offset,
        -ButtonsImag.offset,
        ButtonsImag.position_last.scalingcenter,
        ButtonsImag.position_last.scalingcenter
    )
    love.graphics.draw(
        ButtonsImag.position_next.imag,
        ButtonsImag.position_next.x,
        ButtonsImag.position_next.y,
        0,
        ButtonsImag.ratio,
        ButtonsImag.ratio,
        ButtonsImag.offset,
        -ButtonsImag.offset,
        ButtonsImag.position_next.scalingcenter,
        ButtonsImag.position_next.scalingcenter
    )
    love.graphics.draw(
        ButtonsImag.position_pause.imag,
        ButtonsImag.position_pause.x,
        ButtonsImag.position_pause.y,
        0,
        ButtonsImag.ratio,
        ButtonsImag.ratio,
        ButtonsImag.offset,
        -ButtonsImag.offset,
        ButtonsImag.position_pause.scalingcenter,
        ButtonsImag.position_pause.scalingcenter
    )
    love.graphics.draw(
        ButtonsImag.position_shift_speed.imag,
        ButtonsImag.position_shift_speed.x,
        ButtonsImag.position_shift_speed.y,
        0,
        ButtonsImag.ratio,
        ButtonsImag.ratio,
        ButtonsImag.offset,
        -ButtonsImag.offset,
        ButtonsImag.position_shift_speed.scalingcenter,
        ButtonsImag.position_shift_speed.scalingcenter
    )
    -- ClickFlag = 0
    -- ButtonsImag.scalingcenter = 0
end

function ButtonsImag:ClickedDraw(button)
    print(button.name)
    button.scalingcenter = 0.2

    -- love.graphics.setColor(1, 0, 0, 1)
    -- love.graphics.draw(
    --     button.imag,
    --     button.x,
    --     button.y,
    --     0,
    --     ButtonsImag.ratio + 0.2,
    --     ButtonsImag.ratio + 0.2
    -- )
    return button.name
end

function Buttons:ButtonsClick(mouseX, mouseY)
    local name
    if
        mouseX > ButtonsImag.position_last.x and
            mouseX < ButtonsImag.position_last.x + 50 and
            mouseY > ButtonsImag.position_last.y and
            mouseY < ButtonsImag.position_last.y + 50
     then
        name = ButtonsImag:ClickedDraw(ButtonsImag.position_last)
    elseif
        mouseX > ButtonsImag.position_pause.x and
            mouseX < ButtonsImag.position_pause.x + 50 and
            mouseY > ButtonsImag.position_pause.y and
            mouseY < ButtonsImag.position_pause.y + 50
     then
        name = ButtonsImag:ClickedDraw(ButtonsImag.position_pause)
    elseif
        mouseX > ButtonsImag.position_next.x and
            mouseX < ButtonsImag.position_next.x + 50 and
            mouseY > ButtonsImag.position_next.y and
            mouseY < ButtonsImag.position_next.y + 50
     then
        name = ButtonsImag:ClickedDraw(ButtonsImag.position_next)
    elseif
        mouseX > ButtonsImag.position_shift_speed.x and
            mouseX < ButtonsImag.position_shift_speed.x + 50 and
            mouseY > ButtonsImag.position_shift_speed.y and
            mouseY < ButtonsImag.position_shift_speed.y + 50
     then
        name = ButtonsImag:ClickedDraw(ButtonsImag.position_shift_speed)
    end
    return name
end

function Buttons:ButtonsRelease()
    ButtonsImag.position_last.scalingcenter = 0
    ButtonsImag.position_pause.scalingcenter = 0
    ButtonsImag.position_next.scalingcenter = 0
    ButtonsImag.position_shift_speed.scalingcenter = 0
end

return Buttons
