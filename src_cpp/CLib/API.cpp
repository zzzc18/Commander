#include "GameMap.hpp"
#include "LuaAPI.hpp"

/**
 * @brief 随机生成地图
 *
 * @param @c void
 * @return @c void
 */
static int GameMapRandomGenMap(lua_State *luaState) {
    MAP::Singleton().RandomGen(2, 0);  // FIXME magic numbers
    return APIreturn(luaState);
}
/**
 * @brief 加载地图
 *
 * @param @c void
 * @return @c void
 */
static int GameMapLoadMap(lua_State *luaState) {
    return APIreturn(luaState, MAP::Singleton().Load());
}
/**
 * @brief 保存地图至文件
 *
 * @param @c void
 * @return @c void
 */
static int GameMapWriteMap(lua_State *luaState) {
    MAP::Singleton().Save();
    return APIreturn(luaState);
}

/**
 * @brief 获取地图大小
 *
 * @param @c void
 * @return @c int sizeX 行数
 * @return @c int sizeY 列数
 */
static int GameMapGetSize(lua_State *luaState) {
    auto [sizeX, sizeY] = MAP::Singleton().GetSize();
    return APIreturn(luaState, sizeX, sizeY);
}

/**
 * @brief 判断当前军队是否能看到给定点
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c bool 是否可见
 */
static int GameMapGetVision(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().IsViewable({x, y}));
}
/**
 * @brief 当前军队所看到的给定点类型
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c const-char* 类型对应字符串
 */
static int GameMapGetNodeType(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState,
                     NodeTypeToStr(MAP::Singleton().GetType({x, y})).c_str());
}
/**
 * @brief 当前军队所看到的给定点兵数
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c int 军队看到的兵数
 */
static int GameMapGetUnitNum(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().GetUnitNum({x, y}));
}
/**
 * @brief 当前军队所看到的给定点所属军队编号
 *
 * @param x @c int 给定点所在行号
 * @param y @c int 给定点所在列号
 * @return @c int 军队看到的该点所属军队编号
 */
static int GameMapGetBelong(lua_State *luaState) {
    int x, y;
    APIparam(luaState, x, y);
    return APIreturn(luaState, MAP::Singleton().GetBelong({x, y}));
}
/**
 * @brief 某只军队的计划路径
 *
 * @param armyID @c int 军队ID
 * @param step @c int 军队路径步数
 * @return @c int 某一步的开始坐标，结束坐标
 */
static int GameMapGetArmyPath(lua_State *luaState) {
    int armyID, step;
    APIparam(luaState, armyID, step);
    std::pair<VECTOR, VECTOR> data = MAP::Singleton().GetArmyPath(armyID, step);
    int srcX = data.first.x;
    int srcY = data.first.y;
    int dstX = data.second.x;
    int dstY = data.second.y;
    return APIreturn(luaState, srcX, srcY, dstX, dstY);
}

/**
 * @brief 地图每秒的兵力更新
 *
 * @param @c void
 * @return @c void
 */
static int GameMapUpdate(lua_State *luaState) {
    MAP::Singleton().Update();
    return APIreturn(luaState);
}
/**
 * @brief 地图每 25 秒的兵力大更新
 *
 * @param @c void
 * @return @c void
 */
static int GameMapBigUpdate(lua_State *luaState) {
    MAP::Singleton().BigUpdate();
    return APIreturn(luaState);
}

/**
 * @brief 将给定军队给定点的兵移至相邻点
 *
 * @param armyID @c int 操作的军队编号
 * @param srcX @c int 给定点所在行号
 * @param srcY @c int 给定点所在列号
 * @param dstX @c int 目标点所在行号
 * @param dstY @c int 目标点所在列号
 * @return @c bool 操作是否合法
 */
static int GameMapPushMove(lua_State *luaState) {
    int armyID, srcX, srcY, dstX, dstY;
    APIparam(luaState, armyID, srcX, srcY, dstX, dstY);
    return APIreturn(luaState, MAP::Singleton().PushMove(armyID, {srcX, srcY},
                                                         {dstX, dstY}));
}
/**
 * @brief 地图每 0.5 秒的移动兵力操作更新
 *
 * @param @c void
 * @return @c bool 当前军队是否移动成功
 */
static int GameMapMoveUpdate(lua_State *luaState) {
    return APIreturn(luaState, MAP::Singleton().MoveUpdate());
}
static int GameMapJudge(lua_State *luaState) {
    int armyID;
    APIparam(luaState, armyID);
    return APIreturn(luaState, MAP::Singleton().Judge(armyID));
}

/**
 * @brief 地图更新触发器
 *  Lua 每 @c dt 秒调用一次，该函数计数达到阈值时触发地图更新
 *
 * @note 暂时弃置
 *
 * @param dt @c double Lua 调用的时间间隔，单位：秒
 * @return @c void
 */
static int SystemUpdate(lua_State *luaState) {
    static int cnt;
    static double totalTime;
    double dt;
    APIparam(luaState, dt);
    totalTime += dt;
    if (totalTime > 1) {
        totalTime -= 1;
        if (++cnt == 25) {
            cnt = 0;
            MAP::Singleton().BigUpdate();
        } else
            MAP::Singleton().Update();
    }
    return APIreturn(luaState);
}

#include "Verify.hpp"

/**
 * @brief 注册当前军队的各个属性
 *
 * @param armyID @c int 军队编号
 * @param privilege @c int 军队权限
 * @return @c void
 */
static int VerifyRegister(lua_State *luaState) {
    int armyID, privilege;
    APIparam(luaState, armyID, privilege);
    return APIreturn(luaState, VERIFY::Register(armyID, privilege));
}

/**
 * @brief 向 Lua 注册 API，模块名为 lib/GameMap.dll
 */
LUA_REG_FUNC(CLib, C_API(GameMapRandomGenMap), C_API(GameMapLoadMap),
             C_API(GameMapWriteMap), C_API(GameMapGetSize),
             C_API(GameMapGetVision), C_API(GameMapGetNodeType),
             C_API(GameMapGetUnitNum), C_API(GameMapGetBelong),
             C_API(GameMapGetArmyPath), C_API(GameMapUpdate),
             C_API(GameMapBigUpdate), C_API(GameMapPushMove),
             C_API(GameMapMoveUpdate), C_API(GameMapJudge), C_API(SystemUpdate),
             C_API(VerifyRegister))
