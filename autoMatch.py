import os
import time


class autoMatch(object):
    # 总计游戏局数,1<=matchNumber<=100
    matchNumber = 5
    # 参与游戏的智能体列表
    AI = ["null", "Lua", "C++", "C++"]
    # 智能体获胜记录，数量应与上方的智能体数匹配
    AIwinnings = [[], [], [], []]
    # 游戏使用的地图目录，地图中玩家数应与上方的智能体数匹配
    #mapDict = "maps_3player"
    mapDict = "default"
    mapName = ""
    # 存档文件夹名
    saveDict = "Lua_C++_C++"
    saveName = ""
    timeDelay = 2
    # 自动对战超时时间，超过后强制结束游戏并进入下一局，不产生获胜者
    timeOut = 20
    # 启动游戏时是否打开控制台
    runWithConsol = True

    def __init__(self):
        self.startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        return

    def creatClientTask(self, index):
        fp = open("ClientTask.txt", 'w')
        fp.write("true\n")  # 是否为自动对战任务
        fp.write(str(self.timeOut)+"\n")
        fp.write(self.mapDict+"\n")
        fp.write(self.mapName+"\n")
        fp.write(self.AI[index]+"\n")
        fp.close()
        return

    def creatServerTask(self):
        fp = open("ServerTask.txt", 'w')
        fp.write("true\n")  # 是否为自动对战任务
        fp.write(str(self.timeOut)+"\n")
        fp.write(self.mapDict+"\n")
        fp.write(self.mapName+"\n")
        fp.write(self.saveName+"\n")
        fp.write(self.saveDict+"\n")
        fp.close()
        return

    def startMatch(self, index):
        #self.mapName = str(index)+".map"
        self.mapName = "default"
        self.saveName = "round"+str(index)
        self.creatServerTask()
        if self.runWithConsol == True:
            os.system('cd Server&start lovec .')
        else:
            os.system('cd Server&start love .')
        time.sleep(self.timeDelay)
        for i in range(len(self.AI)-1):
            self.creatClientTask(i+1)
            if self.runWithConsol == True:
                os.system("cd Client&start lovec .")
            else:
                os.system("cd Client&start love .")
            time.sleep(self.timeDelay)
        return

    def waitUntilMatchOver(self):
        roundStartTime = time.time()
        while True:
            if os.path.exists("ServerTask.txt"):
                if time.time()-roundStartTime > self.timeOut:
                    os.remove("ServerTask.txt")
                    break
                time.sleep(1)
            else:
                break
        os.remove("ClientTask.txt")
        return

    def getMatchResult(self, index):
        fp = open(self.saveDict+"/"+self.saveName+"/steps.txt", 'r')
        lines = fp.readlines()
        fp.close()
        if lines[-1][3] == 3 and lines[-1][6] == 3:
            self.AIwinnings[lines[-1][0]].append(index)
        return

    def saveMatchResult(self):
        self.endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        fp = open("matchResult.txt", 'w')
        fp.write("match start: "+self.startTime+"\n")
        fp.write("match end: "+self.endTime+"\n")
        fp.write("total round: "+str(self.matchNumber)+"\n")
        fp.write("savedata: "+self.saveDict+"\n\n\n")
        for i in range(len(self.AI)-1):
            fp.write("armyID: "+str(i+1)+"\n")
            fp.write("AI: "+self.AI[i+1]+"\n")
            fp.write("winning: "+str(self.AIwinnings[i+1])+"\n")
            fp.write("winning rate: " +
                     str(len(self.AIwinnings[i+1])/self.matchNumber)+"\n\n")
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
