#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"

using namespace std;

UserAPI& UserAPI::Singleton(lua_State * L) {
    if (!has_init && L == nullptr) throw "ERROR: argument lua_State not given for initialization";
    static UserAPI singleton(L);
    has_init = true;
    return singleton;
}

void UserAPI::lua_pushstring(string str) { ::lua_pushstring(luaState, str.c_str()); }

void UserAPI::init_func_call(string class_name, string func_name) {
    lua_getglobal(luaState, class_name.c_str());
    if (!lua_istable(luaState, -1)) throw "AI SDK -- not a table error";
    lua_pushstring(func_name);
    lua_gettable(luaState, -2);
}

void UserAPI::execute_func_call(int param_num, int ret_num) {
    int iRet = lua_pcall(luaState, param_num, ret_num, 0);
    if (iRet) {
        throw lua_tostring(luaState, -1);
    }
}

void UserAPI::move_to(VECTOR dest, double moveNum, int direction) {
    init_func_call("AISDK", "MoveTo");
    lua_pushnumber(luaState, dest.x);
    lua_pushnumber(luaState, dest.y);
    lua_pushnumber(luaState, moveNum);
    lua_pushnumber(luaState, direction);
    execute_func_call(4);
}

bool UserAPI::is_connected(int posX1, int posY1, int posX2, int posY2) {
    init_func_call("AISDK", "IsConnected");
    lua_pushnumber(luaState, posX1);
    lua_pushnumber(luaState, posY1);
    lua_pushnumber(luaState, posX2);
    lua_pushnumber(luaState, posY2);
    execute_func_call(4, 1);
    return lua_toboolean(luaState, -1) == true;
}

void UserAPI::add_commands(int direction, string key, string type, int x,
                           int y) {
    init_func_call("AISDK", "addCommands");
    lua_pushnumber(luaState, direction);
    lua_pushstring(key);
    lua_pushstring(type);
    lua_pushnumber(luaState, x);
    lua_pushnumber(luaState, y);
    execute_func_call(5);
}

void UserAPI::get_lua_property(string class_name, string property) {
    lua_getglobal(luaState, class_name.c_str());
    if (!lua_istable(luaState, -1)) {
        throw "not a table" + class_name;
    }
    lua_pushstring(property);
    lua_gettable(luaState, -2);
}

string UserAPI::get_game_state() const { 

}
