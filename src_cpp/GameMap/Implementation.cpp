#include <cstdlib>
#include <iostream>
#include <memory>

#include "GameMap.h"
#include "Tools.h"
using namespace std;

// NODE_TYPE _type = NODE_TYPE_BLANK, int _unitNum = 0, int _belong = 0
NODE::NODE(NODE_TYPE _type, int _unitNum, int _belong)
    : type(_type), unitNum(_unitNum), belong(_belong) {}

NODE_TYPE NODE::Type() const { return type; }

void NODE::ModifyBelong(int id) { belong = id; }
void NODE::ModifyUnitNum(int _unitNum) { unitNum = _unitNum; }
void NODE::ModifyType(NODE_TYPE _type) { type = _type; }

void NODE::ModifyType(std::string _type) {
    if (_type == "NODE_TYPE_BLANK") type = NODE_TYPE_BLANK;
    if (_type == "NODE_TYPE_HILL") type = NODE_TYPE_HILL;
    if (_type == "NODE_TYPE_FORT") type = NODE_TYPE_FORT;
    if (_type == "NODE_TYPE_KING") type = NODE_TYPE_KING;
    if (_type == "NODE_TYPE_OBSTACLE") type = NODE_TYPE_OBSTACLE;
    if (_type == "NODE_TYPE_MARSH") type = NODE_TYPE_MARSH;
}

void NODE::Update() {
    if (!belong) return;
    switch (type) {
        case NODE_TYPE_FORT:
            unitNum++;
            break;
        case NODE_TYPE_KING:
            unitNum++;
        default:
            break;
    }
}

void NODE::BigUpdate() {
    if (!belong) return;
    switch (type) {
        case NODE_TYPE_BLANK:
            unitNum++;
            break;
        case NODE_TYPE_MARSH:
            unitNum--;
        default:
            break;
    }
}

string NODE::GetType() const {
    switch (type) {
        case NODE_TYPE_BLANK:
            return "NODE_TYPE_BLANK";
        case NODE_TYPE_HILL:
            return "NODE_TYPE_HILL";
        case NODE_TYPE_FORT:
            return "NODE_TYPE_FORT";
        case NODE_TYPE_KING:
            return "NODE_TYPE_KING";
        case NODE_TYPE_OBSTACLE:
            return "NODE_TYPE_OBSTACLE";
        case NODE_TYPE_MARSH:
            return "NODE_TYPE_MARSH";
        default:
            break;
    }
}

int NODE::GetUnitNum() const { return unitNum; }
int NODE::GetBelong() const { return belong; }

////////////////////////////////////////////////////////////

void MAP::Update() {
    for (int i = 0; i < sizeX; i++) {
        for (int j = 0; j < sizeY; j++) {
            mat[i][j].Update();
        }
    }
}

void MAP::BigUpdate() {
    for (int i = 0; i < sizeX; i++) {
        for (int j = 0; j < sizeY; j++) {
            mat[i][j].BigUpdate();
        }
    }
}

bool MAP::MoveUpdate() {
    auto Move = [this](int armyID, int srcX, int srcY, int dstX,
                       int dstY) -> bool {
        if (GetBelong(srcX, srcY) != armyID || GetUnitNum(srcX, srcY) <= 1)
            return false;
        if (GetNodeType(dstX, dstY) == "NODE_TYPE_HILL") return false;
        mat[dstX][dstY].ModifyUnitNum(
            GetUnitNum(dstX, dstY) +
            (GetBelong(dstX, dstY) == armyID ? 1 : -1) *
                (GetUnitNum(srcX, srcY) - 1));
        if (int num = GetUnitNum(dstX, dstY); num < 0) {
            mat[dstX][dstY].ModifyUnitNum(-num);
            mat[dstX][dstY].ModifyBelong(armyID);
        }
        return true;
    };
    bool ret = false;
    for (int i = 1, cnt = GetKingCnt(); i <= cnt; ++i) {
        if (moveCommands[i]) {
            auto [srcX, srcY] = moveCommands[i]->first;
            auto [dstX, dstY] = moveCommands[i]->second;
            if (bool tmp = Move(i, srcX, srcY, dstX, dstY); i == GetArmyID())
                ret = tmp;
            moveCommands[i].reset();
        }
    }
    return ret;
}

void MAP::InitNode(int x, int y, NODE_TYPE type) {
    if (type == NODE_TYPE_FORT) {
        int num = 40 + 1.0 * rand() / RAND_MAX * 10;
        mat[x][y] = NODE(type, num);
    } else {
        mat[x][y] = NODE(type);
    }
}

string MAP::GetNodeType(int x, int y) const { return mat[x][y].GetType(); }

bool MAP::InMap(int x, int y) {
    return x >= 0 && x < MainMap->GetSize().first && y >= 0 &&
           y < MainMap->GetSize().second;
}

bool MAP::InMap(pair<int, int> pos) { return InMap(pos.first, pos.second); }

pair<int, int> MAP::GetSize() const { return {sizeX, sizeY}; }

MAP::MAP(int _sizeX, int _sizeY)
    : sizeX(_sizeX), sizeY(_sizeY), kingCnt(0), mat{} {}

void MAP::SetKingPos(int id, pair<int, int> pos) {
    mat[pos.first][pos.second].ModifyBelong(id);
}

NODE MAP::GetNode(int x, int y) const { return mat[x][y]; }

int MAP::GetBelong(int x, int y) const { return mat[x][y].GetBelong(); }

int MAP::GetUnitNum(int x, int y) const { return mat[x][y].GetUnitNum(); }

int MAP::GetKingCnt() const { return kingCnt; }

void MAP::ModifyNode(int x, int y, NODE node) {
    kingCnt -= (mat[x][y].Type() == NODE_TYPE_KING);
    mat[x][y] = node;
    kingCnt += (mat[x][y].Type() == NODE_TYPE_KING);
}

void MAP::MoveNode(int armyID, int srcX, int srcY, int dstX, int dstY) {
    if (!moveCommands[armyID])
        moveCommands[armyID] = {{srcX, srcY}, {dstX, dstY}};
}
