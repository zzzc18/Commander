#include "Tools.h"

bool IsViewable(const MAP &map, int x, int y, int playerID) {
    if (!map.InMap(x, y)) return false;
    if (map.GetNode(x, y).GetBelong() == playerID) return true;
    for (auto dir : Direction8) {
        auto [nx, ny] = dir + std::pair{x, y};
        if (map.InMap(nx, ny) && map.GetNode(nx, ny).GetBelong() == playerID)
            return true;
    }
    return false;
}
