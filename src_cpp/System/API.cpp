/**
 * @file API.cpp
 *
 * @brief @c System 模块对 Lua 提供的 API
 */

#include "GameMap.hpp"
#include "LuaAPI.hpp"

using namespace System;

/**
 * @brief 地图更新触发器
 *  Lua 每 @c dt 秒调用一次，该函数计数达到StepTime秒时触发地图更新
 *
 * @param dt @c double Lua 调用的时间间隔，单位：秒
 * @return @c int 地图当前步数
 */
static int Update(lua_State* luaState) {
    double dt;
    APIparam(luaState, dt);
    MAP::Singleton().timeFromLastStep += dt;
    if (MAP::Singleton().timeFromLastStep > StepTime) {
        MAP::Singleton().timeFromLastStep -= StepTime;
        MAP::Singleton().Update();
    }
    return APIreturn(luaState, MAP::Singleton().step);
}

/**
 * @brief 向 Lua 注册 API，模块名为 lib/System.dll
 */
LUA_REG_FUNC(System, C_API(Update))
