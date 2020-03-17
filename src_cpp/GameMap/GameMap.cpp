#include "GameMap.h"
#include "Tools.h"
#include <ctime>
#include <cstdlib>
#include <vector>
#include <queue>
#include <cstring>
using namespace std;

MAP* MainMap;

void LoadMap() {}

namespace Random_Gen_Map {
NODE_TYPE tmpMap[50][50];
}

NODE_TYPE RandomNode(int level) {
    double ratio = 1.0 * rand() / RAND_MAX;
    if (level == 0) {
        if (ratio < 0.70) {
            return NODE_TYPE_BLANK;
        } else if (ratio >= 0.7 && ratio < 0.8) {
            return NODE_TYPE_FORT;
        } else {
            return NODE_TYPE_HILL;
        }
    }
    if (level == 1) {
        if (ratio < 0.60) {
            return NODE_TYPE_BLANK;
        } else if (ratio >= 0.60 && ratio < 0.65) {
            return NODE_TYPE_FORT;
        } else if (ratio >= 0.65 && ratio < 0.85) {
            return NODE_TYPE_HILL;
        } else if (ratio >= 0.85 && ratio < 0.95) {
            return NODE_TYPE_OBSTACLE;
        } else {
            return NODE_TYPE_MARSH;
        }
    }
}

bool CheckKingConnectivity(vector<pair<int, int>> kingPos) {
    return true;
    using Random_Gen_Map::tmpMap;
    bool vis[50][50];
    memset(vis, 0, sizeof(vis));
    pair<int, int> direct[4];
    direct[0] = {1, 0};
    direct[1] = {0, 1};
    direct[2] = {-1, 0};
    direct[3] = {0, -1};
    queue<pair<int, int>> que;
    que.push(kingPos[0]);
    int kingNumFound = 0;
    while (true) {
        pair<int, int> fro = que.front();
        cerr << fro.first << " " << fro.second << endl;
        que.pop();
        if (vis[fro.second][fro.second]) {
            continue;
        }
        if (tmpMap[fro.second][fro.second] == NODE_TYPE_KING) {
            kingNumFound++;
            if (kingNumFound == kingPos.size()) return true;
        }
        vis[fro.first][fro.second] = 1;
        for (int i = 0; i < 4; i++) {
            pair<int, int> nex = fro + direct[i];
            if (!vis[nex.first][nex.second] && MainMap->InMap(nex) &&
                tmpMap[nex.first][nex.second] != NODE_TYPE_HILL) {
                que.push(nex);
            }
        }
    }
    return false;
}

// level=0
void RandomGenMap(int playerNum, int level) {
    MainMap = new MAP(24, 24);
    srand((unsigned)time(0));
    using Random_Gen_Map::tmpMap;
    pair<int, int> size = MainMap->GetSize();
    for (int i = 0; i < size.first; i++) {
        for (int j = 0; j < size.second; j++) {
            //由于地图不能太规整，所以我们按概率生成
            tmpMap[i][j] = RandomNode(level);
        }
    }
    vector<pair<int, int>> kingPos;
    for (int i = 1; i <= playerNum; i++) {
        int x, y;
        x = 1.0 * rand() / RAND_MAX * size.first;
        y = 1.0 * rand() / RAND_MAX * size.second;
        tmpMap[x][y] = NODE_TYPE_KING;
        kingPos.push_back({x, y});
    }
    if (!CheckKingConnectivity(kingPos)) {
        RandomGenMap(playerNum, level);
    }
    for (int i = 0; i < size.first; i++) {
        for (int j = 0; j < size.second; j++) {
            MainMap->InitNode(i, j, tmpMap[i][j]);
        }
    }
    for (int i = 0; i < kingPos.size(); i++) {
        MainMap->SetKingPos(i + 1, kingPos[i]);
    }
}

void WriteMap() {}