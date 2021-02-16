Buttons = {}

--存储各按钮
EachButton = {}
--存储按钮函数
ButtonsBasic = {}
--存储按钮数据
ButtonsData = {}

IsPause = false
IsClicked = false

function Buttons.Init()
    ButtonsBasic:Load()
end

function Buttons.DeInit()
    EachButton = {}
    ButtonsData = {}
    IsPause = false
    IsClicked = false
end

--orientation:旋转角度;
--ratioX,ratioY:X,Y方向上的缩放比例;
--diaphaneity:透明度;
--offsetX,offsetY:偏移量（默认0）;
--scalingcenterX,scalingcenterY:？？（默认0）
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
    scalingcenterY,
    color)
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
    if nil == color then
        button.color = {1, 1, 1, 1}
    else
        button.color = color
    end
    table.insert(EachButton, button)
end

function ButtonsBasic:Load()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    if Welcome == Running then
        local startImg = love.graphics.newImage("data/Picture/start.PNG")
        local replayImg = love.graphics.newImage("data/Picture/replay.PNG")
        ButtonsData.clickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.selectedColor = {0.7, 0.7, 0.7, 1}
        Buttons.NewButton(
            "data/Picture/start.PNG",
            "start",
            windowWidth / 2,
            windowHeight / 2,
            0,
            0.8,
            0.8,
            0,
            startImg:getWidth() / 2,
            startImg:getHeight() / 2
        )
        Buttons.NewButton(
            "data/Picture/replay.PNG",
            "replay",
            windowWidth / 2,
            windowHeight * 7 / 10,
            0,
            0.7,
            0.7,
            0,
            replayImg:getWidth() / 2,
            replayImg:getHeight() / 2
        )
        return
    end
    if PlayGame == Running then
        ButtonsData.clickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.selectedColor = {0.7, 0.7, 0.7, 1}
        ButtonsData.menuRatio = 0.63
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_MENU.png",
            "menu",
            windowWidth * 0.01,
            windowHeight * 0.01,
            0,
            ButtonsData.menuRatio,
            ButtonsData.menuRatio,
            1
        )
        return
    -- Buttons.NewButton()
    end
    if ReplayGame == Running then
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
            -20,
            0,
            0,
            {1, 1, 1}
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
            -20,
            0,
            0,
            {1, 1, 1}
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
            -20,
            0,
            0,
            {1, 1, 1}
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
            -20,
            0,
            0,
            {1, 1, 1}
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
            -20,
            0,
            0,
            {1, 1, 1}
        )
        ButtonsData.clickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.selectedColor = {0.7, 0.7, 0.7, 1}
        ButtonsData.menuRatio = 0.63
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_MENU.png",
            "menu",
            windowWidth * 0.01,
            windowHeight * 0.01,
            0,
            ButtonsData.menuRatio,
            ButtonsData.menuRatio,
            1
        )
        return
    end
    if GameOver == Running then
        ButtonsData.optionRatio = 0.5
        ButtonsData.clickedColor = {0.867, 0.627, 0.867, 0.68}
        ButtonsData.selectedColor = {0.7, 0.7, 0.7, 1}
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_PLAYAGAIN.PNG",
            "play again",
            445,
            290,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio,
            1
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_WATCHREPLAY.PNG",
            "watch replay",
            445,
            370,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio,
            1
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_EXIT.PNG",
            "exit",
            445,
            450,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio,
            1
        )
        return
    end
end

function Buttons.DrawButtons()
    if Welcome == Running then
        for i, button in pairs(EachButton) do
            love.graphics.setColor(button.color)
            love.graphics.draw(
                button.imag,
                button.x,
                button.y,
                button.orientation,
                button.ratioX,
                button.ratioY,
                button.offsetX,
                button.offsetY
            )
        end
        return
    end
    if PlayGame == Running then
        if "Start" == PlayGame.GameState then
            for i, button in pairs(EachButton) do
                love.graphics.setColor(button.color)
                love.graphics.draw(
                    button.imag,
                    button.x,
                    button.y,
                    button.orientation,
                    button.ratioX,
                    button.ratioY,
                    button.offsetX,
                    button.offsetY
                )
            end
            return
        end
        if "Menu" == PlayGame.GameState then
        end
    end
    if ReplayGame == Running then
        for i, button in pairs(EachButton) do
            if true == IsPause and "pause" == button.name or false == IsPause and "continue" == button.name then
            else
                if "menu" == button.name then
                    print("###")
                end
                table.insert(button.color, button.diaphaneity)
                love.graphics.setColor(button.color)
                table.remove(button.color, 4)
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
            end
        end
        return
    end
    if GameOver == Running then
        for i, button in pairs(EachButton) do
            love.graphics.setColor(button.color)
            love.graphics.draw(
                button.imag,
                button.x,
                button.y,
                button.orientation,
                button.ratioX,
                button.ratioY,
                button.offsetX,
                button.offsetY
            )
        end
        return
    end
end

-- mode==0时为点击，1为悬浮,2为松开
function Buttons.MouseState(mouseX, mouseY, mode)
    if Welcome == Running then
        local name
        local inButton = false
        for i, button in pairs(EachButton) do
            if
                mouseX >= button.x - button.offsetX and mouseX <= button.x + button.offsetX and
                    mouseY >= button.y - button.offsetY and
                    mouseY <= button.y + button.offsetY
             then
                inButton = true
                if 0 == mode then
                    ButtonsBasic:ChangeColor(button, ButtonsData.clickedColor)
                    break
                end
                if 1 == mode and not love.mouse.isDown(1) then
                    ButtonsBasic:ChangeColor(button, ButtonsData.selectedColor)
                    break
                end
                if 2 == mode then
                    name = ButtonsBasic:ButtonsRelease(button)
                    break
                end
            end
        end
        if not inButton then
            ButtonsBasic:ChangeColor()
        end
        return name
    end
    if PlayGame == Running then
        local name
        local inButton = false
        if "Start" == PlayGame.GameState then
            for i, button in pairs(EachButton) do
                if
                    mouseX > button.x and mouseX < button.x + 63 * love.graphics.getWidth() / 1080 and mouseY > button.y and
                        mouseY < button.y + 63 * love.graphics.getWidth() / 1080
                 then
                    inButton = true
                    if 0 == mode then
                        name = "Clicked"
                        ButtonsBasic:ChangeColor(button, ButtonsData.clickedColor)
                    elseif 1 == mode and not love.mouse.isDown(1) then
                        ButtonsBasic:ChangeColor(button, ButtonsData.selectedColor)
                    elseif 2 == mode then
                        name = ButtonsBasic:ButtonsRelease(button)
                    end
                    break
                end
            end
        elseif "Menu" == PlayGame.GameState then
        end
        if not inButton then
            ButtonsBasic:ChangeColor()
        end
        return name
    end
    if ReplayGame == Running then
        local name
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
                    elseif 1 == mode then
                        ButtonsBasic:MouseSuspension(button)
                    elseif 2 == mode then
                        name = ButtonsBasic:ButtonsRelease(button)
                    end
                    break
                end
            end
        end
        if not inButton then
            ButtonsBasic:ChangeColor()
            for i, button in pairs(EachButton) do
                button.ratioX = ButtonsData.initialRatio
                button.ratioY = ButtonsData.initialRatio
            end
        end
        return name
    end
    if GameOver == Running then
        local name
        local inButton = false

        for i, button in pairs(EachButton) do
            if
                mouseX > button.x and mouseX < button.x + 190 * love.graphics.getHeight() / 720 and mouseY > button.y and
                    mouseY < button.y + 70 * love.graphics.getHeight() / 720
             then
                inButton = true
                if 0 == mode then
                    IsClicked = true
                    ButtonsBasic:ChangeColor(button, ButtonsData.clickedColor)
                    break
                elseif 1 == mode and not IsClicked then
                    ButtonsBasic:ChangeColor(button, ButtonsData.selectedColor)
                    break
                elseif 2 == mode then
                    IsClicked = false
                    name = ButtonsBasic:ButtonsRelease(button)
                    break
                end
            end
        end
        if not inButton then
            ButtonsBasic:ChangeColor()
            IsClicked = false
        end
        return name
    end
end

function ButtonsBasic:ChangeColor(v, color)
    if ReplayGame == Running then
        for i, button in pairs(EachButton) do
            button.diaphaneity = ButtonsData.initialDiaphaneity
        end
        return
    end
    if Welcome == Running or GameOver == Running or PlayGame == Running then
        for i, button in pairs(EachButton) do
            button.color = {1, 1, 1, 1}
        end
        if v ~= nil then
            v.color = color
        end
        return
    end
end

function ButtonsBasic:ButtonsRelease(button)
    if Welcome == Running then
        return button.name
    end
    if PlayGame == Running then
        return button.name
    end
    if ReplayGame == Running then
        button.diaphaneity = ButtonsData.initialDiaphaneity
        if "pause" == button.name then
            IsPause = true
        elseif "continue" == button.name then
            IsPause = false
        end
        print(button.name)
        return button.name
    end
    if GameOver == Running then
        return button.name
    end
end

function ButtonsBasic:MouseSuspension(button)
    button.ratioX = ButtonsData.laterRatio * love.graphics.getWidth() / 1080
    button.ratioY = ButtonsData.laterRatio * love.graphics.getWidth() / 1080
end

function Buttons.Update()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local mouseX, mouseY = love.mouse.getPosition()
    if Welcome == Running then
        for i, button in pairs(EachButton) do
            button.x = windowWidth / 2
            if button.name == "start" then
                button.y = windowHeight / 2
                button.ratioX = 0.8 * windowHeight / 990
                button.ratioY = 0.8 * windowHeight / 990
            end
            if button.name == "replay" then
                button.y = windowHeight * 7 / 10
                button.ratioX = 0.7 * windowHeight / 990
                button.ratioY = 0.7 * windowHeight / 990
            end
        end
        Buttons.MouseState(mouseX, mouseY, 1)
        return
    end
    if PlayGame == Running then
        for i, button in pairs(EachButton) do
        end
        Buttons.MouseState(mouseX, mouseY, 1)
        return
    end
    if ReplayGame == Running then
        for i, button in pairs(EachButton) do
            if 1 == i or 2 == i then
                button.x = windowWidth * (i * 0.1 + 0.25)
            else
                button.x = windowWidth * (i * 0.1 + 0.15)
            end
            button.ratioX = ButtonsData.initialRatio * windowWidth / 1080
            button.ratioY = ButtonsData.initialRatio * windowWidth / 1080
        end
        Buttons.MouseState(mouseX, mouseY, 1)
        return
    end
    if GameOver == Running then
        local ratio = windowHeight / 720
        for i, button in pairs(EachButton) do
            button.x = windowWidth / 2 - 95 * ratio
            if button.name == "play again" then
                button.y = windowHeight / 2 - 70 * ratio
            elseif button.name == "watch replay" then
                button.y = windowHeight / 2 + 10 * ratio
            elseif button.name == "exit" then
                button.y = windowHeight / 2 + 90 * ratio
            end
        end
        Buttons.MouseState(mouseX, mouseY, 1)
        return
    end
end

return Buttons
