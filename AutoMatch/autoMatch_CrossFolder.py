# 跨文件夹对战，用于小组赛
# 此脚本应置于服务端所在文件夹内
import os
import time
import xlsxwriter
import math
import numpy as np


class autoMatch(object):
    # 总计游戏局数,1<=matchNumber<=100
    matchNumber = 5
    # 参与游戏的智能体文件夹名列表
    AIteam = ["team_1", "team_2", "team_3"]
    # 参与游戏的智能体语言列表，顺序应与上一个列表对应
    AIlang = ["Lua", "Python"]
    # 智能体获胜记录，数量应与上方的智能体数匹配
    AIwinning = [[], [], []]
    # 智能体的积分总额
    AIcredit = []
    # 游戏使用的地图目录，地图中玩家数应与上方的智能体数匹配；此目录位于服务端所在文件夹外
    mapDict = "../maps_2player"
    mapName = ""
    # 存档文件夹名，不能跨文件夹，例如使用../
    saveDict = "teamMatch_1"
    saveName = ""
    timeDelay = 0.3
    # 自动对战步数限制，超过后强制结束游戏并进入下一局，不产生获胜者
    stepLimit = 2000
    # 启动游戏时是否打开控制台
    runWithConsol = False
    ClientConfigFile = "ClientTask.txt"
    ServerConfigFile = "ServerTask.txt"
    armyNum = 8
    scoreMap = {1: 8, 2: 5, 3: 4, 4: 3, 5: 2, 6: 1, 7: 0, 8: 0}

    def __init__(self, _port=22122, armyNum=8, AIteam=[], AIlang=[], matchNum=100):
        self.startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        self.port = _port
        self.AIwinning = [[] for i in range(armyNum + 1)]
        self.armyNum = armyNum
        self.AIteam, self.AIlang, self.matchNumber = AIteam, AIlang, matchNum
        self.AIcredit = [0] * (self.armyNum + 1)
        return

    def creatClientTask(self, index):
        print(index)
        fp = open(os.path.join("..",
                  self.AIteam[index], self.ClientConfigFile), 'w')

        fp.write("[port]\n")
        fp.write(str(self.port)+"\n")

        fp.write("[autoMatch]\n")
        fp.write("true\n")

        fp.write("[stepLimit]\n")
        fp.write(str(self.stepLimit)+"\n")

        fp.write("[mapDict]\n")
        fp.write(self.mapDict+"\n")

        fp.write("[mapName]\n")
        fp.write(self.mapName+"\n")

        fp.write("[AIlang]\n")
        fp.write(self.AIlang[index]+"\n")

        fp.write("[teamID]\n")
        fp.write(str(index+1)+"\n")
        fp.close()
        return

    def creatServerTask(self):
        fp = open(self.ServerConfigFile, 'w')

        fp.write("[port]\n")
        fp.write(str(self.port)+"\n")

        fp.write("[autoMatch]\n")
        fp.write("true\n")

        fp.write("[stepLimit]\n")
        fp.write(str(self.stepLimit)+"\n")

        fp.write("[mapDict]\n")
        fp.write(self.mapDict+"\n")

        fp.write("[mapName]\n")
        fp.write(self.mapName+"\n")

        fp.write("[saveName]\n")
        fp.write(self.saveName+"\n")

        fp.write("[saveDict]\n")
        fp.write(self.saveDict+"\n")

        fp.write("[saveDict]\n")
        fp.write(self.saveDict+"\n")

        # for i in range(len(self.AIteam)):
        #     fp.write("[teamID]\n")
        #     fp.write(str(self.AIteam[i])+" "+str(i+1)+"\n")

        fp.close()
        return

    def startMatch(self, index, multiTest=False):
        self.mapName = str(index)+".map"
        self.saveName = "round"+str(index)
        self.creatServerTask()

        # 传入给love的参数
        args = ""
        if multiTest:
            args = " multiprocess "+str(self.port)

        if self.runWithConsol == True:
            os.system('cd Server&start lovec .'+args)
        else:
            os.system('cd Server&start love .'+args)
        time.sleep(self.timeDelay)
        for i in range(len(self.AIlang)):
            self.creatClientTask(i)
            if self.runWithConsol == True:
                os.system("cd ../"+self.AIteam[i]+"/Client&start lovec ."+args)
            else:
                os.system("cd ../"+self.AIteam[i]+"/Client&start love ."+args)
            time.sleep(self.timeDelay)
        return

    def waitUntilMatchOver(self):
        while True:
            if os.path.exists(self.ServerConfigFile):
                time.sleep(1)
            else:
                break
        for i in range(len(self.AIlang)):
            os.remove("../"+self.AIteam[i]+"/"+self.ClientConfigFile)
        time.sleep(self.timeDelay)
        return

    def getMatchResult(self, index):
        self.saveName = "round"+str(index)
        fp = open(self.saveDict+"/"+self.saveName+"/steps.txt", 'r')
        # lines = fp.readlines()
        _lines = fp.read().split("\n")
        lines = []
        for line in _lines:
            if line != "" and (not line.isnumeric()):
                line = line.split(' ')
                for i in range(len(line)):
                    if i == 5:
                        line[i] = float(line[i])
                        continue
                    line[i] = int(line[i])
                if (line[1] == -2 and line[2] == -2) or (line[1] == -3 and line[2] == -3):
                    lines.append(line)
        fp.close()

        assert len(lines) == self.armyNum

        # 将最后 alive 的组按照剩余兵力升序排序
        lines = [l for i, l in sorted(
            list(enumerate(lines)), key=lambda l: l[0] + math.sqrt(l[1][3]) * l[1][4] if l[1][1] == -3 else 0)]

        for i, line in enumerate(lines):
            loser_teamid = 0
            gameInfo = None, None
            if line[1] == -2:
                loser_teamid = line[3]
                if line[4] == 0:
                    gameInfo = 'TLE', 0
                else:
                    gameInfo = 'Killed', line[4]
            elif line[1] == -3:
                loser_teamid = line[0]
                gameInfo = 'Score', math.log(math.sqrt(line[3]) * line[4], 10)

            self.AIwinning[loser_teamid].append([None] * 3)
            self.AIwinning[loser_teamid][-1][0] = 8 - i
            self.AIwinning[loser_teamid][-1][1:3] = gameInfo

            self.AIcredit[loser_teamid] = self.AIcredit[loser_teamid] + \
                self.scoreMap[8-i]

            # 8-i 为当前队伍的名次

        # 重写了杨卓的函数，只完成了一半
        # message = []
        # lines.reverse()
        # for line in lines:
        #     message.append(list(line.split(' ')))

        # if lines[-1][3] == "3" and lines[-1][6] == "3":
        #     self.AIwinning[int(lines[-1][0])-1].append(index)
        # return

    def saveMatchResult(self):
        for i, team in enumerate(self.AIwinning):
            if i == 0:
                continue
            print("Team %d sum credit = %d" % (i, self.AIcredit[i]))

            filename = os.path.join(self.saveDict, 'testResult.xlsx')
            with xlsxwriter.Workbook(filename) as workbook:
                ranksheet = workbook.add_worksheet("rank")
                bold = workbook.add_format({'bold': True})

                for j, teamname in enumerate(self.AIteam):
                    ranksheet.write(0, j+1, teamname)

                for j, team in enumerate(self.AIwinning):
                    curlinenum = 3
                    if j == 0:
                        continue
                    for i, rank in enumerate(team):
                        ranksheet.write(curlinenum, 0, i, bold)
                        ranksheet.write(
                            curlinenum, j, rank[0], bold)
                        curlinenum = curlinenum + 1
                        for k, blockitem in enumerate(rank):
                            if k == 0:
                                continue
                            ranksheet.write(curlinenum, j, blockitem)
                            curlinenum = curlinenum + 1
                        curlinenum = curlinenum + 1
                ranksheet.write(1, 0, '总积分')
                for j in range(1, self.armyNum + 1):
                    ranksheet.write(1, j, self.AIcredit[j] + 100)

                curlinenum = curlinenum + 1

        # self.endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        # fp = open(self.saveDict+"/matchResult.txt", 'w')
        # fp.write("match start: "+self.startTime+"\n")
        # fp.write("match end: "+self.endTime+"\n")
        # fp.write("total round: "+str(self.matchNumber)+"\n")
        # fp.write("savedata: "+self.saveDict+"\n\n\n")
        # print(self.AIlang)
        # for i in range(len(self.AIlang)):
        #     print(i)
        #     fp.write("team: "+self.AIteam[i]+"\n")
        #     fp.write("armyID: "+str(i+1)+"\n")
        #     fp.write("AILang: "+self.AIlang[i]+"\n")
        #     fp.write("winning: "+str(self.AIwinning[i])+"\n")
        #     fp.write("winning rate: " +
        #              str(len(self.AIwinning[i])/self.matchNumber)+"\n\n")
        # fp.close()

        return

    def match(self):
        for i in range(self.matchNumber):
            self.startMatch(i)
            self.waitUntilMatchOver()
            self.getMatchResult(i)
        self.saveMatchResult()
        return

    def countMatchResult(self):
        '''
        用于统计整个文件夹的对局信息
        '''
        for i in range(self.matchNumber):
            self.getMatchResult(i)
        self.saveMatchResult()


if __name__ == "__main__":
    am = autoMatch()
    am.match()


def Match(port, index, _AIlang, _mapDict, _saveDict):
    print(f"Running on match {index}")
    am = autoMatch(_port=port)
    am.AIteam = ["Commander_1", "Commander_2", "Commander_3", "Commander_4",
                 "Commander_5", "Commander_6", "Commander_7", "Commander_8"]
    am.AIlang = _AIlang
    am.mapDict = _mapDict
    am.saveDict = _saveDict
    am.ClientConfigFile += str(am.port)
    am.ServerConfigFile += str(am.port)
    am.startMatch(index, multiTest=True)
    am.waitUntilMatchOver()
