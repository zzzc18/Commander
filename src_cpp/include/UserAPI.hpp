#pragma once

#ifndef UserAPI_hpp
#define UserAPI_hpp

#include "GameMap.hpp"
#include "LuaAPI.hpp"

class UserAPI {
   public:
    UserAPI( UserAPI &) = delete;
    bool operator=(const UserAPI &) = delete;
    // 获取类的单例，第一次调用需要传入lua_State
    static UserAPI &Singleton(lua_State *L = nullptr);
    
    // 执行移动操作
    void move_to(VECTOR dest, double moveNum, int direction);
    // 判断两个点是否相连
    bool is_connected(int posX1, int posY1, int posX2, int posY2);

    // 获取King的位置
    VECTOR king_pos() ;
    // 获取当前的step数
    int get_current_step() ;

    // 获取当前选中的位置
    VECTOR selected_pos() ;
    // 设置当前选中位置
    void selected_pos(VECTOR new_pos);

    // 初始化一个类成员函数的执行，参数为类名和函数名
    void init_func_call(std::string class_name, std::string func_name);
    // 执行lua_State栈顶的函数，参数分别为参数个数与返回值个数     
    void execute_func_call(int param_num = 0, int ret_num = 0);     
    // 向lua_State中压入一个字符串
    void lua_pushstring(std::string str) ;       

    // 获取lua表中的元素（可以是函数），两个参数分别为全局表名和数据项名
    void get_lua_property(std::string class_name, std::string property_name) ;       

   private:
    mutable lua_State *luaState;
    UserAPI(lua_State *L) : luaState(L) {}
    VECTOR selected = {-1, -1};
};

#endif  // UserAPI_hpp