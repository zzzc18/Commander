#pragma once

#ifndef LuaAPI_hpp
#define LuaAPI_hpp

extern "C" {
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
}

// register C-API functions
// usage: LUA_REG_FUNC(library,C_API(function1),C_API(function2),...)
#define C_API(function) \
    { #function, function }
#define LUA_REG_FUNC(library, ...)                                 \
    extern "C" int luaopen_lib_##library(lua_State *luaState) {    \
        static constexpr luaL_reg FUNCTIONS[] = {__VA_ARGS__, {}}; \
        luaL_register(luaState, #library, FUNCTIONS);              \
        return 1;                                                  \
    }

// helpful tool for C-API functions to return arguments to Lua
// usage: at the end of a C-API function,
//        just write "return APIreturn(L,ret_arg1,ret_arg2,...);"
template <typename... types>
int APIreturn(lua_State *luaState, types... args);

// helpful tools for C-API functions to get parameters from Lua
// usage: declare the parameters first,
//        then just write "APIparam(L,param1,param2,...);"
template <typename... types>
void APIparam(lua_State *luaState, types &... args);

#include "detail/LuaAPI.hpp"

#endif  // LuaAPI_hpp
