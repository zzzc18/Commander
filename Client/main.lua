package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerification = require("lib.Verification")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")
-- lib.UserImplementation和lib.PythonAPI会依赖lib.UserAPI
require("lib.UserAPI")

Sock = require("sock")
Bitser = require("spec.bitser")
PlayGame = require("PlayGame.PlayGame")
GameOver = require("GameOver.GameOver")
ReplayGame = require("Replayer.ReplayGame")
Welcome = require("Welcome.Welcome")
BGAnimation = require("Welcome.BGAnimation")
Switcher = require("Switcher")

Command = {}
Command["[port]"] = 22122
--客户端是否正运行自动对战任务，如果为true，客户端会在游戏结束或超时后关闭
Command["[autoMatch]"] = "false"
Command["[stepLimit]"] = 100000
Command["[mapDict]"] = "default"
Command["[mapName]"] = "default"
Command["[AIlang]"] = "Lua"
CurrentTime = 0
AI_SDK = require("AI.AI_SDK.AI_SDK")

Font = {}

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Buttons")
require("System.Debug")
require("System.Coordinate")
require("ClientSock")

Running = {}

-- arg 为传入参数
-- arg[1] 是否为多进程模式
-- arg[2] 端口号
function love.load()
    ClientTaskFile = "..\\ClientTask.txt"
    -- love和lovec的参数数目不一样，love会计算 . 而lovec不会（应该是）
    if arg[1] == "multiprocess" then
        ClientTaskFile = ClientTaskFile .. arg[2]
    elseif arg[2] == "multiprocess" then
        ClientTaskFile = ClientTaskFile .. arg[3]
    end
    local task = io.open(ClientTaskFile, "r")
    if task ~= nil then
        local line = task:read()
        while line ~= nil do
            Command[line] = task:read()
            if line == "[stepLimit]" or line == "[port]" then
                Command[line] = tonumber(Command[line])
            end
            line = task:read()
        end
        task:close()
    end

    Debug.Init()
    Debug.Log("info", "game start as client")
    Coordinate.valid()
    if Command["[autoMatch]"] == "true" then
        Debug.Log("info", "start as AI")
        Running = AI_SDK
    else
        Debug.Log("info", "start without task")
        if Visible then
            Running = Welcome
        else
            Running = AI_SDK
        end
    end
    Running.Init()
    Switcher.Init()
    if Visible then
        local gillsans50 = love.graphics.newFont("Font/gillsans.ttf", 50)
        Font.gillsans50 = gillsans50
        Picture.Init()
    end
end

function love.wheelmoved(x, y)
    Running.wheelmoved(x, y)
end

function love.mousepressed(pixelX, pixelY, button, istouch, presses)
    Running.mousepressed(pixelX, pixelY, button, istouch, presses)
end

function love.mousereleased(pixelX, pixelY, button, istouch, presses)
    Running.mousereleased(pixelX, pixelY, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
    Debug.Log("info", "keypressed " .. key)
    Running.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Running.keyreleased(key, scancode)
end

function love.directorydropped(path)
    Debug.Log("info", "directorydropped " .. path)
    ReplayGame.droppedDir = path
end

function love.draw()
    Running.draw()
end

function love.update(dt)
    CurrentTime = CurrentTime + dt
    -- 倍速开关，用于快速测试，可以通过注释和取消注释调整
    dt = dt * 4
    Running.update(dt)
end

function love.quit()
    os.exit()
    Debug.Log("info", "game quit")
    return false
end
