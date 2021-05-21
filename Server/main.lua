package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerification = require("lib.Verification")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")

Sock = require("sock")
Bitser = require("spec.bitser")

Command = {}
Command["[port]"] = 22122
--服务端是否正运行自动对战任务，如果为true，服务端会在超时后结束游戏并关闭、在关闭时删除ServerTask.txt
Command["[autoMatch]"] = "false"
Command["[stepLimit]"] = 100000
Command["[mapDict]"] = "default"
Command["[mapName]"] = "default"
Command["[saveName]"] = "default"
Command["[saveDict]"] = "default"
CurrentTime = 0

require("System.Color")
require("System.Picture")
require("System.BasicMap")
require("System.MapAdjust")
require("System.Debug")
require("System.Coordinate")
require("ServerSock")
require("PlayGame.PlayGame")

-- arg 为传入参数
-- arg[1] 是否为多进程模式
-- arg[2] 端口号
function love.load(arg)
    ServerTaskFile = "..\\ServerTask.txt"
    -- love和lovec的参数数目不一样，love会计算 . 而lovec不会（应该是）
    if arg[1] == "multiprocess" then
        ServerTaskFile = ServerTaskFile .. arg[2]
    elseif arg[2] == "multiprocess" then
        ServerTaskFile = ServerTaskFile .. arg[3]
    end
    local task = io.open(ServerTaskFile, "r")
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
    Debug.Log("info", "game start as server")
    Debug.Log("info", "open " .. ServerTaskFile)
    CVerification.Register(0, 3)
    Coordinate.valid()
    Running = PlayGame
    Running.Init()
    Picture.Init()
    ServerSock.Init(PlayGame.armyNum)
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
    Running.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    Running.keyreleased(key, scancode)
end

function love.draw()
    Running.draw()
end

function love.update(dt)
    CurrentTime = CurrentTime + dt
    -- 倍速开关，用于快速测试，可以通过注释和取消注释调整
    dt = dt * 4
    Server:update()
    Running.update(dt)
end

function love.quit()
    if Command["[autoMatch]"] == "true" then
        Debug.Log("info", "delete " .. ServerTaskFile)
        --通过删除来告知autoMatch.py这场对局已经结束
        os.execute("del " .. ServerTaskFile)
    end
    Debug.Log("info", "game quit")
    return false
end
