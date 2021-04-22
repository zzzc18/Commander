#include <ctime>
#include <iostream>
#include <random>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"
#include "Verify.hpp"

using namespace std;

VECTOR after_move_pos(VECTOR cur, int direction) {
    return cur + DIR[cur.x % 2][direction];
}

ostream &operator<<(ostream &os, const VECTOR &vec) {
    os << "(" << vec.x << "," << vec.y << ")";
    return os;
}

int id;

void testInfo() {
    UserAPI &API = UserAPI::Singleton();
    MAP &mmap = MAP::Singleton();
    cout << "Current selected pos: " << API.selected_pos().x << ", "
         << API.selected_pos().y;
    cout << " Belongs: " << mmap.GetBelong(API.selected_pos());
    cout << " UnitNum: " << mmap.GetUnitNum(API.selected_pos()) << endl;
}

double get_rand_percentage(double lower_bound = 0.0, double upper_bound = 1.0) {
    if (lower_bound < -0.00001 || lower_bound > 1.00001)
        cout << "Invalid lower_bound" << endl;
    if (upper_bound < -0.00001 || upper_bound > 1.00001)
        cout << "Invalid upper_bound" << endl;
    double ret =
        lower_bound + (rand() % 10000) * (upper_bound - lower_bound) / 10000.0;
    cout << "RNG (" << lower_bound << ", " << upper_bound << ") = " << ret
         << endl;
    return ret;
}

bool move_from_select() {
    cout << "try to move" << endl;
    UserAPI &API = UserAPI::Singleton();
    MAP &mmap = MAP::Singleton();
    double move_ratio = 0.5;
    // 判断当前位置周围是否有敌人
    for (int i = 0; i < 6; i++) {
        VECTOR apos = after_move_pos(API.selected_pos(), i);
        if (id == mmap.GetBelong(apos)) continue;             // 平凡情况
        if (mmap.GetType(apos) == NODE_TYPE::HILL) continue;  // 山丘 不可通过
        if (mmap.GetType(apos) == NODE_TYPE::FORT &&
            mmap.GetUnitNum(API.selected_pos()) < 1.5 * mmap.GetUnitNum(apos))
            continue;  // 无法占有或占有后容易被夺去
        double tmp;
        if (tmp = get_rand_percentage() > 0.5) {
            cout << "Skip, tmp = " << tmp << endl;
            continue;
        }  // 随机跳过
        cout << "Prepare to move " << API.selected_pos() << "->";
        cout << apos << endl;

        move_ratio = get_rand_percentage(0.4, 0.8);  // 随机移动
        API.move_to(apos, move_ratio);
        return true;
    }
    return false;
}

// (递归地)随机从已有的领地中选择一个点作为出发点
// 每次从当前选定点开始，从 六个方向的邻接点 或 当前位置
// 总共7个选项的所有可选位置中
// 随机的选择一项，如果选择位置不是当前点，则递归调用自己
void random_select() {
    UserAPI &API = UserAPI::Singleton();
    MAP &mmap = MAP::Singleton();

    // 从当前位置出发的所有可选位置
    vector<VECTOR> options = {API.selected_pos()};

    for (int i = 0; i < 6; i++) {
        VECTOR apos = after_move_pos(API.selected_pos(), i);
        if (mmap.GetType(apos) == NODE_TYPE::HILL) continue;
        if (mmap.GetBelong(apos) != id) continue;
        if (mmap.GetUnitNum(apos) < 2) continue;
        // 该位置是一个可选位置
        cout << "find a optional position: " << apos << endl;
        options.push_back(apos);
    }
    cout << "options :" << options.size() << endl;
    // 没有可选项
    if (options.size() == 1) return;

    // 随机选择的选项
    int choice = rand() % options.size();

    // 不改变位置，直接返回
    if (options[choice] == API.selected_pos()) return;

    API.selected_pos(options[choice]);
    cout << "Selection: " << options[choice] << endl;
    random_select();
}

static int userMain(lua_State *luaState) {
    UserAPI &API = UserAPI::Singleton(luaState);
    MAP &mmap = MAP::Singleton();
    id = VERIFY::Singleton().GetArmyID();

    static bool init = false;
    if (!init) {
        init = true;
        API.selected_pos(API.king_pos());
    }
    testInfo();
    double move_ratio = 0.5;
    if (API.selected_pos().x == -1 ||
        API.selected_pos().y == -1 ||                // 选择位置非法
        mmap.GetBelong(API.selected_pos()) != id ||  // 不可移动
        mmap.GetUnitNum(API.selected_pos()) < 2) {   // 兵力过少
        API.selected_pos(API.king_pos());
    }

    random_select();

    for (int i = 1; i <= 3 && !move_from_select(); i++) {
        random_select();
    }
    return 0;
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))