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
    std::string get_game_state() const;
    std::string get_judgement_state() const;
    int get_armyID() const;
    int get_army_num() const;
    VECTOR get_king_pos() const;
    static UserAPI & Singleton(lua_State * L = nullptr);
    static bool has_init;
    UserAPI(const UserAPI &) = delete;
    bool operator =(const UserAPI &) = delete;
private:
    mutable lua_State* luaState;
    UserAPI(lua_State * L): luaState(L) {}
    void init_func_call(std::string class_name, std::string func_name);
    void execute_func_call(int param_num = 0, int ret_num = 0);
    void lua_pushstring(std::string str);
    void get_lua_property(std::string class_name, std::string property_name);
};

bool UserAPI::has_init = false;



#endif  // UserAPI_hpp

#ifndef UserCore_hpp
#define UserCore_hpp

class UserCore {
public:
    int get_current_step() const; 
    VECTOR get_select_pos() const;
    
};

#endif  // UserCore_hpp