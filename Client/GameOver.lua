GameOver = {}

GameOver.VanquisherID = 0

function GameOver.DrawJudgeInfo(state, VanquisherID)
    local x, y, judgeMenuWidth, judgeMenuHeight, scaleFactor
    local title
    local fontScale
    local titleOffset = 0
    local fontDefault = love.graphics.getFont()
    love.graphics.setFont(Font.gillsans50)
    x, y = love.graphics.getDimensions()
    x, y = x / 2, y / 2
    scaleFactor = x / 1080
    judgeMenuWidth = 500 * scaleFactor
    judgeMenuHeight = 640 * scaleFactor
    fontScale = 1.75 * x / 1080
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
    love.graphics.rectangle("fill", x - judgeMenuWidth / 2, y - judgeMenuHeight / 2, judgeMenuWidth, judgeMenuHeight)
    love.graphics.setColor(0.333, 0.102, 0.545)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle(
        "fill",
        x - (judgeMenuWidth - 12) / 2 + 60 * scaleFactor,
        y - (judgeMenuHeight - 16) / 4 + 20 * scaleFactor,
        judgeMenuWidth - 120 * scaleFactor,
        (judgeMenuHeight - 80 * scaleFactor) / 4
    )
    love.graphics.rectangle(
        "fill",
        x - (judgeMenuWidth - 12) / 2 + 60 * scaleFactor,
        y + 4 + 20 * scaleFactor,
        judgeMenuWidth - 120 * scaleFactor,
        (judgeMenuHeight - 80 * scaleFactor) / 4
    )
    love.graphics.rectangle(
        "fill",
        x - (judgeMenuWidth - 12) / 2 + 60 * scaleFactor,
        y + (judgeMenuHeight + 16) / 4 + 20 * scaleFactor,
        judgeMenuWidth - 120 * scaleFactor,
        (judgeMenuHeight - 80 * scaleFactor) / 4
    )
    love.graphics.setColor(0.867, 0.627, 0.867)
    love.graphics.rectangle(
        "fill",
        x - judgeMenuWidth / 2 + 60 * scaleFactor,
        y + 20 * scaleFactor,
        judgeMenuWidth - 120 * scaleFactor,
        (judgeMenuHeight - 80 * scaleFactor) / 4
    )
    love.graphics.rectangle(
        "fill",
        x - judgeMenuWidth / 2 + 60 * scaleFactor,
        y - judgeMenuHeight / 4 + 20 * scaleFactor,
        judgeMenuWidth - 120 * scaleFactor,
        (judgeMenuHeight - 80 * scaleFactor) / 4
    )
    love.graphics.rectangle(
        "fill",
        x - judgeMenuWidth / 2 + 60 * scaleFactor,
        y + judgeMenuHeight / 4 + 20 * scaleFactor,
        judgeMenuWidth - 120 * scaleFactor,
        (judgeMenuHeight - 80 * scaleFactor) / 4
    )
    -- 上为三个选项框，下为文字内容
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(
        title,
        x - (judgeMenuWidth - (90 + titleOffset) * fontScale) / 2,
        y - (judgeMenuHeight - 40 * fontScale) / 2,
        0,
        fontScale,
        fontScale
    )
    love.graphics.print(
        "Play Again",
        x - (judgeMenuWidth - 130 * fontScale) / 2,
        y - (judgeMenuHeight - 135 * fontScale) / 4,
        0,
        fontScale * 3 / 4,
        fontScale * 3 / 4
    )
    love.graphics.print(
        "Watch Replay",
        x - (judgeMenuWidth - 75 * fontScale) / 2,
        y + (judgeMenuHeight - 200 * fontScale) / 4,
        0,
        fontScale * 3 / 4,
        fontScale * 3 / 4
    )
    love.graphics.print(
        "Exit",
        x - (judgeMenuWidth - 220 * fontScale) / 2,
        y + (judgeMenuHeight - 100 * fontScale) / 2,
        0,
        fontScale * 3 / 4,
        fontScale * 3 / 4
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

function GameOver.DrawJudgement(judgementState, VanquisherID)
    if judgementState == "Win" then
        GameOver.DrawJudgeInfo("Win", nil)
        return
    end
    if judgementState == "Lose" then
        GameOver.DrawJudgeInfo("Lose", VanquisherID)
        return
    end
end

return GameOver
