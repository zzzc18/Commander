#include "GameMap.h"
#include <string>
using namespace std;

static int RandomGenMap(lua_State* L) {
    // TODO: player
    RandomGenMap(2);
    return 0;
}

static int GetSize(lua_State* L) {
    lua_pushnumber(L, MainMap->GetSize().first);
    lua_pushnumber(L, MainMap->GetSize().second);
    return 2;
}

static int GetNodeType(lua_State* L) {
    int x = lua_tonumber(L, 1);
    int y = lua_tonumber(L, 2);
    lua_pushstring(L, MainMap->GetNodeType(x, y).c_str());
    return 1;
}

static const luaL_Reg functions[] = {{"RandomGenMap", RandomGenMap},
                                     {"GetSize", GetSize},
                                     {"GetNodeType", GetNodeType},
                                     {NULL, NULL}};

extern "C" {
int luaopen_lib_GameMap(lua_State* L) {
    luaL_register(L, "GameMap", functions);
    return 1;
}
}