/**
 * @file LuaAPI.hpp
 *
 * @brief ../LuaAPI.hpp 中的一些细节实现
 *  @c detail 中的都是一些外部不应该使用的内容
 */

#pragma once

#ifndef detail_LuaAPI_hpp
#define detail_LuaAPI_hpp

#include <cstddef>
#include <type_traits>
#include <utility>

#include "LuaAPI.hpp"

template <typename... types>
int APIreturn(lua_State *luaState, types... args) {
    [[maybe_unused]] auto Push = [luaState](auto arg) -> void {
        using type = decltype(arg);
        //按照 <lua.h> 中的声明顺序
        if constexpr (std::is_floating_point_v<type>)
            lua_pushnumber(luaState, arg);
        else if constexpr (std::is_integral_v<type> &&
                           !std::is_same_v<type, bool>)  // bool is integral!
            lua_pushinteger(luaState, arg);
        else if constexpr (std::is_same_v<type, char *> ||
                           std::is_same_v<type, const char *>)
            lua_pushstring(luaState, arg);
        else if constexpr (std::is_same_v<type, bool>)
            lua_pushboolean(luaState, arg);
        else  //等价于 static_assert(false)
            static_assert(std::is_void_v<type>, "argument has unknown type!");
    };
    (..., Push(args));
    return sizeof...(args);
}

namespace detail {
template <typename... types, std::size_t... indices>
void APIparam_impl(lua_State *luaState, std::index_sequence<indices...>,
                   types &... args) {
    auto Get = [luaState](auto &arg, std::size_t index) -> void {
        using type = std::remove_reference_t<decltype(arg)>;
        //按照 <lua.h> 中的声明顺序
        if constexpr (std::is_floating_point_v<type>)
            arg = lua_tonumber(luaState, index);
        else if constexpr (std::is_integral_v<type> &&
                           !std::is_same_v<type,
                                           bool>)  // bool is integral!
            arg = lua_tointeger(luaState, index);
        else if constexpr (std::is_same_v<type, bool>)
            arg = lua_toboolean(luaState, index);
        else  //等价于 static_assert(false)
            static_assert(std::is_void_v<type>, "argument has unknown type!");
    };
    (..., Get(args, indices + 1));  // Lua 的参数是从 1 开始数的
}
}  // namespace detail
template <typename... types>
void APIparam(lua_State *luaState, types &... args) {
    detail::APIparam_impl(luaState, std::index_sequence_for<types...>{},
                          args...);
}

#endif  // detail_LuaAPI_hpp
