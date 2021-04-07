#include <ctime>
#include <random>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"
#include "Verify.hpp"

using namespace std;

void random_move() {
    static bool init = false;
    if (!init) {
        srand(time(NULL));
    }
    int direction = rand() % 6 + 1;

}

inline VECTOR after_move_pos(VECTOR cur, int direction) {
    return cur + DIR[cur.x % 2][direction];
}

void testInfo() {
    UserAPI & API = UserAPI::Singleton();
    cout << "Current selected pos: " << API.selected_pos().x << ", " << API.selected_pos().y << endl;
}


static int userMain(lua_State *luaState) {
    // UserAPI & API = UserAPI::Singleton(luaState);
    // MAP & mmap = MAP::Singleton();
    // int id = VERIFY::Singleton().GetArmyID();

    // static bool init = false;
    // if (!init) {
    //     init = true;
    //     API.selected_pos(API.king_pos());
    // }
    // testInfo();

    // double move_ratio = 0.5;
    // if (API.selected_pos().x == -1 || API.selected_pos().y == -1 ||         // 选择位置非法
    //         mmap.GetBelong(API.selected_pos()) != id ||                     // 不可移动
    //         mmap.GetUnitNum(API.selected_pos()) < 2) {                      // 兵力过少
    //     API.selected_pos(API.king_pos());
    // }

    // // 判断当前位置周围是否有敌人
    // for (int i = 1; i <= 6; i++) {
    //     VECTOR apos = after_move_pos(API.selected_pos(), i);
    //     if (id == mmap.GetBelong(apos)) continue;       // 平凡情况
    //     //发现敌人
    //     move_ratio = 0.99;
    //     API.move_to(apos, move_ratio, i);
    //     break;
    // }
    return 0;
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))