#include "LuaAPI.hpp"
#include "UserAPI.hpp"

static int userMain(lua_State *luaState) {
    printf("C++ Implementation Invoke\n");
    
    return 0;
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))