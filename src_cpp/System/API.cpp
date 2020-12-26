/**
 * @file API.cpp
 *
 * @brief @c System 模块对 Lua 提供的 API
 */

#include "GameMap.hpp"
#include "LuaAPI.hpp"

/**
 * @brief 地图更新触发器
 *  Lua 每 @c dt 秒调用一次，该函数计数达到0.5秒时触发地图更新
 *
 * @param dt @c double Lua 调用的时间间隔，单位：秒
 * @return @c void
 */
static int Update(lua_State* luaState) {
    static double totalTime;
    double dt;
    APIparam(luaState, dt);
    totalTime += dt;
    if (totalTime > 0.5) {
        totalTime -= 0.5;
        MAP::Singleton().Update();
    }
    return APIreturn(luaState);
}

/**
 * @brief 向 Lua 注册 API，模块名为 lib/System.dll
 */
LUA_REG_FUNC(System, C_API(Update))
