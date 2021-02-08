Welcome = {}

function Welcome.Init()
    PlayGame.Init()
    PressStart = false
    ReleaseStart = false
    oriColor = {1, 1, 1, 1}
    selectedColor = {0.7, 0.7, 0.7, 1}
    ClickedColor = {0.439, 0.502, 0.565, 1}
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()

    Title = {
        img = love.graphics.newImage("data/Picture/Title.PNG"),
        widthRatio = 0.6,
        heightRatio = 0.6
    }
    Background = {
        img = love.graphics.newImage("data/Picture/Background.JPG"),
        widthRatio = 3,
        heightRatio = 3
    }
    StartButton = {
        img = love.graphics.newImage("data/Picture/start.PNG"),
        widthRatio = 0.8,
        heightRatio = 0.8
    }
    StartButton.width = StartButton.img:getWidth() / 2
    StartButton.height = StartButton.img:getHeight() / 2
end
function Welcome.draw()
    if ReleaseStart then
        PlayGame.draw()
    end
    if not ReleaseStart then
        love.graphics.setColor(oriColor)
        love.graphics.draw(
            Background.img,
            0,
            0,
            0,
            Background.widthRatio,
            Background.heightRatio
        )
        love.graphics.draw(
            Title.img,
            PixelWidth / 2,
            PixelHeight / 3,
            0,
            Title.widthRatio,
            Title.heightRatio,
            Title.img:getWidth() / 2,
            Title.img:getHeight() / 2
        )
        if
            mouseX >= PixelWidth / 2 - StartButton.width / 2 and
                mouseX <= PixelWidth / 2 + StartButton.width / 2 and
                mouseY >= PixelHeight * 2 / 3 - StartButton.height / 2 and
                mouseY <= PixelHeight * 2 / 3 + StartButton.height / 2
         then
            if love.mouse.isDown(1) then
                love.graphics.setColor(ClickedColor)
            else
                love.graphics.setColor(selectedColor)
            end
        end
        love.graphics.draw(
            StartButton.img,
            PixelWidth / 2,
            PixelHeight * 2 / 3,
            0,
            StartButton.widthRatio,
            StartButton.heightRatio,
            StartButton.width,
            StartButton.height
        )
    end
end
function Welcome.update()
    if ReleaseStart then
        PlayGame.update()
    end
    PixelWidth, PixelHeight = love.graphics.getPixelDimensions()
    Title.widthRatio = 0.6 * PixelHeight / 990
    Title.heightRatio = 0.6 * PixelHeight / 990
    StartButton.widthRatio = 0.8 * PixelHeight / 990
    StartButton.heightRatio = 0.8 * PixelHeight / 990
    mouseX, mouseY = love.mouse.getPosition()
end
function Welcome.wheelmoved(x, y)
    if ReleaseStart then
        PlayGame.wheelmoved(x, y)
    end
end

function Welcome.mousepressed(pixelX, pixelY, button, istouch, presses)
    if
        pixelX >= PixelWidth / 2 - StartButton.width / 2 and
            pixelX <= PixelWidth / 2 + StartButton.width / 2 and
            pixelY >= PixelHeight * 2 / 3 - StartButton.height / 2 and
            pixelY <= PixelHeight * 2 / 3 + StartButton.height / 2
     then
        PressStart = true
    end
    if ReleaseStart then
        PlayGame.mousepressed(pixelX, pixelY, button, istouch, presses)
    end
end

function Welcome.mousereleased(pixelX, pixelY, button, istouch, presses)
    if
        pixelX >= PixelWidth / 2 - StartButton.width / 2 and
            pixelX <= PixelWidth / 2 + StartButton.width / 2 and
            pixelY >= PixelHeight * 2 / 3 - StartButton.height / 2 and
            pixelY <= PixelHeight * 2 / 3 + StartButton.height / 2
     then
        ReleaseStart = true
    else
        PressStart = false
    end
    if ReleaseStart == 1 then
        PlayGame.mousereleased(pixelX, pixelY, button, istouch, presses)
    end
end

function Welcome.keypressed(key, scancode, isrepeat)
    if ReleaseStart == 1 then
        PlayGame.keypressed(key, scancode, isrepeat)
    end
end

function Welcome.keyreleased(key, scancode)
    if ReleaseStart == 1 then
        PlayGame.keyreleased(key, scancode)
    end
end

return Welcome
