#include "GameMap.hpp"
#include "LuaAPI.hpp"

[[deprecated]] static int Update(lua_State* luaState) {
    static int cnt;
    static double totalTime;
    double dt;
    APIparam(luaState, dt);
    totalTime += dt;
    if (totalTime > 1) {
        totalTime -= 1;
        if (++cnt == 25) {
            cnt = 0;
            MAP::Singleton().BigUpdate();
        } else
            MAP::Singleton().Update();
    }
    return APIreturn(luaState);
}

LUA_REG_FUNC(System, C_API(Update))
