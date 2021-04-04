#include <ctime>
#include <random>

#include "GameMap.hpp"
#include "LuaAPI.hpp"
#include "UserAPI.hpp"

using namespace std;

enum back_state_type { Backing, Done } back_state;
enum attack_state_type { Done, Ready, Attacking } attack_state;

void Back_init();
void Back_to_king();
void Attack_model();
void AI_move_model(lua_State *luaState);

int rdmDirection = 0;
int attack_index = 0;

static int userMain(lua_State *luaState) {
    static bool init_flag = false;
    if (!init_flag) {
        srand((unsigned)time(NULL));
        init_flag = true;
    }
    printf("C++ Implementation Invoke\n");

    // 初始化API单例
    UserAPI &API = UserAPI.Singleton(luaState);

    if (API.get_current_step() % 45 == 0 &&
        back_state != back_state_type::Backing attack_state ==
            attack_state_type::Done) {
        Back_init();
        Back_to_king();
    } else if (back_state == back_state_type::Backing) {
        Back_to_king();
    } else if (attack_state == attack_state_type::Ready) {
        printf("--Attacking--");
        attack_state = attack_state_type::Attacking;
        attack_index = 1;
        API.selected_pos(API.king_pos());
        Attack_model();
    } else if (attack_state == attack_state_type::Attacking) {
        Attack_model();
    } else if (back_state == back_state_type::Done &&
               attack_state == attack_state_type::Done) {
        AI_move_model(luaState);
    }

    return 0;
}

// 从王的位置随机移动，当军队数量下降到1时重新从王的位置开始移动
void AI_move_model(lua_State *luaState) {
    auto &API = UserAPI.Singleton();
    if (API.selected_pos().x == -1 && API.king_pos != -1) {
        AI.selected_pos(API.king_pos());
    }

    VECTOR cur_pos = API.selected_pos();
    int unit_num = API.get_unit_num(cur_pos);
    double move_num =
        0;  //为0时移动全部，为0到1之间实数时按比例移动，大于1时移动moveNum整数部分
    if (API.get_army_id() != API.get_belong(cur_pos) || unit_num <= 1) {
        API.selected_pos(API.king_pos());
        API.clear_commands();
        return;
    } else if (unit_num >= 50 &&
               GameMap.Singleton().GetType(cur_pos) == NODE_TYPE::KING)
        move_num = 0.5;

    int chance = 10;
    int mode = 0;
    while (chance > 0) {
        cur_pos = API.selected_pos();
        rdmDirection = rand(6);
        mode = cur_pos.x % 2 + 1;
        cur_pos.x += Map_direction[mode][rdmDirection][0];
        cur_pos.y += Map_direction[mode][rdmDirection][1];
        if (GameMap.Singleton().GetType(cur_pos) == NODE_TYPE::BLANK ||
            GameMap.Singleton().GetType(cur_pos) == NODE_TYPE::KING) {
            if (AI.get_army_id() != GameMap.GetBelong(cur_pos)) {
                AI.move_to(cur_pos, move_num, rdmDirection);
                AI.selected_pos(cur_pos);
                break;
            } else {
                chance--;
                if (chance < 3) {
                    AI.move_to(cur_pos, move_num, rdmDirection);
                    AI.selected_pos(cur_pos);
                    break;
                }
            }
        } else if (GameMap.Singleton().GetType(cur_pos) == NODE_TYPE::FORT) {
            int fort_num = GameMap.Singleton().GetUnitNum(cur_pos);
            if (AI.get_army_id() != GameMap.Singleton().GetBelong(cur_pos) &&
                fort_num - 10 < unit_num) {
                AI.move_to(cur_pos, move_num, rdmDirection);
                AI.selected_pos(cur_pos);
                break;
            } else {
                chance--;
            }
        } else
            chance--;
    }
    if (chance <= 0) {
        AI.selected_pos(AI.king_pos());
        AI.clear_commands();
    }
}

void back_init() {
    back_index = 1;
    back_state = back_state_type::Backing;
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))