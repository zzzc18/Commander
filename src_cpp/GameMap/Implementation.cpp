/**
 * @file Implementation.cpp
 *
 * @brief @c GameMap 模块类相关函数的定义
 */

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

void MAP::Update() {
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
    auto Move = [this](int armyID, VECTOR _src, VECTOR _dst) -> bool {
        NODE &src = _mat[_src.x][_src.y], &dst = _mat[_dst.x][_dst.y];
        if (src.belong != armyID || src.unitNum <= 1)
            return false;  // FIXME magic number 1
        if (dst.type == NODE_TYPE::HILL) return false;
        if (dst.belong == armyID)
            dst.unitNum += src.unitNum - 1;  // FIXME magic number 1
        else {
            dst.unitNum -= src.unitNum - 1;  // FIXME magic number 1
            if (dst.unitNum < 0) {
                if (dst.type == NODE_TYPE::KING) {
                    // return ;
                }  //如果被占的是对方的KING，则结束
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

bool MAP::PushMove(int armyID, VECTOR src, VECTOR dst) {
    VECTOR j = {-1, -1};
    if (src == j && dst == j) {
        if (!moveCommands[armyID].empty()) {
            moveCommands[armyID].erase(moveCommands[armyID].begin());
            return true;
        }
    }
    moveCommands[armyID].insert(moveCommands[armyID].begin(), {src, dst});
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
int MAP::Load(std::string_view file) {  // file = "Input/map.map"
    std::ifstream fin(file.data());
    fin >> *this;
    fin.close();
    return kingNum;
}
void MAP::Save(std::string_view file) {  // file = "Output/map.map"
    std::ofstream fout(file.data());
    fout << *this;
    fout.close();
}

std::pair<int, int> MAP::GetSize() const { return {_sizeX, _sizeY}; }

bool MAP::InMap(VECTOR pos) const {
    return 0 <= pos.x && pos.x < _sizeX && 0 <= pos.y && pos.y < _sizeY;
}
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
