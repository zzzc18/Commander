/**
 * @file Implementation.cpp
 *
 * @brief @c GameMap 模块类相关函数的定义
 */

#include <cstdlib>
#include <ctime>
#include <fstream>
#include <queue>
#include <stdexcept>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "Debug.hpp"
#include "GameMap.hpp"
#include "Tools.hpp"
#include "Verify.hpp"

VECTOR VECTOR::operator-() const { return {-x, -y}; }

VECTOR& VECTOR::operator+=(VECTOR other) {
    x += other.x, y += other.y;
    return *this;
}
VECTOR operator+(VECTOR lhs, VECTOR rhs) { return lhs += rhs; }

VECTOR& VECTOR::operator-=(VECTOR other) {
    x -= other.x, y -= other.y;
    return *this;
}
VECTOR operator-(VECTOR lhs, VECTOR rhs) { return lhs -= rhs; }

VECTOR& VECTOR::operator*=(int c) {
    x *= c, y *= c;
    return *this;
}
VECTOR operator*(VECTOR v, int c) { return v *= c; }
VECTOR operator*(int c, VECTOR v) { return v *= c; }

bool operator==(VECTOR lhs, VECTOR rhs) {
    return lhs.x == rhs.x && lhs.y == rhs.y;
}
bool operator!=(VECTOR lhs, VECTOR rhs) {
    return lhs.x != rhs.x || lhs.y != rhs.y;
}

///////////////////////////////////////////////////////////////////////////////

MAP& MAP::Singleton() {
    static MAP singleton;
    return singleton;
}

//地图兵力自然增长
void MAP::TroopsUpdate() {
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j) _mat[i][j].Update();
    }
}
//一段时间以此的兵力大增长
void MAP::BigUpdate() {
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j) _mat[i][j].BigUpdate();
    }
}
//从moveCommands中取出最先加入的移动命令并执行
bool MAP::MoveUpdate() {
    auto Move = [this](int armyID, VECTOR _src, VECTOR _dst) -> bool {
        NODE &src = _mat[_src.x][_src.y], &dst = _mat[_dst.x][_dst.y];
        if (src.belong != armyID || src.unitNum <= 1)
            return false;  // FIXME magic number 1
        if (dst.type == NODE_TYPE::HILL) return false;
        if (VERIFY::Singleton().GetArmyID() == 0) {  //只有服务器会保存
            SaveStep(armyID, _src, _dst);
        }
        if (dst.belong == armyID)
            dst.unitNum += src.unitNum - 1;  // FIXME magic number 1
        else {
            dst.unitNum -= src.unitNum - 1;  // FIXME magic number 1
            if (dst.unitNum < 0) {
                dst.unitNum = -dst.unitNum;
                dst.belong = armyID;
            }
        }
        src.unitNum = 1;  // FIXME magic number 1
        return true;
    };
    bool ret = false;
    for (int i = 1; i <= _armyCnt; ++i) {
        while (!moveCommands[i].empty()) {
            auto& cmd = moveCommands[i].back();
            // cerr << cmd.first << cmd.second << endl;
            moveCommands[i].pop_back();
            if (Move(i, cmd.first, cmd.second)) break;
        }
    }
    return ret;
}

//步长更新
void MAP::Update() {
    step++;
    if (step % TroopsUpdateStep == 0) {
        TroopsUpdate();
    }
    if (step % BigUpdateStep == 0) {
        BigUpdate();
    }
    if (step % MoveUpdateStep == 0) {
        MoveUpdate();
    }
    //只有服务端会自动保存地图
    if (step % SaveMapStep == 0 && VERIFY::Singleton().GetArmyID() == 0) {
        SaveMap();
    }
    return;
}

//将移动命令加入moveCommands
bool MAP::PushMove(int armyID, VECTOR src, VECTOR dst) {
    VECTOR j = {-1, -1};
    if (src == j && dst == j) {  //撤销移动命令
        if (!moveCommands[armyID].empty()) {
            moveCommands[armyID].erase(moveCommands[armyID].begin());
            return true;
        }
    }
    moveCommands[armyID].insert(moveCommands[armyID].begin(), {src, dst});
    return true;
}

//编辑地图单位数量
bool MAP::IncreaseOrDecrease(VECTOR aim, int mode) {
    if (_mat[aim.x][aim.y].type != NODE_TYPE::HILL) {
        if (mode == 1) {
            _mat[aim.x][aim.y].unitNum++;
        } else {
            if (mode == 2) {
                if (_mat[aim.x][aim.y].unitNum > 1) {
                    _mat[aim.x][aim.y].unitNum--;
                }
            }
        }
    }
    return true;
}
//编辑地图格子类型
bool MAP::ChangeType(VECTOR aim, int type) {
    switch (type) {
        case 1:
            _mat[aim.x][aim.y].type = NODE_TYPE::HILL;
            _mat[aim.x][aim.y].unitNum = 0;
            _mat[aim.x][aim.y].belong = SERVER;
            break;
        case 2:
            _mat[aim.x][aim.y].type = NODE_TYPE::BLANK;
            _mat[aim.x][aim.y].unitNum = 0;
            break;
        case 3:
            _mat[aim.x][aim.y].type = NODE_TYPE::KING;
            _mat[aim.x][aim.y].unitNum = 1;
            break;
        case 4:
            _mat[aim.x][aim.y].type = NODE_TYPE::FORT;
            _mat[aim.x][aim.y].unitNum = 1;
            break;
        case 5:
            _mat[aim.x][aim.y].type = NODE_TYPE::OBSTACLE;
            _mat[aim.x][aim.y].unitNum = 1;
            break;
        case 6:
            _mat[aim.x][aim.y].type = NODE_TYPE::MARSH;
            _mat[aim.x][aim.y].unitNum = 1;
            break;
        default:
            break;
    }
    return true;
}
//编辑地图格子归属
bool MAP::ChangeBelong(VECTOR aim) {
    if (_mat[aim.x][aim.y].type == NODE_TYPE::HILL) {
        return false;
    }
    _mat[aim.x][aim.y].belong++;
    if (_mat[aim.x][aim.y].belong > 2) {
        _mat[aim.x][aim.y].belong = SERVER;
    }
    if (_mat[aim.x][aim.y].belong == SERVER &&
        _mat[aim.x][aim.y].type == NODE_TYPE::KING) {
        _mat[aim.x][aim.y].unitNum = 0;
        _mat[aim.x][aim.y].type = NODE_TYPE::BLANK;
    }
    return true;
}

void MAP::RandomGen(int armyCnt, int level) {
    _armyCnt = armyCnt;
    _sizeX = _sizeY = 24;  // FIXME magic number
    //设置每个点的类型
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j)
            _mat[i][j].type = RandomNodeType(level);
    }
    //放置 king
    std::vector<std::pair<VECTOR, NODE_TYPE>> kings;  //(pos,pre_type)
    //检查 king 是否互相连通
    auto ValidateConnectivity = [this, &kings]() -> bool {
        int kingFound = 0;
        bool vis[_sizeX][_sizeY] = {};
        std::queue<VECTOR> que;
        que.push(kings.front().first);
        vis[kings.front().first.x][kings.front().first.y] = true;
        while (!que.empty()) {
            VECTOR u = que.front();
            que.pop();
            if (_mat[u.x][u.y].type == NODE_TYPE::KING) {
                if (++kingFound == kings.size()) return true;
            }
            for (auto dta : DIR[u.x & 1]) {  //判断是奇数行还是偶数行
                if (VECTOR v = u + dta; this->InMap(v)) {
                    if (!vis[v.x][v.y] &&
                        _mat[v.x][v.y].type != NODE_TYPE::HILL) {
                        vis[v.x][v.y] = true;
                        que.push(v);
                    }
                }
            }
        }
        return false;
    };  // lambda ValidateConnectivity
    // king 不连通时把摆 king 的点的属性恢复成之前的属性以供下一次随机放置 king
    auto Recovery = [this, &kings]() -> bool {
        for (auto [pos, type] : kings) _mat[pos.x][pos.y].type = type;
        return true;  //利用逻辑运算的短路求值特性
    };
    do {  //不断随机放置 king，直至合法
        for (int i = 1; i <= _armyCnt; ++i) {
            VECTOR pos = {Random(0, _sizeX - 1), Random(0, _sizeY - 1)};
            kings.emplace_back(pos, _mat[pos.x][pos.y].type);
            _mat[pos.x][pos.y].type = NODE_TYPE::KING;
        }
    } while (!ValidateConnectivity() && Recovery());
    //设置 king 的所属军队
    for (int i = 0; i < _armyCnt; ++i)
        _mat[kings[i].first.x][kings[i].first.y].belong = i + 1;
    // 设置点的其它属性
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j) {
            if (_mat[i][j].type == NODE_TYPE::FORT)
                _mat[i][j].unitNum = Random(40, 50);  // FIXME magic number
        }
    }
}
//初始化存档文件夹，以游戏开始时间命名
void MAP::InitSavedata() {
    std::time_t t = std::time(&t) + 28800;
    struct tm* gmt = gmtime(&t);
    char cst[80];
    strftime(cst, 80, "%Y-%m-%d_%H.%M.%S", gmt);
    StartTime = cst;
    system("cd ..&mkdir Savedata");
    system(("cd ../Savedata&mkdir " + StartTime).c_str());
    return;
}
//加载游戏地图
int MAP::LoadMap(std::string_view file) {  // file = "../Data/map.map"
    std::ifstream fin(file.data());
    fin >> *this;
    fin.close();
    return kingNum;
}
//保存当前步数的游戏地图到存档文件夹，以步数命名
void MAP::SaveMap(std::string_view file) {  // file="../Savedata/"
    std::ofstream fout(file.data() + StartTime + "/" + std::to_string(step) +
                       ".map");
    fout << *this;
    fout.close();
}
//向存档文件夹中steps.txt末尾附加执行的移动命令
void MAP::SaveStep(int armyID, VECTOR src, VECTOR dst) {
    std::ofstream outfile;
    outfile.open("../Savedata/" + StartTime + "/steps.txt", std::ios::app);
    if (outfile.is_open()) {
        outfile << "\n" << step << "\n";
        outfile << armyID << " " << src.x << " " << src.y << " " << dst.x << " "
                << dst.y << "\n";
        outfile.close();
    }
    return;
}
//保存编辑后的地图文件
void MAP::SaveEdit(std::string_view file) {  // file = "../Output/map.map"
    std::ofstream fout(file.data());
    fout << *this;
    fout.close();
}

std::pair<int, int> MAP::GetSize() const { return {_sizeX, _sizeY}; }

bool MAP::InMap(VECTOR pos) const {
    return 0 <= pos.x && pos.x < _sizeX && 0 <= pos.y && pos.y < _sizeY;
}
//检查格子可见性
bool MAP::IsViewable(VECTOR pos) const {
    if (_mat[pos.x][pos.y].belong == VERIFY::Singleton().GetArmyID())
        return true;
    for (auto dta : DIR[pos.x & 1]) {  //判断是奇数行还是偶数行
        if (VECTOR next = pos + dta; this->InMap(next)) {
            if (_mat[next.x][next.y].belong == VERIFY::Singleton().GetArmyID())
                return true;
        }
    }
    return false;
}

int MAP::Judge(int armyID) {
    int x = MAP::Singleton().kingState.kingPos[armyID].x;
    int y = MAP::Singleton().kingState.kingPos[armyID].y;
    if (MAP::Singleton()._mat[x][y].belong !=
        MAP::Singleton().kingState.kingBelong[armyID]) {
        return 0;
    }
    return 1;
}

NODE_TYPE MAP::GetType(VECTOR pos) const {
    NODE_TYPE type = _mat[pos.x][pos.y].type;
    if (this->IsViewable(pos)) return type;
    switch (type) {
        default:
            return NODE_TYPE::HILL;
        case NODE_TYPE::BLANK:
            [[fallthrough]];
        case NODE_TYPE::KING:
            [[fallthrough]];
        case NODE_TYPE::OBSTACLE:
            [[fallthrough]];
        case NODE_TYPE::MARSH:
            return NODE_TYPE::BLANK;
    }
}
int MAP::GetUnitNum(VECTOR pos) const {
    return this->IsViewable(pos) ? _mat[pos.x][pos.y].unitNum : 0;
}
int MAP::GetBelong(VECTOR pos) const {
    return this->IsViewable(pos) ? _mat[pos.x][pos.y].belong : SERVER;
}
std::pair<VECTOR, VECTOR> MAP::GetArmyPath(int armyID, int step) const {
    if (!moveCommands[armyID].empty() && step < moveCommands[armyID].size()) {
        return moveCommands[armyID][step];
    } else {
        return {{-1, -1}, {-1, -1}};
    }
}

//国王处兵力增长
void MAP::NODE::Update() {
    if (belong == SERVER) return;
    switch (type) {
        default:
            break;
        case NODE_TYPE::FORT:
            [[fallthrough]];
        case NODE_TYPE::KING:
            ++unitNum;
    }
}
//空白格子兵力增长，沼泽兵力减少
void MAP::NODE::BigUpdate() {
    if (belong == SERVER) return;
    switch (type) {
        default:
            break;
        case NODE_TYPE::BLANK:
            ++unitNum;
            break;
        case NODE_TYPE::MARSH:
            --unitNum;
            break;
    }
}
