#pragma once

#include <iostream>

#include "GameMap.hpp"
#include "LuaAPI.hpp"

#ifndef UserAPI_hpp
#define UserAPI_hpp

class UserAPI {
   public:
    static UserAPI &Singleton(lua_State *L = nullptr);
    UserAPI(UserAPI &) = delete;
    bool operator=(const UserAPI &) = delete;

    // 初始化一个类成员函数的执行，参数为类名和函数名
    void init_func_call(std::string class_name, std::string func_name);
    // 执行lua_State栈顶的函数，参数分别为参数个数与返回值个数
    void execute_func_call(int param_num = 0, int ret_num = 0);
    // 向lua_State中压入一个字符串
    void lua_pushstring(std::string str);
    // 获取lua表中的元素（可以是函数），两个参数分别为全局表名和数据项名
    void get_lua_property(std::string class_name, std::string property_name);

    // 执行移动操作
    void move_to(VECTOR dest, double moveNum);

    void move_by_direction(VECTOR src, double moveNum, int direction);

    void move_by_coordinates(VECTOR src, VECTOR dest, double moveNum);

    // 判断两个点是否相连
    bool is_connected(int posX1, int posY1, int posX2, int posY2);

    // 获取King的位置
    VECTOR king_pos();
    // 获取当前的step数
    int get_current_step();

    // 获取当前选中的位置
    VECTOR getSelectedPos();
    // 设置当前选中位置
    // Python接口中改名为setSelected
    void setSelectedPos(VECTOR pos);

   protected:
    lua_State *luaState;
    UserAPI(lua_State *L);
};

#endif  // UserAPI_hpp