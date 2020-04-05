#pragma once

#ifndef detail_LuaAPI_hpp
#define detail_LuaAPI_hpp

#include <cstddef>
#include <type_traits>
#include <utility>

#include "LuaAPI.hpp"

template <typename... types>
int APIreturn(lua_State *luaState, types... args) {
    auto Push = [luaState](auto arg) -> void {
        using type = decltype(arg);
        // in order from: lua.h
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
        else  // static_assert(false) is illegal, weird syntax...
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
        using type = decltype(arg);
        // in order from: lua.h
        if constexpr (std::is_floating_point_v<type>)
            arg = lua_tonumber(luaState, index);
        else if constexpr (std::is_integral_v<type> &&
                           !std::is_same_v<type,
                                           bool>)  // bool is integral!
            arg = lua_tointeger(luaState, index);
        else if constexpr (std::is_same_v<type, bool>)
            arg = lua_toboolean(luaState, index);
        else  // static_assert(false) is illegal, weird syntax...
            static_assert(std::is_void_v<type>, "argument has unknown type!");
    };  // TODO if-else is almost the same as what in APIreturn
    (..., Get(args, indices));
}
}  // namespace detail

template <typename... types>
void APIparam(lua_State *luaState, types &... args) {
    detail::APIparam_impl(luaState, std::index_sequence_for<types...>{},
                          args...);
}

#endif  // detail_LuaAPI_hpp
