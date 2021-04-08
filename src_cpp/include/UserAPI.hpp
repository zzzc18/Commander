#pragma once

#include <iostream>
#include "GameMap.hpp"
#include "LuaAPI.hpp"

#ifndef UserAPI_hpp
#define UserAPI_hpp

class UserAPI {
public:
    static UserAPI& Singleton(lua_State *L = nullptr) {
        static bool has_init = false;
        if (!has_init && L == nullptr)   "ERROR: argument lua_State not given for initialization";
        static UserAPI singleton(L);
        has_init = true;
        return singleton;
    }
    
    UserAPI( UserAPI &) = delete;
    bool operator=(const UserAPI &) = delete;

    // 初始化一个类成员函数的执行，参数为类名和函数名
    void init_func_call(std::string class_name, std::string func_name) {
        lua_getglobal(luaState, class_name.c_str());
        if (!lua_istable(luaState, -1)) throw "AI SDK -- not a table error";
        lua_pushstring(func_name);
        lua_gettable(luaState, -2);
    }
    // 执行lua_State栈顶的函数，参数分别为参数个数与返回值个数     
    void execute_func_call(int param_num = 0, int ret_num = 0) {
        int iRet = lua_pcall(luaState, param_num, ret_num, 0);
        if (iRet) {
            throw lua_tostring(luaState, -1);
        }
    }
    // 向lua_State中压入一个字符串
    void lua_pushstring(std::string str)  {
        ::lua_pushstring(luaState, str.c_str());
    }
    // 获取lua表中的元素（可以是函数），两个参数分别为全局表名和数据项名
    void get_lua_property(std::string class_name, std::string property_name)  {
        // std::cout << "Called get_lua_property " << class_name << " : " << property_name << std::endl;
        lua_getglobal(luaState, class_name.c_str());
        if (!lua_istable(luaState, -1)) {
            std::cout << "Error: not a table" << std::endl;
            throw "not a table" + class_name;
        }
        // std::cout << "table " << class_name << " got" << std::endl;
        lua_getfield(luaState, -1, property_name.c_str());
    }


    // 执行移动操作
    void move_to(VECTOR dest, double moveNum, int direction) {
        init_func_call("AI_SDK", "MoveTo");
        lua_pushnumber(luaState, dest.x);
        lua_pushnumber(luaState, dest.y);
        lua_pushnumber(luaState, moveNum);
        lua_pushnumber(luaState, direction);
        execute_func_call(4);
    }
    // 判断两个点是否相连
    bool is_connected(int posX1, int posY1, int posX2, int posY2) {
        init_func_call("AI_SDK", "IsConnected");
        lua_pushnumber(luaState, posX1);
        lua_pushnumber(luaState, posY1);
        lua_pushnumber(luaState, posX2);
        lua_pushnumber(luaState, posY2);
        execute_func_call(4, 1);
        return lua_toboolean(luaState, -1) == true;
    }
    
    // 获取King的位置
    VECTOR king_pos() {
        get_lua_property("AI_SDK", "KingPos");
        if (!lua_istable(luaState, -1)) {
            throw "not a table: KingPos";
        }
        lua_getfield(luaState, -1, "x");
        int x = lua_tonumber(luaState, -1);
        lua_getfield(luaState, -2, "y");
        int y = lua_tonumber(luaState, -1);
        return {x, y};
    }
    // 获取当前的step数
    int get_current_step() {
        get_lua_property("ReplayGame", "step");
        return lua_tonumber(luaState, -1); 
    }

    // 获取当前选中的位置
    VECTOR selected_pos()  {
        get_lua_property("Core", "SelectPos");
        if (!lua_istable(luaState, -1)) {
            throw "not a table: SelectPos";
        }
        lua_getfield(luaState, -1, "x");
        int x = lua_tonumber(luaState, -1);
        lua_getfield(luaState, -2, "y");
        int y = lua_tonumber(luaState, -1);
        return {x, y};
    }
    // 设置当前选中位置
    void selected_pos(VECTOR pos) {
        init_func_call("AI_SDK", "setSelected");
        lua_pushnumber(luaState, pos.x);
        lua_pushnumber(luaState, pos.y);
        execute_func_call(2, 0);
    }

private:  
    mutable lua_State *luaState;
    UserAPI(lua_State *L) : luaState(L) {}
};

#endif  // UserAPI_hpp