#ifndef Tools_H
#define Tools_H

#include <iostream>
#include <utility>

#include "GameMap.h"

inline std::pair<int, int> operator+(std::pair<int, int> x,
                                     std::pair<int, int> y) {
    return {x.first + y.first, x.second + y.second};
}

inline std::pair<int, int> operator-(std::pair<int, int> x,
                                     std::pair<int, int> y) {
    return {x.first - y.first, x.second - y.second};
}

////////////////////////////////////////////////////////////

inline constexpr std::pair<int, int> Direction4[] = {
    {-1, 0}, {1, 0}, {0, -1}, {0, 1}};
inline constexpr std::pair<int, int> Direction8[] = {
    {-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};

//判断map中的(x,y)对于playerID是否可见
bool IsViewable(const MAP &map, int x, int y, int playerID);

#endif
