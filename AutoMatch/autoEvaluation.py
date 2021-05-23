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
from os.path import pathsep
import time
from multiprocessing import Pool
import numpy as np
import re
import AutoMatch.autoMatch_CrossFolder
from AutoMatch.autoMatch_CrossFolder import autoMatch, Match


def copyFile(teamName, teamAI, index):
    if(teamAI == "C++"):
        print("\ntring to copy C++ file from"+teamName)
        print("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\lib\\UserImplementation.dll ..\\Commander_"+str(
            index)+"\\lib\\UserImplementation.dll")
        os.system("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\lib\\UserImplementation.dll ..\\Commander_"+str(
            index)+"\\lib\\UserImplementation.dll")
    elif(teamAI == "Lua"):
        print("\ntring to copy Lua file from"+teamName)
        os.system("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\Client\\AI\\*.lua ..\\Commander_"+str(
            index)+"\\Client\\AI\\")
    elif(teamAI == "Python"):
        print("\ntring to copy Python file from"+teamName)
        os.system("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\Client\\AI\\*.py ..\\Commander_"+str(
            index)+"\\Client\\AI\\")


def main(_processes=8):
    # 对局类型，ffa=八队混战，共一轮；1v1=八选二一对一，共56轮
    matchType = "ffa"
    # 每轮游戏局数,1<=teammatchNumber<=100
    teamMatchNumber = 100
    # 参与游戏的智能体文件夹名列表
    AIteam = ["zhou", "鹓鶵", "炮灰",
              "NULL", "UED远征计划：海豚行动", "ddl战神", "愿天堂没有ddl", "bot"]
    AIlang = ["Python", "Lua", "C++", "Lua", "C++", "C++", "C++", "Lua"]

    startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())

    if(matchType == "ffa"):
        for i in range(8):
            copyFile(AIteam[i], AIlang[i], i+1)

        with Pool(processes=_processes) as pool:
            args = []  # [[port,index,AIlang,mapDict,saveDict],...]
            for i in range(teamMatchNumber):
                args.append(
                    [22122+i, i, AIlang, "../maps_8player", "teamMatch"])
            idx = 0
            blockSize = _processes
            while True:
                pool.starmap(
                    Match, args[idx:min(idx+blockSize, teamMatchNumber)])
                os.system("taskkill /f /IM love.exe")
                os.system("taskkill /f /IM lovec.exe")
                idx = idx+blockSize
                if idx >= teamMatchNumber:
                    break

        # 统计结果
        # am = autoMatch()
        # am.saveDict = "teamMatch"
        # am.AIwinning = [[], [], [], [], [], [], [], []]
        # am.matchNumber = teamMatchNumber
        # am.countMatchResult()
        # # 这里产生的txt文件里的开始时间是错的
        # endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        # print(startTime, endTime)

    elif(matchType == "1v1"):
        for team_1 in range(len(AIteam)):
            for team_2 in range(team_1+1, len(AIteam)):
                print("\nstatr match "+AIteam[team_1]+"vs"+AIteam[team_2])
                copyFile(AIteam[team_1], AIlang[team_1], 1)
                copyFile(AIteam[team_2], AIlang[team_2], 2)
                with Pool(processes=10) as pool:
                    args = []  # [[port,index,AIlang,mapDict,saveDict],...]
                    for i in range(teamMatchNumber):
                        args.append(
                            [22122+i, i, [AIlang[team_1], AIlang[team_2]], "maps_2player",
                             "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]])
                    pool.starmap(Match, args)
                am = autoMatch()
                am.saveDict = "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]
                am.AIwinning = [[], []]
                am.AIteam = [AIteam[team_1], AIteam[team_2]]
                am.AIlang = [AIlang[team_1], AIlang[team_2]]
                am.matchNumber = teamMatchNumber
                am.countMatchResult()  # 这里产生的txt文件里的开始时间是错的
                endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
                print(startTime, endTime)
                fp = open(
                    "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]+"/matchResult.txt", 'r')
                res = fp.read()
                fp.close()
                findTeamName = re.compile(r'team: (.*)')
                TeamName = findTeamName.findall(res)


if __name__ == '__main__':
    main()
