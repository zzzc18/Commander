#pragma once

#ifndef UserAPI_hpp
#define UserAPI_hpp

#include "GameMap.hpp"
#include "LuaAPI.hpp"

namespace AI_SDK {
class UserAPI {
   public:
    void move_to(int x, int y, double moveNum, int direction);
    // string get_game_state();
    bool is_connected(int posX1, int posY1, int posX2, int posY2);
    void add_commands(int direction, string key, string type, int x, int y);
    void clear_commands();

   private:
    lua_State* luaState;
    void Init();
    void init_AISDK_func_call(string func_name);
    int execute_AISDK_func_call(int param_num);
};

void UserAPI::init_AISDK_func_call(string func_name) {
    lua_getglobal(luaState, "AISDK");
    if (!lua_istable(luaState, -1)) throw "AI SDK -- not a table error";
    lua_pushstring(luaState, func_name);
    lua_gettable(luaState, -2);
}

void UserAPI::execute_AISDK_func_call(int param_num = 0, int ret_num = 0) {
    int iRet = lua_pcall(luaState, param_num, ret_num, 0);
    if (iRet) {
        throw lua_tostring(luaState, -1);
    }
}

void UserAPI::move_to(int x, int y, double moveNum, int direction) {
    init_AISDK_func_call("MoveTo");
    lua_pushnumber(luaState, x);
    lua_pushnumber(luaState, y);
    lua_pushnumber(luaState, moveNum);
    lua_pushnumber(luaState, direction);
    execute_AISDK_func_call(4);
}

bool UserAPI::is_connected(int posX1, int posY1, int posX2, int posY2) {
    init_AISDK_func_call("IsConnected");
    lua_pushnumber(luaState, posX1);
    lua_pushnumber(luaState, posY1);
    lua_pushnumber(luaState, posX2);
    lua_pushnumber(luaState, posY2);
    execute_AISDK_func_call(4, 1);
    return lua_toboolean(luaState, -1) == true;
}

void UserAPI::add_commands(int direction, string key, string type, int x, int y) {

}

}  // namespace AI_SDK

#endif  // UserAPI_hpp

#ifndef UserCore_hpp
#define UserCore_hpp

class UserCore {
public:
    int selectX, selectY;
    void 
};

#endif // UserCore_hpp