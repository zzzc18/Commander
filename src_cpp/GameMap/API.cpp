#include <string>

#include "GameMap.h"
#include "Verify.h"
using namespace std;

//! 未来可能删除，有些地方与LoadMap行为不同，使用会出问题
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
    lua_pushnumber(L, GetUnitNum(x, y));
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
    lua_pushboolean(L, GetVision({x, y}));
    return 1;
}

static int LoadMap(lua_State* L) {
    LoadMap();
    return 0;
}

static int Update(lua_State* L) {
    MainMap->Update();
    return 0;
}

static int BigUpdate(lua_State* L) {
    MainMap->BigUpdate();
    return 0;
}

static int Move(lua_State* L) {
    int armyID = lua_tointeger(L, 1);
    int srcX = lua_tointeger(L, 2);
    int srcY = lua_tointeger(L, 3);
    int dstX = lua_tointeger(L, 4);
    int dstY = lua_tointeger(L, 5);
    MainMap->MoveNode(armyID, srcX, srcY, dstX, dstY);
    return 0;
}

static int MoveUpdate(lua_State* L) {
    bool ret = MainMap->MoveUpdate();
    if (GetArmyID() == -1)
        return 0;
    else {
        lua_pushboolean(L, ret);
        return 1;
    }
}

static const luaL_Reg functions[] = {{"RandomGenMap", RandomGenMap},
                                     {"GetSize", GetSize},
                                     {"GetNodeType", GetNodeType},
                                     {"WriteMap", WriteMap},
                                     {"LoadMap", LoadMap},
                                     {"GetUnitNum", GetUnitNum},
                                     {"GetBelong", GetBelong},
                                     {"GetVision", GetVision},
                                     {"Update", Update},
                                     {"BigUpdate", BigUpdate},
                                     {"Move", Move},
                                     {"MoveUpdate", MoveUpdate},
                                     {NULL, NULL}};

extern "C" {
int luaopen_lib_GameMap(lua_State* L) {
    luaL_register(L, "GameMap", functions);
    return 1;
}
}
