import os
import time


class autoMatch(object):
    # 总计游戏局数,1<=matchNumber<=100
    matchNumber = 100
    # 参与游戏的智能体列表
    AI = ["C++", "Python"]
    # 智能体获胜记录，数量应与上方的智能体数匹配
    AIwinnings = [[], []]
    # 游戏使用的地图目录，地图中玩家数应与上方的智能体数匹配
    mapDict = "maps_2player"
    # mapDict = "default"
    mapName = ""
    # 存档文件夹名，不能跨文件夹，例如使用../
    saveDict = "输出文件夹"
    saveName = ""
    timeDelay = 1.0
    # 自动对战步数限制，超过后强制结束游戏并进入下一局，不产生获胜者
    stepLimit = 2000
    # 启动游戏时是否打开控制台
    runWithConsol = False
    ClientConfigFile = "ClientTask.txt"
    ServerConfigFile = "ServerTask.txt"

    def __init__(self, port=22122):
        self.port = port
        self.startTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        return

    def creatClientTask(self, index):
        fp = open(self.ClientConfigFile, 'w')

        fp.write("[port]\n")
        fp.write(str(self.port)+"\n")

        fp.write("[autoMatch]\n")
        fp.write("true\n")  # 是否为自动对战任务

        fp.write("[stepLimit]\n")
        fp.write(str(self.stepLimit)+"\n")

        fp.write("[mapDict]\n")
        fp.write(self.mapDict+"\n")

        fp.write("[mapName]\n")
        fp.write(self.mapName+"\n")

        fp.write("[AIlang]\n")
        fp.write(self.AI[index]+"\n")
        fp.close()
        return

    def creatServerTask(self):
        fp = open(self.ServerConfigFile, 'w')

        fp.write("[port]\n")
        fp.write(str(self.port)+"\n")

        fp.write("[autoMatch]\n")
        fp.write("true\n")  # 是否为自动对战任务

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

    def startMatch(self, index, multiTest=False):
        self.mapName = str(index)+".map"
        # self.mapName = "default"
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
        for i in range(len(self.AI)):
            self.creatClientTask(i)
            if self.runWithConsol == True:
                os.system("cd Client&start lovec ."+args)
            else:
                os.system("cd Client&start love . "+args)
            time.sleep(self.timeDelay)
        return

    def waitUntilMatchOver(self):
        while True:
            if os.path.exists(self.ServerConfigFile):
                time.sleep(1)
            else:
                break
        os.remove(self.ClientConfigFile)
        time.sleep(self.timeDelay)
        return

    def getMatchResult(self, index):
        self.saveName = "round"+str(index)
        fp = open(self.saveDict+"/"+self.saveName+"/steps.txt", 'r')
        lines = fp.readlines()
        fp.close()
        if lines[-1][3] == "3" and lines[-1][6] == "3":
            self.AIwinnings[int(lines[-1][0])-1].append(index)
        return

    def saveMatchResult(self):
        self.endTime = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
        fp = open(self.saveDict+"/matchResult.txt", 'w')
        fp.write("match start: "+self.startTime+"\n")
        fp.write("match end: "+self.endTime+"\n")
        fp.write("total round: "+str(self.matchNumber)+"\n")
        fp.write("savedata: "+self.saveDict+"\n\n\n")
        for i in range(len(self.AI)):
            fp.write("armyID: "+str(i+1)+"\n")
            fp.write("AI: "+self.AI[i]+"\n")
            fp.write("winning: "+str(self.AIwinnings[i])+"\n")
            fp.write("winning rate: " +
                     str(len(self.AIwinnings[i])/self.matchNumber)+"\n\n")
        fp.close()
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


def Match(port, index):
    print(f"Running on match {index}")
    am = autoMatch(port)
    am.ClientConfigFile += str(am.port)
    am.ServerConfigFile += str(am.port)
    am.startMatch(index, multiTest=True)
    am.waitUntilMatchOver()
