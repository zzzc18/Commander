#include "GameMap.h"
#include <cstdlib>
#include <iostream>
using namespace std;

// NODE_TYPE _type = NODE_TYPE_BLANK, int _unitNum = 0, int _belong = 0
NODE::NODE(NODE_TYPE _type, int _unitNum, int _belong)
    : type(_type), unitNum(_unitNum), belong(_belong) {}

void NODE::ModifyBelong(int id) { belong = id; }

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

string NODE::GetType() {
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

////////////////////////////////////////////////////////////

void MAP::Update() {
    for (int i = 0; i < sizeX; i++) {
        for (int j = 0; j < sizeY; i++) {
            mat[i][j].Update();
        }
    }
}

void MAP::BigUpdate() {
    for (int i = 0; i < sizeX; i++) {
        for (int j = 0; j < sizeY; i++) {
            mat[i][j].BigUpdate();
        }
    }
}

void MAP::InitNode(int x, int y, NODE_TYPE type) {
    if (type == NODE_TYPE_FORT) {
        int num = 40 + 1.0 * rand() / RAND_MAX * 10;
        mat[x][y] = NODE(type, num);
    } else {
        mat[x][y] = NODE(type);
    }
}

string MAP::GetNodeType(int x, int y) { return mat[x][y].GetType(); }

bool MAP::InMap(int x, int y) {
    return x >= 0 && x < MainMap->GetSize().first && y >= 0 &&
           y < MainMap->GetSize().second;
}

bool MAP::InMap(pair<int, int> pos) { return InMap(pos.first, pos.second); }

pair<int, int> MAP::GetSize() { return {sizeX, sizeY}; }

MAP::MAP(int _sizeX, int _sizeY) : sizeX(_sizeX), sizeY(_sizeY) {}

void MAP::SetKingPos(int id, pair<int, int> pos) {
    mat[pos.first][pos.second].ModifyBelong(id);
}