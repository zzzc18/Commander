#ifndef __LUAAPI_H__
#define __LUAAPI_H__

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
    extern "C" int luaopen_lib_##library(lua_State *lua_state) {   \
        static constexpr luaL_reg FUNCTIONS[] = {__VA_ARGS__, {}}; \
        luaL_register(lua_state, #library, FUNCTIONS);             \
        return 1;                                                  \
    }

#endif  //__LUAAPI_H__
