#include "Verify.h"

static int Register(lua_State* L) {
    int armyID = lua_tonumber(L, 1);
    int privilege = lua_tonumber(L, 2);
    lua_pushnumber(L, Register(armyID, privilege));
    return 1;
}

LUA_REG_FUNC(Verify, C_API(Register));
