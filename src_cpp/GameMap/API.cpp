#include "GameMap.h"
using namespace std;

static int foo(lua_State* L) {}

static const luaL_Reg functions[] = {{"foo", foo}, {NULL, NULL}};

extern "C" {
int luaopen_lib_GameMap(lua_State* L) {
    luaL_register(L, "GameMap", functions);
    return 1;
}
}