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

void MAP::TroopsUpdate() {
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j) _mat[i][j].Update();
    }
}

void MAP::BigUpdate() {
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j) _mat[i][j].BigUpdate();
    }
}

bool MAP::MoveUpdate() {
    // num是要移动的军队数，移动成功返回true
    auto Move = [this](int armyID, VECTOR _src, VECTOR _dst,
                       double num) -> bool {
        NODE &src = _mat[_src.x][_src.y], &dst = _mat[_dst.x][_dst.y];
        if (src.belong != armyID || src.unitNum <= 1) {
            return false;  // FIXME magic number 1
        }
        if (dst.type == NODE_TYPE::HILL) {
            return false;
        }
        if (num == 0 || num >= src.unitNum) {
            num = src.unitNum - 1;
        } else if (src.unitNum > num && num >= 1) {
            num = int(num);
        } else if (1 > num && num > 0) {
            num = int(num * src.unitNum);
            if (num < 1) {
                return false;
            }
        } else if (num < 0) {
            printf(
                "An error occurred when the army is trying to move: moveNum is "
                "%lf.\n",
                num);
            return false;
        }
        if (dst.belong == armyID) {
            dst.unitNum += num;  // FIXME magic number 1
        } else {
            dst.unitNum -= num;  // FIXME magic number 1
            if (dst.unitNum < 0) {
                dst.unitNum = -dst.unitNum;
                dst.belong = armyID;
            }
        }
        src.unitNum -= num;  // FIXME magic number 1
        return true;
    };
    bool ret = false;
    for (int i = 1; i <= _armyCnt; ++i) {
        while (!moveCommands[i].empty()) {
            auto& cmd = moveCommands[i].back();
            double cmdNum = moveNumCmd[i].back();
            // cerr << cmd.first << cmd.second << endl;
            moveCommands[i].pop_back();
            moveNumCmd[i].pop_back();
            if (Move(i, cmd.first, cmd.second, cmdNum)) {
                break;  //每次更新每方只移动一次
            }
        }
    }
    return ret;
}

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
    if (step % SaveMapStep == 0 &&
        VERIFY::Singleton().GetPrivilege() == 3) {  //只有服务器会保存
        SaveMap();
    }
    if (VERIFY::Singleton().GetPrivilege() == 2) {  //只有回放器会读取
        ReadMove(step);
    }
    return;
}

bool MAP::PushMove(int armyID, VECTOR src, VECTOR dst, double num) {
    if (VERIFY::Singleton().GetPrivilege() == 3) {
        SaveStep(armyID, src, dst, num);
    }
    if (src == VECTOR{-1, -1} && dst == VECTOR{-1, -1}) {  //撤销移动命令
        if (!moveCommands[armyID].empty()) {
            moveCommands[armyID].erase(moveCommands[armyID].begin());
        }
        return true;
    }
    if (dst.x < 0 || dst.y < 0 || dst.x >= this->_sizeX ||
        dst.y >= this->_sizeY) {  //移动到边界外无效
        return false;
    }
    moveCommands[armyID].insert(moveCommands[armyID].begin(), {src, dst});
    moveNumCmd[armyID].insert(moveNumCmd[armyID].begin(), num);
    return true;
}

bool MAP::IncreaseOrDecrease(VECTOR aim, int mode) {
    if (_mat[aim.x][aim.y].type != NODE_TYPE::HILL) {
        if (mode == 1) {
            _mat[aim.x][aim.y].unitNum++;
        } else {
            if (mode == 2) {
                if (_mat[aim.x][aim.y].unitNum > 0) {
                    _mat[aim.x][aim.y].unitNum--;
                }
            }
        }
    }
    return true;
}

bool MAP::ChangeType(VECTOR aim, int type) {
    if (_mat[aim.x][aim.y].type == NODE_TYPE::KING) {
        _armyCnt--;
    }
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
            this->_armyCnt++;
            _mat[aim.x][aim.y].unitNum = 0;
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

bool MAP::ChangeBelong(VECTOR aim) {
    if (_mat[aim.x][aim.y].type == NODE_TYPE::HILL) {
        return false;
    }
    _mat[aim.x][aim.y].belong++;
    if (_mat[aim.x][aim.y].belong > 4) {
        _mat[aim.x][aim.y].belong = SERVER;
    }
    if (_mat[aim.x][aim.y].belong == SERVER &&
        _mat[aim.x][aim.y].type == NODE_TYPE::KING) {
        _mat[aim.x][aim.y].unitNum = 0;
        _mat[aim.x][aim.y].type = NODE_TYPE::BLANK;
        this->_armyCnt--;
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
    // king 不连通时把摆 king 的点的属性恢复成之前的属性以供下一次随机放置
    // king
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

void MAP::InitSavedata() {
    std::time_t t = std::time(&t) + 28800;  //转换到东八区
    struct tm* gmt = gmtime(&t);
    char cst[80];
    strftime(cst, 80, "%Y-%m-%d_%H.%M.%S", gmt);
    StartTime = cst;
    system("cd ..&mkdir Savedata");
    system(("cd ../Savedata&mkdir " + StartTime).c_str());
    SaveMap();
    return;
}

int MAP::LoadMap(std::string_view file) {  // file = "../Data/"
    Debug::Singleton().Log("info", "LoadMap");
    step = 0;
    kingNum = 0;
    std::ifstream fin(std::string(file.data()) + "3Player.map");
    fin >> *this;
    fin.close();
    return this->_armyCnt;
}

void MAP::SaveMap(std::string_view file) {  // file="../Savedata/"
    Debug::Singleton().Log("info", "SaveMap");
    std::ofstream fout(file.data() + StartTime + "/" + std::to_string(step) +
                       ".map");
    fout << *this;
    fout.close();
    return;
}

void MAP::SaveStep(int armyID, VECTOR src, VECTOR dst, double num) {
    std::ofstream outfile;
    outfile.open("../Savedata/" + StartTime + "/steps.txt", std::ios::app);
    // 似乎file.data()相连后从string_view变成了string，因此可以直接和const
    // char相连
    if (outfile.is_open()) {
        outfile << "\n" << step << "\n";
        outfile << armyID << " " << src.x << " " << src.y << " " << dst.x << " "
                << dst.y << " " << num << "\n";
        outfile.close();
    }
    return;
}

void MAP::SaveGameOver(int armyID) {
    SaveStep(armyID, {-3, -3}, {0, 0}, 0);
    return;
}

void MAP::SaveEdit(std::string_view file) {  // file = "../Output/"
    std::time_t t = std::time(&t) + 28800;
    char cst[80];
    strftime(cst, 80, "%Y-%m-%d_%H.%M.%S", gmtime(&t));
    StartTime = cst;
    std::ofstream fout(file.data() + StartTime + ".map");
    fout << *this;
    fout.close();
    return;
}

int MAP::LoadReplayFile(std::string_view file,
                        int loadstep) {  // loadstep = 0
    Debug::Singleton().Log("info", "LoadReplayFile");
    step = loadstep;
    ReplayFile = std::string(file.data());
    std::ifstream fin(ReplayFile + "/" + std::to_string(loadstep) + ".map");
    if (!fin) return 0;
    fin >> *this;
    fin.close();
    return kingNum;
}

void MAP::ReadMove(int ReplayStep) {
    std::string line;
    std::ifstream replayfile;
    replayfile.open(ReplayFile + "/steps.txt", std::ios::in);
    if (replayfile.is_open()) {
        while (std::getline(replayfile, line)) {  //搜索step.txt的每一行
            if (line != std::to_string(ReplayStep)) continue;
            std::getline(replayfile, line);
            char* move = (char*)line.c_str();
            int army, sx, sy, dx, dy;
            double num;
            sscanf(move, "%d %d %d %d %d %lf", &army, &sx, &sy, &dx, &dy, &num);
            if (sx == sy && sy == -2) {  //某支军队归属改变
                Surrender(dx, dy);
            }
            if (sx == sy && sy == -3) {  //游戏结束
                ReplayOver = true;
                return;
            }
            PushMove(army, {sx, sy}, {dx, dy}, num);
        }
    }
    replayfile.close();
    return;
}

std::pair<int, int> MAP::GetSize() const { return {_sizeX, _sizeY}; }

bool MAP::InMap(VECTOR pos) const {
    return 0 <= pos.x && pos.x < _sizeX && 0 <= pos.y && pos.y < _sizeY;
}

bool MAP::IsViewable(VECTOR pos) const {
    if (SERVER == VERIFY::Singleton().GetArmyID()) {
        return true;
    }
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
        return MAP::Singleton()._mat[x][y].belong;
    }
    return 0;
}

int MAP::Surrender(int armyID, int vanquisherID) {
    if (VERIFY::Singleton().GetPrivilege() == 3) {
        SaveStep(0, {-2, -2}, {armyID, vanquisherID}, 0);
    }
    for (int i = 0; i < MAX_GRAPH_SIZE; i++) {
        for (int j = 0; j < MAX_GRAPH_SIZE; j++) {
            if (MAP::_mat[i][j].belong == armyID) {
                MAP::_mat[i][j].belong = vanquisherID;
            }
        }
    }
    MAP::_mat[MAP::Singleton().kingState.kingPos[armyID].x]
             [MAP::Singleton().kingState.kingPos[armyID].y]
                 .type = NODE_TYPE::FORT;
    //投降后kingNum减一，但_armyCnt不变
    kingNum--;
    return 0;
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
const char* MAP::GetFolder() {
    return (std::string("../Savedata/") + StartTime).c_str();
}
std::pair<int, int> MAP::GetKingPos(int armyID) const {
    int x = MAP::Singleton().kingState.kingPos[armyID].x;
    int y = MAP::Singleton().kingState.kingPos[armyID].y;
    return {x, y};
}

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
