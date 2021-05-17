#include <ctime>
#include <iostream>
#include <random>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"
#include "Verification.hpp"

using namespace std;

static int userMain(lua_State *luaState) {
    UserAPI &API = UserAPI::Singleton(luaState);
    MAP &mmap = MAP::Singleton();
    int id = VERIFICATION::Singleton().GetArmyID();
    // User Code Begin

    // User Code End
    return 0;
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))
