/**
 * @file LuaAPI.hpp
 *
 * @brief 面向 Lua 的 API 所需要的一些东西
 */

#pragma once

#ifndef LuaAPI_hpp
#define LuaAPI_hpp

// Lua 官方的东西
extern "C" {
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
}

/**
 * @brief 向 Lua 注册 API
 *
 * @example LUA_REG_FUNC(lib,C_API(func1),C_API(func2),...)
 */
#define C_API(function) \
    { #function, function }
#define LUA_REG_FUNC(library, ...)                                 \
    extern "C" int luaopen_lib_##library(lua_State *luaState) {    \
        static constexpr luaL_reg FUNCTIONS[] = {__VA_ARGS__, {}}; \
        luaL_register(luaState, #library, FUNCTIONS);              \
        return 1;                                                  \
    }

/**
 * @brief 用于 API 函数向 Lua 返回值
 *
 * @tparam types 自动推断，无需考虑
 * @param luaState API 函数的 @c lua_State* 参数
 * @param args 零或任意多个要向 Lua 返回的值
 * @return 返回给 Lua 的值的数量
 *
 * @example 在函数末尾 return APIreturn(luaState,ret1,ret2,...);
 */
template <typename... types>
int APIreturn(lua_State *luaState, types... args);
/**
 * @brief 用于 API 函数从 Lua 获取参数
 *
 * @tparam types 自动推断，无需考虑
 * @param luaState API 函数的 @c lua_State* 参数
 * @param args 零或任意多个要从 Lua 获取的参数
 * @return @c void
 *
 * @example 先声明各参数，而后 APIparam(luaState,param1,param2,...);
 */
template <typename... types>
void APIparam(lua_State *luaState, types &... args);

#include "detail/LuaAPI.hpp"

#endif  // LuaAPI_hpp
