--场景切换器
local Switcher = {}

--可切换的场景
local Scene = {}
Scene["Welcome"] = Welcome
Scene["PlayGame"] = PlayGame
Scene["ReplayGame"] = ReplayGame

--Switchable["x"]["y"]==1代表可以从场景x切换到场景y
local Switchable = {}
--场景切换快捷键和名称的对应关系
local Target = {
    ["p"] = "PlayGame",
    ["r"] = "ReplayGame",
    ["w"] = "Welcome"
}
--当前场景
local now = "Welcome"

function Switcher.Init()
    Welcome.name = "Welcome"
    PlayGame.name = "PlayGame"
    GameOver.name = "GameOver"
    ReplayGame.name = "ReplayGame"
    for key_i, value_i in pairs(Target) do
        Switchable[value_i] = {}
        for key_j, value_j in pairs(Target) do
            Switchable[value_i][value_j] = 0
        end
    end
    Switchable["Welcome"]["PlayGame"] = 1
    Switchable["Welcome"]["ReplayGame"] = 1
    Switchable["PlayGame"]["ReplayGame"] = 1
    Switchable["ReplayGame"]["Welcome"] = 1
end

--用按键切换场景的功能不会在正常游戏中使用
function Switcher.keypressed(key)
    print(now)
    if Target[key] ~= nil and Switchable[now][Target[key]] ~= 0 then
        now = Target[key]
        Switcher.To(Scene[Target[key]])
    end
end

--取消初始化当前场景，然后将Running切换到newState(table)
function Switcher.To(newState)
    print("switch to " .. newState.name)
    now = newState.name
    Running.DeInit()
    Running = newState
    Running.Init()
    now = Running.name
    print(now)
end

return Switcher
