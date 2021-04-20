Buttons = {}

--存储各按钮
local EachButton = {}
--存储按钮函数
local ButtonsBasic = {}
--存储按钮数据
local ButtonsData = {}

Buttons.isPause = false

function Buttons.Init()
    ButtonsBasic:Load()
    Debug.Log("info", "init Buttons")
end

function Buttons.DeInit()
    --ButtonsBasic = {}
    --以上操作会导致ButtonsBasic中的函数永久消失
    EachButton = {}
    ButtonsData = {}
    Buttons.isPause = false
    Debug.Log("info", "deinit Buttons")
end

--orientation:旋转角度;
--ratioX,ratioY:X,Y方向上的缩放比例;
--offsetX,offsetY:偏移量（默认0）;
--fun:按钮自带的函数（默认nil）;
--scalingcenterX,scalingcenterY:？？（默认0）
function Buttons.NewButton(
    path,
    name,
    x,
    y,
    orientation,
    ratioX,
    ratioY,
    offsetX,
    offsetY,
    fun,
    scalingcenterX,
    scalingcenterY,
    Color)
    local button = {}
    button.imag = love.graphics.newImage(path)
    button.name = name
    button.x = x
    button.y = y
    button.orientation = orientation
    button.ratioX = ratioX
    button.ratioY = ratioY
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
    if nil == fun then
        button.fun = function()
        end
    else
        button.fun = fun
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
    if nil == Color then
        button.Color = {1, 1, 1, 1}
    else
        button.Color = Color
    end
    table.insert(EachButton, button)
end

function ButtonsBasic:Load()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    if Welcome == Running then
        ButtonsData.ClickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.SelectedColor = {0.7, 0.7, 0.7, 1}
        ButtonsData.startRatio = 0.582
        ButtonsData.replayRatio = 0.51
        Buttons.NewButton(
            "data/Picture/start.PNG",
            "start",
            windowWidth / 2,
            windowHeight / 2,
            0,
            ButtonsData.startRatio,
            ButtonsData.startRatio,
            307 / 2,
            141 / 2
        )
        Buttons.NewButton(
            "data/Picture/replay.PNG",
            "replay",
            windowWidth / 2,
            windowHeight * 7 / 10,
            0,
            ButtonsData.replayRatio,
            ButtonsData.replayRatio,
            344 / 2,
            179 / 2
        )
        return
    end
    if PlayGame == Running or AI_SDK == Running then
        ButtonsData.ClickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.SelectedColor = {0.7, 0.7, 0.7, 1}
        ButtonsData.optionRatio = 0.5
        ButtonsData.menuRatio = 0.63
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_MENU.png",
            "menu",
            windowWidth * 0.01,
            windowHeight * 0.01,
            0,
            ButtonsData.menuRatio,
            ButtonsData.menuRatio
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_CONTINUE.PNG",
            "continue",
            445,
            290,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_EXIT.PNG",
            "exit",
            445,
            410,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        return
    end
    if ReplayGame == Running then
        ButtonsData.initialRatio = 0.2
        ButtonsData.optionRatio = 0.5
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
            -20,
            -20,
            nil,
            0,
            0,
            {1, 1, 1, ButtonsData.initialDiaphaneity}
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_PAUSE.png",
            "pause",
            windowWidth * 0.45,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            -20,
            -20,
            function()
                Buttons.isPause = true
            end,
            0,
            0,
            {1, 1, 1, ButtonsData.initialDiaphaneity}
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_CONTINUE.png",
            "continue",
            windowWidth * 0.45,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            -20,
            -20,
            function()
                Buttons.isPause = false
            end,
            0,
            0,
            {1, 1, 1, ButtonsData.initialDiaphaneity}
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_NEXT.png",
            "next",
            windowWidth * 0.55,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            -20,
            -20,
            nil,
            0,
            0,
            {1, 1, 1, ButtonsData.initialDiaphaneity}
        )
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_SHIFTSPEED.png",
            "shiftSpeed",
            windowWidth * 0.65,
            windowHeight * 0,
            0,
            ButtonsData.initialRatio,
            ButtonsData.initialRatio,
            -20,
            -20,
            nil,
            0,
            0,
            {1, 1, 1, ButtonsData.initialDiaphaneity}
        )
        ButtonsData.ClickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.SelectedColor = {0.7, 0.7, 0.7, 1}
        ButtonsData.menuRatio = 0.63
        Buttons.NewButton(
            "data/Picture/BUTTON_TYPE_MENU.png",
            "menu",
            windowWidth * 0.01,
            windowHeight * 0.01,
            0,
            ButtonsData.menuRatio,
            ButtonsData.menuRatio
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_CONTINUE.PNG",
            "continue_Opt",
            445,
            290,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_EXIT.PNG",
            "exit_Opt",
            445,
            410,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        return
    end
    if GameOver == Running then
        ButtonsData.optionRatio = 0.5
        ButtonsData.ClickedColor = {0.439, 0.502, 1, 1}
        ButtonsData.SelectedColor = {0.7, 0.7, 0.7, 1}
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_PLAYAGAIN.PNG",
            "play again",
            445,
            290,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_WATCHREPLAY.PNG",
            "watch replay",
            445,
            370,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        Buttons.NewButton(
            "data/Picture/OPTION_TYPE_EXIT.PNG",
            "exit",
            445,
            450,
            0,
            ButtonsData.optionRatio,
            ButtonsData.optionRatio
        )
        return
    end
end

function Buttons.DrawButtons()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    if Welcome == Running then
        for i, button in pairs(EachButton) do
            love.graphics.setColor(button.Color)
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
    if PlayGame == Running or AI_SDK == Running then
        for i, button in pairs(EachButton) do
            if "menu" == button.name and "Start" == Running.gameState then
                love.graphics.setColor(button.Color)
                love.graphics.draw(
                    button.imag,
                    button.x,
                    button.y,
                    button.orientation,
                    button.ratioX * windowHeight / 720,
                    button.ratioY * windowHeight / 720,
                    button.offsetX,
                    button.offsetY
                )
            elseif "menu" ~= button.name and "Menu" == Running.gameState then
                love.graphics.setColor(button.Color)
                love.graphics.draw(
                    button.imag,
                    button.x,
                    button.y,
                    button.orientation,
                    button.ratioX * windowWidth / 1080,
                    button.ratioY * windowHeight / 720,
                    button.offsetX,
                    button.offsetY
                )
            end
        end
        return
    end
    if ReplayGame == Running then
        for i, button in pairs(EachButton) do
            if "Start" == ReplayGame.gameState and "continue_Opt" ~= button.name and "exit_Opt" ~= button.name then
                if
                    (true == Buttons.isPause and "pause" == button.name) or
                        (false == Buttons.isPause and "continue" == button.name)
                 then
                else
                    love.graphics.setColor(button.Color)
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
            elseif "Menu" == ReplayGame.gameState and ("continue_Opt" == button.name or "exit_Opt" == button.name) then
                love.graphics.setColor(button.Color)
                love.graphics.draw(
                    button.imag,
                    button.x,
                    button.y,
                    button.orientation,
                    button.ratioX * windowWidth / 1080,
                    button.ratioY * windowHeight / 720,
                    button.offsetX,
                    button.offsetY
                )
            end
        end
        return
    end
    if GameOver == Running then
        for i, button in pairs(EachButton) do
            love.graphics.setColor(button.Color)
            love.graphics.draw(
                button.imag,
                button.x,
                button.y,
                button.orientation,
                button.ratioX * windowHeight / 720,
                button.ratioY * windowHeight / 720,
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
                mouseX >= button.x - button.offsetX * button.ratioX and
                    mouseX <= button.x + button.offsetX * button.ratioX and
                    mouseY >= button.y - button.offsetY * button.ratioY and
                    mouseY <= button.y + button.offsetY * button.ratioY
             then
                inButton = true
                if 0 == mode then
                    ButtonsBasic:ChangeColor(button, ButtonsData.ClickedColor)
                    break
                end
                if 1 == mode and not love.mouse.isDown(1) then
                    ButtonsBasic:ChangeColor(button, ButtonsData.SelectedColor)
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
    if PlayGame == Running or AI_SDK == Running then
        local name
        local inButton = false
        for i, button in pairs(EachButton) do
            if "menu" == button.name and "Start" == PlayGame.gameState then
                if mouseX > button.x and mouseX < button.x + 63 and mouseY > button.y and mouseY < button.y + 63 then
                    inButton = true
                    if 0 == mode then
                        name = "Clicked"
                        ButtonsBasic:ChangeColor(button, ButtonsData.ClickedColor)
                    elseif 1 == mode and not love.mouse.isDown(1) then
                        ButtonsBasic:ChangeColor(button, ButtonsData.SelectedColor)
                    elseif 2 == mode then
                        name = ButtonsBasic:ButtonsRelease(button)
                    end
                    break
                end
            elseif "menu" ~= button.name and "Menu" == Running.gameState then
                if
                    mouseX > button.x and mouseX < button.x + 190 * love.graphics.getWidth() / 1080 and
                        mouseY > button.y and
                        mouseY < button.y + 70 * love.graphics.getHeight() / 720
                 then
                    inButton = true
                    if 0 == mode then
                        name = "Clicked"
                        ButtonsBasic:ChangeColor(button, ButtonsData.ClickedColor)
                    elseif 1 == mode and not love.mouse.isDown(1) then
                        ButtonsBasic:ChangeColor(button, ButtonsData.SelectedColor)
                    elseif 2 == mode then
                        name = ButtonsBasic:ButtonsRelease(button)
                    end
                    break
                end
            end
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
            if "Start" == ReplayGame.gameState and "continue_Opt" ~= button.name and "exit_Opt" ~= button.name then
                if
                    (true == Buttons.isPause and "pause" == button.name) or
                        (false == Buttons.isPause and "continue" == button.name)
                 then
                else
                    if mouseX > button.x and mouseX < button.x + 63 and mouseY > button.y and mouseY < button.y + 63 then
                        inButton = true
                        if 0 == mode then
                            if "menu" == button.name then
                                ButtonsBasic:ChangeColor(button, ButtonsData.ClickedColor)
                            else
                                table.remove(button.Color, 4)
                                table.insert(button.Color, ButtonsData.laterDiaphaneity)
                            end
                        elseif 1 == mode and not love.mouse.isDown(1) then
                            if "menu" == button.name then
                                ButtonsBasic:ChangeColor(button, ButtonsData.SelectedColor)
                            else
                                button.ratioX = ButtonsData.laterRatio
                                button.ratioY = ButtonsData.laterRatio
                            end
                        elseif 2 == mode then
                            if "menu" == button.name then
                            else
                                table.remove(button.Color, 4)
                                table.insert(button.Color, ButtonsData.initialDiaphaneity)
                            end
                            name = ButtonsBasic:ButtonsRelease(button)
                        end
                        break
                    end
                end
            elseif "Menu" == ReplayGame.gameState and ("continue_Opt" == button.name or "exit_Opt" == button.name) then
                if
                    mouseX > button.x and mouseX < button.x + 190 * love.graphics.getWidth() / 1080 and
                        mouseY > button.y and
                        mouseY < button.y + 70 * love.graphics.getHeight() / 720
                 then
                    inButton = true
                    if 0 == mode then
                        name = "Clicked"
                        ButtonsBasic:ChangeColor(button, ButtonsData.ClickedColor)
                    elseif 1 == mode and not love.mouse.isDown(1) then
                        ButtonsBasic:ChangeColor(button, ButtonsData.SelectedColor)
                    elseif 2 == mode then
                        name = ButtonsBasic:ButtonsRelease(button)
                    end
                    break
                end
            end
        end
        if not inButton then
            ButtonsBasic:ChangeColor()
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
                    ButtonsBasic:ChangeColor(button, ButtonsData.ClickedColor)
                    break
                elseif 1 == mode and not love.mouse.isDown(1) then
                    ButtonsBasic:ChangeColor(button, ButtonsData.SelectedColor)
                    break
                elseif 2 == mode then
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
end

function ButtonsBasic:ChangeColor(v, Color)
    if ReplayGame == Running then
        if v == nil then
            for i, button in pairs(EachButton) do
                if "menu" ~= button.name and "continue_Opt" ~= button.name and "exit_Opt" ~= button.name then
                    table.remove(button.Color, 4)
                    table.insert(button.Color, ButtonsData.initialDiaphaneity)
                    button.ratioX = ButtonsData.initialRatio
                    button.ratioY = ButtonsData.initialRatio
                else
                    button.Color = {1, 1, 1, 1}
                end
            end
        else
            v.Color = Color
        end
        return
    end
    if Welcome == Running or GameOver == Running or PlayGame == Running or AI_SDK == Running then
        for i, button in pairs(EachButton) do
            button.Color = {1, 1, 1, 1}
        end
        if v ~= nil then
            v.Color = Color
        end
        return
    end
end

function ButtonsBasic:ButtonsRelease(button)
    button.fun()
    Debug.Log("info", "trigger button: " .. button.name)
    return button.name
end

--可随窗口大小调整按钮大小
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
            -- button.offsetX = 307 / 2 * button.ratioX
            -- button.offsetY = 141 / 2 * button.ratioY
            end
            if button.name == "replay" then
                button.y = windowHeight * 7 / 10
                button.ratioX = 0.7 * windowHeight / 990
                button.ratioY = 0.7 * windowHeight / 990
            -- button.offsetX = button.imag:getWidth() / 2
            -- button.offsetY = button.imag:getHeight() / 2
            end
        end
        Buttons.MouseState(mouseX, mouseY, 1)
        return
    end
    if PlayGame == Running or AI_SDK == Running then
        for i, button in pairs(EachButton) do
            if "menu" ~= button.name and "Menu" == PlayGame.gameState then
                button.x = windowWidth / 2 - 95 * windowWidth / 1080
                if button.name == "continue" then
                    button.y = windowHeight / 2 - 70 * windowHeight / 720
                elseif button.name == "exit" then
                    button.y = windowHeight / 2 + 50 * windowHeight / 720
                end
            end
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
        for i, button in pairs(EachButton) do
            if "Menu" == ReplayGame.gameState and ("continue_Opt" == button.name or "exit_Opt" == button.name) then
                button.x = windowWidth / 2 - 95 * windowWidth / 1080
                if button.name == "continue_Opt" then
                    button.y = windowHeight / 2 - 70 * windowHeight / 720
                elseif button.name == "exit_Opt" then
                    button.y = windowHeight / 2 + 50 * windowHeight / 720
                end
            end
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
    Buttons.MouseState(mouseX, mouseY, 1)
end

return Buttons
