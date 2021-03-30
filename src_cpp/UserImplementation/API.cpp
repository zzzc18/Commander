#include "LuaAPI.hpp"
#include "UserAPI.hpp"

static int userMain(lua_State *luaState) {
    printf("USER IMPLEMENTATION\n");
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))