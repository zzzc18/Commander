Switcher = {}
local canchange = {}
local target = {
    ["p"] = "PlayGame",
    ["r"] = "ReplayGame",
    ["w"] = "Welcome",
    ["g"] = "GameOver"
}
--场景切换快捷键和名称的对应关系
local now = "Welcome"
-- local now = "PlayGame"

function Switcher.Init()
    for key_i, value_i in pairs(target) do
        canchange[value_i] = {}
        for key_j, value_j in pairs(target) do
            canchange[value_i][value_j] = 0
        end
    end
    canchange["Welcome"]["PlayGame"] = 1
    canchange["Welcome"]["ReplayGame"] = 1
    canchange["PlayGame"]["Welcome"] = 1
    canchange["PlayGame"]["GameOver"] = 1
    canchange["GameOver"]["Welcome"] = 1
    canchange["GameOver"]["ReplayGame"] = 1
    canchange["ReplayGame"]["Welcome"] = 1
    --canchange["x"]["y"]==1代表可以从场景x切换到场景y
end

function Switcher.keypressed(key)
    if target[key] ~= nil and canchange[now][target[key]] ~= 0 then
        now = target[key]
        print(target[key])
        Switcher.To(Scene[target[key]])
    end
end

function Switcher.To(newState)
    Running.DeInit()
    Running = newState
    Running.Init()
end

return Switcher
