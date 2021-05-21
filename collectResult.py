import numpy as np
import re
from matplotlib import pyplot as plt
from matplotlib import cm
from matplotlib import axes

plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

AIteam = ["ddl战神", "316驾校", "生鱼队"]
# AIwinning[i,j]为AIteam[i]和AIteam[j]对战中AIteam[i]获胜的次数
AIwinning = np.zeros((len(AIteam), len(AIteam)))


def find(str):
    for i in range(len(AIteam)):
        if AIteam[i] == str:
            return i


def draw_heatmap(data, xlabels, ylabels):
    cmap = cm.Blues
    # cmap = cm.get_cmap('rainbow', 1000)
    figure = plt.figure(facecolor='w')
    ax = figure.add_subplot(1, 1, 1, position=[0.1, 0.15, 0.8, 0.8])
    ax.set_yticks(range(len(ylabels)))
    ax.set_yticklabels(ylabels)
    ax.set_xticks(range(len(xlabels)))
    ax.set_xticklabels(xlabels)
    map = ax.imshow(data, interpolation='nearest', cmap=cmap,
                    aspect='auto')
    cb = plt.colorbar(mappable=map, cax=None, ax=None, shrink=0.5)
    plt.show()


for team_1 in range(len(AIteam)):
    for team_2 in range(team_1+1, len(AIteam)):
        fp = open(
            "teamMatch_"+AIteam[team_1]+"_"+AIteam[team_2]+"/matchResult.txt", 'r')
        res = fp.read()
        fp.close()
        findTeamName = re.compile(r'team: (.*)')
        TeamName = findTeamName.findall(res)
        findWinning = re.compile(r'\[(.*)]')
        TeamWinning = findWinning.findall(res)
        print(TeamName)
        print(TeamWinning)
        AIwinning[find(TeamName[0]), find(TeamName[1])] = len(
            TeamWinning[0].split(', '))
print(AIwinning)
a = np.random.rand(3, 3)
draw_heatmap(AIwinning, AIteam, AIteam)
a = np.random.rand(3, 3)
