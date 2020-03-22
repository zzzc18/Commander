Switcher = {}

local preRunning = {}
local newState = {}
local delay = 0

-- delay s
function Switcher.To(info, _delay)
    if _delay == nil then
        delay = 0
    else
        delay = _delay
    end
    if info == "本地对局" then
        newState = PlayGame
    elseif info == "对局回放" then
        newState = ReplayGame
    end
    Running.DeInit()
    preRunning = Running
    Running = Switcher
end

function Switcher.Destroy()
    preRunning.Destroy()
end

function Switcher.wheelmoved(x, y)
    preRunning.wheelmoved(x, y)
end

function Switcher.mousepressed(pixelX, pixelY, button, istouch, presses)
    preRunning.mousepressed(pixelX, pixelY, button, istouch, presses)
end

function Switcher.mousereleased(pixelX, pixelY, button, istouch, presses)
    preRunning.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function Switcher.keypressed(key, scancode, isrepeat)
    preRunning.keypressed(key, scancode, isrepeat)
end

function Switcher.keyreleased(key, scancode)
    preRunning.keyreleased(key, scancode)
end

function Switcher.draw()
    preRunning.draw()
end

function Switcher.update(dt)
    delay = delay - dt
    if delay <= 0 then
        Running.Destroy()
        Running = newState
        Running.Init()
    end
    preRunning.update(dt)
end

return Switcher
