--场景切换器
local Switcher = {}

--可切换的场景
local Scene = {}
Scene["Welcome"] = Welcome
Scene["PlayGame"] = PlayGame
Scene["ReplayGame"] = ReplayGame
Scene["GameOver"] = GameOver
Scene["AI_SDK"] = AI_SDK

local Switchable = {}
--场景切换快捷键和名称的对应关系
local Target = {
    ["p"] = "PlayGame",
    ["r"] = "ReplayGame",
    ["w"] = "Welcome",
    ["g"] = "GameOver",
    ["a"] = "AI_SDK"
}
--当前场景
local now = "Welcome"

function Switcher.Init()
    Welcome.name = "Welcome"
    PlayGame.name = "PlayGame"
    AI_SDK.name = "AI_SDK"
    GameOver.name = "GameOver"
    ReplayGame.name = "ReplayGame"
    for key_i, value_i in pairs(Target) do
        Switchable[value_i] = {}
        for key_j, value_j in pairs(Target) do
            Switchable[value_i][value_j] = 0
        end
    end
    Switchable["Welcome"]["PlayGame"] = 1
    Switchable["Welcome"]["AI_SDK"] = 1
    Switchable["Welcome"]["ReplayGame"] = 1
    Switchable["PlayGame"]["GameOver"] = 1
    Switchable["PlayGame"]["Welcome"] = 1
    Switchable["AI_SDK"]["GameOver"] = 1
    Switchable["AI_SDK"]["Welcome"] = 1
    Switchable["ReplayGame"]["Welcome"] = 1
    Switchable["GameOver"]["Welcome"] = 1
    Switchable["GameOver"]["PlayGame"] = 1
    Switchable["GameOver"]["ReplayGame"] = 1
    --Switchable["x"]["y"]==1代表可以从场景x切换到场景y
    Debug.Log("info", "init Switcher")
end

--用按键切换场景的功能不会在正常游戏中使用
function Switcher.keypressed(key)
    if Target[key] ~= nil and Switchable[now][Target[key]] ~= 0 then
        now = Target[key]
        Switcher.To(Scene[Target[key]])
    end
end

--取消初始化当前场景，然后将Running切换到newState(table)
function Switcher.To(newState)
    Debug.Log("info", "switch to " .. newState.name)
    now = newState.name
    Running.DeInit()
    Running = newState
    Running.Init()
end

return Switcher
