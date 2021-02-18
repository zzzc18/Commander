Switcher = {}

--场景切换快捷键和名称的对应关系
local now = "Welcome"

function Switcher.Init()
    Welcome.name = "Welcome"
    PlayGame.name = "PlayGame"
    GameOver.name = "GameOver"
    ReplayGame.name = "ReplayGame"
end

function Switcher.To(newState)
    Running.DeInit()
    Running = newState
    Running.Init()
    now = Running.name
    print(now)
end

return Switcher
