#include <fstream>
#include "GameMap.h"
using namespace std;

ifstream& operator>>(ifstream& _ifstream, NODE& node) {
    string tmp, name;
    int belong, unitNum;
    while (true) {
        _ifstream >> tmp;
        if (tmp == "{") break;
    }
    _ifstream >> name >> belong >> unitNum;
    node.ModifyType(name);
    node.ModifyBelong(belong);
    node.ModifyUnitNum(unitNum);
    _ifstream >> tmp;
    return _ifstream;
}

ofstream& operator<<(ofstream& _ofstream, const NODE& node) {
    _ofstream << "{ ";
    _ofstream << node.GetType() << " ";
    _ofstream << node.GetBelong() << " ";
    _ofstream << node.GetUnitNum();
    _ofstream << " }";
    return _ofstream;
}

ifstream& operator>>(ifstream& _ifstream, MAP*& mapPtr) {
    string tmp;
    int sizeX, sizeY, x, y;
    delete mapPtr;
    _ifstream >> tmp >> tmp >> sizeX >> sizeY;
    mapPtr = new MAP(sizeX, sizeY);
    for (int i = 0; i < sizeX * sizeY; i++) {
        NODE node;
        _ifstream >> x >> y >> tmp;
        _ifstream >> node;
        mapPtr->ModifyNode(x, y, node);
    }
    return _ifstream;
}

ofstream& operator<<(ofstream& _ofstream, const MAP* mapPtr) {
    pair<int, int> size = mapPtr->GetSize();
    _ofstream << "size : " << size.first << " " << size.second << endl;
    for (int i = 0; i < size.first; i++) {
        for (int j = 0; j < size.second; j++) {
            _ofstream << i << " " << j << " : ";
            _ofstream << mapPtr->GetNode(i, j) << endl;
        }
    }
    return _ofstream;
}