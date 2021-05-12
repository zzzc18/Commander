# root
# ├─TeamsFolder  <-提交的队伍，所有文件夹目录结构与Commender相同
# │  ├─DDL战神
# │  ├─316驾校
# │  └─...
# └─Commender  <-九个Develop上的Commender
#    ├─Commender_0
#    │  └─autoEvaluation.py  <-运行这个
#    ├─Commender_1
#    ├─...
#    ├─Commender_8
#    ├─maps_8player
#    └─maps_2player

import os
import time
from multiprocessing import Pool
from autoMatch_CrossFolder import autoMatch_CrossFolder, Match


def copyFile(teamName, teamAI, index):
    if(teamAI == "C++"):
        print("\ntring to copy C++ file from"+teamName)
        os.system("copy /y ../../TeamsFolder/"+teamName+"/lib/UserImplementation.dll ../Commender_"+str(
            index)+"/lib/UserImplementation.dll")
    elif(teamAI == "Lua"):
        print("\ntring to copy Lua file from"+teamName)
        os.system("copy /y ../../TeamsFolder/"+teamName+"/Client/AI/Core.lua ../Commender_"+str(
            index)+"/Client/AI/Core.lua")
    elif(teamAI == "Python"):
        print("\ntring to copy Python file from"+teamName)
        os.system("copy /y ../../TeamsFolder/"+teamName+"/Client/AI/Core.py ../Commender_"+str(
            index)+"/Client/AI/Core.py")


if __name__ == '__main__':
    # 对局类型，ffa=八队混战，共一轮；1v1=八选二一对一，共56轮
    matchType = "ffa"
    # 每轮游戏局数,1<=matchNumber<=100
    teamMatchNumber = 100
    # 参与游戏的智能体文件夹名列表
    AIteam = ["DDL战神", "316驾校", "team_3", "team_4",
              "team_5", "team_6", "team_7", "team_8"]
    AIlang = ["C++", "Lua", "default", "default",
              "default", "default", "default", "default"]
    startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
    if(matchType == "ffa"):
        for i in range(8):
            copyFile(AIteam[i], AIlang[i], i+1)
        with Pool(processes=10) as pool:
            args = []  # [[port,index,AIlang,mapDict,saveDict],...]
            for i in range(teamMatchNumber):
                args.append(
                    [22122+i, i, AIlang, "../maps_8player", "teamMatch"])
            pool.starmap(Match, args)
        # 统计结果
        am = autoMatch_CrossFolder()
        am.saveDict = "teamMatch"
        am.AIwinning = [[], [], [], [], [], [], [], []]
        am.matchNumber = teamMatchNumber
        am.countMatchResult()  # 这里产生的txt文件里的开始时间是错的
        endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        print(startTime, endTime)
    elif(matchType == "1v1"):
        for team_1 in range(8):
            for team_2 in range(team_1+1, 8):
                print("\nstatr match "+AIteam[team_1]+"vs"+AIteam[team_2])
                copyFile(AIteam[team_1], AIlang[team_1], 1)
                copyFile(AIteam[team_2], AIlang[team_2], 1)
                with Pool(processes=10) as pool:
                    args = []  # [[port,index,AIlang,mapDict,saveDict],...]
                    for i in range(teamMatchNumber):
                        args.append(
                            [22122+i, i, AIlang, "../maps_2player",
                             "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]])
                    pool.starmap(Match, args)
                am = autoMatch_CrossFolder()
                am.saveDict = "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]
                am.AIwinning = [[], []]
                am.matchNumber = teamMatchNumber
                am.countMatchResult()  # 这里产生的txt文件里的开始时间是错的
                endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
                print(startTime, endTime)
