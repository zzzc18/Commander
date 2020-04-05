#include <fstream>
#include <queue>
#include <stdexcept>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "GameMap.hpp"
#include "Tools.hpp"

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
    auto Move = [this](int id, VECTOR _src, VECTOR _dst) -> bool {
        NODE &src = _mat[_src.x][_src.y], &dst = _mat[_dst.x][_dst.y];
        if (src.belong != id || src.unitNum <= 1)
            return false;  // FIXME 1 is magic number?
        if (src.type == NODE_TYPE::HILL) return false;
        if (dst.belong == id)
            dst.unitNum += src.unitNum - 1;  // FIXME 1 is magic number?
        else {
            dst.unitNum -= src.unitNum - 1;  // FIXME
            if (dst.unitNum < 0) {
                dst.unitNum = -dst.unitNum;
                dst.belong = id;
            }
        }
        src.unitNum = 1;  // FIXME
        return true;
    };
    bool ret = false;
    for (int i = 1; i <= _playerCnt; ++i) {
        if (auto& cmd = _moveCommands[i]; cmd) {
            if (bool tmp = Move(i, cmd->first, cmd->second);
                i)  // FIXME module verify need rewrite
                ret = tmp;
            cmd.reset();
        }
    }
    return ret;
}

bool MAP::MoveNode(int id, VECTOR src, VECTOR dst) {
    if (!_moveCommands[id]) {
        _moveCommands[id] = {src, dst};
        return true;
    }
    return false;
}

void MAP::RandomGen(int playerCnt, int level) {
    _playerCnt = playerCnt;
    _sizeX = _sizeY = 24;  // FIXME magic number
    // set node types
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j)
            _mat[i][j].type = RandomNodeType(level);
    }
    // set kings
    std::vector<std::pair<VECTOR, NODE_TYPE>> kings;  //(pos,pretype)
    auto ValidateConnectivity = [this, &kings]() -> bool {
        int kingFound = 0;
        bool vis[_sizeX][_sizeY]{};
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
    auto Recovery = [this, &kings]() -> bool {
        for (auto [pos, type] : kings) _mat[pos.x][pos.y].type = type;
        return true;  // always true, a magic short-circuit evaluation trick
    };
    do {
        for (int i = 1; i <= _playerCnt; ++i) {
            VECTOR pos{Random(0, _sizeX - 1), Random(0, _sizeY - 1)};
            kings.emplace_back(pos, _mat[pos.x][pos.y].type);
            _mat[pos.x][pos.y].type = NODE_TYPE::KING;
        }
    } while (!ValidateConnectivity() && Recovery());
    for (int i = 0; i < _playerCnt; ++i)
        _mat[kings[i].first.x][kings[i].first.y].belong = i + 1;
    // set other properties
    for (int i = 0; i < _sizeX; ++i) {
        for (int j = 0; j < _sizeY; ++j) {
            if (_mat[i][j].type == NODE_TYPE::FORT)
                _mat[i][j].unitNum = Random(40, 50);  // FIXME magic number
        }
    }
}
void MAP::Load(std::string_view file) {  // file = "Input/map.map"
    std::ifstream fin(file.data);
    fin >> *this;
    fin.close();
}
void MAP::Save(std::string_view file) {  // file = "Output/map.map"
    std::ofstream fout(file.data);
    fout << *this;
    fout.close();
}

std::pair<int, int> MAP::GetSize() const { return {_sizeX, _sizeY}; }

bool MAP::InMap(VECTOR pos) const {
    return 0 <= pos.x && pos.x <= _sizeX && 0 <= pos.y && pos.y <= _sizeY;
}
bool MAP::IsViewable(VECTOR pos) const {
    int id;  // FIXME module verify need rewrite
    if (_mat[pos.x][pos.y].belong == id) return true;
    for (auto dta : DIR[pos.x & 1]) {  //判断是奇数行还是偶数行
        if (VECTOR next = pos + dta; this->InMap(next)) {
            if (_mat[next.x][next.y].belong == id) return true;
        }
    }
    return false;
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
