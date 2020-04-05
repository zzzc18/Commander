#include <iostream>
#include <limits>

#include "GameMap.hpp"
#include "Tools.hpp"

std::istream& operator>>(std::istream& is, MAP::NODE& node) {
    std::string typeName;
    is >> skip('{') >> typeName;
    node.type = StrToNodeType(typeName);
    is >> node.belong >> node.unitNum;
    return is >> skip('}');
}
std::ostream& operator<<(std::ostream& os, MAP::NODE node) {
    os << "{ ";
    os << NodeTypeToStr(node.type) << ' ';
    os << node.belong << ' ';
    os << node.unitNum;
    os << " }";
    return os;
}

///////////////////////////////////////////////////////////////////////////////

std::istream& operator>>(std::istream& is, MAP& map) {
    is >> skip(':') >> map._playerCnt;
    is >> skip(':') >> map._sizeX >> map._sizeY;
    for (int i = 0; i < map._sizeX; ++i) {
        for (int j = 0; j < map._sizeY; ++j) is >> skip(':') >> map._mat[i][j];
    }
    return is;
}
std::ostream& operator<<(std::ostream& os, const MAP& map) {
    os << "player : " << map._playerCnt << std::endl;
    os << "size : " << map._sizeX << ' ' << map._sizeY << std::endl;
    for (int i = 0; i < map._sizeX; ++i) {
        for (int j = 0; j < map._sizeY; ++j)
            os << i << ' ' << j << " : " << map._mat[i][j] << std::endl;
    }
    return os;
}
