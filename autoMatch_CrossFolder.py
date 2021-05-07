#跨文件夹对战，用于小组赛
#此脚本应置于服务端所在文件夹内
import os
import time


class autoMatch(object):
    # 总计游戏局数,1<=matchNumber<=100
    matchNumber = 5
    #参与游戏的智能体文件夹名列表
    AIteam=["team_1","team_2","team_3"]
    # 参与游戏的智能体语言列表，顺序应与上一个列表对应
    AIlang = ["Lua", "C++", "Python"]
    # 智能体获胜记录，数量应与上方的智能体数匹配
    AIwinning = [[], [],[]]
    # 游戏使用的地图目录，地图中玩家数应与上方的智能体数匹配；此目录位于服务端所在文件夹外
    mapDict = "../maps_3player"
    mapName = ""
    # 存档文件夹名，不能跨文件夹，例如使用../
    saveDict = "teamMatch_1"
    saveName = ""
    timeDelay = 0.5
    # 自动对战步数限制，超过后强制结束游戏并进入下一局，不产生获胜者
    stepLimit = 200
    # 启动游戏时是否打开控制台
    runWithConsol = False
    port = 22122

    def __init__(self,_port=22122):
        self.startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        self.port=_port
        return

    def creatClientTask(self, index):
        fp = open("../"+self.AIteam[index]+"/ClientTask.txt", 'w')

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
        fp.close()
        return

    def creatServerTask(self):
        fp = open("ServerTask.txt", 'w')

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
        fp.close()
        return

    def startMatch(self, index):
        self.mapName = str(index)+".map"
        self.saveName = "round"+str(index)
        self.creatServerTask()
        if self.runWithConsol == True:
            os.system('cd Server&start lovec .')
        else:
            os.system('cd Server&start love .')
        time.sleep(self.timeDelay)
        for i in range(len(self.AIlang)):
            self.creatClientTask(i)
            if self.runWithConsol == True:
                os.system("cd ../"+self.AIteam[i]+"/Client&start lovec .")
            else:
                os.system("cd ../"+self.AIteam[i]+"/Client&start love .")
            time.sleep(self.timeDelay)
        return

    def waitUntilMatchOver(self):
        while True:
            if os.path.exists("ServerTask.txt"):
                time.sleep(1)
            else:
                break
        for i in range(len(self.AIlang)):
            os.remove("../"+self.AIteam[i]+"/ClientTask.txt")
        time.sleep(self.timeDelay)
        return

    def getMatchResult(self, index):
        fp = open(self.saveDict+"/"+self.saveName+"/steps.txt", 'r')
        lines = fp.readlines()
        fp.close()
        if lines[-1][3] == "3" and lines[-1][6] == "3":
            self.AIwinning[int(lines[-1][0])-1].append(index)
        return

    def saveMatchResult(self):
        self.endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        fp = open(self.saveDict+"/matchResult.txt", 'w')
        fp.write("match start: "+self.startTime+"\n")
        fp.write("match end: "+self.endTime+"\n")
        fp.write("total round: "+str(self.matchNumber)+"\n")
        fp.write("savedata: "+self.saveDict+"\n\n\n")
        for i in range(len(self.AIlang)):
            fp.write("team: "+self.AIteam[i]+"\n")
            fp.write("armyID: "+str(i+1)+"\n")
            fp.write("AILang: "+self.AIlang[i]+"\n")
            fp.write("winning: "+str(self.AIwinning[i])+"\n")
            fp.write("winning rate: " +
                     str(len(self.AIwinning[i])/self.matchNumber)+"\n\n")
        fp.close()
        return

    def match(self):
        for i in range(self.matchNumber):
            self.startMatch(i)
            self.waitUntilMatchOver()
            self.getMatchResult(i)
        self.saveMatchResult()
        return


am = autoMatch()
am.match()
