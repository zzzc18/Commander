package.path = package.path .. ";../?.lua;..\\?.lua"
package.cpath = package.cpath .. ";../?.so;..\\?.dll"

CVerification = require("lib.Verification")
CGameMap = require("lib.GameMap")
CSystem = require("lib.System")
require("os")

DirName = "map"
KingNum = 4
SizeX, SizeY = 32, 32

os.execute("mkdir " .. DirName)

-- CGameMap.RandomGenMap(KingNum, SizeX, SizeY, DirName .. "/" .. "test")

for i = 0, 10 do
    print("Generating " .. i)
    CGameMap.RandomGenMap(KingNum, SizeX, SizeY, DirName .. "/" .. i)
end
