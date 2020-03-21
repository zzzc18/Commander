#include <string>

#include "GameMap.h"
#include "Verify.h"
using namespace std;

static int RandomGenMap(lua_State* L) {
    // TODO: player
    RandomGenMap(2);
    return 0;
}

/**
 * @brief 获得地图大小sizeX,sizeY
 *
 * @param L
 * @return int
 */
static int GetSize(lua_State* L) {
    pair<int, int> ret = MainMap->GetSize();
    lua_pushnumber(L, ret.first);
    lua_pushnumber(L, ret.second);
    return 2;
}

static int GetNodeType(lua_State* L) {
    int x = lua_tonumber(L, 1);
    int y = lua_tonumber(L, 2);
    lua_pushstring(L, GetNodeType(x, y).c_str());
    return 1;
}

static int WriteMap(lua_State* L) {
    WriteMap();
    return 0;
}

static int GetUnitNum(lua_State* L) {
    int x = lua_tonumber(L, 1);
    int y = lua_tonumber(L, 2);
    lua_pushnumber(L, MainMap->GetUnitNum(x, y));
    return 1;
}

static int GetBelong(lua_State* L) {
    int x = lua_tonumber(L, 1);
    int y = lua_tonumber(L, 2);
    lua_pushnumber(L, GetBelong(x, y));
    return 1;
}

static int GetVision(lua_State* L) {
    int x = lua_tonumber(L, 1);
    int y = lua_tonumber(L, 2);
    int armyID = GetArmyID();
    lua_pushboolean(L, GetVision({x, y}, armyID));
    return 1;
}

static int LoadMap(lua_State* L) {
    LoadMap();
    return 0;
}

LUA_REG_FUNC(GameMap, C_API(RandomGenMap), C_API(GetSize), C_API(GetNodeType),
             C_API(WriteMap), C_API(LoadMap), C_API(GetUnitNum),
             C_API(GetBelong), C_API(GetVision));
