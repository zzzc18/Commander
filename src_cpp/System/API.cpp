/**
 * @file API.cpp
 *
 * @brief @c System 模块对 Lua 提供的 API
 */

#include "GameMap.hpp"
#include "LuaAPI.hpp"

/**
 * @brief 地图更新触发器
 *  Lua 每 @c dt 秒调用一次，该函数计数达到阈值时触发地图更新
 *
 * @note 暂时弃置
 *
 * @param dt @c double Lua 调用的时间间隔，单位：秒
 * @return @c void
 */
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

/**
 * @brief 向 Lua 注册 API，模块名为 lib/System.dll
 */
LUA_REG_FUNC(System, C_API(Update))
