/**
 * @file API.cpp
 *
 * @brief @c Verify 模块对 Lua 提供的 API
 */

#include "LuaAPI.hpp"
#include "Verify.hpp"

/**
 * @brief 注册当前军队的各个属性
 *
 * @param armyID @c int 军队编号
 * @param privilege @c int 军队权限
 * @return @c void
 */
static int Register(lua_State *luaState) {
    int armyID, privilege;
    APIparam(luaState, armyID, privilege);
    return APIreturn(luaState, VERIFY::Register(armyID, privilege));
}

/**
 * @brief 向 Lua 注册 API，模块名为 lib/Verify.dll
 */
LUA_REG_FUNC(Verify, C_API(Register))
