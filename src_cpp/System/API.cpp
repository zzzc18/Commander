#include "GameMap.h"
#include "System.h"
using namespace std;

static int Update(lua_State* L) {
    double dt = lua_tonumber(L, 1);
    static double totalTime = 0;
    static int cnt = 0;
    totalTime += dt;
    if (totalTime > 1) {
        totalTime -= 1;
        cnt++;
        MainMap->Update();
        if (cnt == 25) {
            cnt = 0;
            MainMap->BigUpdate();
        }
    }
    return 0;
}

static const luaL_Reg functions[] = {{"Update", Update}, {NULL, NULL}};

extern "C" {
int luaopen_lib_System(lua_State* L) {
    luaL_register(L, "System", functions);
    return 1;
}
}