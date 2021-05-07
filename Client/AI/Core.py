from Commander import AI_SDK, GameMap, Verification
from random import randint

armyID, mapX, mapY = 0, 0, 0


def RandomSelect():
    controllingArea = []
    for i in range(mapX):
        for j in range(mapY):
            if GameMap.GetBelong(i, j) == armyID:
                controllingArea.append([i, j])

    u = randint(0, len(controllingArea)-1)
    direction = randint(0, 5)
    return controllingArea[u][0], controllingArea[u][1], direction


def Load():
    '''
    开始时调用
    '''
    global armyID, mapX, mapY
    armyID = Verification.GetArmyID()
    mapX, mapY = GameMap.GetSize()


def Main():
    '''
    每个Step调用一次
    '''
    x, y, direction = RandomSelect()
    AI_SDK.MoveByDirection(x, y, 0, direction)
