Picture = {}

NodeImageSet = {}
SelectImage = {}
ArrowImage = {}

function NodeImageSet:Load()
    self.center = {}
    self.center.x = 97
    self.center.y = 97
    self.divRatio = 135
    self["NODE_TYPE_BLANK"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_BLANK.png")
    self["NODE_TYPE_HILL"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_HILL.png")
    self["NODE_TYPE_FORT"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_FORT.png")
    self["NODE_TYPE_KING"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_KING.png")
    self["NODE_TYPE_OBSTACLE"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_OBSTACLE.png")
    self["NODE_TYPE_MARSH"] =
        love.graphics.newImage("data/Picture/NODE_TYPE_MARSH.png")
end

function SelectImage:Load()
    self.center = {}
    self.center.x = 113
    self.center.y = 113
    self.divRatio = 135
    self.image = love.graphics.newImage("data/Picture/Select.png")
end

function ArrowImage:Load()
    self.image = love.graphics.newImage("data/Picture/arrow.png")
    self.center = {x = 0, y = 25}
    self.divRatio = 50
end

function Picture.Init()
    NodeImageSet:Load()
    SelectImage:Load()
    ArrowImage:Load()
end

function Picture.DrawNode(pixelX, pixelY, nodeType)
    love.graphics.draw(
        NodeImageSet[nodeType],
        pixelX,
        pixelY,
        0,
        BasicMap.radius / NodeImageSet.divRatio, --- scale factor x
        BasicMap.radius / NodeImageSet.divRatio, --- scale factor y
        NodeImageSet.center.x,
        NodeImageSet.center.y
    )
end

function Picture.DrawSelect(pixelX, pixelY)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        SelectImage.image,
        pixelX,
        pixelY,
        0,
        BasicMap.radius / SelectImage.divRatio,
        BasicMap.radius / SelectImage.divRatio,
        SelectImage.center.x,
        SelectImage.center.y
    )
end

function Picture.DrawArrow(pixelX, pixelY, targetX, targetY)
    love.graphics.setColor(1, 1, 1)
    -- love.graphics.setLineWidth(10)
    -- love.graphics.line(pixelX, pixelY, targetX, targetY)
    local theta
    theta = math.atan((targetY - pixelY) / (targetX - pixelX))
    if (targetX - pixelX) < 0 then
        theta = theta + math.pi
    end
    love.graphics.draw(
        ArrowImage.image,
        pixelX,
        pixelY,
        theta,
        BasicMap.radius / ArrowImage.divRatio,
        BasicMap.radius / ArrowImage.divRatio,
        ArrowImage.center.x,
        ArrowImage.center.y
    )
end

function Picture.DrawWin(state)
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
    if state == 0 then
        title = "Victory!"
        titleOffset = 30
    else
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
    if state ~= 0 then
        local defeatText = "you are defeated by:"
        local nameText =
            love.graphics.print(
            defeatText,
            x - (judgeMenuWidth - 0 * fontScale) / 2,
            y - (judgeMenuHeight - 150 * fontScale) / 2,
            0,
            fontScale * 1 / 2,
            fontScale * 1 / 2
        )
    end
    love.graphics.setFont(fontDefault)
    -- 确保只有裁决信息使用了新字体
end

function Picture.DrawJudgement(judgementState)
    if judgementState == "Win" then
        Picture.DrawWin(1)
        return
    end
    if judgementState == "Lose" then
        Picture.DrawWin(0)
        return
    end
end

return Picture
