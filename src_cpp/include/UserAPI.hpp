#pragma once

#ifndef UserAPI_hpp
#define UserAPI_hpp

#include "GameMap.hpp"
#include "LuaAPI.hpp"


class UserAPI {
   public:
    void move_to(int x, int y, double moveNum, int direction);
    // string get_game_state();
    bool is_connected(int posX1, int posY1, int posX2, int posY2);
    void add_commands(int direction, std::string key, std::string type, int x,
                      int y);
    void clear_commands();

   private:
    lua_State* luaState;
    void Init();
    void init_func_call(std::string class_name, std::string func_name);
    void execute_func_call(int param_num = 0, int ret_num = 0);
    void lua_pushstring(std::string str);
};



#endif  // UserAPI_hpp

#ifndef UserCore_hpp
#define UserCore_hpp

class UserCore {
   public:
    int selectX, selectY;
    
};

#endif  // UserCore_hpp