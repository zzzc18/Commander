#include "LuaAPI.hpp"
#include "Verify.hpp"

static int Register(lua_State *luaState) {
    int armyID, privilege;
    APIparam(luaState, armyID, privilege);
    return APIreturn(luaState, VERIFY::Register(armyID, privilege));
}

LUA_REG_FUNC(Verify, C_API(Register))
