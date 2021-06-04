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
import xlsxwriter


def copyFile(teamName, teamAI, index):
    if(teamAI == "C++"):
        print("\ntring to copy C++ file from"+teamName)
        print("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\UserImplementation.dll ..\\Commander_"+str(
            index)+"\\lib\\UserImplementation.dll")
        os.system("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\UserImplementation.dll ..\\Commander_"+str(
            index)+"\\lib\\UserImplementation.dll")
    elif(teamAI == "Lua"):
        print("\ntring to copy Lua file from"+teamName)
        os.system("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\*.lua ..\\Commander_"+str(
            index)+"\\Client\\AI\\")
    elif(teamAI == "Python"):
        print("\ntring to copy Python file from"+teamName)
        os.system("copy /y ..\\..\\TeamsFolder\\"+teamName+"\\*.py ..\\Commander_"+str(
            index)+"\\Client\\AI\\")


def main(_processes=8):
    # 对局类型，ffa=八队混战，共一轮；1v1=八选二一对一，共56轮
    matchType = "Final1v1"
    # 每轮游戏局数,1<=teammatchNumber<=100
    teamMatchNumber = 100
    # 参与游戏的智能体文件夹名列表
    # teamMatch1
    # AIteam = ["西西米托", "阿巴阿巴队", "快乐星球小分队",
    #           "芜湖起飞", "咕咕咕", "126黑网吧", "选定之剑", "bot"]
    # AIlang = ["Lua", "Lua", "C++", "Lua", "C++", "Python", "C++", "Lua"]
    # # # teamMatch2
    # AIteam = ["zhou", "鹓鶵", "炮灰",
    #           "NULL", "UED远征计划：海豚行动", "ddl战神", "愿天堂没有ddl", "bot"]
    # AIlang = ["Python", "Lua", "C++", "Lua", "C++", "C++", "C++", "Lua"]

    # teamMatch3
    # AIteam = ["阿西莫夫执法队", "LZD_is_our_RED_Sun", "九的三次方",
    #           "为什么你们这么熟练啊", "啦啦啦啦啦", "生鱼队", "bot", "bot"]
    # AIlang = ["C++", "Lua", "Python", "C++", "Lua", "Lua", "Lua", "Lua"]

    # # teamMatch4
    # AIteam = ["稳谐莽苟偷", "土埋良乡队", "316驾校",
    #           "我的女人不翼而飞", "能动就行", "这次我觉得你能赢", "琪露诺的完美偷家教室", "bot"]
    # AIlang = ["C++", "C++", "Lua", "Python", "Python", "Python", "C++", "Lua"]

    # 决赛
    # AIteam = ["316驾校", "ddl战神",
    #           "UED远征计划：海豚行动", "咕咕咕", "九的三次方", "啦啦啦啦啦", "琪露诺的完美偷家教室", "芜湖起飞"]
    # AIlang = ["Lua",  "C++",  "C++", "C++", "Python", "Lua", "C++", "Lua"]

    # 一二名A
    AIteam = ["316驾校", "啦啦啦啦啦"]
    AIlang = ["Lua", "Lua"]
    # 一二名B
    # AIteam = ["316驾校", "琪露诺的完美偷家教室"]
    # AIlang = ["Lua", "C++"]
    # 一二名C
    # AIteam = ["316驾校", "芜湖起飞"]
    # AIlang = ["Lua", "Lua"]
    # 一二名D
    # AIteam = ["啦啦啦啦啦", "琪露诺的完美偷家教室"]
    # AIlang = ["Lua", "C++"]
    # 一二名E
    # AIteam = ["啦啦啦啦啦", "芜湖起飞"]
    # AIlang = ["Lua",  "Lua"]
    # 一二名F
    # AIteam = ["琪露诺的完美偷家教室", "芜湖起飞"]
    # AIlang = ["C++", "Lua"]

    # 决赛4player
    AIteam = ["316驾校", "啦啦啦啦啦", "琪露诺的完美偷家教室", "芜湖起飞"]
    AIlang = ["Lua", "Lua", "C++", "Lua"]

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

    elif(matchType == "1v1"):
        matches = []
        for team_1 in range(len(AIteam)):
            for team_2 in range(team_1+1, len(AIteam)):
                if team_1 != 1 or team_2 != 5:
                    continue
                print("\nstart match "+AIteam[team_1]+"vs"+AIteam[team_2])
                copyFile(AIteam[team_1], AIlang[team_1], 1)
                copyFile(AIteam[team_2], AIlang[team_2], 2)
                with Pool(processes=_processes) as pool:
                    args = []  # [[port,index,AIlang,mapDict,saveDict],...]
                    for i in range(teamMatchNumber):
                        args.append(
                            [22122+i, i, [AIlang[team_1], AIlang[team_2]], "../maps_2player",
                             "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]])
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

                am = autoMatch(armyNum=2, matchNum=teamMatchNumber)
                am.saveDict = "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]
                am.AIteam = [AIteam[team_1], AIteam[team_2]]
                am.AIlang = [AIlang[team_1], AIlang[team_2]]
                am.matchNumber = teamMatchNumber
                am.scoreMap = {1: 1, 2: 0}
                am.countMatchResult()  # 这里产生的txt文件里的开始时间是错的
                matches.append(am)
                endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
                print(startTime, endTime)
                pass
    elif(matchType == "Final1v1"):
        print("\nstart match "+AIteam[0]+"vs"+AIteam[1])

        # Round1
        copyFile(AIteam[0], AIlang[0], 1)
        copyFile(AIteam[1], AIlang[1], 2)
        Match(22122, 0, [AIlang[0], AIlang[1]], "../final_2player",
              "teamMatch_"+AIteam[0]+"_"+AIteam[1])
        os.system("taskkill /f /IM love.exe")
        os.system("taskkill /f /IM lovec.exe")
        while True:
            keyboardCommand = input("input string \"next\" to continue")
            if keyboardCommand == "next":
                break

        # Round2
        copyFile(AIteam[0], AIlang[0], 2)
        copyFile(AIteam[1], AIlang[1], 1)
        Match(22122, 1, [AIlang[1], AIlang[0]], "../final_2player",
              "teamMatch_"+AIteam[1]+"_"+AIteam[0])
        os.system("taskkill /f /IM love.exe")
        os.system("taskkill /f /IM lovec.exe")
        while True:
            keyboardCommand = input("input string \"next\" to continue")
            if keyboardCommand == "next":
                break

        # Round3
        Match(22122, 2, [AIlang[0], AIlang[1]], "../final_2player",
              "teamMatch_"+AIteam[0]+"_"+AIteam[1])
        os.system("taskkill /f /IM love.exe")
        os.system("taskkill /f /IM lovec.exe")

        am = autoMatch(armyNum=2, matchNum=teamMatchNumber)
        am.saveDict = "teamMatch_"+AIteam[0]+"_"+AIteam[1]
        am.AIteam = [AIteam[0], AIteam[1]]
        am.AIlang = [AIlang[0], AIlang[1]]
        am.matchNumber = teamMatchNumber
        am.scoreMap = {1: 1, 2: 0}
        am.countMatchResult()  # 这里产生的txt文件里的开始时间是错的
        # matches.append(am)
        # endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        # print(startTime, endTime)
        # filename = os.path.abspath(os.path.join(os.getcwd(), "statistic.xlsx"))
        # print(filename)

        # with xlsxwriter.Workbook(filename) as workbook:
        #     sheet = workbook.add_worksheet('statistic')
        #     bold = workbook.add_format({'bold': True})
        #     for j, teamname in enumerate(AIteam):
        #         sheet.write(0, j+1, teamname)
        #         sheet.write(j+1, 0, teamname)

        #     total_grade = [0] * 8
        #     for match in matches:
        #         team_1_name, team_2_name = match.AIteam[0], match.AIteam[1]
        #         team_1_id = [i for i, teamname in enumerate(
        #             AIteam) if teamname == team_1_name][0]
        #         team_2_id = [i for i, teamname in enumerate(
        #             AIteam) if teamname == team_2_name][0]
        #         print(team_1_id, team_2_id)
        #         sheet.write(team_1_id + 1, team_2_id + 1, match.AIcredit[1])
        #         # sheet.write(team_2_id + 1, team_1_id + 1, match.AIcredit[1])
        #         total_grade[team_1_id] = total_grade[team_1_id] + \
        #             match.AIcredit[1]
        #         total_grade[team_2_id] = total_grade[team_2_id] + \
        #             match.AIcredit[2]

        #     sheet.write(0, len(AIteam) + 2, "总积分")
        #     for i, grade in enumerate(total_grade):
        #         sheet.write(i + 1, len(AIteam) + 2, grade)

    elif(matchType == '4player'):
        for i in range(4):
            copyFile(AIteam[i], AIlang[i], i+1)

        with Pool(processes=_processes) as pool:
            args = []  # [[port,index,AIlang,mapDict,saveDict],...]
            for i in range(teamMatchNumber):
                args.append(
                    [22122+i, i, AIlang, "../maps_4player", "teamMatch"])
            idx = 0
            blockSize = _processes
            while True:
                pool.starmap(
                    Match, args[idx:min(idx+blockSize, teamMatchNumber)])
                os.system("taskkill /f /IM love.exe")
                os.system("taskkill /f /IM lovec.exe")
                idx = idx + blockSize
                if idx >= teamMatchNumber:
                    break


# def generateStatMatchResult(matches):
#     end
if __name__ == '__main__':
    main()
