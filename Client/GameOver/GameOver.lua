GameOver = {}

GameOver.VanquisherID = 0
GameOver.armyNum = 0

function GameOver.draw()
    BasicMap.DrawMap()
    if PlayGame.judgementState == "Lose" then
        GameOver.DrawJudgeInfo("Lose", GameOver.VanquisherID)
    elseif PlayGame.judgementState == "Win" then
        GameOver.DrawJudgeInfo("Win", nil)
    end
end

function GameOver.DrawJudgeInfo(state, VanquisherID)
    local x, y, judgeMenuWidth, judgeMenuHeight
    local title
    local fontScale
    local titleOffset = 0
    local menu
    local fontDefault = love.graphics.getFont()
    love.graphics.setFont(Font.gillsans50)
    x, y = love.graphics.getDimensions()
    local ratio = y / 720
    x, y = x / 2, y / 2
    judgeMenuWidth = 250 * ratio
    judgeMenuHeight = 360 * ratio
    fontScale = 1.75 * y / 720
    if state == "Win" then
        menu = GameOver.MenuV
    elseif state == "Lose" then
        menu = GameOver.MenuD
    end --标题设置
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(menu, x - judgeMenuWidth / 2, y - judgeMenuHeight / 2, 0, 0.5 * ratio, 0.5 * ratio, 1)
    Buttons.DrawButtons() --创建选项
    -- 上为选项框，下为文字内容
    love.graphics.setColor(0, 0, 0)
    if state == "Lose" then
        local nameText = string.format("Player %d", VanquisherID)
        love.graphics.print(
            nameText,
            x + (judgeMenuWidth - 145 * fontScale) / 2,
            y - (judgeMenuHeight - 195 * fontScale) / 2,
            0,
            fontScale * 1 / 3,
            fontScale * 1 / 3
        )
    end
    love.graphics.setFont(fontDefault)
    -- 确保只有裁决信息使用了新字体
end

-- 初始化裁决界面选项
function GameOver.Init()
    GameOver.armyNum = PlayGame.armyNum
    GameOver.MenuV = love.graphics.newImage("data/Picture/OPTION_TYPE_VICTORY.PNG")
    GameOver.MenuD = love.graphics.newImage("data/Picture/OPTION_TYPE_DEFEATED.PNG")
    Buttons.Init()
end

function GameOver.DeInit()
    Buttons.DeInit()
end

function GameOver.update(dt)
    Client:update()
    Buttons.MouseState(love.mouse.getX(), love.mouse.getY(), 1)
    MapAdjust.Update()
end

function GameOver.mousepressed(pixelX, pixelY, button, istouch, presses)
    Buttons.MouseState(pixelX, pixelY, 0)
end

function GameOver.mousereleased(pixelX, pixelY, button, istouch, presses)
    Buttons.MouseState(pixelX, pixelY, 2)
end

return GameOver
