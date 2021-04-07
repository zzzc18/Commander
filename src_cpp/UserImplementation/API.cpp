#include <ctime>
#include <random>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"
#include "Verify.hpp"

using namespace std;

static int userMain(lua_State *luaState) {
    

    return 0;
}


LUA_REG_FUNC(UserImplementation, C_API(userMain))