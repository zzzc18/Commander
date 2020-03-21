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

LUA_REG_FUNC(System, C_API(Update));
