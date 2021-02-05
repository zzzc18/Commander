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
    GameOver.GameOverOptUpdate(x, y, ratio)
    x, y = x / 2, y / 2
    judgeMenuWidth = 250 * ratio
    judgeMenuHeight = 350 * ratio
    fontScale = 1.75 * y / 720
    if state == "Win" then
        title = "Victory!"
        titleOffset = 30
    elseif state == "Lose" then
        title = "Defeated"
    end
    love.graphics.setColor(0.333, 0.102, 0.545)
    love.graphics.setLineWidth(5)
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

EachOption.isClicked = false

function GameOver.Update(mouseX, mouseY)
    GameOver.MouseStateForOpts(mouseX, mouseY, 1)
end

-- 下面的是绘制裁决界面的选项
function EachOption:LoadGameOverOpts()
    self.optionColor = {1, 1, 1, 1}
    self.optionRatio = 0.5
    self.button_play_again = {}
    self.button_watch_replay = {}
    self.button_exit = {}
    self.button_play_again.imag =
        love.graphics.newImage("data/Picture/OPTION_TYPE_PLAYAGAIN.PNG")
    self.button_watch_replay.imag =
        love.graphics.newImage("data/Picture/OPTION_TYPE_WATCHREPLAY.PNG")
    self.button_exit.imag =
        love.graphics.newImage("data/Picture/OPTION_TYPE_EXIT.PNG")
    self.button_play_again.x = 445
    self.button_play_again.y = 290
    self.button_play_again.width = 190
    self.button_play_again.height = 70
    self.button_play_again.ratio = self.optionRatio
    self.button_play_again.color = self.optionColor
    self.button_watch_replay.x = 445
    self.button_watch_replay.y = 370
    self.button_watch_replay.width = 190
    self.button_watch_replay.height = 70
    self.button_watch_replay.ratio = self.optionRatio
    self.button_watch_replay.color = self.optionColor
    self.button_exit.x = 445
    self.button_exit.y = 450
    self.button_exit.width = 190
    self.button_exit.height = 70
    self.button_exit.ratio = self.optionRatio
    self.button_exit.color = self.optionColor
    self.button_play_again.name = "play again"
    self.button_watch_replay.name = "watch replay"
    self.button_exit.name = "exit"
end

function GameOver.GameOverOptInit()
    EachOption:LoadGameOverOpts()
end

function GameOver.DrawGameOverOptions()
    love.graphics.setColor(EachOption.button_play_again.color)
    love.graphics.draw(
        EachOption.button_play_again.imag,
        EachOption.button_play_again.x,
        EachOption.button_play_again.y,
        0,
        EachOption.button_play_again.ratio,
        EachOption.button_play_again.ratio
    )
    love.graphics.setColor(EachOption.button_watch_replay.color)
    love.graphics.draw(
        EachOption.button_watch_replay.imag,
        EachOption.button_watch_replay.x,
        EachOption.button_watch_replay.y,
        0,
        EachOption.button_watch_replay.ratio,
        EachOption.button_watch_replay.ratio
    )
    love.graphics.setColor(EachOption.button_exit.color)
    love.graphics.draw(
        EachOption.button_exit.imag,
        EachOption.button_exit.x,
        EachOption.button_exit.y,
        0,
        EachOption.button_exit.ratio,
        EachOption.button_exit.ratio
    )
end

-- mode==0时为点击，1为悬浮,2为松开
function GameOver.MouseStateForOpts(mouseX, mouseY, mode)
    local oriColor = {1, 1, 1, 1}
    local selectedColor = {0.7, 0.7, 0.7, 1}
    local ClickedColor = {0.867, 0.627, 0.867, 0.68}
    local name = nil
    local x, y = mouseX, mouseY
    if
        x > EachOption.button_play_again.x and
            x <
                EachOption.button_play_again.x +
                    EachOption.button_play_again.width and
            y > EachOption.button_play_again.y and
            y <
                EachOption.button_play_again.y +
                    EachOption.button_play_again.height
     then
        if mode == 0 then
            EachOption.isClicked = true
            EachOption.button_play_again.color = ClickedColor
        elseif mode == 1 and not EachOption.isClicked then
            EachOption.button_play_again.color = selectedColor
            EachOption.button_watch_replay.color = oriColor
            EachOption.button_exit.color = oriColor
        elseif mode == 2 then
            EachOption.isClicked = false
            EachOption.button_play_again.color = oriColor
            print(EachOption.button_play_again.name)
        end
    elseif
        x > EachOption.button_watch_replay.x and
            x <
                EachOption.button_watch_replay.x +
                    EachOption.button_watch_replay.width and
            y > EachOption.button_watch_replay.y and
            y <
                EachOption.button_watch_replay.y +
                    EachOption.button_watch_replay.height
     then
        if mode == 0 then
            EachOption.isClicked = true
            EachOption.button_watch_replay.color = ClickedColor
        elseif mode == 1 and not EachOption.isClicked then
            EachOption.button_watch_replay.color = selectedColor
            EachOption.button_play_again.color = oriColor
            EachOption.button_exit.color = oriColor
        elseif mode == 2 then
            EachOption.isClicked = false
            EachOption.button_watch_replay.color = oriColor
            print(EachOption.button_watch_replay.name)
        end
    elseif
        x > EachOption.button_exit.x and
            x < EachOption.button_exit.x + EachOption.button_exit.width and
            y > EachOption.button_exit.y and
            y < EachOption.button_exit.y + EachOption.button_exit.height
     then
        if mode == 0 then
            EachOption.isClicked = true
            EachOption.button_exit.color = ClickedColor
        elseif mode == 1 and not EachOption.isClicked then
            EachOption.button_exit.color = selectedColor
            EachOption.button_play_again.color = oriColor
            EachOption.button_watch_replay.color = oriColor
        elseif mode == 2 then
            EachOption.isClicked = false
            EachOption.button_exit.color = oriColor
            print(EachOption.button_exit.name)
        end
    else
        EachOption.button_play_again.color = oriColor
        EachOption.button_watch_replay.color = oriColor
        EachOption.button_exit.color = oriColor
    end
    return name
end

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
    GameOver.optZoom(EachOption.button_play_again, x, y, ratio)
    GameOver.optZoom(EachOption.button_watch_replay, x, y, ratio)
    GameOver.optZoom(EachOption.button_exit, x, y, ratio)
end

return GameOver
