--场景切换器
Switcher = {}

--可切换的场景
Scene = {}
Scene["Welcome"] = Welcome
Scene["PlayGame"] = PlayGame
Scene["ReplayGame"] = ReplayGame

--switchable["x"]["y"]==1代表可以从场景x切换到场景y
local switchable = {}
--场景切换快捷键和名称的对应关系
local target = {
    ["p"] = "PlayGame",
    ["r"] = "ReplayGame",
    ["w"] = "Welcome"
}
--当前场景
local now = "Welcome"

function Switcher.Init()
    for key_i, value_i in pairs(target) do
        switchable[value_i] = {}
        for key_j, value_j in pairs(target) do
            switchable[value_i][value_j] = 0
        end
    end
    switchable["Welcome"]["PlayGame"] = 1
    switchable["Welcome"]["ReplayGame"] = 1
    switchable["PlayGame"]["ReplayGame"] = 1
    switchable["ReplayGame"]["Welcome"] = 1
end

--用按键切换场景的功能不会在正常游戏中使用
function Switcher.keypressed(key)
    print(now)
    if target[key] ~= nil and switchable[now][target[key]] ~= 0 then
        now = target[key]
        Switcher.To(Scene[target[key]])
    end
end

--取消初始化当前场景，然后将Running切换到newState(table)
function Switcher.To(newState)
    print("switch to " .. newState.name)
    now = newState.name
    Running.DeInit()
    Running = newState
    Running.Init()
end

return Switcher
