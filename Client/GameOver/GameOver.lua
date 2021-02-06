GameOver = {}

GameOver.VanquisherID = 0

function GameOver.DrawJudgeInfo(state, VanquisherID)
    local x, y, judgeMenuWidth, judgeMenuHeight
    local title
    local fontScale
    local titleOffset = 0
    local fontDefault = love.graphics.getFont()
    love.graphics.setFont(Font.gillsans50)
    x, y = love.graphics.getDimensions()
    local ratio = y / 720
    GameOver.GameOverOptUpdate(x, y, ratio) --创建选项
    x, y = x / 2, y / 2
    judgeMenuWidth = 250 * ratio
    judgeMenuHeight = 350 * ratio
    fontScale = 1.75 * y / 720
    if state == "Win" then
        title = "Victory!"
        titleOffset = 30
    elseif state == "Lose" then
        title = "Defeated"
    end --标题设置
    love.graphics.setColor(0.333, 0.102, 0.545)
    love.graphics.rectangle(
        "fill",
        x - (judgeMenuWidth - 12) / 2,
        y - (judgeMenuHeight - 16) / 2,
        judgeMenuWidth,
        judgeMenuHeight
    )
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.rectangle(
        "fill",
        x - judgeMenuWidth / 2,
        y - judgeMenuHeight / 2,
        judgeMenuWidth,
        judgeMenuHeight
    )
    GameOver.DrawGameOverOptions()
    -- 上为选项框，下为文字内容
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(
        title,
        x - (judgeMenuWidth - (90 + titleOffset) * fontScale) / 2,
        y - (judgeMenuHeight - 40 * fontScale) / 2,
        0,
        fontScale,
        fontScale
    )
    if titleOffset == 0 then
        local defeatText = "you are defeated by:"
        if VanquisherID == nil then
            VanquisherID = 0
        end
        local nameText = string.format("Player %d", VanquisherID)
        love.graphics.print(
            defeatText,
            x - (judgeMenuWidth - 0 * fontScale) / 2,
            y - (judgeMenuHeight - 150 * fontScale) / 2,
            0,
            fontScale * 1 / 2,
            fontScale * 1 / 2
        )
        love.graphics.print(
            nameText,
            x + (judgeMenuWidth - 135 * fontScale) / 2,
            y - (judgeMenuHeight - 155 * fontScale) / 2,
            0,
            fontScale * 1 / 3,
            fontScale * 1 / 3
        )
    end
    love.graphics.setFont(fontDefault)
    -- 确保只有裁决信息使用了新字体
end

EachOption = {}

GameOver.isClicked = false

function GameOver.Update(mouseX, mouseY)
    GameOver.MouseStateForOpts(mouseX, mouseY, 1)
end

-- 初始化裁决界面的选项的参数
function GameOver.LoadGameOverOpts()
    local optionColor = {1, 1, 1, 1}
    local optionRatio = 0.5
    local options = {}
    options.button_play_again =
        GameOver.NewOptions(
        "play again",
        "data/Picture/OPTION_TYPE_PLAYAGAIN.PNG",
        445,
        290,
        190,
        70,
        optionRatio,
        optionColor
    )
    options.button_watch_replay =
        GameOver.NewOptions(
        "watch replay",
        "data/Picture/OPTION_TYPE_WATCHREPLAY.PNG",
        445,
        370,
        190,
        70,
        optionRatio,
        optionColor
    )
    options.button_exit =
        GameOver.NewOptions(
        "exit",
        "data/Picture/OPTION_TYPE_EXIT.PNG",
        445,
        450,
        190,
        70,
        optionRatio,
        optionColor
    )
    for i, v in pairs(options) do
        GameOver.insertOpts(v)
    end
end

-- 创建裁决界面选项
function GameOver.NewOptions(name, imagPath, x, y, width, height, ratio, color)
    return {
        name = name,
        imag = love.graphics.newImage(imagPath),
        x = x,
        y = y,
        width = width,
        height = height,
        ratio = ratio,
        color = color
    }
end

function GameOver.insertOpts(Option)
    table.insert(EachOption, Option)
end

-- 初始化裁决界面选项
function GameOver.GameOverOptInit()
    GameOver.LoadGameOverOpts()
end

function GameOver.DrawGameOverOptions()
    for i, v in pairs(EachOption) do
        love.graphics.setColor(v.color)
        love.graphics.draw(v.imag, v.x, v.y, 0, v.ratio, v.ratio)
    end
end

-- 裁决选项相关功能，mode==0时为点击，1为悬浮,2为松开
function GameOver.MouseStateForOpts(mouseX, mouseY, mode)
    local oriColor = {1, 1, 1, 1}
    local selectedColor = {0.7, 0.7, 0.7, 1}
    local ClickedColor = {0.867, 0.627, 0.867, 0.68}
    local x, y = mouseX, mouseY
    local isBeyond = true -- 用来表示鼠标是否在任一选项内部
    for i, v in pairs(EachOption) do
        if x > v.x and x < v.x + v.width and y > v.y and y < v.y + v.height then
            isBeyond = false
            if mode == 0 then
                GameOver.isClicked = true
                v.color = ClickedColor
            elseif mode == 1 and not GameOver.isClicked then
                GameOver.changeColor(v, oriColor, selectedColor)
            elseif mode == 2 then
                GameOver.isClicked = false
                v.color = oriColor
                print(v.name)
            end
        end
    end
    if isBeyond then
        GameOver.changeColor(nil, oriColor, selectedColor)
    end
end

function GameOver.changeColor(option, oriColor, selectedColor)
    for i, v in pairs(EachOption) do
        v.color = oriColor
    end
    if option ~= nil then
        option.color = selectedColor
    end
end

-- 缩放选项
function GameOver.optZoom(button, x, y, ratio)
    button.width = 190 * ratio
    button.height = 70 * ratio
    ratio = ratio * 0.5
    button.x = x / 2 - 190 * ratio
    if button.name == "play again" then
        button.y = y / 2 - 140 * ratio
    elseif button.name == "watch replay" then
        button.y = y / 2 + 20 * ratio
    elseif button.name == "exit" then
        button.y = y / 2 + 180 * ratio
    end
    button.ratio = ratio
end

function GameOver.GameOverOptUpdate(x, y, ratio)
    for i, v in pairs(EachOption) do
        GameOver.optZoom(v, x, y, ratio)
    end
end

return GameOver
