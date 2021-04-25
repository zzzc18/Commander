from Commander import AI_SDK,GameMap,Verification
from random import randint

initialized=False
armyID = 0

def RunOnce():
    mapX,mapY = GameMap.GetSize()
    armyID = Verification.GetArmyID()

def RandomSelect():
    controllingArea = []
    for i in range(mapX):
        for j in range(mapY):
            if GameMap.GetBelong(i,j)==armyID:
                controllingArea.append([i,j])

    u = randint(0,len(controllingArea))
    direction = randint(1,7)
    return controllingArea[u][0],controllingArea[u][1],direction

def Main():
    if not initialized:
        initialized=True
        RunOnce()
    x,y,direction=RandomSelect()
    AI_SDK.MoveByDirection(x,y,direction,0)
    print("Python Called")