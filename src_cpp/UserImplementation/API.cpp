#include "LuaAPI.hpp"
#include "UserAPI.hpp"

enum back_state_type { Backing, Done } back_state;
enum attack_state_type { Done, Ready, Attacking } attack_state;

void Back_init();
void Back_to_king();

int attack_index = 0;

static int userMain(lua_State *luaState) {
    printf("C++ Implementation Invoke\n");

    // 初始化API单例
    UserAPI &API = UserAPI.Singleton(luaState);

    if (API.get_current_step() % 45 == 0 &&
        back_state != back_state_type::Backing attack_state ==
            attack_state_type::Done) {
        Back_init();
        Back_to_king();
    }

    return 0;
}

LUA_REG_FUNC(UserImplementation, C_API(userMain))