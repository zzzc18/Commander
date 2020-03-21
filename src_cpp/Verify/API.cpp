#include "Verify.h"

static int Register(lua_State* L) {
    int armyID = lua_tonumber(L, 1);
    int privilege = lua_tonumber(L, 2);
    lua_pushnumber(L, Register(armyID, privilege));
    return 1;
}

static const luaL_Reg functions[] = {{"Register", Register}, {NULL, NULL}};

extern "C" {
int luaopen_lib_Verify(lua_State* L) {
    luaL_register(L, "Verify", functions);
    return 1;
}
}