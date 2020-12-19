/**
 * @file API.cpp
 *
 * @brief @c GameMap 模块对 Lua 提供的 API
 */

#include "GameMap.hpp"
#include "LuaAPI.hpp"

/**
 * @brief 随机生成地图
 *
 * @param @c void
 * @return @c void
 */
static int RandomGenMap(lua_State *luaState) {
    MAP::Singleton().RandomGen(2, 0);  // FIXME magic numbers
    return APIreturn(luaState);
}
/**
 * @brief 加载地图
 *
 * @param @c void
 * @return @c void
 */
static int LoadMap(lua_State *luaState) {
    return APIreturn(luaState, MAP::Singleton().Load());
}
/**
 * @brief 保存地图至文件
 *
 * @param @c void
 * @return @c void
 */
static int WriteMap(lua_State *luaState) {
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
static int GetSize(lua_State *luaState) {
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
static int GetVision(lua_State *luaState) {
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
static int GetNodeType(lua_State *luaState) {
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
static int GetUnitNum(lua_State *luaState) {
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
static int GetBelong(lua_State *luaState) {
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
static int GetArmyPath(lua_State *luaState) {
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
 * @brief 地图每步的兵力更新
 *
 * @param @c void
 * @return @c void
 */
static int Update(lua_State *luaState) {
    MAP::Singleton().Update();
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
static int PushMove(lua_State *luaState) {
    int armyID, srcX, srcY, dstX, dstY;
    APIparam(luaState, armyID, srcX, srcY, dstX, dstY);
    return APIreturn(luaState, MAP::Singleton().PushMove(armyID, {srcX, srcY},
                                                         {dstX, dstY}));
}

static int Judge(lua_State *luaState) {
    int armyID;
    APIparam(luaState, armyID);
    return APIreturn(luaState, MAP::Singleton().Judge(armyID));
}
/**
 * @brief 向 Lua 注册 API，模块名为 lib/GameMap.dll
 */
LUA_REG_FUNC(GameMap, C_API(RandomGenMap), C_API(LoadMap), C_API(WriteMap),
             C_API(GetSize), C_API(GetVision), C_API(GetNodeType),
             C_API(GetUnitNum), C_API(GetBelong), C_API(GetArmyPath),
             C_API(Update), C_API(PushMove), C_API(Judge))
